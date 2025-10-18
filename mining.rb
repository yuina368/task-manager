#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'nokogiri'
require 'uri'
require 'natto' # MeCab バインディング（gem 'natto' を使用）

# Chrome (ヘッドレス) を起動
def create_driver
  opts = Selenium::WebDriver::Chrome::Options.new
  opts.add_argument('--headless=new') rescue opts.add_argument('--headless')
  opts.add_argument('--no-sandbox')
  opts.add_argument('--disable-dev-shm-usage')
  opts.add_argument('--disable-blink-features=AutomationControlled')
  opts.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')
  Selenium::WebDriver.for(:chrome, options: opts)
end

def fetch_search_urls(keyword, driver)
  # DuckDuckGo HTML版（bot対策が緩い）
  search_url = "https://html.duckduckgo.com/html/?q=#{URI.encode_www_form_component(keyword)}"
  driver.navigate.to(search_url)

  sleep 2 # ページ読み込み待ち

  doc = Nokogiri::HTML(driver.page_source)
  urls = []
  
  # HTML版のセレクタ
  doc.css('a.result__a').each do |a|
    href = a['href']
    next unless href
    
    # DuckDuckGoのリダイレクトURLをデコード
    if href =~ /uddg=([^&]+)/
      url = URI.decode_www_form_component($1)
      urls << url
    elsif href.start_with?('http')
      urls << href
    end
  end

  urls.compact.uniq.first(3)
end

def fetch_page_text(url, driver)
  driver.navigate.to(url)
  # ページ読み込み完了待ち
  wait = Selenium::WebDriver::Wait.new(timeout: 8)
  begin
    wait.until { driver.execute_script('return document.readyState') == 'complete' }
  rescue Selenium::WebDriver::Error::TimeoutError
    # 続行
  end

  doc = Nokogiri::HTML(driver.page_source)
  doc.search('script, style, noscript').remove
  text = doc.text.gsub(/\s+/, ' ').strip
  text
end

def extract_words_with_mecab(text)
  nm = Natto::MeCab.new
  words = []
  nm.parse(text) do |n|
    break if n.is_eos?
    features = n.feature.split(',')
    # 名詞を抽出（他の条件に変えることも可）
    words << n.surface if features[0] == '名詞' && n.surface && n.surface.strip != ''
  end
  words
end

def filter_keywords(words)
  words.reject do |word|
    # 数字だけ、記号だけ、1文字だけを除外
    word.match?(/^[\d:\/\(\)\.\-\!\&\°]+$/) || word.length == 1
  end
end

driver = create_driver

begin
  puts "🔍 検索ワードを入力してください:"
  keyword = STDIN.gets&.strip.to_s

  puts "\n🌐 上位3件のURLを取得しました:"
  urls = fetch_search_urls(keyword, driver)
  
  if urls.empty?
    puts "⚠️ URLが取得できませんでした"
    exit
  end
  
  urls.each_with_index { |u, i| puts "#{i+1}: #{u}" }

  puts "\n📈 キーワード分析を開始します..."
  all_text = ''

  urls.each do |url|
    print "▶ #{url} からテキスト抽出中... "
    begin
      text = fetch_page_text(url, driver)
      if text.empty?
        puts "⚠️ テキストが空です"
      else
        all_text << text << ' '
        puts "完了 (#{text.length}文字)"
      end
    rescue => e
      puts "⚠️ 取得に失敗: #{e.class}: #{e.message}"
    end
  end

  if all_text.strip.empty?
    puts "\n取得したテキストが空です。処理を中止します。"
    exit
  end

  # MeCabで名詞を抽出して頻度カウント
  words = extract_words_with_mecab(all_text)
  words = filter_keywords(words) # ノイズ除去
  freq = words.each_with_object(Hash.new(0)) { |w, h| h[w] += 1 }

  top300 = freq.sort_by { |_, v| -v }.first(300)

  puts "\n📈 頻出キーワード（上位300・フィルタリング済み）"
  top300.each_with_index do |(word, count), i|
    puts "#{i+1}. #{word} - #{count}回"
  end
  
  puts "\n✅ 分析完了！"
ensure
  driver.quit rescue nil
end

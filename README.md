# Mining Website / テキストマイニング＆スクレイピングツール

---

日本語 | Japanese
-----------------

概要
- このリポジトリは、Selenium + Nokogiri でウェブページを取得し、MeCab（natto gem）で日本語テキストを形態素解析して名詞の頻度を集計するサンプルスクリプト（mining.rb）を含みます。
- 主に日本語の記事やページのキーワード抽出・簡易テキストマイニングに使えます。

特徴
- DuckDuckGo（HTML版）で検索して上位3件のURLを取得
- 取得したページをヘッドレスChromeで読み込み、Nokogiriで本文テキストを抽出
- MeCab（natto）で名詞を抽出して頻度集計（上位300を表示）
- シンプルで学習用途やポートフォリオ向けの実装

前提条件
- Ruby（推奨 2.6 以上）
- bundler（任意だが推奨）
- MeCab 本体 と 辞書（OSに応じて別途インストール）
- Chrome と chromedriver（chromedriver のバージョンは Chrome と合わせる）
- 必要な gem: selenium-webdriver, nokogiri, natto

インストール（手順）
1. リポジトリをクローン
   ```bash
   git clone https://github.com/yuina368/task-manager.git
   cd task-manager
   ```
2. Ruby と bundler がなければインストール
   ```bash
   # Bundler がなければ
   gem install bundler
   ```
3. 必要な gem をインストール（Gemfile がある場合）
   ```bash
   bundle install
   ```
   もしくは個別に:
   ```bash
   gem install selenium-webdriver nokogiri natto
   ```

MeCab のインストール例
- macOS (Homebrew)
  ```bash
  brew install mecab mecab-ipadic
  ```
- Ubuntu / Debian
  ```bash
  sudo apt update
  sudo apt install mecab libmecab-dev mecab-ipadic-utf8
  ```
- natto gem は Ruby から MeCab を利用するためのバインディングです:
  ```bash
  gem install natto
  ```

chromedriver のインストール例
- macOS (Homebrew)
  ```bash
  brew install chromedriver
  ```
  PATH に配置されていることを確認してください（または実行時にフルパスを指定）。

使い方
- スクリプトは mining.rb を参照してください。
- 実行方法（対話式）:
  ```bash
  ruby mining.rb
  ```
  実行後、「検索ワードを入力してください:」と表示されるので、キーワードを入力して Enter を押します。
- 処理の流れ:
  1. DuckDuckGo（HTML版）で検索 → 上位3件のURL取得
  2. 各ページをヘッドレスChromeで読み込み、本文テキストを抽出
  3. MeCab（natto）で形態素解析 → 名詞を抽出
  4. 頻度集計して上位300を表示

出力例（抜粋）
```
🔍 検索ワードを入力してください:
> プログラミング

🌐 上位3件のURLを取得しました:
1: https://example.com/article1
2: https://example.com/article2
3: https://example.com/article3

📈 キーワード分析を開始します...
▶ https://example.com/article1 からテキスト抽出中... 完了 (10234文字)
▶ https://example.com/article2 からテキスト抽出中... 完了 (8452文字)
▶ https://example.com/article3 からテキスト抽出中... 完了 (5321文字)

📈 頻出キーワード（上位300・フィルタリング済み）
1. プログラミング - 45回
2. 言語 - 30回
3. 学習 - 20回
...
✅ 分析完了！
```

注意事項 / Tips
- 公開サイトをスクレイピングする際は robots.txt や利用規約を必ず確認してください。
- 大量リクエストは避け、適切なスリープやレート制限を導入してください。
- ヘッドレスブラウザや chromedriver のバージョン差で動作が変わる場合があります。動作しない場合は chromedriver と Chrome のバージョンを合わせてください。
- 現行スクリプトは標準入力でキーワードを受け取ります。必要ならコマンドライン引数対応や出力をファイルへ保存する機能を追加できます。

カスタマイズ案（今後追加できる機能）
- コマンドライン引数で複数キーワード・出力ファイル名を指定
- stopword（ストップワード）除外リストの導入
- 出力を CSV / JSON フォーマットで保存
- 並列処理によるページ取得の高速化（要注意：サーバ負荷に配慮）
- 言語判定や名詞以外（動詞・形容詞）の解析オプション

貢献・連絡
- バグ報告、改善提案は Issue または Pull Request を歓迎します。
- 作者: yuina368 (GitHub: @yuina368)

ライセンス
- 明記がない場合はパーソナルサンプルとして公開しています。必要なら MIT などのライセンスを追加してください。

---

English | 英語
-----------------

Overview
- This repository contains a sample script (mining.rb) that uses Selenium + Nokogiri to fetch web pages and MeCab (via the natto gem) to perform morphological analysis on Japanese text and count noun frequencies.
- Useful for extracting keywords and performing simple text-mining on Japanese web pages.

Features
- Searches DuckDuckGo (HTML version) and collects top 3 result URLs
- Loads pages with headless Chrome and extracts page text with Nokogiri
- Uses MeCab (natto) to extract nouns and aggregates frequency (shows top 300)
- Lightweight and designed for learning / portfolio purposes

Prerequisites
- Ruby (recommended 2.6+)
- bundler (optional but recommended)
- MeCab and dictionary installed on your system
- Chrome and matching chromedriver
- Required gems: selenium-webdriver, nokogiri, natto

Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yuina368/task-manager.git
   cd task-manager
   ```
2. Install bundler if needed:
   ```bash
   gem install bundler
   ```
3. Install gems:
   ```bash
   bundle install
   ```
   or:
   ```bash
   gem install selenium-webdriver nokogiri natto
   ```

MeCab installation examples
- macOS (Homebrew):
  ```bash
  brew install mecab mecab-ipadic
  ```
- Ubuntu / Debian:
  ```bash
  sudo apt update
  sudo apt install mecab libmecab-dev mecab-ipadic-utf8
  ```

chromedriver example (macOS Homebrew)
```bash
brew install chromedriver
```
Ensure chromedriver is in PATH or provide full path when launching.

Usage
- The script reads a keyword from STDIN.
- Run:
  ```bash
  ruby mining.rb
  ```
  Then enter the search keyword when prompted.
- Flow:
  1. Search DuckDuckGo HTML → get top 3 URLs
  2. Load pages with headless Chrome and extract text
  3. Parse with MeCab (natto) → extract nouns
  4. Aggregate frequencies and print top 300

Sample output
(See the Japanese section for a sample console output.)

Notes / Tips
- Always check robots.txt and site's terms before scraping.
- Avoid heavy/frequent requests; add sleeps and rate limiting as needed.
- Make sure Chrome and chromedriver versions match.
- The script currently accepts input via STDIN; adding CLI argument support or output-to-file features is recommended for production use.

Future enhancements
- CLI options for keywords and output file
- Stopword filtering
- CSV/JSON export
- Parallel fetching with care for server load
- Support for analyzing POS other than nouns

Contributing / Contact
- Issues and PRs are welcome.
- Author: yuina368 (GitHub: @yuina368)

License
- If you'd like, add an OSI-compatible license such as MIT.

---

What I did: mining.rb の内容に即した日英両対応の README を作成しました。スクリプトの挙動（検索→取得→形態素解析→頻度集計）や必要な依存関係、実行方法、注意点を整理しています。

次にできること: 実際の Gemfile やサンプル出力ファイル（CSV/JSON）のテンプレート追加、またはスクリプトをコマンドライン引数対応に改良して README にサンプルコマンドを追記することが可能です。どれを優先するか教えてください。
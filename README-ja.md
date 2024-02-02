<p align="center">
  <img src="https://raw.githubusercontent.com/kokuyouwind/rbs_goose/main/assets/logo.svg" alt="RuboCop Logo"/>
</p>

[![en-US README](https://img.shields.io/badge/Multilingual_README-en--US-blue.svg)](/README.md)
[![ja-JP README](https://img.shields.io/badge/Multilingual_README-ja--JP-orangered.svg)](/README-ja.md)

[![Ruby](https://github.com/kokuyouwind/rbs_goose/actions/workflows/main.yml/badge.svg)](https://github.com/kokuyouwind/rbs_goose/actions/workflows/main.yml)

RBS Goose は ChatGPT などの大規模言語モデルを利用して、 Ruby コードの RBS シグニチャを推測するツールです。

> [!CAUTION]
> 現在は技術検証中のため、適切な型がほとんど、あるいは全く出力されない可能性があります。
> また推測にあたっては ChatGPT API などを利用するため、コード規模によっては利用料が高額になる可能性があります。

## Installation

```bash
$ gem install rbs_goose
# 利用する LangChain LLM に応じて、対応する gem を合わせてインストールします
$ gem install ruby-openai
```

`bundler` を利用する場合は、代わりに以下を `Gemfile` に追加してください。

```ruby
gem 'rbs_goose'
# 利用する LangChain LLM に応じて、対応する gem を合わせてインストールします
gem 'ruby-openai'
```

## Usage

現状ではコマンドラインツールが未整備なので、 `Rakefile` などから `RbsGoose.run` を直接呼び出してください。

[OpenAI API](https://openai.com/blog/openai-api) を利用する場合は以下のようにします。

```ruby
require 'rbs_goose'
require 'openai'

desc 'refine RBS files in sig directory'
task :refine do
  RbsGoose.configure do |c|
    c.use_open_ai(ENV.fetch('OPENAI_ACCESS_TOKEN'))
  end
  RbsGoose.run
end
```

このタスクを実行すると、 `lib` 以下の Ruby コードと `sig` 以下の RBS シグニチャを参照し、推測したシグニチャを上書きします。

対象とするディレクトリを変更する場合、以下のように `RbsGoose.run` の引数を指定してください。

```ruby
RbsGoose.run(code_dir: 'app', sig_dir: 'types', base_path: Rails.root)
```

大規模言語モデルの呼び出しには [Langchain.rb](https://github.com/andreibondarev/langchainrb) を利用しています。

他の大規模言語モデルを利用する場合は、以下のように `llm` を直接設定してください。

```ruby
RbsGoose.configure do |c|
  c.llm = Langchain::LLM::GooglePalm.new(api_key: ENV["GOOGLE_PALM_API_KEY"])
end
```

## Development

リポジトリのチェックアウト後、bin/setup を実行して依存関係をインストールします。次に、`rake spec` を実行してテストを実行します。対話型プロンプトとして `bin/console` を実行して試してみることもできます。

この gem をローカルマシンにインストールするには、`bundle exec rake install` を実行します。新しいバージョンをリリースするには、`version.rb` でバージョン番号を更新してから `bundle exec rake release` を実行します。これにより、バージョンに対する Git タグが作成され、Git のコミットと作成されたタグがプッシュされ、.gem ファイルが rubygems.org にプッシュされます。

## Contributing

バグレポートやプルリクエストは GitHub の https://github.com/kokuyouwind/rbs_goose で受け付けています。このプロジェクトは、共同作業のための安全で歓迎すべきスペースを目指しており、貢献者は [行動規範](/CODE_OF_CONDUCT.md) に従うことが求められます。

## ライセンス

この gem は [MITライセンス](https://opensource.org/licenses/MIT) の条項に基づいてオープンソースとして利用できます。

## 行動規範

RbsGoose プロジェクトのコードベース、課題トラッカー、チャットルーム、およびメーリングリストに関わる全員は、 [行動規範](/CODE_OF_CONDUCT.md) に従うことが求められます。

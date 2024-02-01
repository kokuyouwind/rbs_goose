<p align="center">
  <img src="https://raw.githubusercontent.com/kokuyouwind/rbs_goose/main/assets/logo.svg" alt="RuboCop Logo"/>
</p>

[![en-US README](https://img.shields.io/badge/Multilingual_README-en--US-blue.svg)](/README.md)
[![ja-JP README](https://img.shields.io/badge/Multilingual_README-ja--JP-orangered.svg)](/README-ja.md)

[![Ruby](https://github.com/kokuyouwind/rbs_goose/actions/workflows/main.yml/badge.svg)](https://github.com/kokuyouwind/rbs_goose/actions/workflows/main.yml)

RBS Goose is a tool that uses ChatGPT and other large language models to infer the RBS signature of Ruby code.

> [!CAUTION]
> Currently undergoing technical validation, so you may get little or no output of the appropriate types.
> Also, the tool uses ChatGPT API and other tools to infer RBS signatures, so depending on the size of your code, the usage fee may be expensive.

## Installation

```bash
$ gem install rbs_goose
## Depending on the LangChain LLM you are using, install the corresponding gem
$ gem install ruby-openai
```

If you use `bundler`, add the following to your `Gemfile` instead.

```ruby
gem 'rbs_goose'.
# Depending on your LangChain LLM, install the corresponding gem
gem 'ruby-openai'
```

## Usage

Currently, command line tools are not yet available, so please call `RbsGoose.run` directly from `Rakefile` or other sources.

If you use [OpenAI API](https://openai.com/blog/openai-api), do the following.

```ruby
require 'rbs_goose'
require 'openai'

desc 'refine RBS files in sig directory' ```ruby require 'rbs_goose' require 'openai'
task :refine do
  RbsGoose.configure do |c|
    c.use_open_ai(ENV.fetch('OPENAI_ACCESS_TOKEN'))
  end
  RbsGoose.run
end
```

Running this task will reference the Ruby code under `lib` and the RBS signature under `sig` and override the guessed signature.

To change the target directory, specify the following arguments to `RbsGoose.run`.

```ruby
RbsGoose.run(code_dir: 'app', sig_dir: 'types', base_path: Rails.root)
```

[Langchain.rb](https://github.com/andreibondarev/langchainrb) is used to invoke the large language model.

To use other large-scale language models, set `llm` directly as follows.

```ruby
RbsGoose.configure do |c|
  c.llm = Langchain::LLM::GooglePalm.new(api_key: ENV["GOOGLE_PALM_API_KEY"])
end
```

## Development

After checking out the repository, run bin/setup to install the dependencies. Next, run `rake spec` to run the tests. You can also try running `bin/console` as an interactive prompt.

To install the gem on your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb` and run `bundle exec rake release`. This will create a Git tag for the version, push the Git commit and the created tag, and push the .gem file to rubygems.org.

## Contributing

Bug reports and pull requests are accepted on GitHub at https://github.com/kokuyouwind/rbs_goose. The project aims to be a safe and welcoming space for collaborative work, and contributors are expected to follow the [CODE OF CONDUCT](/CODE_OF_CONDUCT.md).

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone involved with the RbsGoose project codebase, issue tracker, chat room, and mailing lists is expected to follow the [CODE OF CONDUCT](/CODE_OF_CONDUCT.md).

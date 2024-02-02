<p align="center">
  <img src="https://raw.githubusercontent.com/kokuyouwind/rbs_goose/main/assets/logo.svg" alt="RuboCop Logo"/>
</p>

[![en-US README](https://img.shields.io/badge/Multilingual_README-en--US-blue.svg)](/README.md)
[![ja-JP README](https://img.shields.io/badge/Multilingual_README-ja--JP-orangered.svg)](/README-ja.md)

[![Ruby](https://github.com/kokuyouwind/rbs_goose/actions/workflows/main.yml/badge.svg)](https://github.com/kokuyouwind/rbs_goose/actions/workflows/main.yml)

RBS Goose is a tool that uses large language models like ChatGPT to infer RBS signatures for Ruby code.

> [!CAUTION]
> Currently in the process of technical verification, there is a possibility that appropriate types may not be output at all or may not be output in most cases.
> Also, when inferring, it may be expensive to use services such as the ChatGPT API, depending on the size of the code.

## Installation

```bash
$ gem install rbs_goose
# Install the corresponding gem according to the LangChain LLM you want to use
$ gem install ruby-openai
```

If you are using `bundler`, add the following to your `Gemfile` instead.

```ruby
gem 'rbs_goose'
# Install the corresponding gem according to the LangChain LLM you want to use
gem 'ruby-openai'
```

## Usage

As the command-line tool is not fully developed at the moment, please call `RbsGoose.run` directly from a file like `Rakefile`.

To use the [OpenAI API](https://openai.com/blog/openai-api), do the following:

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

When you run this task, it will reference the Ruby code in the `lib` directory and the RBS signatures in the `sig` directory, and overwrite the inferred signatures.

If you want to change the target directories, specify the arguments for `RbsGoose.run` as follows:

```ruby
RbsGoose.run(code_dir: 'app', sig_dir: 'types', base_path: Rails.root)
```

The invocation of the large language model uses [Langchain.rb](https://github.com/andreibondarev/langchainrb).

If you want to use another large language model, set the `llm` directly as follows:

```ruby
RbsGoose.configure do |c|
  c.llm = Langchain::LLM::GooglePalm.new(api_key: ENV["GOOGLE_PALM_API_KEY"])
end
```

## Development

After checking out the repository, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`. This will create a git tag for the version, push git commits and tags, and push the .gem file to rubygems.org.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kokuyouwind/rbs_goose. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](/CODE_OF_CONDUCT.md).

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RbsGoose project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [code of conduct](/CODE_OF_CONDUCT.md).
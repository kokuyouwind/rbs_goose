# frozen_string_literal: true

RSpec.describe RbsGoose::Templates::FixErrorTemplate do
  let(:example_groups) do
    [RbsGoose::IO::ExampleGroup.load_from(fixture_path('examples/with_errors'))]
  end

  let(:input_typed_ruby_list) do
    [
      build(
        :typed_ruby,
        ruby: build(:file, content: 'ruby_1_input', path: 'input_ruby_1.rb'),
        rbs: build(:file, content: 'rbs_1_input', path: 'input_rbs_1.rbs')
      ),
      build(
        :typed_ruby,
        ruby: build(:file, content: 'ruby_2_input', path: 'input_ruby_2.rb'),
        rbs: build(:file, content: 'rbs_2_input', path: 'input_rbs_2.rbs')
      )
    ]
  end
  let(:input_error_messages) { 'error_message_input' }

  describe '#format' do
    subject do
      described_class.new(instruction:, example_groups:)
                     .format(
                       typed_ruby_list: input_typed_ruby_list,
                       error_messages: input_error_messages
                     )
    end

    let(:instruction) { 'This is example instruction.' }

    it 'returns formatted prompt' do # rubocop:disable RSpec/ExampleLength
      expect(subject).to eq(<<~PROMPT.strip)
        This is example instruction.

        ========Input========
        ```ruby:lib/test.rb
        def test; end
        ```

        ```rbs:sig/test.rbs
        def test: untyped
        ```


        ========Errors========
        error_message


        ========Output========
        ```rbs:sig/test.rbs
        def test: string
        ```


        ========Input========
        ```ruby:input_ruby_1.rb
        ruby_1_input
        ```

        ```rbs:input_rbs_1.rbs
        rbs_1_input
        ```

        ```ruby:input_ruby_2.rb
        ruby_2_input
        ```

        ```rbs:input_rbs_2.rbs
        rbs_2_input
        ```


        ========Errors========
        error_message_input


        ========Output========
      PROMPT
    end
  end

  describe '#format_system_prompt' do
    subject { described_class.new(instruction:, example_groups:).format_system_prompt }

    let(:instruction) { 'This is example instruction.' }

    it 'returns formatted prompt' do
      expect(subject).to eq('This is example instruction.')
    end
  end

  describe '#format_user_prompt' do
    subject do
      described_class.new(instruction:, example_groups:)
                     .format_user_prompt(
                       typed_ruby_list: input_typed_ruby_list,
                       error_messages: input_error_messages
                     )
    end

    let(:instruction) { 'This is example instruction.' }

    it 'returns formatted prompt' do # rubocop:disable RSpec/ExampleLength
      expect(subject).to eq(<<~PROMPT.strip)
        ========Input========
        ```ruby:lib/test.rb
        def test; end
        ```

        ```rbs:sig/test.rbs
        def test: untyped
        ```


        ========Errors========
        error_message


        ========Output========
        ```rbs:sig/test.rbs
        def test: string
        ```


        ========Input========
        ```ruby:input_ruby_1.rb
        ruby_1_input
        ```

        ```rbs:input_rbs_1.rbs
        rbs_1_input
        ```

        ```ruby:input_ruby_2.rb
        ruby_2_input
        ```

        ```rbs:input_rbs_2.rbs
        rbs_2_input
        ```


        ========Errors========
        error_message_input


        ========Output========
      PROMPT
    end
  end

  describe '#parse_result' do
    subject { described_class.new(instruction: '', example_groups: []).parse_result(result) }

    let(:result) do
      <<~RESULT
        ```rbs:result_rbs_1.rbs
        result_rbs_1_line_1
        result_rbs_1_line_2
        result_rbs_1_line_3
        ```

        ```rbs:result_rbs_2.rbs
        result_rbs_2_line_1
        result_rbs_2_line_2
        result_rbs_2_line_3
        ```
      RESULT
    end

    it 'returns parsed files' do
      expect(subject).to contain_exactly(
        be_a(RbsGoose::IO::File)
          .and(have_attributes(
                 path: 'result_rbs_1.rbs',
                 content: <<~RBS.strip
                   result_rbs_1_line_1
                   result_rbs_1_line_2
                   result_rbs_1_line_3
                 RBS
               )),
        be_a(RbsGoose::IO::File)
          .and(have_attributes(
                 path: 'result_rbs_2.rbs',
                 content: <<~RBS.strip
                   result_rbs_2_line_1
                   result_rbs_2_line_2
                   result_rbs_2_line_3
                 RBS
               ))
      )
    end
  end
end

# frozen_string_literal: true

RSpec.describe RbsGoose::Templates::DefaultTemplate do
  let(:example_groups) do
    [
      RbsGoose::IO::ExampleGroup.load_from(fixture_path('examples/test')),
      RbsGoose::IO::ExampleGroup.load_from(fixture_path('examples/multi_file_test'))
    ]
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

  describe '#format' do
    subject do
      described_class.new(instruction: instruction, example_groups: example_groups).format(input_typed_ruby_list)
    end

    let(:instruction) { 'This is example instruction.' }

    it 'returns formatted prompt' do
      expect(subject).to eq(<<~PROMPT)
        This is example instruction.

        ========Input========
        ```ruby:lib/test.rb
        def test; end
        ```

        ```rbs:sig/test.rbs
        def test: untyped
        ```


        ========Output========
        ```rbs:sig/test.rbs
        def test: string
        ```


        ========Input========
        ```ruby:lib/test1.rb
        ruby test1
        ```

        ```rbs:sig/test1.rbs
        rbs test1
        ```

        ```ruby:lib/test2.rb
        ruby test2
        ```

        ```rbs:sig/test2.rbs
        rbs test2
        ```


        ========Output========
        ```rbs:sig/test1.rbs
        refined rbs test1
        ```

        ```rbs:sig/test2.rbs
        refined rbs test2
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

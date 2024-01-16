# frozen_string_literal: true

RSpec.describe RbsGoose::Templates::OneByOneTemplate do
  let(:examples) do
    [{
      typed_ruby: build(
        :typed_ruby,
        ruby: build(:file, :with_multi_line_content, line_prefix: 'example_ruby_line_', path: 'example_ruby.rb'),
        rbs: build(:file, :with_multi_line_content, line_prefix: 'example_rbs_line_', path: 'example_rbs.rbs')
      ),
      refined_rbs: build(
        :file, :with_multi_line_content,
        line_prefix: 'example_refined_rbs_line_',
        path: 'example_rbs.rbs'
      )
    }]
  end

  let(:input_typed_ruby) do
    build(
      :typed_ruby,
      ruby: build(:file, :with_multi_line_content, line_prefix: 'input_ruby_line_', path: 'input_ruby.rb'),
      rbs: build(:file, :with_multi_line_content, line_prefix: 'input_rbs_line_', path: 'input_rbs.rbs')
    )
  end

  describe '#format' do
    subject { described_class.new(instruction: instruction, examples: examples).format(input_typed_ruby) }

    let(:instruction) { 'This is example instruction.' }

    it 'returns formatted prompt' do
      expect(subject).to eq(<<~PROMPT)
        This is example instruction.

        ========Input========
        ```ruby:example_ruby.rb
        example_ruby_line_1
        example_ruby_line_2
        example_ruby_line_3
        ```

        ```rbs:example_rbs.rbs
        example_rbs_line_1
        example_rbs_line_2
        example_rbs_line_3
        ```


        ========Output========
        ```rbs:example_rbs.rbs
        example_refined_rbs_line_1
        example_refined_rbs_line_2
        example_refined_rbs_line_3
        ```


        ========Input========
        ```ruby:input_ruby.rb
        input_ruby_line_1
        input_ruby_line_2
        input_ruby_line_3
        ```

        ```rbs:input_rbs.rbs
        input_rbs_line_1
        input_rbs_line_2
        input_rbs_line_3
        ```


        ========Output========
      PROMPT
    end
  end

  describe '#parse_result' do
    subject { described_class.new(instruction: '', examples: []).parse_result(result) }

    let(:result) do
      <<~RESULT
        ```rbs:result_rbs.rbs
        result_rbs_line_1
        result_rbs_line_2
        result_rbs_line_3
        ```
      RESULT
    end

    it 'returns parsed files' do
      expect(subject).to contain_exactly(
        be_a(RbsGoose::IO::File)
          .and(have_attributes(
                 path: 'result_rbs.rbs',
                 content: <<~RBS.strip
                   result_rbs_line_1
                   result_rbs_line_2
                   result_rbs_line_3
                 RBS
               ))
      )
    end
  end
end

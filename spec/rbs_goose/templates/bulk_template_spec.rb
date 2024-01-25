# frozen_string_literal: true

RSpec.describe RbsGoose::Templates::BulkTemplate do
  let(:example_groups) do
    [[
      build(:example,
            typed_ruby: build(
              :typed_ruby,
              ruby: build(:file, content: 'ruby_1', path: 'example_ruby_1.rb'),
              rbs: build(:file, content: 'rbs_1', path: 'example_rbs_1.rbs')
            ),
            refined_rbs: build(:file, content: 'refined_rbs_1', path: 'example_rbs_1.rbs')),
      build(:example,
            typed_ruby: build(
              :typed_ruby,
              ruby: build(:file, content: 'ruby_2', path: 'example_ruby_2.rb'),
              rbs: build(:file, content: 'rbs_2', path: 'example_rbs_2.rbs')
            ),
            refined_rbs: build(:file, content: 'refined_rbs_2', path: 'example_rbs_2.rbs'))
    ]]
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
        ```ruby:example_ruby_1.rb
        ruby_1
        ```

        ```rbs:example_rbs_1.rbs
        rbs_1
        ```

        ```ruby:example_ruby_2.rb
        ruby_2
        ```

        ```rbs:example_rbs_2.rbs
        rbs_2
        ```


        ========Output========
        ```rbs:example_rbs_1.rbs
        refined_rbs_1
        ```

        ```rbs:example_rbs_2.rbs
        refined_rbs_2
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
end

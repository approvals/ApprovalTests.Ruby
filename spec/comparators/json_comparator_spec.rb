require 'spec_helper'
require 'approvals/configuration'
require 'approvals/namers/default_namer'

describe Approvals::Comparators::JsonComparator do
  let(:namer){ |example| Approvals::Namers::RSpecNamer.new(example) }
  subject{ Approvals.verify json, :format => :json, comparator: {ignore_ordering_paths: ignore_patterns}, :namer => namer }

  context "no params" do
    let(:json) { "[2, 1, 3]" }
    let(:ignore_patterns) { nil }
    it "performs order-sensitive comparisons" do
      Approvals::Dotfile.stub(:path => '/dev/null')
      expect{subject}.to raise_error Approvals::ApprovalError
    end
  end

  context "with params" do
    test_cases = [
      # case, input, ignore keys, success
      ["plain arrays", '[2,1,3]', '', true],
      ["plain arrays and the root scope", '[2,1,3]', '.', true],
      ["nested arrays", '{"nested": [2,1,3]}', 'nested', true],
      ["arrays of objects", '{"nested": [{"a": 2}, {"a": 1}, {"a": 3}]}', 'nested', true],
      ["deep nesting", '{"nested": {"nestedyetagain": [{"a": 2}, {"a": 1}, {"a": 3}]}}', 'nested.nestedyetagain', true],
      ["deep nesting with wildcards", '{"nested": {"nestedyetagain": {"another": [{"a": 2}, {"a": 1}, {"a": 3}]}}}', 'nested.*.another', true],
      ["wildcard array indices", '[{"arr": [3, 2, 1]}, {"arr": [1, 2, 3]}, {"arr": [1, 2, 3]}]', '*.arr', true],
      ["multiple keys with ambiguity", '[{"arr": [3, 2, 1]}, {"arr": [1, 2, 3]}, {"arr": [1, 2, 3]}]', ['*.arr', ''], true],
      ["multiple keys without ambiguity", '[{"arr": [5, 4, 6]}, {"arr": [2, 1, 3]}, {"arr": [8, 7, 9]}]', ['*.arr', ''], true],
      ["not given enough keys", '[{"arr": [5, 4, 6]}, {"arr": [2, 1, 3]}, {"arr": [8, 7, 9]}]', ['*.arr'], false]
    ]
    test_cases.each { |test_case|
      context test_case[0] do
        let(:json){ test_case[1] }
        let(:ignore_patterns){ test_case[2] }
        it test_case[3] ? "works": "fails" do
          if test_case[3]
            subject
          else
            Approvals::Dotfile.stub(:path => '/dev/null')
            expect{subject}.to raise_error Approvals::ApprovalError
          end
        end
      end
    }
  end
end

require 'spec_helper'
require 'approvals/configuration'
require 'approvals/namers/default_namer'

describe Approvals::Comparators::JsonComparator do

  let(:namer){ |example| Approvals::Namers::RSpecNamer.new(example) }

  context "when left unperturbed" do
    it "performs order-sensitive comparisons" do
      Approvals::Dotfile.stub(:path => '/dev/null')
      lambda {
        Approvals.verify '[2,1,3]', :format => :json, :namer => namer
      }.should raise_error Approvals::ApprovalError
    end
  end

  context "when passed parameters" do
    subject{ Approvals.verify json, :format => :json, comparator: {ignore_ordering_paths: ignore_patterns}, :namer => namer }
    context "and given plain arrays" do
        let(:json) { '[2,1,3]' }
        let(:ignore_patterns) { '' }
        it "doesn't fail" do
          subject
        end
    end

    context "and given nested arrays" do
        let(:json) { '{"nested": [2,1,3]}' }
        let(:ignore_patterns) { 'nested' }
        it "doesn't fail" do
          subject
        end
    end

    context "and given arrays of objects" do
        let(:json) { '{"nested": [{"a": 2}, {"a": 1}, {"a": 3}]}' }
        let(:ignore_patterns) { 'nested' }
        it "doesn't fail" do
          subject
        end
    end

    context "and given deep nesting" do
        let(:json) { '{"nested": {"nestedyetagain": [{"a": 2}, {"a": 1}, {"a": 3}]}}' }
        let(:ignore_patterns) { 'nested.nestedyetagain' }
        it "doesn't fail" do
          subject
        end
    end

    context "and given deep nesting with wildcards" do
        let(:json) { '{"nested": {"nestedyetagain": {"another": [{"a": 2}, {"a": 1}, {"a": 3}]}}}' }
        let(:ignore_patterns) { 'nested.*.another' }
        it "doesn't fail" do
          subject
        end
    end

    context "and given wildcard array indices" do
        let(:json) { '[{"arr": [3, 2, 1]}, {"arr": [1, 2, 3]}, {"arr": [1, 2, 3]}]' }
        let(:ignore_patterns) { '*.arr' }
        it "doesn't fail" do
          subject
        end
    end

    context "and given multiple keys with ambiguity" do
        let(:json) { '[{"arr": [3, 2, 1]}, {"arr": [1, 2, 3]}, {"arr": [1, 2, 3]}]' }
        let(:ignore_patterns) { ['*.arr', ''] }
        it "doesn't fail" do
          subject
        end
    end

    context "and given multiple keys without ambiguity" do
        let(:json) { '[{"arr": [5, 4, 6]}, {"arr": [2, 1, 3]}, {"arr": [8, 7, 9]}]' }
        let(:ignore_patterns) { ['*.arr', ''] }
        it "doesn't fail" do
          subject
        end
    end

    context "not given enough keys" do
        let(:json) { '[{"arr": [5, 4, 6]}, {"arr": [2, 1, 3]}, {"arr": [8, 7, 9]}]' }
        let(:ignore_patterns) { ['*.arr'] }
        it "fails" do
          Approvals::Dotfile.stub(:path => '/dev/null')
          expect{subject}.to raise_error Approvals::ApprovalError
        end
    end
  end
end

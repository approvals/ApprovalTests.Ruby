require 'spec_helper'

describe Approvals do

  it "defaults the output dir to spec/approvals" do
    RSpec.configuration.approvals_path.should == 'spec/approvals'
  end

  describe "initializing approval directory" do
    it "does nothing if directory exists" do
      RSpec.configuration.stub(:approvals_path).and_return 'xyz'
      Dir.stub(:exists?).and_return true
      FileUtils.should_not_receive(:makedirs).with 'xyz'

      Approvals.initialize_approvals_path
    end

    it "creates directory if it is missing" do
      RSpec.configuration.stub(:approvals_path).and_return 'abc'
      Dir.stub(:exists?).and_return false
      FileUtils.should_receive(:makedirs).with('abc')

      Approvals.initialize_approvals_path
    end
  end

  it "needs to be able to run with :filtered => true"

  approve "a string" do
    "We have, I fear, confused power with greatness."
  end

  approve "a hash" do
    {
      :universe => {
        :side => :dark,
        :other_side => :light
      },
      :force => true,
      :evil => "undecided"
    }
  end

  approve "an array" do
    [
      "abc",
      123,
      :zomg_fooooood,
      %w(cheese burger ribs steak bacon)
    ]
  end

  approve "a complex object" do
    hello = Object.new
    def hello.to_s
      "Hello, World!"
    end

    def hello.inspect
      "#<The World Says: Hello!>"
    end

    hello # => output matches hello.inspect
  end

end

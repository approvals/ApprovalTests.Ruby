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

  it "cleans up the given line of the backtrace" do
    Dir.stub(:pwd => 'the/path')
    location = Approvals.location_of('the/path/to/my/heart:9372 <is through my stomach>')
    location.should eq('./to/my/heart:9372')
  end

  it "needs to be able to run with :filtered => true"

end

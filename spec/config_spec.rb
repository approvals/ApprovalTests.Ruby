require 'rspec/approvals'

describe RSpec::Approvals do
  include RSpec

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
end

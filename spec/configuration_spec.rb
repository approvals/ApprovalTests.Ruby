require 'approvals/configuration'

describe Approvals::Configuration do

  it "defaults to 'approvals/'" do
    Approvals.configuration.approvals_path.should eq('approvals/')
  end

  describe "when set" do
    before(:each) do
      Approvals.configure do |c|
        c.approvals_path = 'output/dir/'
      end
    end

    it "overrides the output directory" do
      Approvals.configuration.approvals_path.should eq('output/dir/')
    end
  end

end

require 'approvals'

describe Approvals::Namers::RSpecNamer do
  include Approvals::Namers

  it "uses non-$%^&*funky example description" do
    RSpecNamer.new(self.example).name.should eq("approvals_namers_rspecnamer_uses_non_funky_example_description")
  end

  it "has a decent default" do
    RSpecNamer.new(self.example).output_dir.should eq('spec/fixtures/approvals/')
  end

  context "when RSpec is configured" do
    before :each do
      RSpec.configure do |c|
        c.approvals_path = 'spec/output/dir/'
      end
    end

    after :each do
      RSpec.configure do |c|
        c.approvals_path = nil
      end
    end

    it "uses the rspec config option" do
      RSpecNamer.new(self.example).output_dir.should eq('spec/output/dir/')
    end
  end
end

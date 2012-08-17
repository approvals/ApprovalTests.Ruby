require 'spec_helper'
require 'approvals/rspec'

describe Approvals::Namers::DirectoryNamer do

  it "uses non-$%^&*funky example description" do
    Approvals::Namers::DirectoryNamer.new(self.example).name.should eq("approvals_namers_directorynamer/uses_non_funky_example_description")
  end

  it "has a decent default" do
    Approvals::Namers::DirectoryNamer.new(self.example).output_dir.should eq('spec/fixtures/approvals/')
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
      Approvals::Namers::DirectoryNamer.new(self.example).output_dir.should eq('spec/output/dir/')
    end
  end
end

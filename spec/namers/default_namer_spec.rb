require 'approvals/configuration'
require 'approvals/namers/default_namer'

describe Approvals::Namers::DefaultNamer do
  include Approvals::Namers

  subject { DefaultNamer.new("a f!$^%&*(unky name") }

  it "normalizes the name" do
    subject.name.should eq("a_funky_name")
  end

  context "when configured" do
    before :each do
      Approvals.configure do |c|
        c.approvals_path = 'path/to/files/'
      end
    end

    after :each do
      Approvals.configure do |c|
        c.approvals_path = nil
      end
    end

    it "uses the approvals output dir" do
      subject.output_dir.should eq('path/to/files/')
    end
  end

end

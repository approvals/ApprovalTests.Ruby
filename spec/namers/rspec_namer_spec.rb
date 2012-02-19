require 'approvals/namers/rspec_namer'

describe Approvals::Namers::RSpecNamer do
  include Approvals::Namers

  it "uses non-$%^&*funky example description" do
    RSpecNamer.new(self.example).name.should eq("approvals_namers_rspecnamer_uses_non_funky_example_description")
  end

  it "has a decent default source dir" do
    RSpecNamer.new(self.example).output_dir.should eq('spec/fixtures/approvals/')
  end
end

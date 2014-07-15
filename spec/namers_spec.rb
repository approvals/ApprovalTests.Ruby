require 'spec_helper'
require 'approvals/rspec'

describe Approvals::Namers do

  it "uses the RSpecNamer" do |example|
    approval = Approvals::Approval.new("naming with rspec namer", :namer => Approvals::Namers::RSpecNamer.new(example))
    approval.name.should eq("approvals_namers_uses_the_rspecnamer")
  end

  it "uses the DefaultNamer" do
    approval = Approvals::Approval.new("naming with default namer", :name => "a name")
    approval.name.should eq("a_name")
  end

end

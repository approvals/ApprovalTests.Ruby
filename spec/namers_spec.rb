require 'approvals'

describe Approvals::Namers do
  include Approvals::Namers

  it "uses the RSpecNamer" do
    approval = Approvals::Approval.new("naming with rspec namer", :namer => RSpecNamer.new(self.example))
    approval.name.should eq("approvals_namers_uses_the_rspecnamer")
  end

  it "uses the DefaultNamer" do
    approval = Approvals::Approval.new("naming with default namer", :name => "a name")
    approval.name.should eq("a_name")
  end

end

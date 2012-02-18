require 'rspec/approvals/system_command'

describe RSpec::Approvals::SystemCommand, "#exists?" do
  include RSpec::Approvals

  it "does" do
    SystemCommand.exists?("ls").should be_true
  end

  it "does not" do
    SystemCommand.exists?("absolutelydoesnotexistonyoursystem").should be_false
  end
end

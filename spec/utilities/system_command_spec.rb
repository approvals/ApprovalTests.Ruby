require 'approvals/utilities/system_command'

describe Approvals::SystemCommand, "#exists?" do
  include Approvals

  it "does" do
    SystemCommand.exists?("ls").should be_true
  end

  it "does not" do
    SystemCommand.exists?("absolutelydoesnotexistonyoursystem").should be_false
  end
end

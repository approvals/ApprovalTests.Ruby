require 'spec_helper'
require 'approvals/system_command'

describe Approvals::SystemCommand, "#exists?" do

  it "does" do
    Approvals::SystemCommand.exists?("ls").should be_truthy
  end

  it "does not" do
    Approvals::SystemCommand.exists?("absolutelydoesnotexistonyoursystem").should be_falsey
  end
end

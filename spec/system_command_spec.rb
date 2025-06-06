require 'spec_helper'

describe Approvals::SystemCommand, "#exists?" do

  it "does" do
    program = Approvals::SystemUtils.windows? ? "where" : "ls"
    expect(Approvals::SystemCommand.exists?(program)).to be_truthy
  end

  it "does not" do
    expect(Approvals::SystemCommand.exists?("absolutelydoesnotexistonyoursystem")).to be_falsey
  end
end

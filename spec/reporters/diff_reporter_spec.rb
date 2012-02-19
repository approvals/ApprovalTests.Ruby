require 'approvals/reporters'

describe Approvals::Reporters::DiffReporter do
  include Approvals::Reporters

  it "is not approved by default" do
    DiffReporter.new.should_not be_approved_when_reported
  end

  it "takes a launcher" do
    move = lambda {|received, approved|
      "echo \"mv #{received} #{approved}\""
    }

    DiffReporter.new(&move).launcher.call('received.txt', 'approved.txt').should eq("echo \"mv received.txt approved.txt\"")
  end

  it "defaults to the default OpenDiff launcher" do
    DiffReporter.new.launcher.should eq(Launcher.opendiff)
  end
end

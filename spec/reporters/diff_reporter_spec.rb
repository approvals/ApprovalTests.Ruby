require 'approvals/reporters'

describe Approvals::Reporters::DiffReporter do


  it "is not approved by default" do
    Approvals::Reporters::DiffReporter.new.should_not be_approved_when_reported
  end

  it "takes a launcher" do
    move = lambda {|received, approved|
      "echo \"mv #{received} #{approved}\""
    }

    Approvals::Reporters::DiffReporter.new(&move).launcher.call('received.txt', 'approved.txt').should eq("echo \"mv received.txt approved.txt\"")
  end

  it "defaults to the default OpenDiff launcher" do
    Approvals::Reporters::DiffReporter.new.launcher.should eq(Approvals::Reporters::Launcher.opendiff)
  end
end

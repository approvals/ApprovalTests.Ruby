require 'approvals/reporters/first_working_reporter'

describe Approvals::Reporters::FirstWorkingReporter do


  let(:no) { stub(:working_in_this_environment? => false) }
  let(:yes) { stub(:working_in_this_environment? => true) }
  let(:yes_too) { stub(:working_in_this_environment? => true) }

  context "when at least one reporter works" do
    subject { Approvals::Reporters::FirstWorkingReporter.new(no, yes) }
    its(:working_in_this_environment?) { should be_true }
  end

  context "when no reporters work" do
    subject { Approvals::Reporters::FirstWorkingReporter.new(no, no) }
    its(:working_in_this_environment?) { should be_false }
  end

  it "calls the first working reporter" do
    working = Approvals::Reporters::FirstWorkingReporter.new(no, yes, yes_too)

    no.should_not_receive(:report)
    yes.should_receive(:report)
    yes_too.should_not_receive(:report)

    working.report("r", "a")
  end
end

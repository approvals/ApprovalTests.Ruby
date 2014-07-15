require 'spec_helper'
require 'approvals/reporters/first_working_reporter'

describe Approvals::Reporters::FirstWorkingReporter do


  let(:no) { double(:working_in_this_environment? => false) }
  let(:yes) { double(:working_in_this_environment? => true) }
  let(:yes_too) { double(:working_in_this_environment? => true) }

  it "when at least one reporter works it is working" do
    reporter = Approvals::Reporters::FirstWorkingReporter.new(no, yes)
    reporter.should be_working_in_this_environment
  end

  it "when no reporters work it's not working" do
    reporter = Approvals::Reporters::FirstWorkingReporter.new(no, no)
    reporter.should_not be_working_in_this_environment
  end

  it "calls the first working reporter" do
    working = Approvals::Reporters::FirstWorkingReporter.new(no, yes, yes_too)

    no.should_not_receive(:report)
    yes.should_receive(:report)
    yes_too.should_not_receive(:report)

    working.report("r", "a")
  end
end

require 'approvals/reporters/launcher'

describe Approvals::Reporters::Launcher do
  include Approvals::Reporters

  it "has a vimdiff launcher" do
    Launcher.vimdiff.call('one', 'two').should eq("vimdiff one two")
  end

  it "has an opendiff launcher" do
    Launcher.opendiff.call('one', 'two').should eq("opendiff one two")
  end

  it "has a diffmerge launcher" do
    Launcher.diffmerge.call('one', 'two').should match(/DiffMerge.*\"one\"\ \"two\"/)
  end
end

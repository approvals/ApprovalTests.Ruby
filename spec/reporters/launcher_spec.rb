require 'approvals/reporters/launcher'

describe Approvals::Reporters::Launcher do


  it "has a vimdiff launcher" do
    Approvals::Reporters::Launcher.vimdiff.call('one', 'two').should eq("vimdiff one two")
  end

  it "has an opendiff launcher" do
    Approvals::Reporters::Launcher.opendiff.call('one', 'two').should eq("opendiff one two")
  end

  it "has a diffmerge launcher" do
    Approvals::Reporters::Launcher.diffmerge.call('one', 'two').should match(/DiffMerge.*\"one\"\ \"two\"/)
  end

  it "has a tortoisediff launcher" do
    Approvals::Reporters::Launcher.tortoisediff.call('one', 'two').should match(/TortoiseMerge.exe.*one.*two/)
  end

  it "has a filelauncher launcher" do
    Approvals::Reporters::Launcher.filelauncher.call('one', 'two').should eq("open one")
  end
end

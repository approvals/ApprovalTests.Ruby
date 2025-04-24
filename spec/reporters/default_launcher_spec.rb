require 'spec_helper'

describe "#default_launcher" do
  def default_launcher_for(reporter_name)
    klass = ::Approvals::Reporters.const_get(reporter_name)
    reporter = klass.ancestors.include?(Singleton) ? klass.instance : klass.new
    reporter.default_launcher
  end

  def launcher(name)
    Approvals::Reporters::Launcher.send(name)
  end

  it { expect( default_launcher_for(:DiffmergeReporter)    ).to eq launcher(:diffmerge) }
  it { expect( default_launcher_for(:FilelauncherReporter) ).to eq launcher(:filelauncher) }
  it { expect( default_launcher_for(:OpendiffReporter)     ).to eq launcher(:opendiff) }
  it { expect( default_launcher_for(:TortoisediffReporter) ).to eq launcher(:tortoisediff) }
  it { expect( default_launcher_for(:VimdiffReporter)      ).to eq launcher(:vimdiff) }
end

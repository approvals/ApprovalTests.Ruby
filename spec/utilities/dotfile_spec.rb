require 'approvals/utilities/dotfile'

describe Approvals::Dotfile do
  let(:dotfile) { '/tmp/.approvals' }

  before(:each) do
    Approvals::Dotfile.stub(:path => dotfile)
    Approvals::Dotfile.reset
  end

  it "appends the text" do
    Approvals::Dotfile.append('text')
    File.readlines(dotfile).map(&:chomp).should eq(['text'])
  end

  it "appends the text exactly once" do
    Approvals::Dotfile.append('text')
    Approvals::Dotfile.append('text')
    File.readlines(dotfile).map(&:chomp).should eq(['text'])
  end
end

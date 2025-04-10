require 'spec_helper'
require 'approvals/dotfile'
require 'tempfile'

describe Approvals::Dotfile do
  let(:dotfile) { Tempfile.create('.approvals').tap(&:close).path }

  before(:each) do
    allow(Approvals::Dotfile).to receive(:path).and_return dotfile
    Approvals::Dotfile.reset
  end

  it "appends the text" do
    Approvals::Dotfile.append('text')
    expect(File.readlines(dotfile).map(&:chomp)).to eq ['text']
  end

  it "appends the text exactly once" do
    Approvals::Dotfile.append('text')
    Approvals::Dotfile.append('text')
    expect(File.readlines(dotfile).map(&:chomp)).to eq ['text']
  end
end

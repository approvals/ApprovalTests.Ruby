require 'spec_helper'
require 'approvals/executable'

describe Approvals::Executable do

  it "reflects the its value in inspect" do
    executable = Approvals::Executable.new('SELECT 1')
    executable.inspect.should eq 'SELECT 1'
  end

  it "takes a block" do
    executable = Approvals::Executable.new('SELECT 1') do |command|
      "execute query: #{command}"
    end
    executable.on_failure.call('SELECT 1').should eq('execute query: SELECT 1')
  end
end

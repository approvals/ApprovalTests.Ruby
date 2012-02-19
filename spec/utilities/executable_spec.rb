require 'approvals/utilities/executable'

describe Approvals::Executable do
  include Approvals

  subject { Executable.new('SELECT 1') }
  its(:inspect) { should eq('SELECT 1') }

  it "takes a block" do
    executable = Executable.new('SELECT 1') do |command|
      "execute query: #{command}"
    end
    executable.on_failure.call('SELECT 1').should eq('execute query: SELECT 1')
  end
end

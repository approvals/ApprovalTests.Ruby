require 'rspec/approvals/executable'

describe RSpec::Approvals::Executable do
  include RSpec::Approvals

  subject { Executable.new('SELECT 1') }
  its(:inspect) { should eq('SELECT 1') }

  it "takes a block" do
    command = 'SELECT 1'
    executable = Executable.new(command) do
      'execute query'
    end
    executable.on_failure.call.should eq('execute query')
  end
end

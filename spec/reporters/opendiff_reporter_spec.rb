require 'approvals'

describe Approvals::Reporters::OpendiffReporter do
  include Approvals::Reporters

  it "has a nice launcher" do
    pending "Breaks off execution of the tests. Horrible."
    one = 'spec/fixtures/one.txt'
    two = 'spec/fixtures/two.txt'
    executable = Approvals::Executable.new(OpendiffReporter.instance.launcher.call(one, two)) do |command|
      OpendiffReporter.report(one, two)
    end

    Approvals.verify(executable, :name => 'opendiff launcher')
  end
end

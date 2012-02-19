module Approvals
  module RSpec
    class Example < ::RSpec::Core::Example

      attr_reader :received
      def initialize(example_group, description, options, &block)
        super(example_group, description, options, block)

        namer = Approvals::Namers::RSpecNamer.new(self)
        approval = Approval.new(@example_block.call, options.merge(:namer => namer))
        @example_block = Proc.new { approval.verify }
      end
    end
  end
end



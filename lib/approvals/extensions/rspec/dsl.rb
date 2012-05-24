module Approvals
  module RSpec
    module DSL
      def executable(command, &block)
        Approvals::Executable.new(command, &block)
      end

      def verify(options = {}, &block)
        group = eval "self", block.binding
        namer = ::RSpec.configuration.approvals_namer_class.new(group.example)
        Approvals.verify(block.call, options.merge(:namer => namer))
      end
    end
  end
end

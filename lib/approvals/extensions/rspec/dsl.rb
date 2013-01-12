require 'rspec/expectations'

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
      rescue ApprovalError => e
        ::RSpec::Expectations.fail_with(e.message, e.received_text, e.approved_text)
      end
    end
  end
end

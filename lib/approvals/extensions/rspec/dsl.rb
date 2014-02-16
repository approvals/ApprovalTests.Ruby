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
        defaults = {
          :namer => namer
        }
        Approvals.verify(block.call, defaults.merge(options))
      rescue ApprovalError => e
        if diff_on_approval_failure?
          ::RSpec::Expectations.fail_with(e.message, e.approved_text, e.received_text)
        else
          raise e
        end
      end

      private

      def diff_on_approval_failure?
        ::RSpec.configuration.diff_on_approval_failure? ||
          example.metadata[:diff_on_approval_failure]
      end
    end
  end
end

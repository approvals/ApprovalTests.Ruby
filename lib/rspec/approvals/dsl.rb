require 'rspec/expectations/errors'

module RSpec
  module Approvals
    module DSL

      def approve(description)
        approval = Approval.new(example, description, yield)
        backtrace = Approvals.location_of(caller.first)

        specify(description) do
          if approval.failed?
            exception = RSpec::Expectations::ExpectationNotMetError
            raise exception, approval.failure_message, backtrace
          end
        end
      end

    end
  end
end

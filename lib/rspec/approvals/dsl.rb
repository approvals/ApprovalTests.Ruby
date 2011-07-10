require 'rspec/expectations/errors'

module RSpec
  module Approvals
    module DSL

      def approve(description)
        approval = Approval.new(example, description, yield)

        specify(description) do
          if approval.failed?
            raise RSpec::Expectations::ExpectationNotMetError.new(approval.failure_message)
          end
        end
      end

    end
  end
end

require 'rspec/expectations/errors'

module RSpec
  module Approvals
    module DSL

      def approve(description)
        approval = Approval.new(example, description, yield)
        approval.location = caller

        specify(description, :approval => true) do

          if approval.failed?
            exception = RSpec::Expectations::ExpectationNotMetError
            raise exception, approval.failure_message, approval.location
          end

        end
      end

    end
  end
end

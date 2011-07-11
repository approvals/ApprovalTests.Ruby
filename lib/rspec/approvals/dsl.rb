require 'rspec/expectations/errors'

module RSpec
  module Approvals
    module DSL

      def approve(description)
        approval = Approval.new(example, description, yield)
        approval.location = caller

        specify(description, :approval => true) do
          approval.verify
        end
      end

    end
  end
end

module RSpec
  module Approvals
    module DSL

      def approve(description)
        approval = Approval.new(example, description, yield)

        specify(description) do
          approval.received.should eq(approval.approved)
        end
      end

    end
  end
end

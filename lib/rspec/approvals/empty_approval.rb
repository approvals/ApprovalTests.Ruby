module RSpec
  module Approvals

    class EmptyApproval
      def inspect
        ""
      end
      def strip; end
    end

  end
end

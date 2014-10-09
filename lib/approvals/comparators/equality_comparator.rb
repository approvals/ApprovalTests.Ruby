module Approvals
  module Comparators
    class EqualityComparator

      def initialize(options)
      	# Nothing to see here
      end

      def compare(approved, received)
        approved == received
      end
    end
  end
end

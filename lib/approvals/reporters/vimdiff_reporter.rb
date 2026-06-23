module Approvals
  module Reporters
    class VimdiffReporter < NamedReporter
      def self.command(received, approved)
        "vimdiff \"#{received}\" \"#{approved}\""
      end
    end
  end
end

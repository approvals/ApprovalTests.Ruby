module Approvals
  module Reporters
    class OpendiffReporter < NamedReporter
      def self.command(received, approved)
        "opendiff \"#{received}\" \"#{approved}\""
      end
    end
  end
end

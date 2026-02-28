module Approvals
  module Reporters
    class DiffmergeReporter < NamedReporter
      def self.command(received, approved)
        "/Applications/DiffMerge.app/Contents/MacOS/DiffMerge --nosplash \"#{received}\" \"#{approved}\""
      end
    end
  end
end

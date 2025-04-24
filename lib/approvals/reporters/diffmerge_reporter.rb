module Approvals
  module Reporters
    class DiffmergeReporter < Reporter
      include Singleton

      def self.report(received, approved)
        instance.report(received, approved)
      end

      def default_launcher
        Launcher.diffmerge
      end
    end
  end
end

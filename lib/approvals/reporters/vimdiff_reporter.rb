module Approvals
  module Reporters
    class VimdiffReporter < Reporter
      include Singleton

      def self.report(received, approved)
        instance.report(received, approved)
      end

      def default_launcher
        Launcher.vimdiff
      end
    end
  end
end

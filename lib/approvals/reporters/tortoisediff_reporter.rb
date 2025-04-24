module Approvals
  module Reporters
    class TortoisediffReporter < Reporter
      include Singleton

      def self.report(received, approved)
        instance.report(received, approved)
      end

      def default_launcher
        Launcher.tortoisediff
      end
    end
  end
end

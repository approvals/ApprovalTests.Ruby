module Approvals
  module Reporters
    class OpendiffReporter < Reporter
      include Singleton

      def self.report(received, approved)
        instance.report(received, approved)
      end

      def default_launcher
        Launcher.opendiff
      end
    end
  end
end

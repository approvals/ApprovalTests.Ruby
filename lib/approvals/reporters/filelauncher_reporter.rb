module Approvals
  module Reporters
    class FilelauncherReporter < Reporter
      include Singleton

      def self.report(received, approved = nil)
        instance.report(received, approved)
      end

      def default_launcher
        Launcher.filelauncher
      end
    end
  end
end

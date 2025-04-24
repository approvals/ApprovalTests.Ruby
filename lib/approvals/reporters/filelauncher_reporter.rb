module Approvals
  module Reporters
    class FilelauncherReporter < SingletonReporter
      def default_launcher
        Launcher.filelauncher
      end
    end
  end
end

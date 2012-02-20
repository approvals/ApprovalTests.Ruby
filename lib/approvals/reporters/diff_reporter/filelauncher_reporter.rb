module Approvals
  module Reporters
    class FilelauncherReporter < DiffReporter
      include Singleton

      class << self
        def report(received, approved)
          self.instance.report(received, approved)
        end
      end

      def default_launcher
        Launcher.filelauncher
      end

    end
  end
end

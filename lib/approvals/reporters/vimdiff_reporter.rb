module Approvals
  module Reporters
    class VimdiffReporter < SingletonReporter
      def default_launcher
        Launcher.vimdiff
      end
    end
  end
end

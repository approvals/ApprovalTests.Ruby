module Approvals
  module Reporters
    class OpendiffReporter < SingletonReporter
      def default_launcher
        Launcher.opendiff
      end
    end
  end
end

module Approvals
  module Reporters
    class TortoisediffReporter < SingletonReporter
      def default_launcher
        Launcher.tortoisediff
      end
    end
  end
end

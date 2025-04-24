module Approvals
  module Reporters
    class DiffmergeReporter < SingletonReporter
      def default_launcher
        Launcher.diffmerge
      end
    end
  end
end

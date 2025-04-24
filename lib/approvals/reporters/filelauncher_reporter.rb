module Approvals
  module Reporters
    class FilelauncherReporter < NamedReporter
      def self.command(received, _)
        "open #{received}"
      end
    end
  end
end

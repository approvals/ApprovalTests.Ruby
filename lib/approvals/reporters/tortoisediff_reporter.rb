module Approvals
  module Reporters
    class TortoisediffReporter < NamedReporter
      def self.command(received, approved)
        "C:\\Program Files\\TortoiseSVN\\bin\\TortoiseMerge.exe \"#{received}\" \"#{approved}\""
      end
    end
  end
end

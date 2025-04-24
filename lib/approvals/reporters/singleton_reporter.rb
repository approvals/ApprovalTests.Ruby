module Approvals
  module Reporters
    class SingletonReporter
      include Singleton

      def self.report(received, approved)
        instance.report(received, approved)
      end
    end
  end
end

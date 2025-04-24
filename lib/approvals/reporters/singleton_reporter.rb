module Approvals
  module Reporters
    class SingletonReporter
      include Singleton

      def self.report(received, approved)
        instance.report(received, approved)
      end

      def default_launcher
        Launcher.send(launcher_name)
      end

      private

      def launcher_name
        self
          .class
          .name
          .split("::")
          .last
          .gsub(/Reporter$/, '')
          .downcase
      end
    end
  end
end

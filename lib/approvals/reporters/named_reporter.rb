module Approvals
  module Reporters
    class NamedReporter
      # TODO:  remove this if/when Launcher goes away
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

module RSpec
  module Approvals

    class ImageMagickReporter
      include Singleton

      def working_in_this_environment?
        SystemCommand.exists? "compare"
      end

      def create_command_line(received, approved)
        "compare #{received} #{approved} -compose Src x:"
      end

      def report(received, approved)
        system(create_command_line(received, approved))
      end
    end

  end
end

module RSpec
  module Approvals
    class Executable

      attr_accessor :command, :on_failure
      def initialize(command, &block)
        self.command = command
        self.on_failure = block
      end

      def to_s
        command
      end
    end
  end
end

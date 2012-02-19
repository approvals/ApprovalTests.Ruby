module Approvals
  module RSpec
    module DSL
      def executable(command, &block)
        Approvals::Executable.new(command, &block)
      end
    end
  end
end

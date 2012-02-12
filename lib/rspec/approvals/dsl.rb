require 'rspec/expectations/errors'

module RSpec
  module Approvals
    module DSL

      def verify(description, options = {})

        origin = caller
        specify(description) do
          approval = Approval.new(example, yield, options)

          # We may be able to set file_path and
          # line_number on example in the approval
          # see RSpec::Core::Metadata::LocationKeys
          approval.location = origin

          approval.verify
        end
      end

      def executable(command, &block)
        Executable.new(command, &block)
      end

    end
  end
end

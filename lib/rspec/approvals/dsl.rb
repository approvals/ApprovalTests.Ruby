require 'rspec/expectations/errors'

module RSpec
  module Approvals
    module DSL

      def approve(description, options = {})

        specify(description) do
          approval = Approval.new(example, yield, options)

          # We may be able to set file_path and
          # line_number on example in the approval
          # see RSpec::Core::Metadata::LocationKeys
          approval.location = caller

          approval.verify
        end
      end

    end
  end
end

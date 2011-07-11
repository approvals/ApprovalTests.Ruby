require 'rspec/core/formatters/progress_formatter'

module RSpec
  module Approvals
    module Formatters

      class OpendiffFormatter < RSpec::Core::Formatters::ProgressFormatter
        def dump_failures
          super
          failed_examples.each do |example|
            if example.options[:approval]
              paths = example.options[:approval_diff_paths]
              system("opendiff #{paths[:received]} #{paths[:approved]} &")
            end
          end
        end

      end

    end
  end
end

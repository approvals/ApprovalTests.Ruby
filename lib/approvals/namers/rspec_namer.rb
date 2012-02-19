module Approvals
  module Namers
    class RSpecNamer

      attr_reader :name
      def initialize(example)
        @name = normalize example.full_description
      end

      def normalize(string)
        string.gsub(/[\W]/, ' ').strip.squeeze(" ").gsub(' ', '_').downcase
      end

      def output_dir
        unless @output_dir
          begin
            @output_dir = ::RSpec.configuration.approvals_path
          rescue NoMethodError => e
            @output_dir = 'spec/fixtures/approvals/'
          end
        end
        @output_dir
      end

    end
  end
end

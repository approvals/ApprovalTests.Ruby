module Approvals
  module Namers
    class RSpecNamer

      attr_reader :name
      def initialize(example)
        @name = normalize example.full_description
      end

      def normalize(string)
        string.strip.squeeze(" ").gsub(/[\ :-]+/, '_').gsub(/[\W]/, '').downcase
      end

      def output_dir
        unless @output_dir
          begin
            @output_dir = ::RSpec.configuration.approvals_path
          rescue NoMethodError => e
          end
          @output_dir ||= 'spec/fixtures/approvals/'
        end
        @output_dir
      end

    end
  end
end

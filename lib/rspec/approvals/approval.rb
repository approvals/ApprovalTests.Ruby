module RSpec
  module Approvals

    class Approval

      def self.normalize(s)
        s.gsub(/[\W]/, ' ').strip.squeeze(" ").gsub(' ', '_').downcase
      end

      def self.base_path(s)
        Approvals.path + normalize(s)
      end

      attr_reader :received, :approved

      def initialize(example, description, received = '')
        @path = Approval.base_path(example.full_description + description)

        write(:approved, '') unless File.exists?(approved_path)
        write(:received, received)

        @received = received
        @approved ||= File.read approved_path
      end

      def approved_path
        "#{@path}.approved.txt"
      end

      def received_path
        "#{@path}.received.txt"
      end

      def write(suffix, contents)
        File.open("#{@path}.#{suffix}.txt", 'w') do |f|
          f.write contents
        end
      end

    end
  end
end

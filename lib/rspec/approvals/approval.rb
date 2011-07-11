require 'rspec/expectations/errors'

module RSpec
  module Approvals

    class ReceivedDiffersError < RSpec::Expectations::ExpectationNotMetError; end

    class Approval

      def self.normalize(s)
        s.gsub(/[\W]/, ' ').strip.squeeze(" ").gsub(' ', '_').downcase
      end

      def self.base_path(s)
        Approvals.path + normalize(s)
      end

      attr_reader :location

      def initialize(example, description, received = '')
        @path = Approval.base_path(example.full_description + description)

        write(:approved, '') unless File.exists?(approved_path)
        write(:received, received)
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

      def failure_message
        <<-FAILURE_MESSAGE

        Approval Failure:

        The received contents did not match the approved contents.

        Inspect the differences in the following files:
        #{received_path}
        #{approved_path}

        If you like what you see in the *.received.txt file, you can approve it
        like so:

        mv #{received_path} #{approved_path}


        FAILURE_MESSAGE
      end

      def location=(backtrace)
        @location = [backtrace.first.gsub(Dir.pwd, '.')]
      end

      def verify
        if FileUtils.cmp(received_path, approved_path)
          File.unlink(received_path)
        else
          raise RSpec::Approvals::ReceivedDiffersError, failure_message, location
        end
      end
    end
  end
end

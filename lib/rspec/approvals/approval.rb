require 'rspec/expectations/errors'
require 'rspec/approvals/empty_approval'

module RSpec
  module Approvals

    class ReceivedDiffersError < RSpec::Expectations::ExpectationNotMetError; end

    class Approval

      class << self
        def normalize(s)
          s.gsub(/[\W]/, ' ').strip.squeeze(" ").gsub(' ', '_').downcase
        end
      end

      attr_reader :location, :name, :options, :path, :received

      def initialize(example, received = '', options = {})
        @name = Approval.normalize(example.full_description)
        @path = Approvals.path + name
        @options = options
        @received = received
        @formatter = Formatter.new(self)

        example.options[:approval] = true
        example.options[:approval_diff_paths] = {
          :received => received_path,
          :approved => approved_path,
        }
      end

      def location=(backtrace)
        @location = [backtrace.first.gsub(Dir.pwd, '.').gsub(/:in\ .*$/, '')]
      end

      def approved_path
        "#{@path}.approved.txt"
      end

      def received_path
        "#{@path}.received.txt"
      end

      def diff_path
        "#{received_path} #{approved_path}"
      end

      def approved_text
        if File.exists?(approved_path)
          File.read(approved_path)
        else
          EmptyApproval.new.inspect
        end
      end

      def received_text
        @received_text ||= Formatter.new(self).as_s(received)
      end

      def verify
        unless received_text == approved_text
          write(received_path, received_text)
          Dotfile.append(diff_path)
          if received.respond_to?(:on_failure)
            received.on_failure.call(approved_text)
            received.on_failure.call(received_text)
          end
          raise RSpec::Approvals::ReceivedDiffersError, failure_message, location
        end
      end

      def write(path, contents)
        File.open(path, 'w') do |f|
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

        FAILURE_MESSAGE
      end

    end
  end
end

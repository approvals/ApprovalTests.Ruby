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

      attr_reader :location, :name, :options, :path, :writer, :received

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
        write(approved_path, EmptyApproval.new.inspect) unless File.exists?(approved_path)
        write(received_path, Formatter.new(self).as_s(received))
      end

      def write(path, contents)
        File.open(path, 'w') do |f|
          f.write contents
        end
      end

      def approved_path
        "#{@path}.approved.txt"
      end

      def received_path
        "#{@path}.received.txt"
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

      def location=(backtrace)
        @location = [backtrace.first.gsub(Dir.pwd, '.').gsub(/:in\ .*$/, '')]
      end

      def verify

        if FileUtils.cmp(received_path, approved_path)
          File.unlink(received_path)
        else
          Dotfile.append(diff_path)
          raise RSpec::Approvals::ReceivedDiffersError, failure_message, location
        end
      end

      def diff_path
        "#{received_path} #{approved_path}"
      end
    end
  end
end

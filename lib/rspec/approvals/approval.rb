require 'rspec/expectations/errors'

module RSpec
  module Approvals

    class ReceivedDiffersError < RSpec::Expectations::ExpectationNotMetError; end

    class EmptyApproval
      def inspect
        ""
      end
      def strip; end
    end

    class Approval

      def self.normalize(s)
        s.gsub(/[\W]/, ' ').strip.squeeze(" ").gsub(' ', '_').downcase
      end

      def self.base_path(s)
        Approvals.path + normalize(s)
      end

      attr_reader :location

      def initialize(example, received = '', options = {})
        @path = Approval.base_path(example.full_description)
        @options = options

        example.options[:approval] = true
        example.options[:approval_diff_paths] = {
          :received => received_path,
          :approved => approved_path,
        }

        write(:approved, EmptyApproval.new) unless File.exists?(approved_path)
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
          if xml?
            parser = XML::Parser.string contents.strip
            doc = parser.parse
            f.write doc.to_s
          elsif contents.respond_to?(:each_pair)
            contents.each_pair do |k,v|
              f.write "#{k.inspect} => #{v.inspect}\n"
            end
          elsif contents.respond_to?(:each_with_index)
            contents.each_with_index do |v,i|
              f.write "[#{i.inspect}] #{v.inspect}\n"
            end
          else
            f.write contents.inspect
          end
        end
      end

      def failure_message
        return failure_message_exposing_received if show_received?
        return default_failure_message
      end

      def default_failure_message
        <<-FAILURE_MESSAGE

        Approval Failure:

        The received contents did not match the approved contents.

        Inspect the differences in the following files:
        #{received_path}
        #{approved_path}

        If you like what you see in the *.received.txt file, you can approve it
        by renaming it with the .approved.txt suffix.

        mv #{received_path} #{approved_path}


        FAILURE_MESSAGE
      end

      def failure_message_exposing_received
        default_failure_message << "        received:\n        " << received << "\n\n\n"
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

      def approved
        File.read(approved_path)
      end

      def received
        File.read(received_path)
      end

      def xml?
        [:xml, :html].include? @options[:format]
      end

      def show_received?
        @options[:show_received]
      end
    end
  end
end

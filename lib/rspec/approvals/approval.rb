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

      attr_reader :location, :name

      def initialize(example, received = '', options = {})
        @name = Approval.normalize(example.full_description)
        @path = Approvals.path + name
        @options = options

        example.options[:approval] = true
        example.options[:approval_diff_paths] = {
          :received => received_path,
          :approved => approved_path,
        }

        write(:approved, EmptyApproval.new) unless File.exists?(approved_path)
        write(:received, received)
        FileUtils.touch(Approvals.dotfile)
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
            f.write as_xml(contents)
          elsif json?
            f.write as_json(contents)
          elsif contents.respond_to?(:each_pair)
            f.write as_hash(contents)
          elsif contents.respond_to?(:each_with_index)
            f.write as_array(contents)
          else
            f.write contents.inspect
          end
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

      def location=(backtrace)
        @location = [backtrace.first.gsub(Dir.pwd, '.').gsub(/:in\ .*$/, '')]
      end

      def verify
        if FileUtils.cmp(received_path, approved_path)
          File.unlink(received_path)
          delete_from_dot_file
        else
          append_to_dot_file
          raise RSpec::Approvals::ReceivedDiffersError, failure_message, location
        end
      end

      def append_to_dot_file
        unless in_dotfile?
          File.open(Approvals.dotfile, 'a+') do |f|
            f.write "#{diff_path}\n"
          end
        end
      end

      def delete_from_dot_file
        if in_dotfile?
          failures = File.read(Approvals.dotfile).split("\n")
          File.open(Approvals.dotfile, 'w') do |f|
            f.write (failures - [diff_path]).join("\n")
          end
        end
      end

      def in_dotfile?
        system("cat #{Approvals.dotfile} | grep -q \"^#{diff_path}$\"")
      end

      def diff_path
        "#{received_path} #{approved_path}"
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

      def json?
        @options[:format] == :json
      end

      def as_json(contents)
        JSON.pretty_generate(JSON.parse(contents))
      end

      def as_xml(contents)
        parser = XML::Parser.string contents.strip
        parser.parse.to_s
      end

      def as_hash(contents)
        s = ""
        contents.each_pair do |k,v|
          s << "#{k.inspect} => #{v.inspect}\n"
        end
        s
      end

      def as_array(contents)
        s = ""
        contents.each_with_index do |v,i|
          s << "[#{i.inspect}] #{v.inspect}\n"
        end
        s
      end
    end
  end
end

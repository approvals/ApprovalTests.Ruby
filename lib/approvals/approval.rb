require 'erb' # It is referenced on line 69
module Approvals
  class Approval
    class << self
      attr_accessor :namer
    end

    attr_reader :subject, :namer, :failure
    def initialize(subject, options = {})
      @subject = subject
      @namer = options[:namer] || default_namer(options[:name])
      @format = options[:format] || identify_format
    end

    def default_namer(name)
      Approvals::Approval.namer || Namers::DefaultNamer.new(name)
    end

    # Add a Proc that tests if subject is a kind of format
    IDENTITIES = {
      hash: Proc.new(){|subject|subject.respond_to? :each_pair},
      array: Proc.new(){|subject|subject.respond_to? :each_with_index},
    }

    def identify_format
      IDENTITIES.each_pair do |format, id_test|
        return format if id_test.call(subject)
      end
      # otherwise
      return :txt
    end

    def writer
      @writer ||= Writer.for(@format)
    end

    def verify
      unless File.exist?(namer.output_dir)
        FileUtils.mkdir_p(namer.output_dir)
      end

      writer.write(subject, received_path)

      unless approved?
        fail_with "Approval file \"#{approved_path}\" not found."
      end

      @approved_content, @received_content = read_content

      unless received_matches?
        fail_with "Received file does not match approved:\n"+
          "#{received_path}\n#{approved_path}\n#{diff_preview}"
      end

      success!
    end

    def diff_preview
      approved, received = diff_lines
      return unless approved and received
      diff_index =
          approved.each_char.with_index.find_index do |approved_char, i|
            approved_char != received[i]
          end
      "approved fragment: #{approved[diff_index - 10 .. diff_index + 30]}\n"+
      "received fragment: #{received[diff_index - 10 .. diff_index + 30]}"
    end

    def diff_lines
      approved = @approved_content.split("\n")
      received = @received_content.split("\n")
      approved.each_with_index do |line, i|
        return line, received[i] unless line == received[i]
      end
    end

    def success!
      File.delete received_path
    end

    def approved?
      File.exist? approved_path
    end

    BINARY_FORMATS = [:binary]

    def read_content
      if BINARY_FORMATS.include?(@format) # Read without ERB
        [IO.read(approved_path).chomp,
         IO.read(received_path).chomp]
      else
        [ERB.new(IO.read(approved_path).chomp).result,
         ERB.new(IO.read(received_path).chomp).result]
      end
    end

    def received_matches?
      @approved_content == @received_content
    end

    def fail_with(message)
      Dotfile.append(diff_path)

      if subject.respond_to?(:on_failure)
        subject.on_failure.call(approved_text) if approved?
        subject.on_failure.call(received_text)
      end

      error = ApprovalError.new("Approval Error: #{message}")
      error.approved_path = approved_path
      error.received_path = received_path

      raise error
    end

    def diff_path
      "#{approved_path} #{received_path}"
    end

    def full_path(state)
      "#{namer.output_dir}#{namer.name}.#{state}.#{writer.extension}"
    end

    def name
      namer.name
    end

    def approved_path
      full_path('approved')
    end

    def received_path
      full_path('received')
    end

    def approved_text
      File.read(approved_path).chomp
    end

    def received_text
      File.read(received_path).chomp
    end
  end
end

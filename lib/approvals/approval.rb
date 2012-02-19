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
      Namers::DefaultNamer.new(name)
    end

    def identify_format
      return :hash if subject.respond_to? :each_pair
      return :array if subject.respond_to? :each_with_index
      return :txt
    end

    def writer
      @writer ||= Writer.for(@format)
    end

    def verify
      unless File.exists?(namer.output_dir)
        FileUtils.mkdir_p(namer.output_dir)
      end

      writer.write(subject, received_path)

      unless approved?
        fail_with "Approval file \"#{approved_path}\" not found."
      end

      unless received_matches?
        fail_with "Received file \"#{received_path}\" does not match approved \"#{approved_path}\"."
      end

      success!
    end

    def success!
      File.delete received_path
    end

    def approved?
      File.exists? approved_path
    end

    def received_matches?
      FileUtils.cmp received_path, approved_path
    end

    def fail_with(message)
      writer.touch(approved_path) unless File.exists? approved_path

      Dotfile.append(diff_path)

      if subject.respond_to?(:on_failure)
        subject.on_failure.call(approved_text) if approved?
        subject.on_failure.call(received_text)
      end

      raise ApprovalError.new("Approval Error: #{message}")
    end

    def diff_path
      "#{received_path} #{approved_path}"
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
      File.read approved_path
    end

    def received_text
      File.read received_path
    end
  end
end

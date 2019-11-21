require 'approvals/writers/text_writer'
require 'approvals/writers/array_writer'
require 'approvals/writers/hash_writer'
require 'approvals/writers/json_writer'
require 'approvals/writers/binary_writer'

module Approvals
  module Writer
    extend Writers

    REGISTRY = {
      json: Writers::JsonWriter.new,
      hash: Writers::HashWriter.new,
      array: Writers::ArrayWriter.new,
      txt: Writers::TextWriter.new,
    }


    class << self
      def for(format)
        begin
          REGISTRY[format] || Object.const_get(format).new
        rescue NameError => e
          error = ApprovalError.new(
            "Approval Error: #{ e }. Please define a custom writer as outlined"\
            " in README section 'Customizing formatted output': "\
            "https://github.com/kytrinyx/approvals#customizing-formatted-output"
          )
          raise error
        end
      end
    end

  end
end

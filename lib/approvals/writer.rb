require 'approvals/writers/text_writer'
require 'approvals/writers/array_writer'
require 'approvals/writers/hash_writer'
require 'approvals/writers/html_writer'
require 'approvals/writers/xml_writer'
require 'approvals/writers/json_writer'
require 'approvals/writers/binary_writer'

module Approvals
  module Writer
    extend Writers

    REGISTRY = {
      json: Writers::JsonWriter.new,
      xml: Writers::XmlWriter.new,
      html: Writers::HtmlWriter.new,
      hash: Writers::HashWriter.new,
      array: Writers::ArrayWriter.new,
      txt: Writers::TextWriter.new,
    }


    class << self
      def for(format)
        REGISTRY[format] || format.new
      end
    end

  end
end

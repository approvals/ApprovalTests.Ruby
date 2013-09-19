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
      json: Writers::JsonWriter.instance,
      xml: Writers::XmlWriter.instance,
      html: Writers::HtmlWriter.instance,
      hash: Writers::HashWriter.instance,
      array: Writers::ArrayWriter.instance,
    }
        

    class << self
      def for(format)
        if REGISTRY.include?(format)
          REGISTRY[format]
        else
          TextWriter.instance
        end
      end
    end

  end
end

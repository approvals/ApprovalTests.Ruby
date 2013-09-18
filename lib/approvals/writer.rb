require 'approvals/writers/text_writer'
require 'approvals/writers/array_writer'
require 'approvals/writers/hash_writer'
require 'approvals/writers/html_writer'
require 'approvals/writers/xml_writer'
require 'approvals/writers/json_writer'

module Approvals
  module Writer
    extend Writers
    
    REGISTRY = {
      json: JsonWriter.instance,
      xml: XmlWriter.instance,
      html: HtmlWriter.instance,
      hash: HashWriter.instance,
      array: ArrayWriter.instancce,
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

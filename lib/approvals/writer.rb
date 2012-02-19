require 'approvals/writers/text_writer'
require 'approvals/writers/array_writer'
require 'approvals/writers/html_writer'
require 'approvals/writers/xml_writer'
require 'approvals/writers/json_writer'

module Approvals
  module Writer
    extend Writers

    class << self
      def for(format)
        case format
        when :json then JsonWriter.instance
        when :xml then XmlWriter.instance
        when :html then HtmlWriter.instance
        when :hash then HashWriter.instance
        when :array then ArrayWriter.instance
        else
          TextWriter.instance
        end
      end
    end

  end
end

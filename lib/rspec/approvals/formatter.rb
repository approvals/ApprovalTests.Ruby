module RSpec
  module Approvals
    class Formatter
      attr_accessor :approval, :contents
      def initialize(approval)
        self.approval = approval
        self.contents = approval.received
      end

      def to_s
        if html?
          as_html
        elsif xml?
          as_xml
        elsif json?
          as_json
        elsif hash?
          as_hash
        elsif array?
          as_array
        else
          contents.inspect
        end
      end

      def xml?
        approval.options[:format] == :xml
      end

      def html?
        approval.options[:format] == :html
      end

      def json?
        approval.options[:format] == :json
      end

      def hash?
        contents.respond_to?(:each_pair)
      end

      def array?
        contents.respond_to?(:each_with_index)
      end

      def as_json
        JSON.pretty_generate(JSON.parse(contents))
      end

      def as_html
        Nokogiri::XML(contents.to_s.strip,&:noblanks).to_xhtml(:indent => 2, :encoding => 'UTF-8')
      end

      def as_xml
        Nokogiri::XML(contents.to_s.strip,&:noblanks).to_xml(:indent => 2, :encoding => 'UTF-8')
      end

      def as_hash
        s = ""
        contents.each_pair do |k,v|
          s << "#{k.inspect} => #{v.inspect}\n"
        end
        s
      end

      def as_array
        s = ""
        contents.each_with_index do |v,i|
          s << "[#{i.inspect}] #{v.inspect}\n"
        end
        s
      end
    end

  end
end

module RSpec
  module Approvals
    class Formatter
      attr_accessor :approval
      def initialize(approval)
        self.approval = approval
      end

      def as_s(contents)
        if html?
          as_html(contents)
        elsif xml?
          as_xml(contents)
        elsif json?
          as_json(contents)
        elsif contents.respond_to?(:each_pair)
          as_hash(contents)
        elsif contents.respond_to?(:each_with_index)
          as_array(contents)
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

      def as_json(contents)
        JSON.pretty_generate(JSON.parse(contents))
      end

      def as_html(contents)
        Nokogiri::XML(contents.to_s.strip,&:noblanks).to_xhtml(:indent => 2, :encoding => 'UTF-8')
      end

      def as_xml(contents)
        Nokogiri::XML(contents.to_s.strip,&:noblanks).to_xml(:indent => 2, :encoding => 'UTF-8')
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

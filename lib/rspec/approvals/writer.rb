module RSpec
  module Approvals

    class Writer

      attr_accessor :approval
      def initialize(approval)
        self.approval = approval
      end

      def write(suffix, contents)
        File.open("#{approval.path}.#{suffix}.txt", 'w') do |f|
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

      def xml?
        [:xml, :html].include? approval.options[:format]
      end

      def json?
        approval.options[:format] == :json
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

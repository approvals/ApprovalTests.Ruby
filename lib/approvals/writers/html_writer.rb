module Approvals
  module Writers
    class HtmlWriter < TextWriter

      def extension
        'html'
      end

      def format(data)
        Nokogiri::XML(data.to_s.strip,&:noblanks).to_xhtml(:indent => 2, :encoding => 'UTF-8')
      end

    end
  end
end

require 'tempfile'

module RSpec
  module Approvals

    class HtmlImageReporter
      include Singleton

      def working_in_this_environment?
        true
      end

      def report(received, approved)
        display html(received, approved)
      end

      def html(received, approved)
        template(File.expand_path(received), File.expand_path(approved))
      end

      def display(page)
        file = Tempfile.new(['foo', '.html'])
        file.write page
        file.close
        system("open #{file.path}")
      end

      private
      def template(received, approved)
        "<html><body><center><table style=\"text-align: center;\" border=1><tr><td><img src=\"file:///#{received}\"></td><td><img src=\"file:///#{approved}\"></td></tr><tr><td>received</td><td>approved</td></tr></table></center></body></html>"
      end
    end

  end
end

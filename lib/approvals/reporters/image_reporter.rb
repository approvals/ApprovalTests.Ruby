require 'approvals/reporters/image_reporter/image_magick_reporter'
require 'approvals/reporters/image_reporter/html_image_reporter'

module Approvals
  module Reporters

    class ImageReporter < FirstWorkingReporter
      include Singleton

      def initialize
        super(ImageMagickReporter.instance, HtmlImageReporter.instance)
      end
    end

  end
end

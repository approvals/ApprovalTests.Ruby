require 'rspec/approvals/reporters/image_reporter/image_magick_reporter'
require 'rspec/approvals/reporters/image_reporter/html_image_reporter'

module RSpec
  module Approvals

    class ImageReporter < FirstWorkingReporter
      include Singleton

      def initialize
        super(ImageMagickReporter.instance, HtmlImageReporter.instance)
      end
    end

  end
end

require 'singleton'

module Approvals

  class << self
    def configure(&block)
      block.call Approvals::Configuration.instance
    end

    def configuration
      Approvals::Configuration.instance
    end
  end

  class Configuration
    include Singleton

    attr_writer :approvals_path

    def approvals_path
      @approvals_path ||= 'approvals/'
    end
  end
end

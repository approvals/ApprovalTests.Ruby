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

    attr_writer :approvals_path, :excluded_json_keys, :default_format

    def approvals_path
      @approvals_path ||= 'fixtures/approvals/'
    end

    def excluded_json_keys
      @excluded_json_keys ||= {}
    end

    def default_format
      @default_format ||= :txt
    end
  end
end

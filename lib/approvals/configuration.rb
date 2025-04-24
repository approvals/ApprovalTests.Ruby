require 'singleton'

module Approvals
  def self.configure(&block)
    block.call Approvals::Configuration.instance
  end

  def self.configuration
    Approvals::Configuration.instance
  end

  class Configuration
    include Singleton

    attr_writer :approvals_path
    attr_writer :excluded_json_keys

    def approvals_path
      @approvals_path ||= 'fixtures/approvals/'
    end

    def excluded_json_keys
      @excluded_json_keys ||= {}
    end
  end
end

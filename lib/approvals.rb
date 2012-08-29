require 'json'
require 'fileutils'
require 'nokogiri'
require 'approvals/version'
require 'approvals/configuration'
require 'approvals/approval'
require 'approvals/dsl'
require 'approvals/error'
require 'approvals/utilities'
require 'approvals/reporters'
require 'approvals/writer'
require 'approvals/namers/default_namer'

module Approvals
  extend DSL

  class << self
    def reset
      Dotfile.reset
    end
  end
end

Approvals.reset

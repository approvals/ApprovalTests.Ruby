require 'nokogiri'
require 'approvals/dsl'
require 'approvals/approval'
require 'approvals/error'
require 'approvals/utilities'
require 'approvals/reporters'
require 'approvals/writer'


module Approvals
  extend DSL

  class << self
    def reset
      Dotfile.reset
    end
  end
end

Approvals.reset

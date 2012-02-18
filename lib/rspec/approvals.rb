require 'nokogiri'
require "rspec/approvals/version"
require "rspec/approvals/approval"
require "rspec/approvals/dsl"
require 'rspec/approvals/dotfile'
require 'rspec/approvals/formatter'
require 'rspec/approvals/executable'
require 'rspec/approvals/reporters'

module RSpec
  RSpec.configure do |c|
    c.extend RSpec::Approvals::DSL
    c.add_setting :approvals_path, :default => 'spec/approvals'
    c.before(:suite) { RSpec::Approvals.reset }
  end

  module Approvals

    class << self
      def initialize_approvals_path
        FileUtils.makedirs(RSpec.configuration.approvals_path) unless Dir.exists?(RSpec.configuration.approvals_path)
      end

      def path
        RSpec.configuration.approvals_path + "/"
      end

      def tmp_path
        'tmp/'
      end

      def reset
        Dotfile.reset
      end

    end

  end

end

RSpec::Approvals.initialize_approvals_path
FileUtils.makedirs(RSpec::Approvals.tmp_path) unless Dir.exists?(RSpec::Approvals.tmp_path)

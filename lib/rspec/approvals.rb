require "rspec/approvals/version"
require "rspec/approvals/dsl"
require "rspec/approvals/approval"

module RSpec
  RSpec.configure do |c|
    c.extend RSpec::Approvals::DSL
    c.add_setting :approvals_path, :default => 'spec/approvals'
  end

  module Approvals

    class << self
      def initialize_approvals_path
        FileUtils.makedirs(RSpec.configuration.approvals_path) unless Dir.exists?(RSpec.configuration.approvals_path)
      end

      def path
        RSpec.configuration.approvals_path + "/"
      end

      def location_of(approval)
        approval.gsub(Dir.pwd, '.').gsub(/(:\d*).*$/, '\1')
      end
    end

  end

end

RSpec::Approvals.initialize_approvals_path

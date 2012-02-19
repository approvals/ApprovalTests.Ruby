require 'approvals'
require 'approvals/namers/rspec_namer'
require 'approvals/extensions/rspec/example_group'
require 'approvals/extensions/rspec/example'
require 'approvals/extensions/rspec/dsl'

RSpec.configure do |c|
  c.extend Approvals::RSpec::DSL
  c.add_setting :approvals_path, :default => 'spec/fixtures/approvals/'
end

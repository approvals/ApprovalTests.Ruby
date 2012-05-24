if defined? RSpec
  require 'approvals/extensions/rspec/dsl'
  require 'approvals/namers/rspec_namer'
  require 'approvals/namers/directory_namer'

  RSpec.configure do |c|
    c.include Approvals::RSpec::DSL
    c.add_setting :approvals_path, :default => 'spec/fixtures/approvals/'
    c.add_setting :approvals_namer_class, :default => Approvals::Namers::DirectoryNamer
  end
end

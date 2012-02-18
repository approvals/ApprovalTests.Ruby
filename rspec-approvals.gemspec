# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rspec/approvals/version"

Gem::Specification.new do |s|
  s.name        = "rspec-approvals"
  s.version     = RSpec::Approvals::VERSION
  s.authors     = ["Katrina Owen"]
  s.email       = ["katrina.owen@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Approval Tests for Ruby}
  s.description = %q{An RSpec extension that adds support for approvals. Based on the idea of the Golden Master.}

  s.rubyforge_project = "rspec-approvals"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rspec', '~> 2.7'
  s.add_dependency 'thor'
  s.add_dependency 'nokogiri'
end

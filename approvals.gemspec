# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'approvals/version'

Gem::Specification.new do |s|
  s.name        = "approvals"
  s.version     = Approvals::VERSION
  s.licenses    = ['MIT']
  s.authors     = ["Katrina Owen"]
  s.email       = ["katrina.owen@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Approval Tests for Ruby}
  s.description = %q{Approval Tests for Ruby}

  s.rubyforge_project = "approvals"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'json', '~> 1.8'
  s.add_dependency 'thor', '~> 0.18'
  s.add_dependency 'nokogiri', '~> 1.6'
end

# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "approvals"
  s.version     = "0.0.5"
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

  s.add_development_dependency 'rspec', '~> 2.9'
  s.add_dependency 'thor'
  s.add_dependency 'nokogiri'
end

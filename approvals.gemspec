# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'approvals/version'

Gem::Specification.new do |s|
  s.name        = "approvals"
  s.version     = Approvals::VERSION
  s.licenses    = ['MIT']
  s.authors     = ["Katrina Owen"]
  s.email       = ["katrina.owen@gmail.com"]
  s.homepage    = "https://github.com/kytrinyx/approvals"
  s.summary     = %q{Approval Tests for Ruby}
  s.description = %q{A library to make it easier to do golden-master style testing in Ruby}

  s.rubyforge_project = "approvals"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.extensions    << 'ext/mkrf_conf.rb'

  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_dependency 'thor', '~> 1.0'

  if RUBY_VERSION < "2.1"
    s.add_dependency 'nokogiri', '~> 1.6.8'
  else
    s.add_dependency 'nokogiri', '~> 1.8'
  end
  # We also depend on the json gem, but the version we need is
  # Ruby-version-specific. See `ext/mkrf_conf.rb`.
end

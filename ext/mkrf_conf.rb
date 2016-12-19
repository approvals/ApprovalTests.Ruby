require 'rubygems/dependency_installer'

# This is how we can depend on a different version of the same gem for
# different Ruby versions.
# See https://en.wikibooks.org/wiki/Ruby_Programming/RubyGems

installer = Gem::DependencyInstaller.new

begin
  if RUBY_VERSION >= '2.0'
    installer.install 'json', '~> 2.0'
  else
    installer.install 'json', '~> 1.8'
  end
rescue
  exit(1)
end

# Write fake Rakefile for rake since Makefile isn't used
File.open(File.join(File.dirname(__FILE__), 'Rakefile'), 'w') do |f|
  f.write("task :default\n")
end

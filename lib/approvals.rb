require 'json'
require 'fileutils'
require 'nokogiri'

require_relative 'approvals/error'

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  'dsl'         => 'DSL',
  'rspec'       => 'RSpec',
  'rspec_namer' => 'RSpecNamer',
)
loader.setup



module Approvals
  extend DSL

  def self.project_dir
    @project_dir ||= FileUtils.pwd
  end

  def self.reset
    Dotfile.reset
  end
end

Approvals.reset

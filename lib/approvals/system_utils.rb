# frozen_string_literal: true
module Approvals
  class SystemUtils
    def self.windows?
      RUBY_PLATFORM =~ /win32|mingw|cygwin/
    end
  end
end
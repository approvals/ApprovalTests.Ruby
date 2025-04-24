module Approvals
  module SystemCommand
    def self.exists?(executable)
      if SystemUtils.windows?
        `where #{executable}` != ""
      else
        `which #{executable}` != ""
      end
    end
  end
end

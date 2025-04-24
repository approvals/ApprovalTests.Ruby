module Approvals
  module SystemCommand
    class << self
      def exists?(executable)
        # if on a winodw system
        if SystemUtils.windows?
          `where #{executable}` != ""
        else
          `which #{executable}` != ""
        end
      end
    end
  end
end

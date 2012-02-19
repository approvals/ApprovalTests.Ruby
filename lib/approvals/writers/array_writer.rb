module Approvals
  module Writers
    class ArrayWriter < TextWriter

      def format(data)
        s = ""
        data.each_with_index do |value, i|
          s << "[#{i.inspect}] #{value.inspect}\n"
        end
        s
      end

    end
  end
end

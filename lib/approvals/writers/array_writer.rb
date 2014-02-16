module Approvals
  module Writers
    class ArrayWriter < TextWriter

      def format(data)
        data.map.with_index do |value, i|
          "[#{i.inspect}] #{value.inspect}\n"
        end.join
      end

    end
  end
end

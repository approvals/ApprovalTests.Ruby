module Approvals
  module Writers
    class HashWriter < TextWriter

      def format(data)
        s = "{\n"
        data.each do |key, value|
          s << "\t#{key.inspect} => #{value.inspect}\n"
        end
        s << "}"
        s
      end

    end
  end
end

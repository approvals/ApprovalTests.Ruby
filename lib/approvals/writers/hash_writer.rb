module Approvals
  module Writers
    class HashWriter < TextWriter

      def format(data)
        lines = data.map do |key, value|
          "\t#{key.inspect} => #{value.inspect}"
        end.join("\n")

        "{\n#{lines}\n}\n"
      end

    end
  end
end

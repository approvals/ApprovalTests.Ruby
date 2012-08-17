module Approvals
  module Writers
    class JsonWriter < TextWriter

      def extension
        'json'
      end

      def format(data)
        JSON.pretty_generate(JSON.parse(data))
      end

    end
  end
end

module Approvals
  module Writers
    class JsonWriter < TextWriter
      def extension
        'json'
      end

      def format(data)
        hash_or_array = filter(parse_data(data))

        # These are the same options as pretty_generate but when using the Oj
        # gem, a space is added in front of the ":" for some reason.
        JSON.generate(hash_or_array, {
          indent: '  ',
          space: ' ',
          object_nl: "\n",
          array_nl: "\n"
        }) + "\n"
      end

      private

      def parse_data(data)
        if data.respond_to?(:to_str)
          # if the data is a string, assume it has been already json-ified
          JSON.parse(data)
        else
          JSON.parse(data.to_json)
        end
      end

      def filter data
        filter = ::Approvals::Filter.new(Approvals.configuration.excluded_json_keys)
        filter.apply(data)
      end
    end
  end
end

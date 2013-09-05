module Approvals
  module Writers
    class JsonWriter < TextWriter

      def extension
        'json'
      end

      def format(data)
        hash_or_array = parse_data(data)

        apply_filters!(hash_or_array) if filters.any?

        JSON.pretty_generate(hash_or_array)
      end

      private

      def filters
        Approvals.configuration.excluded_json_keys
      end

      def parse_data(data)
        JSON.parse(data)
      end

      def apply_filters!(hash_or_array)
        case hash_or_array
        when Array
          for i in (0 ... hash_or_array.size) do
            apply_filters!(hash_or_array[i])
          end
        when Hash
          hash_or_array.each do |key, value|
            next if value.nil?

            if value.is_a?(Hash) || value.is_a?(Array)
              apply_filters!(value)
            else
              filters.each do |placeholder, pattern|
                if pattern && key.match(pattern)
                  hash_or_array[key] = "<#{placeholder}>"
                end
              end
            end
          end
        end
      end
    end
  end
end

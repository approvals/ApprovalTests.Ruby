module Approvals
  module Writers
    class JsonWriter < TextWriter
      class Filter
        attr_reader :filters
        def initialize(filters)
          @filters = filters
        end

        def apply hash_or_array
          return hash_or_array unless @filters.any?
          apply_internal hash_or_array
        end

        def apply_internal hash_or_array, key: nil
          case hash_or_array
          when Array
            hash_or_array.map do |item|
              apply_internal(item)
            end
          when Hash
            hash_or_array.each_with_object({}) do |(key, value), res|
              res[key] = apply_internal(value, key: key)
            end
          when nil
            nil
          else
            applicable_filters = filters.select do |placeholder, pattern|
              pattern && key.match(pattern)
            end
            if applicable_filters.length > 0
              placeholder = applicable_filters.keys.last
              "<#{placeholder}>"
            else
              hash_or_array
            end
          end
        end
      end

      def extension
        'json'
      end

      def format(data)
        hash_or_array = parse_data(data)

        hash_or_array = filter.apply(hash_or_array)

        JSON.pretty_generate(hash_or_array) + "\n"
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

      def filter
        Filter.new(Approvals.configuration.excluded_json_keys)
      end
    end
  end
end

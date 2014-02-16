module Approvals
  module Writers
    class JsonWriter < TextWriter
      class Filter
        attr_reader :filters
        def initialize(filters)
          @filters = filters
        end

        def apply hash_or_array
          return unless @filters.any?
          apply_internal hash_or_array
        end

        def apply_internal hash_or_array, key: nil
          case hash_or_array
          when Array
            for i in (0 ... hash_or_array.size) do
              apply_internal(hash_or_array[i])
            end
          when Hash
            hash_or_array.each do |key, value|
              next if value.nil?

              if value.is_a?(Hash) || value.is_a?(Array)
                apply_internal(value)
              else
                hash_or_array[key] = value_for(key, value)
              end
            end
          end
        end

        def value_for key, value
          applicable_filters = filters.select do |placeholder, pattern|
            pattern && key.match(pattern)
          end
          if applicable_filters.length > 0
            placeholder = applicable_filters.keys.last
            "<#{placeholder}>"
          else
            value
          end
        end
      end

      def extension
        'json'
      end

      def format(data)
        hash_or_array = parse_data(data)

        filter.apply(hash_or_array)

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

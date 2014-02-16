module Approvals
  module Writers
    class JsonWriter < TextWriter
      class Filter
        attr_reader :filters
        def initialize(filters)
          @filters = filters
          @placeholder = {}
        end

        def apply hash_or_array
          if @filters.any?
            censored(hash_or_array)
          else
            hash_or_array
          end
        end

        def censored value, key=nil
          case value
          when Array
            value.map { |item| censored(item) }
          when Hash
            Hash[value.map { |key, value| [key, censored(value, key)] }]
          when nil
            nil
          else
            if placeholder_for(key)
              "<#{placeholder_for(key)}>"
            else
              value
            end
          end
        end

        def placeholder_for key
          return @placeholder[key] if @placeholder.key? key

          applicable_filters = filters.select do |placeholder, pattern|
            pattern && key.match(pattern)
          end

          @placeholder[key] = applicable_filters.keys.last
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

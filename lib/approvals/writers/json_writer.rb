module Approvals
  module Writers
    class JsonWriter < TextWriter

      def extension
        'json'
      end

      def format(data)
        hash = parse_data(data)

        filters = Approvals.configuration.excluded_json_keys
        apply_filters!(hash, filters) if filters.any?

        JSON.pretty_generate(hash)
      end

      private

      def parse_data(data)
        JSON.parse(data)
      end

      def apply_filters!(hash, filters)
        hash.each do |key, value|
          if value.is_a?(Hash)
            apply_filters!(value, filters)
          else
            filters.each do |placeholder, pattern|
              if pattern && key.match(pattern)
                hash[key] = "<#{placeholder}>"
              end
            end
          end
        end
      end
    end
  end
end

module Approvals
  module Comparators
    class JsonComparator
      attr_accessor :ignore_ordering_paths

      def initialize(options)
        options ||= {}
        if options[:ignore_ordering_paths]
          @ignore_ordering_paths = options[:ignore_ordering_paths]
          @ignore_ordering_paths = [@ignore_ordering_paths] if @ignore_ordering_paths.is_a?(String)
          @ignore_ordering_paths = @ignore_ordering_paths.map { |v| v.split('.') } if @ignore_ordering_paths.first.is_a?(String)

        end
      end

      def compare(approved, received)
        approved = JSON.parse(approved)
        received = JSON.parse(received)

        return approved == received if ignore_ordering_paths.nil?

        walk_and_compare(approved, received)
      end

      private
      def unordered_path_match(path)
        ignore_ordering_paths.any? do |search_key|
          # Don't attempt matching unless it has a chance of working
          path.length == search_key.length &&
          path.zip(search_key).all? do |path_component, search_component|
            path_component == search_component || # If they specified the key in the search path
            search_component == '*' # If they don't care what key it is
          end
        end
      end

      def walk_and_compare(a, b, path=[])
        return false if a.class != b.class

        if a.is_a?(Array)
          return false if a.length != b.length
          # Do we care if this array is properly ordered?
          if unordered_path_match(path)
            # This is hilariously inefficient
            # Since we compared lengths above, we don't need to worry about the use of any? here
            return a.all? { |element_a| b.any? { |element_b| walk_and_compare(element_a, element_b, path + ['*']) } }
          else
            return a.zip(b).all? { |element_a, element_b| walk_and_compare(element_a, element_b, path + ['*']) }
          end
        elsif a.is_a?(Hash)
          return false if a.keys.to_set != b.keys.to_set
          return a.keys.all? { |key| walk_and_compare(a[key], b[key], path + [key]) }
        else
          return a == b
        end
      end
    end
  end
end

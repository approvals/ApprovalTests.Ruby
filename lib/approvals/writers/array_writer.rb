module Approvals
  module Writers
    # Module containing refinements for custom hash inspection
    module HashInspectRefinements
      refine Hash do
        def inspect
          '{' + map { |k, v| "#{k.inspect}=>#{v.inspect}" }.join(', ') + '}'
        end
      end
      
      # Add refinements for Array to handle nested hashes
      refine Array do
        def inspect_with_hash_refinements
          '[' + map { |v| v.respond_to?(:inspect_with_hash_refinements) ? v.inspect_with_hash_refinements : v.inspect }.join(', ') + ']'
        end
      end
      
      # Add refinements for Object to handle any object type
      refine Object do
        def inspect_with_hash_refinements
          inspect
        end
      end
    end

    class ArrayWriter < TextWriter
      using HashInspectRefinements
      
      # Custom inspect method that uses the refinements
      def inspect_with_refinements(obj)
        case obj
        when Hash
          obj.inspect  # Uses the refined Hash#inspect
        when Array
          obj.inspect_with_hash_refinements
        else
          obj.inspect
        end
      end

      def format(data)
        filtered_data = filter(data)
        filtered_data.map.with_index do |value, i|
          "[#{i.inspect}] #{inspect_with_refinements(value)}\n"
        end.join
      end

      def filter(data)
        filter = ::Approvals::Filter.new(Approvals.configuration.excluded_json_keys)
        filter.apply(data)
      end
    end
  end
end

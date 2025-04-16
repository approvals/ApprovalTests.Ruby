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
        def inspect
          '[' + map { |v| v.inspect }.join(', ') + ']'
        end
      end
      

    end

    class ArrayWriter < TextWriter
      using HashInspectRefinements
      
      # Custom inspect method that uses the refinements


      def format(data)
        filtered_data = filter(data)
        filtered_data.map.with_index do |value, i|
          "[#{i.inspect}] #{value.inspect()}\n"
        end.join
      end

      def filter(data)
        filter = ::Approvals::Filter.new(Approvals.configuration.excluded_json_keys)
        filter.apply(data)
      end
    end
  end
end

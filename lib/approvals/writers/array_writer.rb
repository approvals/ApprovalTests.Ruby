module Approvals
  module Writers
    require_relative 'approvals/writers/hash_inspect_refinements.rb'

    class ArrayWriter < TextWriter
      using HashInspectRefinements
      def format(data)
        filter(data).map.with_index do |value, i|
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

module Approvals
  module Writers
    class ArrayWriter < TextWriter
      ORIGINAL_INSPECT = Hash.instance_method(:inspect)

      def format(data)
        Hash.define_method(:inspect) {'{' + map { |k, v| "#{k.inspect}=>#{v.inspect}" }.join(', ') + '}'}
        filter(data).map.with_index do |value, i|
          "[#{i.inspect}] #{value.inspect}\n"
        end.join
      ensure
        Hash.define_method(:inspect, ORIGINAL_INSPECT)
      end

      def filter data
        filter = ::Approvals::Filter.new(Approvals.configuration.excluded_json_keys)
        filter.apply(data)
      end

      private

    end
  end

end

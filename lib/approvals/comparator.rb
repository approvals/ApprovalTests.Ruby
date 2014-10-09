require 'approvals/comparators/equality_comparator'
require 'approvals/comparators/json_comparator'

module Approvals
  module Comparator
    extend Comparators

    REGISTRY = {
      json: Comparators::JsonComparator
    }

    class << self
      def for(format, options)
        if REGISTRY.include?(format)
          REGISTRY[format].new(options)
        else
          EqualityComparator.new(options)
        end
      end
    end

  end
end

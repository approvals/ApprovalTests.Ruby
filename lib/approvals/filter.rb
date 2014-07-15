module Approvals
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
        if value.empty?
          value
        elsif key && placeholder_for(key)
          "<#{placeholder_for(key)}>"
        else
          value.map { |item| censored(item) }
        end
      when Hash
        Hash[value.map { |key, value| [key, censored(value, key)] }]
      else
        if value.nil?
          nil
        elsif key && placeholder_for(key)
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
end

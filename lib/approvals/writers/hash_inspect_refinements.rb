module Approvals
  module Writers
    module HashInspectRefinements
      refine Hash do
        def inspect
          "{#{map { |k, v| "#{k.inspect}=>#{v.inspect}" }.join(', ')}}"
        end
      end

      refine Array do
        def inspect
          "[#{map(&:inspect).join(', ')}]"
        end
      end
    end
  end
end

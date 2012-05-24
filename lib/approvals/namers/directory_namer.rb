module Approvals
  module Namers
    class DirectoryNamer < RSpecNamer

      def initialize(example)
        @name = directorize example
      end

      private

      def directorize(example)
        parts     = [ ]
        metadata  = example.metadata

        begin
          parts << metadata[ :description ]
        end while metadata = metadata[ :example_group ]

        parts.reverse.map { |p| normalize p }.join '/'
      end
    end
  end
end

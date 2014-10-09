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

        approvals_name_for = lambda do |metadata|
          description = normalize metadata[:description]
          example_group = if metadata.key?(:example_group)
                            metadata[:example_group]
                          else
                            metadata[:parent_example_group]
                          end

          if example_group
            [approvals_name_for[example_group], description].join('/')
          else
            description
          end
        end

        approvals_name_for[example.metadata]
      end
    end
  end
end

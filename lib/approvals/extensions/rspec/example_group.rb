module Approvals
  module RSpec
    module ExampleGroup

      def verify(desc=nil, *args, &block)
        options = build_metadata_hash_from(args)
        examples << Approvals::RSpec::Example.new(self, desc, options, &block)
        examples.last
      end

    end
  end
end

RSpec::Core::ExampleGroup.send(:extend, Approvals::RSpec::ExampleGroup)

module Approvals
  module Reporters
    # TODO:  this module doesn't appear to be adding much value,
    #        and could possibly go away?
    module Launcher
      module_function

      REPORTERS = {
        diffmerge:    DiffmergeReporter,
        filelauncher: FilelauncherReporter,
        opendiff:     OpendiffReporter,
        tortoisediff: TortoisediffReporter,
        vimdiff:      VimdiffReporter,
      }

      # Metaprogramming: create a method for each key in REPORTERS.
      # (NB: these will become class [AKA "static"] methods due to the
      # module_function keyword above.)
      #
      # Those methods return a lambda that can be invoked (with args `received,
      # approved` to return a command.
      #
      # They also memoize their results (which seems unnecessary?).
      #
      # See usage examples in: spec/reporters/launcher_spec.rb
      REPORTERS.each do |name, klass|
        define_method name do # method body starts here
          memoized(:"@#{name}") do
            lambda {  |received, approved|
              klass.command(received, approved)
            }
          end
        end # method body ends here
      end

      def memoized(instance_variable)
        unless self.instance_variable_get(instance_variable)
          value = yield
          self.instance_variable_set(instance_variable, value)
        end
        self.instance_variable_get(instance_variable)
      end
    end
  end
end

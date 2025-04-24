module Approvals
  module Reporters
    module Launcher
      REPORTERS = {
        opendiff:     OpendiffReporter,
        diffmerge:    DiffmergeReporter,
        vimdiff:      VimdiffReporter,
        tortoisediff: TortoisediffReporter,
        filelauncher: FilelauncherReporter,
      }

      module_function

      def memoized(instance_variable)
        unless self.instance_variable_get(instance_variable)
          value = yield
          self.instance_variable_set(instance_variable, value)
        end
        self.instance_variable_get(instance_variable)
      end

      REPORTERS.each do |name, klass|
        define_method name do
          memoized(:"@#{name}") do
            lambda {  |received, approved|
              klass.command(received, approved)
            }
          end
        end
      end
    end
  end
end

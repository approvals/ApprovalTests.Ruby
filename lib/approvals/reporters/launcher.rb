module Approvals
  module Reporters
    module Launcher
      REPORTERS = [:opendiff, :diffmerge, :vimdiff, :tortoisediff, :filelauncher]

      module_function

      def memoized(instance_variable)
        unless self.instance_variable_get(instance_variable)
          value = yield
          self.instance_variable_set(instance_variable, value)
        end
        self.instance_variable_get(instance_variable)
      end

      REPORTERS.each do |name|
        define_method name do
          memoized(:"@#{name}") do
            lambda {|received, approved|
              self.send("#{name}_command".to_sym, received, approved)
            }
          end
        end
      end

      def opendiff_command(received, approved)
        OpendiffReporter.command(received, approved)
      end

      def diffmerge_command(received, approved)
        DiffmergeReporter.command(received, approved)
      end

      def vimdiff_command(received, approved)
        VimdiffReporter.command(received, approved)
      end

      def tortoisediff_command(received, approved)
        TortoisediffReporter.command(received, approved)
      end

      def filelauncher_command(received, approved)
        FilelauncherReporter.command(received, approved)
      end
    end
  end
end

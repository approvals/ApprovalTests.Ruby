
module Approvals
  module Reporters
    module Launcher

      class << self
        [:opendiff, :diffmerge, :vimdiff].each do |name|
          define_method name do
            instance_variable = :"@#{name}"
            unless self.instance_variable_get(instance_variable)
              launcher = lambda {|received, approved|
                self.send("#{name}_command".to_sym, received, approved)
              }
              self.instance_variable_set(instance_variable, launcher)
            end
            self.instance_variable_get(instance_variable)
          end
        end

        def opendiff_command(received, approved)
          "opendiff #{received} #{approved}"
        end

        def diffmerge_command(received, approved)
          "/Applications/DiffMerge.app/Contents/MacOS/DiffMerge --nosplash \"#{received}\" \"#{approved}\""
        end

        def vimdiff_command(received, approved)
          "vimdiff #{received} #{approved}"
        end

      end
    end
  end
end

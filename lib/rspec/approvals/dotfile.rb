module RSpec
  module Approvals

    class Dotfile
      class << self

        def reset
          File.delete(path) if File.exists?(path)
        end

        def path
          Approvals.dotfile
        end

        def touch
          FileUtils.touch(path)
        end

        def append(text)
          unless includes?(text)
            write text
          end
        end

        def includes?(text)
          system("cat #{path} | grep -q \"^#{text}$\"")
        end

        def write(text)
          File.open(path, 'a+') do |f|
            f.write "#{text}\n"
          end
        end

      end
    end

  end
end

module Approvals
  module Dotfile
    def self.reset
      File.truncate(path, 0) if File.exist?(path)
    end

    def self.append(text)
      unless includes?(text)
        write text
      end
    end

    module Private
      private

      def path
        File.join(Approvals.project_dir, '.approvals')
      end

      def includes?(text)
        return false unless File.exist?(path)
        File.read(path).include?(text)
      end

      def write(text)
        File.open(path, 'a+') do |f|
          f.write "#{text}\n"
        end
      end
    end
    extend Private
  end
end

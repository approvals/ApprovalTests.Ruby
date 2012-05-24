module Approvals
  module Writers
    class TextWriter
      include Singleton

      def extension
        'txt'
      end

      def write(data, path)
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w') do |f|
          f.write format(data)
        end
      end

      def format(data)
        data.to_s
      end

    end
  end
end

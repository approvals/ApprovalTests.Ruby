module Approvals

  module Writers

    class BinaryWriter
      include Singleton

      EXCEPTION_WRITER = Proc.new do |data, file|
        raise "BinaryWriter#callback missing"
      end

      def new(opts = {})
        self.autoregister = opts[:autoregister] || true
        self.format = opts[:format] || :binary
        self.extension = opts[:extension] || ''
        self.write = opts[:write] || EXCEPTION_WRITER
        self.detect = opts[:detect]        
      end
           
      attr_accessor :autoregister
      attr_accessor :extension
      attr_accessor :write
      
      
      attr_reader :format

      def format=(sym)
        unregister if autoregister
                
        @format = sym        
        
        register if autoregister
        
      end
      
      def register
        if @format
          Writer::REGISTRY[@format] = self 
          Approval::BINARY_FORMATS << @format
          Approval::IDENTITIES[@format] = @detect if @detect
        end
      end
      
      def unregister
        if @format
          Writer::REGISTRY.delete!(@format)
          Approval::BINARY_FORMATS.delete!(@format)
          Approval::IDENTITIES.delete!(@format)
        end
      end

      def write(data,path)
        @write.call(data,path)
      end

    end
  end
end
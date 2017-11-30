module Approvals
  module Verifiers
    class JsonVerifier
      def initialize(received_path, approved_path)
        self.received_path = received_path
        self.approved_path = approved_path
      end

      def verify
        return false unless approved == received
        true
      end

      private

      attr_accessor :approved_path, :received_path

      def approved
        @approved = JSON.parse(File.read(approved_path))
      end

      def received
        @receiver = JSON.parse(File.read(received_path))
      end
    end
  end
end

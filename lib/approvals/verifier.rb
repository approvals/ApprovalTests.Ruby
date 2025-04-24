module Approvals
  module Verifier
    REGISTRY = {
      json: Verifiers::JsonVerifier,
    }

    def self.for(format)
      REGISTRY[format]
    end
  end
end

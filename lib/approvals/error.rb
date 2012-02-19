module Approvals
  class ApprovalError < Exception
    attr_accessor :received_path, :approved_path
  end
end

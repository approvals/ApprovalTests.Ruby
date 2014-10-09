require 'spec_helper'
require 'approvals/configuration'

describe Approvals::Configuration do

  it "defaults to 'fixtures/approvals/'" do
    expect(Approvals.configuration.approvals_path).to eq('fixtures/approvals/')
  end

  describe "when set" do
    before(:each) do
      Approvals.configure do |c|
        c.approvals_path = 'output/dir/'
      end
    end

    after(:each) do
      Approvals.configure do |c|
        c.approvals_path = nil
      end
    end

    it "overrides the output directory" do
      expect(Approvals.configuration.approvals_path).to eq('output/dir/')
    end
  end

end

require 'spec_helper'
require 'approvals/scrubber'

describe Approvals::Scrubber do

  describe "defaults" do
    let(:path) { File.expand_path('.') }
    subject { Approvals::Scrubber.new("I am currently at #{path}") }

    its(:to_s) { should eq("I am currently at {{current_dir}}") }

    it "unscrubs" do
      subject.unscrub.should eq("I am currently at #{path}")
    end

    it "unscrubs any old string" do
      subject.unscrub("Hoy, where's {{current_dir}}?").should eq("Hoy, where's #{path}?")
    end
  end

  it "overrides default hash" do
    Approvals::Scrubber.new("oh, my GAWD", {"deity" => "GAWD"}).to_s.should eq('oh, my {{deity}}')
  end
end

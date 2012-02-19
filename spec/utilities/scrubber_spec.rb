require 'approvals/utilities/scrubber'

describe Approvals::Scrubber do
  include Approvals

  describe "defaults" do
    let(:path) { File.expand_path('.') }
    subject { Scrubber.new("I am currently at #{path}") }

    its(:to_s) { should eq("I am currently at {{current_dir}}") }

    it "unscrubs" do
      subject.unscrub.should eq("I am currently at #{path}")
    end

    it "unscrubs any old string" do
      subject.unscrub("Hoy, where's {{current_dir}}?").should eq("Hoy, where's #{path}?")
    end
  end

  it "overrides default hash" do
    Scrubber.new("oh, my GAWD", {"deity" => "GAWD"}).to_s.should eq('oh, my {{deity}}')
  end
end

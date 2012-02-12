require 'rspec/approvals'

describe RSpec::Approvals::Approval do
  include RSpec::Approvals

  describe "#normalize" do
    it "downcases" do
      Approval.normalize("KTHXBYE").should eq("kthxbye")
    end

    it "replaces spaces with underscores" do
      Approval.normalize("the spec").should eq("the_spec")
    end

    it "leaves numbers alone" do
      Approval.normalize('a 2009 party').should eq("a_2009_party")
    end

    it "deletes funky characters" do
      Approval.normalize('the !@\#$%^&*(){}+| name').should eq("the_name")
    end

    it "collapses spaces before replacing with underscores" do
      Approval.normalize('omf             g').should eq('omf_g')
    end

    it "deletes all sorts of spaces" do
      name = <<-FUNKY_NAME

The::Class       \t \r\n \fname
      FUNKY_NAME
      Approval.normalize(name).should eq('the_class_name')
    end
  end

  let(:example) { stub('example', :full_description => 'fairy dust and unicorns').as_null_object }

  describe "an approval" do
    let(:path) { 'spec/approvals/fairy_dust_and_unicorns' }
    subject { Approval.new(example) }

    its(:approved_path) { should eq("#{path}.approved.txt") }
    its(:received_path) { should eq("#{path}.received.txt") }

    it "can set a location" do
      Dir.stub(:pwd => 'the/path')
      subject.location = ['the/path/to/my/heart:9372:in <is through my stomach>', 'bla bla bla']
      subject.location.should eq(['./to/my/heart:9372'])
    end
  end

  describe "verification" do
    let(:approval) { Approval.new(example, 'xyz') }

    context "with a match" do
      before :each do
        approval.stub(:approved_text => 'xyz', :received_text => 'xyz')
      end

      it "does not raise an error" do
        lambda { approval.verify }.should_not raise_error(RSpec::Approvals::ReceivedDiffersError)
      end

      it "does not leave a received file" do
        lambda { approval.verify }.call
        File.exists?(approval.received_path).should be_false
      end
    end

    context "with a mismatch" do
      before :each do
        approval.stub(:approved_text => 'xyz', :received_text => 'abc')
      end

      after :each do
        File.delete(approval.received_path) if File.exists?(approval.received_path)
      end

      it "raises an error" do
        lambda { approval.verify }.should raise_error(RSpec::Approvals::ReceivedDiffersError)
      end

      it "leaves a received file" do
        begin
          approval.verify
        rescue RSpec::Approvals::ReceivedDiffersError => e
          # we want to land here and then move on
        end
        File.exists?(approval.received_path).should be_true
      end

      it "appends to the dotfile" do
        approval.stub(:diff_path => 'the diff path')
        Dotfile.should_receive(:append).with "the diff path"

        begin
          approval.verify
        rescue RSpec::Approvals::ReceivedDiffersError => e
          # moving on
        end
      end
    end

    it "fails magnificently" do
      message = <<-FAILURE_MESSAGE

        Approval Failure:
          The received contents did not match the approved contents.

        Inspect the differences in the following files:
        #{approval.received_path}
        #{approval.approved_path}

      FAILURE_MESSAGE

      approval.failure_message.should eq(message)
    end
  end
end

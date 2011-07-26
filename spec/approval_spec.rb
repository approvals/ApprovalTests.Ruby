require 'spec_helper'

describe Approvals::Approval do
  let(:description) { 'spec/approvals/fairy_dust_and_unicorns' }
  let(:example) { stub('example', :full_description => 'fairy dust and unicorns').as_null_object }

  describe "#normalize" do
    it "downcases" do
      Approvals::Approval.normalize("KTHXBYE").should eq("kthxbye")
    end

    it "replaces spaces with underscores" do
      Approvals::Approval.normalize("the spec").should eq("the_spec")
    end

    it "leaves numbers alone" do
      Approvals::Approval.normalize('a 2009 party').should eq("a_2009_party")
    end

    it "deletes funky characters" do
      Approvals::Approval.normalize('the !@\#$%^&*(){}+| name').should eq("the_name")
    end

    it "collapses spaces before replacing with underscores" do
      Approvals::Approval.normalize('omf             g').should eq('omf_g')
    end

    it "deletes all sorts of spaces" do
      name = <<-FUNKY_NAME

The::Class       \t \r\n \fname
      FUNKY_NAME
      Approvals::Approval.normalize(name).should eq('the_class_name')
    end
  end

  it "knows the approved_path" do
    approval = Approvals::Approval.new(example)
    approval.approved_path.should eq("#{description}.approved.txt")
  end

  it "knows the received path" do
    approval = Approvals::Approval.new(example)
    approval.received_path.should eq("#{description}.received.txt")
  end

  it "can set a location" do
    Dir.stub(:pwd => 'the/path')
    approval = Approvals::Approval.new(example)
    approval.location = ['the/path/to/my/heart:9372 <is through my stomach>', 'bla bla bla']
    approval.location.should eq(['./to/my/heart:9372 <is through my stomach>'])
  end

  context "approvals" do
    before :each do
      @approved_file = "#{description}.approved.txt"
      @received_file = "#{description}.received.txt"
    end

    after :each do
      File.delete(@approved_file) if File.exists?(@approved_file)
      File.delete(@received_file) if File.exists?(@received_file)
    end

    describe "on the filesystem" do

      it "writes the approved file if it doesn't exist" do
        File.delete(@approved_file) if File.exists?(@approved_file)

        Approvals::Approval.new(example)

        File.exists?(@approved_file).should be_true
        File.read(@approved_file).should eq('')
      end

      it "doesn't overwrite an existing approved file" do
        File.open(@approved_file, 'w') do |f|
          f.write "this doesn't get deleted"
        end

        Approvals::Approval.new(example)

        File.exists?(@approved_file).should be_true
        File.read(@approved_file).should eq("this doesn't get deleted")
      end

      it "writes the received contents to file" do
        approval = Approvals::Approval.new(example, 'oooh, shiney!')

        File.exists?(@received_file).should be_true
        File.read(@received_file).should eq('"oooh, shiney!"')
      end
    end

    describe "verification" do

      context "with a match" do
        before :each do
          @approval = Approvals::Approval.new(example, 'xyz')
          @approval.write(:approved, 'xyz')
        end

        it "does not raise an error" do
          lambda { @approval.verify }.should_not raise_error(RSpec::Approvals::ReceivedDiffersError)
        end

        it "does not leave a received file" do
          lambda { @approval.verify }.call
          File.exists?(@approval.received_path).should be_false
        end
      end

      context "with a mismatch" do
        before :each do
          @approval = Approvals::Approval.new(example, 'xyz')
          @approval.write(:approved, 'abc')
        end

        it "raises an error" do
          lambda { @approval.verify }.should raise_error(RSpec::Approvals::ReceivedDiffersError)
        end

        it "leaves a received file" do
          begin
            @approval.verify
          rescue RSpec::Approvals::ReceivedDiffersError => e
            # we want to land here and then move on
          end
          File.exists?(@approval.received_path).should be_true
        end
      end
    end

    it "fails magnificently" do
      approval = Approvals::Approval.new(example, 'xyz')
      message = <<-FAILURE_MESSAGE

        Approval Failure:

        The received contents did not match the approved contents.

        Inspect the differences in the following files:
        #{approval.received_path}
        #{approval.approved_path}

        If you like what you see in the *.received.txt file, you can approve it
        like so:

        mv #{approval.received_path} #{approval.approved_path}


      FAILURE_MESSAGE

      approval.failure_message.should eq(message)
    end
  end
end

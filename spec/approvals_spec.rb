require 'spec_helper'
require 'approvals/namers/rspec_namer'
require 'date'

describe Approvals do

  let(:namer) { |example| Approvals::Namers::RSpecNamer.new(example) }

  it "fails" do
    dev_null = Gem.win_platform? ? 'nul' : '/dev/null'
    allow(Approvals::Dotfile).to receive(:path).and_return(dev_null)

    expect do
      Approvals.verify "this one doesn't exist", :namer => namer
    end.to raise_error Approvals::ApprovalError
  end

  it "verifies a string" do
    string = "We have, I fear, confused power with greatness."
    Approvals.verify string, :namer => namer
  end

  it "verifies an array" do
    array = [
      "abc",
      123,
      :zomg_fooooood,
      %w(cheese burger ribs steak bacon)
    ]
    Approvals.verify array, :namer => namer
  end

  it "verifies a hash" do
    hash = {
      :meal => 'breakfast',
      :proteins => '90%',
      :price => 38,
      :delicious => true
    }
    Approvals.verify hash, :namer => namer
  end

  it "verifies a complex object" do
    hello = Object.new
    def hello.to_s
      "Hello, World!"
    end

    def hello.inspect
      "#<The World Says: Hello!>"
    end

    Approvals.verify hello, :namer => namer
  end

  context "custom writer" do
    let(:hello) { Object.new }

    class MyCustomWriter < Approvals::Writers::TextWriter
      def format(data)
        filter(data)
      end

      def filter(data)
        data.to_s.chars.reject {|c| c =~ /[a-zA-Z0-9]/}
      end
    end

    it "verifies a complex object" do
      Approvals.verify hello, :namer => namer, :format => "MyCustomWriter"
    end

    it "raises an error with an uninitialized custom writer class" do
      expect{
        Approvals.verify hello, :namer => namer, :format => "UninitializedWriter"
      }.to raise_error.with_message(
        /Please define a custom writer as outlined in README section 'Customizing formatted output':/
      )
    end
 end

  it "verifies html" do
    html = <<-HTML
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd"><html><head><title>Approval</title></head><body><h1>An Approval</h1><p>It has a paragraph</p></body></html>
    HTML
    Approvals.verify html, :format => :html, :namer => namer
  end

  it "verifies a malformed html fragment" do
    pending
    html = <<-HTML
<!DOCTYPE html>
<html>
<title>Hoi</title>
<script async defer src="http://foo.com/bar.js"></script>
<h1>yo</h1>
    HTML
    Approvals.verify html, :format => :html, :namer => namer
  end

  it "verifies xml" do
    xml = "<xml char=\"kiddo\"><node><content name='beatrice' /></node><node aliases='5'><content /></node></xml>"
    Approvals.verify xml, :format => :xml, :namer => namer
  end

  it "verifies json" do
    json = '{"pet":{"species":"turtle","color":"green","name":"Anthony"}}'
    Approvals.verify json, :format => :json, :namer => namer
  end

  it "ignores whitespace differences in json" do
    hash = { foo: {} }

    Approvals.verify hash, :format => :json, :namer => namer
  end

  it "verifies json and is newline agnostic" do
    json = '{"pet":{"species":"turtle","color":"green","name":"Anthony"}}'
    Approvals.verify json, :format => :json, :namer => namer
  end

  it "verifies an array as json when format is set to json" do
    people = [
      {"name" => "Alice", "age" => 28},
      {"name" => "Bob", "age" => 22}
    ]

    Approvals.verify(people, format: :json, namer: namer)
  end

  it "verifies an executable" do
    executable = Approvals::Executable.new('SELECT 1') do |command|
      puts "your slip is showing (#{command})"
    end

    Approvals.verify executable, :namer => namer
  end

  it "passes approved files through ERB" do
    $what  = 'greatness'
    string = "We have, I fear, confused power with greatness."
    Approvals.verify string, :namer => namer
  end

  # Bugfix: If only the approved file gets passed through ERB,
  # then <% (received) is not equal to <% (approved).
  it "passes the received files through ERB" do
    string = "<%"
    Approvals.verify string, :namer => namer
  end

  describe "supports excluded keys option" do
    let(:hash) { {:object => {:id => rand(100), :created_at => Time.now, :name => 'test', deleted_at: nil}} }

    before do
      Approvals.configure do |c|
        c.excluded_json_keys = {
          :id => /(\A|_)id$/,
          :date => /_at$/
        }
      end
    end

    it "verifies json with excluded keys" do
      Approvals.verify JSON.dump(hash), :format => :json, :namer => namer
    end

    it "also supports an array of hashes" do
      Approvals.verify JSON.dump([hash]), :format => :json, :namer => namer
    end

    # NOTE: Ruby 3.4 changed the output of Hash#inspect:
    # https://bugs.ruby-lang.org/issues/20433
    #
    # TODO: When the time has come, find two tests below that say "supports the
    # [array|hash] writer", lift them out of the enclosing `context` block that
    # says "(while we're still supporting Ruby < 3.4)", then delete that
    # `context` block in its entirety.
    #
    # You'll then need to rerun `approvals verify` and accept the new fixtures.
    # (You should probably also remove the old fixtures you'll have just
    # orphaned, if this gem hasn't gained the ability to clean those up
    # automagically.)
    context "(while we're still supporting Ruby < 3.4)" do
      before do
        if '2027-03-31' < Date.today.iso8601
          raise 'THE TIME HAS COME ... to remove a hack in the test suite (SEE COMMENTS)'
        end
      end

      def current_ruby = Gem::Version.new(RUBY_VERSION)
      def ruby_3_4     = Gem::Version.new('3.4.0')

      context "in Ruby versions prior to 3.4" do
        before do
          if ruby_3_4 <= current_ruby
            skip "Don't test this for Ruby #{RUBY_VERSION}"
          end
        end

        # TODO: promote these after 2027-03-31
        it "supports the array writer" do
          Approvals.verify [hash], format: :array, namer: namer
        end

        it "supports the hash writer" do
          Approvals.verify hash, format: :array, namer: namer
        end
      end

      context "in Ruby versions 3.4 AND BEYOND" do
        before do
          if current_ruby < ruby_3_4
            skip "Don't test this for Ruby #{RUBY_VERSION}"
          end
        end

        # TODO: delete these after 2027-03-31 (they'll be redundant to the 'promote these' tests, above)
        it "supports the array writer" do
          Approvals.verify [hash], format: :array, namer: namer
        end

        it "supports the hash writer" do
          Approvals.verify hash, format: :array, namer: namer
        end
      end
    end
  end
end

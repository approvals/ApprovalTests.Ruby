require 'approvals/extensions/rspec'

describe "Verifies" do
  verify "a string" do
    "We have, I fear, confused power with greatness."
  end

  verify "an array" do
    array = [
      "abc",
      123,
      :zomg_fooooood,
      %w(cheese burger ribs steak bacon)
    ]
  end

  verify "a complex object" do
    hello = Object.new
    def hello.to_s
      "Hello, World!"
    end

    def hello.inspect
      "#<The World Says: Hello!>"
    end

    hello
  end

  verify "html", :format => :html do
    html = <<-HTML
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd"><html><head><title>Approval</title></head><body><h1>An Approval</h1><p>It has a paragraph</p></body></html>
    HTML
  end

  verify "xml", :format => :xml do
    xml = "<xml char=\"kiddo\"><node><content name='beatrice' /></node><node aliases='5'><content /></node></xml>"
  end

  verify "json", :format => :json do
    json = '{"pet":{"species":"turtle","color":"green","name":"Anthony"}}'
  end

  verify "an executable" do
    executable('SELECT 1') do |command|
      puts "your slip is showing (#{command})"
    end
  end
end

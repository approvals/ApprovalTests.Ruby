require 'spec_helper'
require 'json'

describe Approvals do

  it "defaults the output dir to spec/approvals" do
    RSpec.configuration.approvals_path.should == 'spec/approvals'
  end

  describe "initializing approval directory" do
    it "does nothing if directory exists" do
      RSpec.configuration.stub(:approvals_path).and_return 'xyz'
      Dir.stub(:exists?).and_return true
      FileUtils.should_not_receive(:makedirs).with 'xyz'

      Approvals.initialize_approvals_path
    end

    it "creates directory if it is missing" do
      RSpec.configuration.stub(:approvals_path).and_return 'abc'
      Dir.stub(:exists?).and_return false
      FileUtils.should_receive(:makedirs).with('abc')

      Approvals.initialize_approvals_path
    end
  end

  it "needs to be able to run with :filtered => true"

  verify "a string" do
    "We have, I fear, confused power with greatness."
  end

  verify "a hash" do
    {
      :universe => {
        :side => :dark,
        :other_side => :light
      },
      :force => true,
      :evil => "undecided"
    }
  end

  verify "an array" do
    [
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

    hello # => output matches hello.inspect
  end

  verify "formats html nicely", :format => :html, :show_received => true do
    <<-XML
    <?xml version="1.0" encoding="UTF-8"?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en"><head><meta content="text/html; charset=utf-8" http-equiv="Content-Type"/><title>blog</title><script type="text/javascript" src="/blog/static/jquery-1.1.3.pack.js"></script><script type="text/javascript" src="/blog/static/blog.js"></script><link type="text/css" rel="stylesheet" href="/blog/styles.css" media="screen"/></head><body><h1 class="header"><a href="/blog/">blog</a></h1><div class="content"><h1 class="post_head"><a href="/blog/view/2">Hej</a><a class="edit_link" href="/blog/edit/2">edit</a></h1><p>ASDJlksdjfsld
    </p><h2 class="comment_head"><a href="javascript:getComments(2)">See comments (2)</a></h2><div id="comments"><h3>tyysen</h3><p>miljoooner</p><h3>hej</h3><p>bulan</p></div><h2 class="add_comment_head"><a href="#comment_form">Add comment</a></h2><form method="post" name="comment_form" id="comment_form" action="/blog/comment"><label for="post_username">Name</label><br/><input type="text" name="post_username"/><br/><label for="post_body">Comment</label><br/><textarea name="post_body"></textarea><br/><input type="hidden" name="post_id" value="2"/><input type="submit" value="Add comment"/></form></div></body></html>
    XML
  end

  verify "formats xml nicely", :format => :xml, :show_received => true do
    "<xml testsdf=\"dsfsdf\"><test/><node><content attr='fgsd' /></node><node id='2'><content /></node></xml>"
  end

  verify "formats json nicely", :format => :json, :show_received => true do
    {"hello" => "world"}.to_json
  end
end

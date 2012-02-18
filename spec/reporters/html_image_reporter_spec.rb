require 'rspec/approvals/reporters'

describe RSpec::Approvals::HtmlImageReporter do
  subject { RSpec::Approvals::HtmlImageReporter.instance }

  it "creates the appropriate command" do
    result = subject.html("spec/fixtures/one.png", "spec/fixtures/two.png")
    expected = "<html><body><center><table style=\"text-align: center;\" border=1><tr><td><img src=\"file:///Users/katrina/code/gems/rspec-approvals/spec/fixtures/one.png\"></td><td><img src=\"file:///Users/katrina/code/gems/rspec-approvals/spec/fixtures/two.png\"></td></tr><tr><td>received</td><td>approved</td></tr></table></center></body></html>"
    if result != expected
      subject.display(result)
    end
    result.should eq(expected)
  end

end

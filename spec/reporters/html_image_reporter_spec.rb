require 'rspec/approvals/reporters'
require 'rspec/approvals/utilities/scrubber'

describe RSpec::Approvals::HtmlImageReporter do

  verify "creates the appropriate command", :format => :html do
    reporter = RSpec::Approvals::HtmlImageReporter.instance
    scrubber = Scrubber.new(reporter.html("spec/fixtures/one.png", "spec/fixtures/two.png"))
    scrubber.to_executable do |html|
      reporter.display(html)
    end
  end

end

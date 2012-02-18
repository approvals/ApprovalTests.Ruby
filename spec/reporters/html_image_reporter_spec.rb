require 'rspec/approvals/reporters'

describe RSpec::Approvals::HtmlImageReporter do

  verify "creates the appropriate command", :format => :html do
    reporter = RSpec::Approvals::HtmlImageReporter.instance
    executable reporter.html("spec/fixtures/one.png", "spec/fixtures/two.png") do |html|
      reporter.display(html)
    end
  end

end

require 'rspec/approvals/reporters'

describe RSpec::Approvals::ImageMagickReporter do
  subject { RSpec::Approvals::ImageMagickReporter.instance }

  it "creates the appropriate command" do
    result = subject.create_command_line("spec/fixtures/one.png", "spec/fixtures/two.png")
    expected = "compare spec/fixtures/one.png spec/fixtures/two.png -compose Src x:"
    if result != expected
      system(result)
      system(expected)
    end
    result.should eq(expected)
  end
end

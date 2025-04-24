module Approvals
  module Writer
    extend Writers

    REGISTRY = {
      json:  Writers::JsonWriter.new,
      xml:   Writers::XmlWriter.new,
      html:  Writers::HtmlWriter.new,
      hash:  Writers::HashWriter.new,
      array: Writers::ArrayWriter.new,
      txt:   Writers::TextWriter.new,
    }

    class << self
      def for(format)
        begin
          REGISTRY[format] || Object.const_get(format).new
        rescue NameError => e
          error = ApprovalError.new(
            "Approval Error: #{ e }. Please define a custom writer as outlined"\
            " in README section 'Customizing formatted output': "\
            "https://github.com/kytrinyx/approvals#customizing-formatted-output"
          )
          raise error
        end
      end
    end
  end
end

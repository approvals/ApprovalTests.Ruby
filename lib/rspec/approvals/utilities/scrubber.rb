class Scrubber
  def initialize(string)
    @hash = get_hash
    @string = scrub(string)
  end

  def to_executable(&block)
    RSpec::Approvals::Executable.new(@string) do |scrubbed|
      block.call(unscrub(scrubbed))
    end
  end

  def get_hash
    {
      'current_dir' => File.expand_path('.')
    }
  end

  def scrub(string)
    @hash.each do |key, value|
      string = string.gsub(value, wrap(key))
    end
    string
  end

  def wrap(string)
    "{{#{string}}}"
  end

  def unscrub(string)
    @hash.each do |key, value|
      string = string.gsub(wrap(key), value)
    end
    string
  end

  def to_s
    @string
  end
end

module Typingtutor
  class Stats < Hash
    FILE = '~/.typingtutor'

    def initialize
      self.merge(YAML.load(IO.read(FILE))) if File.exists?(FILE)
      self[:created_at] ||= Time.now
      self[:exercises]  ||= {}
      self[:words] ||= {}
      self[:letters] ||= {}
    end

    def save
      IO.write(FILE, YAML.dump(self))
    end
  end
end

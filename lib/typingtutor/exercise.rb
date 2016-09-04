module Typingtuor
  class Exercise
    attr_accessor :name, :body, :stats, :start, :time

    # class methods

    def self.load(name:, stats:)
      return nil if name.nil?
      body = load_body(name)
      return body.nil? ? nil : Exercise.new(name:name, body:body, stats:stats)
    end

    def self.load_body(name)
      gem_file_name = File.join(File.dirname(__FILE__), '..', '..', "exercises", "#{name}.txt")

      lines ||= dictionary.training_exercise if name == 'training'
      # load from exercise folder in the gem
      lines ||= IO.read(name).lines if File.exists?(name)
      lines ||= IO.read("#{name}.txt").lines if File.exists?("#{name}.txt")
      lines ||= IO.read(gem_file_name).lines if File.exists?(gem_file_name)

      return if lines.nil?

      lines.each {|line| line.strip!}    # remove extra spaces
      lines.reject! {|line| line.strip.to_s == ""} # remove empty lines
      return lines
    end

    def self.available_exercises
      files = Dir[File.join(File.dirname(__FILE__), '..', '..', "exercises", "*.txt")]
      files.map! do |name|
        name = name.split(File::SEPARATOR).last
        name = name.gsub /\.txt/, ''
        name
      end
      files
    end

    # instance methods

    def initialize(name:, body:, stats:)
      self.name  = name
      self.body  = body
      self.stats = stats
    end

    def play
      results = body.map { |line| Line.new(line).play }
      self.time = Time.now - start
      self.total_chars   = results.map {|s| s[:total_chars] }.inject(:+)
      self.correct_chars = results.map {|s| s[:correct_chars] }.inject(:+)
      self.total_words   = results.map {|s| s[:total_words] }.inject(:+)
      self.keystrokes    = results.map {|s| s[:keystrokes] }.inject(:+)
      self.typing_accuracy = (correct_chars.to_f / keystrokes.to_f * 100).to_i
      self.word_accuracy   = (correct_chars.to_f / total_chars.to_f * 100).to_i # TODO
      self.gross_wpm = total_words / (time / 60)
      return results
    end

    def results
      {
        time: time,
        total_chars: total_chars,
        correct_chars: correct_chars,
        total_words: total_words,
        keystrokes: keystrokes,
        typing_accuracy: typing_accuracy,
        word_accuracy: word_accuracy,
        gross_wpm: gross_wpm
      }
    end

    def print
      puts
      puts "------------------------"
      puts "Time: #{time.round(1)}s (#{total_words} words)"
      puts "Speed: #{gross_wpm.round} wpm"
      puts "Word accuracy: #{word_accuracy}%"
      puts "Typing accuracy: #{typing_accuracy}%"
    end

  end
end

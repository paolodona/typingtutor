module Typingtutor
  class Exercise
    attr_accessor :name, :body, :stats, :start, :time
    attr_accessor :chars, :correct_chars, :words, :keystrokes, :typing_accuracy, :word_accuracy, :gross_wpm

    # class methods

    def self.load(name:, stats:)
      return nil if name.nil?
      body = load_body(name:name, stats:stats)
      return body.nil? ? nil : Exercise.new(name:name, body:body, stats:stats)
    end

    def self.load_body(name:, stats:)
      gem_file_name = File.join(File.dirname(__FILE__), '..', '..', "exercises", "#{name}.txt")

      lines ||= dictionary.training_exercise if name == 'training'
      lines ||= improve_exercise(stats) if name == 'improve'
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

    def self.improve_exercise(stats)
      lines = []
      index = 0
      stats.worst_letters.to_h.each do |letter, accuracy|
        next if dictionary.pick_word_with_letter(letter).nil? # no samples to use
        lines << "You have a #{accuracy}% accuracy on letter #{letter}, let's work on that:"
        2.times do
          lines << 8.times.map {|i| dictionary.pick_word_with_letter(letter)}.join(" #{letter * (rand(2)+1)} ").strip
        end
        index += 1
        break if index > 5
      end
      lines
    end

    def self.dictionary
      @dictionary ||= Dictionary.new
    end

    # instance methods

    def initialize(name:, body:, stats:)
      self.name  = name
      self.body  = body
      self.stats = stats
    end

    def play
      @start = Time.now
      results = body.map { |line| Line.new(line:line, stats:stats).play unless line == ""}
      self.time = Time.now - @start
      self.chars = results.map {|s| s[:chars] }.inject(:+)
      self.correct_chars = results.map {|s| s[:correct_chars] }.inject(:+)
      self.words = results.map {|s| s[:words] }.inject(:+)
      self.keystrokes  = results.map {|s| s[:keystrokes] }.inject(:+)
      self.typing_accuracy = (correct_chars.to_f / keystrokes.to_f * 100).to_i
      self.word_accuracy   = (correct_chars.to_f / chars.to_f * 100).to_i # TODO
      self.gross_wpm = words / (time / 60)
      stats.record_exercise(self)
      return results
    end

    def results
      {
        time: time,
        chars: chars,
        correct_chars: correct_chars,
        words: words,
        keystrokes: keystrokes,
        typing_accuracy: typing_accuracy,
        word_accuracy: word_accuracy,
        gross_wpm: gross_wpm
      }
    end

    def print
      puts
      puts "------------------------"
      puts "Time: #{time.round.divmod(60).join('m ')}s (#{words} words)"
      puts "Speed: #{gross_wpm.round} wpm"
      # puts "Word accuracy: #{word_accuracy}%"
      puts "Typing accuracy: #{typing_accuracy}%"
    end

  end
end

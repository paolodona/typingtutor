module Typingtutor
  class Stats
    FILE = File.expand_path('~/.typingtutor')

    def initialize
      @stats = {}
      @stats.merge!(YAML.load(IO.read(FILE))) if File.exists?(FILE)
      @stats[:created_at] ||= Time.now
      @stats[:exercises]  ||= {}
      @stats[:words] ||= {}
      @stats[:letters] ||= {}
    end

    def save
      IO.write(FILE, YAML.dump(@stats))
    end

    def record_exercise(exercise)
      @stats[:exercises][exercise.name] ||= {}
      @stats[:exercises][exercise.name][:runs] ||= 0
      @stats[:exercises][exercise.name][:runs] += 1
      @stats[:exercises][exercise.name][:last_run] = Time.now
      @stats[:exercises][exercise.name][:last_run_results] = exercise.results
    end

    def record_word(word)
      # TODO
    end

    def record_letter(letter, ok)
      @stats[:letters][letter] ||= {}
      @stats[:letters][letter][:total] ||= {}
      @stats[:letters][letter][:total][:count] ||= 0
      @stats[:letters][letter][:total][:count] += 1
      @stats[:letters][letter][:total][:correct] ||= 0
      @stats[:letters][letter][:total][:correct] += 1 if ok
    end
  end
end

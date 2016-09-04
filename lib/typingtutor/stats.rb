module Typingtutor
  class Stats
    FILE = File.expand_path('~/.typingtutor')

    def initialize
      @stats = {}
      @stats.merge!(YAML.load(IO.read(FILE))) if File.exists?(FILE)
      @stats[:created_at] ||= Time.now
      @stats[:total] ||= {}
      @stats[:exercises]  ||= {}
      @stats[:words] ||= {}
      @stats[:letters] ||= {}
    end

    def save
      @stats[:updated_at] = Time.now
      IO.write(FILE, YAML.dump(@stats))
    end

    def record_exercise(exercise)
      @stats[:exercises][exercise.name] ||= {}
      @stats[:exercises][exercise.name][:runs] ||= 0
      @stats[:exercises][exercise.name][:runs] += 1
      @stats[:exercises][exercise.name][:last_run] = Time.now
      @stats[:exercises][exercise.name][:last_run_results] = exercise.results

      # update totals
      @stats[:total][:runs] ||= 0
      @stats[:total][:runs] += 1

      [:time, :chars, :correct_chars, :words, :keystrokes].each do |metric|
        @stats[:total][metric] ||= 0
        @stats[:total][metric] += exercise.results[metric]
      end

      @stats[:total][:max_wpm] ||= 0
      @stats[:total][:max_wpm] = [@stats[:total][:max_wpm], exercise.results[:gross_wpm]].max
      @stats[:total][:avg_wpm] = @stats[:total][:words] / (@stats[:total][:time] / 60)
    end

    def record_word(word)
      # TODO
    end

    def record_letter(letter, ok)
      return if letter == ' '
      @stats[:letters][letter] ||= {}
      @stats[:letters][letter][:total] ||= {}
      @stats[:letters][letter][:total][:count] ||= 0
      @stats[:letters][letter][:total][:count] += 1
      @stats[:letters][letter][:total][:correct] ||= 0
      @stats[:letters][letter][:total][:correct] += 1 if ok
      @stats[:letters][letter][:total][:accuracy] = (@stats[:letters][letter][:total][:correct].to_f / @stats[:letters][letter][:total][:count].to_f * 100).round
    end
  end
end

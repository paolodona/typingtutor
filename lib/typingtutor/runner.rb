module Typingtutor
  class Runner
    include HighLine::SystemExtensions

    def run(exercise_name)
      exercise = load_exercise(exercise_name) unless exercise_name.nil?
      if exercise
        setup_color_scheme
        play_intro
        @start = Time.now
        stats = exercise.map { |line| Line.new(line).play }
        print_stats(stats)
      else
        puts "Typingtutor v#{Typingtutor::VERSION}"
        puts
        puts "$ typingtutor <exercise>"
        puts "$ typingtutor path/to/localfile.txt"
        puts
        puts "built in exercises:"
        puts "- training (dynamically generated)"
        exercises.each {|e| puts "- #{e}"}
        puts
        puts "eg: typingtutor biglebowski"
      end
    end

    protected

    def play_intro
      puts "Typingtutor: Touch Typing Training"; sleep 0.5;
      3.downto(1) {|n| print "#{n}"; sleep 0.5; print '.'; sleep 0.5}
      print "GO!\n"
    end

    def setup_color_scheme
      cs = HighLine::ColorScheme.new do |cs|
         cs[:plain]   = [:white]
         cs[:correct] = [:green]
         cs[:error]   = [:red, :bold]
      end
      HighLine.color_scheme = cs
    end

    def load_exercise(name)
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

    def exercises
      files = Dir[File.join(File.dirname(__FILE__), '..', '..', "exercises", "*.txt")]
      files.map! do |name|
        name = name.split(File::SEPARATOR).last
        name = name.gsub /\.txt/, ''
        name
      end
      files
    end

    def dictionary
      @dictionary ||= Dictionary.new
    end

    def print_stats(stats)
      time = Time.now - @start
      total_chars   = stats.map {|s| s[:total_chars] }.inject(:+)
      correct_chars = stats.map {|s| s[:correct_chars] }.inject(:+)
      total_words   = stats.map {|s| s[:total_words] }.inject(:+)
      keystrokes    = stats.map {|s| s[:keystrokes] }.inject(:+)

      typing_accuracy = (correct_chars.to_f / keystrokes.to_f * 100).to_i
      word_accuracy   = (correct_chars.to_f / total_chars.to_f * 100).to_i # TODO

      gross_wpm = total_words / (time / 60)

      puts
      puts "------------------------"
      puts "Time: #{time.round(1)}s (#{total_words} words)"
      puts "Speed: #{gross_wpm.round} wpm"
      puts "Word accuracy: #{word_accuracy}%"
      puts "Typing accuracy: #{typing_accuracy}%"
    end
  end # Runner
end # Typingtutor

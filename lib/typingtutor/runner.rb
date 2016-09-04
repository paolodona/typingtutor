module Typingtutor
  class Runner
    include HighLine::SystemExtensions

    def run(exercise_name)
      if exercise_name == 'stats'
        stats.print_full
        exit(0)
      end

      exercise = Exercise.load(name:exercise_name, stats:stats)
      if exercise
        setup_color_scheme
        play_intro
        exercise.play
        exercise.print
        stats.print
        stats.save
      else
        puts "Typingtutor v#{Typingtutor::VERSION}"
        puts
        puts "$ typingtutor <exercise>"
        puts "$ typingtutor path/to/localfile.txt"
        puts
        puts "built in exercises:"
        puts "- training (250 random english words)"
        puts "- improve  (250 words dynamically generated)"
        Exercise.available_exercises.each {|e| puts "- #{e}"}
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

    def stats
      @stats ||= Stats.new
    end

  end # Runner
end # Typingtutor

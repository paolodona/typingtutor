module Typingtutor
  class Runner
    include HighLine::SystemExtensions

    def run(exercise_name)
      exercise = exercises[exercise_name]
      if exercise
        setup_color_scheme
        play_intro
        @start = Time.now
        stats = exercise.map { |line| Line.new(line).play }
        print_stats(stats)
      else
        puts "usage: typingtutor <exercise>"
        puts "available:"
        exercises.keys.each {|e| puts "- #{e}"}
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

    def exercises
      {
        "lorem" => [
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', 'Nam nulla lacus, pharetra nec sollicitudin nec, faucibus non est. Nunc a erat in ante aliquet dapibus.',
          'Quisque congue libero vel mattis sodales.', 'Sed pellentesque, nunc nec gravida molestie, tellus mauris semper tellus, ac suscipit nisl est sit amet augue.',
          'Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.', 'Sed vehicula risus risus, a lobortis velit ultricies ut. Nullam porttitor leo eu leo congue, id porta elit vestibulum.',
          'Suspendisse facilisis ut diam nec molestie. Donec consequat elementum volutpat.' ],
        "test" => [
          'paolo is a nice guy', 'but he cannot type fast', 'that is a shame.'
        ],
        "fox" => ["The quick brown fox jumps over the lazy dog"],
        "haikurb" => [
          '"eyes".scan /the_darkness/',
          'catch( :in_the_wind ) { ?a.round; "breath"',
          'or "a".slice /of_moon/ }'
        ]
      }
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

module Typingtutor
  class Line
    def initialize(line:, stats:)
      @original = line
      @actual   = ""
      @position = 0
      @keystrokes = 0
      @stats = stats
    end

    def play
      print "\n#{@original.ljust(80)}\r"

      while(true) do
        char = STDIN.getch
        case char.ord
        when 3 # CTRL-C
          puts
          exit(1)
        when 13 then break # enter
        when 127 # backspace
          @actual.chop!
          @position = [@position - 1, 0].max
          print_backspace
        else
          @actual += char
          print_char
          @position += 1
          @keystrokes +=1
        end
      end
      return results
    end

    def print_char
      if actual_char
        print HighLine.color(actual_char, ok? ? :correct : :error)
      else
        print HighLine.color(expected_char, :plain)
      end
      @stats.record_letter(expected_char, ok?)
    end

    def print_backspace
      print "\b#{HighLine.color(expected_char || " ", :plain)}\b"
    end

    def expected_char; @original[@position]; end
    def actual_char;   @actual[@position];   end
    def ok?; expected_char == actual_char; end

    def results
      { chars: @original.length,
        correct_chars: @original.length.times.select {|i| @original[i] == @actual[i] }.size,
        keystrokes: @keystrokes,
        words: @actual.split(' ').size
      }
    end

  end # Line
end # Typingtutor

module Typingtutor
  class Dictionary

    def initialize
      @letters = {}
      @words   = []

      files = Dir[File.join(File.dirname(__FILE__), '../../dictionary/*')]
      files.each do |file|
        IO.read(file).lines.each {|word| add(word)}
      end
    end

    def add(word)
      return if word =~ /'s/
      word = word.strip
      @words << word
      word.chars.uniq.each do |letter|
        @letters[letter] ||= []
        @letters[letter] << word
      end
      word
    rescue Exception => e
      puts "Error adding '#{word}': #{e.message}"
      raise e
    end

    def pick_word_with_letter(letter)
      @letters[letter][rand(@letters[letter].size)]
    end

    def pick_word
      @words[rand(@words.size)]
    end

    def training_exercise
      lines = []
      line = ""
      500.times do
        line << (pick_word+" ")
        if line.size > 70
          lines << line.strip
          line = ""
        end
      end
      lines << line
      lines
    end

  end
end

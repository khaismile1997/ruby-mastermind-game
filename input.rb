module Input
  def msg_hash
    {
      rows:  "Enter number of maximum guesses (typical is 12): ",
      mode:  "Please choose player mode (1: MAKER, 2: BREAKER): ",
      code:  "Enter a valid code (e.g. 'b b y c' or 'blue blue yellow cyan'): ",
      guess: "Enter a valid guess (e.g. 'b' or 'blue'): ",
      win:   "Congratulations, you win!",
      lose:  "Sorry, you lose. Better luck next time!",
      again: "Would you like to play again? (y or n): ",
      bye:   "Thanks for playing! Goodbye."
    }
  end

  def color_hash
    {
      r: :red,
      b: :blue,
      g: :green,
      y: :yellow,
      c: :cyan,
      p: :pink
    }
  end

  def peg_hash
    {
      empty: "\u25ef",
      red: "\u2b24".red,
      blue:  "\u2b24".blue,
      green: "\u2b24".green,
      yellow: "\u2b24".yellow,
      cyan: "\u2b24".cyan,
      pink: "\u2b24".pink
    }
  end

  def key_hash
    {
      empty: "\u25cb",
      used: "\u25cc",
      red: "\u25cf".red,
      white: "\u25cf".white
    }
  end
  
  def input_number_in_range(msg, range)
    print msg
    number = gets.chomp.to_i
    until range.include?(number)
      puts "Number must be between #{range.first} & #{range.last}, inclusive."
      print msg
      number = gets.chomp.to_i
    end
    number
  end
  
  def yes_no(msg)
    print msg
    ans = gets.chomp[0]
    ans.downcase!
    
    until %w(y n).include? ans
      puts "Please enter 'y' or 'n'."
      print msg
      ans = gets.chomp[0]
      ans.downcase!
    end
    ans
  end

  def input_code(msg)
    print msg
    code = gets.chomp.split(' ')
               .filter { |color| color.match?(/^r|^y|^b|^g|^c|^p/) }
    until code.length == 4
      puts "Code must be 4 words or letters separated by spaces.".red
      puts "E.g. 'blue red red green' or 'b r r g'"
      puts "Available colors are: red, green, blue, yellow, cyan and pink."
      print msg
      code = gets.chomp.split(' ')
               .filter { |color| color.match?(/^r|^y|^b|^g|^c|^p/) }
    end
    code.map { |color| color_hash[color.to_sym] }
  end

  def input_guess(msg)
    print msg
    guess = gets.chomp[0]
    guess.downcase!
    until guess.match?(/^r|^y|^b|^g|^c|^p/)
      puts "Guesses should be a valid color or letter.".red
      puts "E.g. 'blue', 'yellow', or 'y'."
      puts "Available colors are: red, green, blue, yellow, cyan and pink."
      print msg
      guess = gets.chomp[0]
      guess.downcase!
    end
    color_hash[guess.to_sym]
  end
  
  def introduce
    <<~HEREDOC
      #{'Welcome to Mastermind!'.bold.underline.italic}
      Wiki guide: https://en.wikipedia.org/wiki/Mastermind_(board_game)

      Summary: Mastermind or Master Mind is a code-breaking game for two players.
        - The code #{'MAKER'.red.bold}
        - The code #{'BREAKER'.blue.bold}

      The code #{'MAKER'.red.bold} will sets the code contains 4 color in the following color:
        - #{"Red".red}(#{peg_hash[:red]} ), #{"Yellow".yellow}(#{peg_hash[:yellow]} ), #{"Blue".blue}(#{peg_hash[:blue]} ), #{"Green".green}(#{peg_hash[:green]} ), #{"Cyan".cyan}(#{peg_hash[:cyan]} ), #{"Pink".pink}(#{peg_hash[:pink]} )
      
      The code #{'BREAKER'.blue.bold} attempts to guess the code in the number of turns 
      specified when starting a game. After each guess, four #{'keys'.bold} will be updated 
      to provide hints. A #{'white'.bold.white} key indicates the guess contains a correct
      color in the wrong position, while a #{'red'.bold.red} means a correct color AND position.

      #{'NOTE'.bold} that these keys appear in #{'no particular order'.bold}, so the breaker won't 
      explicitly know WHICH colors have been guessed correctly via the keys alone.

      Below is a sample game:

      #{'Code:'.bold.underline}
      #{GameBoard.new(rows: 1, board: [{ guess: %i(red pink pink blue), 
                                         keys: %i(empty empty empty empty) }])}

      #{'Gameplay:'.bold.underline}
      #{GameBoard.new(rows: 5, board: [{ guess: %i(red red blue blue), 
                                         keys: %i(used red used red) }, 
                                       { guess: %i(red red green green), 
                                         keys: %i(used red used used) }, 
                                       { guess: %i(red yellow blue yellow), 
                                         keys: %i(red used white used) }, 
                                       { guess: %i(red pink pink blue), 
                                         keys: %i(red red red red) }, 
                                       { guess: %i(empty empty empty empty), 
                                         keys: %i(empty empty empty empty) }])}

      This program has two game modes:
        - 1: Play as the code #{'MAKER'.red.bold}, and try to fool the computer's algorithm!
        - 2: Play as the code #{'BREAKER'.blue.bold}, and try to guess a randomly generated code.
             (Note, the algorithm will likely win in 5 turns on average)
      Explain for algorithm: https://github.com/nattydredd/Mastermind-Five-Guess-Algorithm

    HEREDOC
  end
end

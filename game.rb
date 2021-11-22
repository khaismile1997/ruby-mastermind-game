require_relative 'input.rb'
require_relative 'display.rb'

class Game
  include Input
  include Display

  attr_reader :rows, :code, :game_board, :game_mode, :maker, :breaker
  attr_accessor :turn

  def initialize
    clear_screen
    puts introduce
  end

  def play_game
    playing = true
    while playing
      new_game
      playing = play_again?
    end
    puts msg_hash[:bye]
  end

  private
  def new_game
    game_setup
    @game_board = GameBoard.new(code: code, rows: rows)
    self.turn = -1
    next_turn until game_over
    clear_stdin
    breaker.show_msg_final(game_over)
    puts "Code:".bold
    code_board = GameBoard.new(rows: 1, board: GameBoard.create_row(guess: code))
    puts code_board
  end

  def game_setup
    @game_mode = input_number_in_range(msg_hash[:mode], (1..2).to_a)
    @rows = input_number_in_range(msg_hash[:rows], (1..12).to_a)

    if game_mode.eql? 1
      @maker = Human.new
      @breaker = Computer.new
    else
      @maker = Computer.new
      @breaker = Human.new
    end
    
    @code = maker.set_code
    clear_screen
  end

  def next_turn
    self.turn += 1
    clear_screen
    waiting_for_guesses
    game_board.update_keys(row: turn)
    puts game_board
  end

  def waiting_for_guesses
    4.times do |i|  
      puts game_board
      puts "Waiting for computer's thoughts..." if breaker.name == 'Computer'
      game_board.add_guess(row: turn, col: i, guess: breaker.set_guess(game_board))
      clear_screen
    end
  end
  
  def play_again?
    yes_no(msg_hash[:again]) == 'y'
  end
  
  def game_over
    return "loser" if rows == turn + 1 && game_board.keys_place(turn).uniq != [:red]
    return "winner" if game_board.keys_place(turn).uniq == [:red]

    false
  end

  def clear_stdin
    $stdin.getc while $stdin.ready?
  end
end

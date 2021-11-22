require_relative 'display.rb'

class GameBoard
  include Display

  attr_reader :rows, :code, :board

  def initialize(code: Array.new(4, :red), rows: 12, board: empty_board(rows))
    @rows = rows
    @code = code
    @board = board
  end

  def add_guess(row:, col:, guess:)
    board[row][:guess][col] = guess
  end

  def update_keys(row:)
    keys = Array.new

    tmp_guess = board[row][:guess].clone
    tmp_code = code.clone

    # duyệt flag_red trước và set nếu có thì remove value của code và guess
    # sau đó mới duyệt tiếp guess tìm flag white
    tmp_guess.each_with_index do |color, i|
      next unless tmp_code[i] == color
      keys.push(:red)
      tmp_code[i] = :empty
      tmp_guess[i] = :found
    end

    tmp_guess.each do |color|
      next unless tmp_code.include? color
      keys.push(:white)
      tmp_code[tmp_code.index(color)] = :empty
    end

    keys += Array.new(4 - keys.length, :used) if keys.length != 4
    board[row][:keys] = keys.shuffle
  end

  def keys_place(row)
    board[row][:keys]
  end

  def to_s 
    game_rows = board
                .map { |obj| draw_row(obj[:guess], obj[:keys]) }
                .join("\n" + middle_row + "\n")
    top_row + "\n" + game_rows + "\n" + bottom_row
  end
  
  def self.create_row(guess: Array.new(4, :empty), keys: Array.new(4, :empty))
    [{ guess: guess, keys: keys}]
  end
  
  private

  def empty_board(rows)
    Array.new(rows) { GameBoard.create_row.first }
  end
end

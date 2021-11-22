require_relative 'input.rb'

class Human
  include Input

  attr_reader :name
  def initialize
    @name = "Human"
  end

  def set_code
    input_code(msg_hash[:code])
  end

  def set_guess(_game_board)
    input_guess(msg_hash[:guess])
  end
  
  def show_msg_final(status)
    puts status == "winner" ? msg_hash[:win] : msg_hash[:lose]
  end
end

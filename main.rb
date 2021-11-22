require 'colorize'
require 'io/wait'
require_relative 'game.rb'
require_relative 'game_board.rb'
require_relative 'human.rb'
require_relative 'computer.rb'

start_game = Game.new.play_game

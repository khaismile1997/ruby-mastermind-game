require "active_support/all"

class Computer
  include Input

  attr_reader :colors, :all_guesses, :name
  attr_accessor :guess, :s, :turn, :index

  def initialize
    @name = "Computer"
    @colors = %i(red blue green yellow cyan magenta)
    @all_guesses = colors.repeated_permutation(4).to_a
    @s = all_guesses.clone
    @turn = 0
    @guess = %i(red red blue blue)
  end
  
  def set_code
    (1..4).map{colors.sample}
  end
  
  def set_guess(game_board)
    update_turn(game_board)
    update_index(game_board)
    update_guess(game_board)
    all_guesses.delete(guess)

    sleep 0.25
    guess[index]
  end
  
  def show_msg_final(status)
    puts status == "winner" ? msg_hash[:lose] : msg_hash[:win]
  end

  private

  def update_turn(game_board)
    self.turn += 1 until game_board.board[turn][:keys].include? :empty
  end

  def update_index(game_board)
    self.index = 4 - game_board.board[turn][:guess].count(:empty)
  end
  
  def update_guess(game_board)
    return if turn.zero? || !index.zero? # index != 0 because handle guess before that
    previous_keys = game_board.board[turn-1][:keys]
    flag_red = previous_keys.count(:red)
    flag_white = previous_keys.count(:white)

    if (flag_red + flag_white).zero?
      no_keys_update_s
    else
      keys_update_s(reds: flag_red, whites: flag_white)
    end
    
    results = minimax
    choose_guess(results)
  end

  def no_keys_update_s
    s.delete_if {|arr| !(arr & guess).empty?}
    all_guesses.delete_if {|arr| !(arr & guess).empty?}
  end
  
  def keys_update_s(reds:, whites:)
    total_flag = reds + whites
    # loop all guess và giả sử nó như là code rồi so sánh => giữ lại những guess tiềm năng:
    # 1. trường hợp chung => code phải chứa colors trong guess trước và số phần tử chứa phải bằng số white+red flag
    # 2. trường hợp có red flag => code phải chứa các color và đúng vị trí so với guess trước và số phần tử phải bằng số red flag
    s.keep_if {|code_suppose| common(code_suppose, guess) == total_flag && exact(code_suppose, guess) == reds}
  end
  
  def common(code_suppose, gs)
    (code_suppose & gs).flat_map { |n| [n] * [code_suppose.count(n), gs.count(n)].min }.length
  end
  
  def exact(code_suppose, gs)
    # giữ lại những guess trong s có các element trùng cả index và value với guess trước(red keys)
    count = 0
    code_suppose.each_with_index {|color, i| count+=1 if color == gs[i]}
    count
  end

  def possible_keys
    # lấy ra tất cả các trường hợp có thể xảy ra từ các flag white/red
    # mỗi phần tử là 1 mảng có dạng [total_flag, red_flag]
    arr = [0,1,2,3,4]
    arr.repeated_permutation(2).filter{|e| e[0] <= e[1]}
  end
  
  def minimax
    results = {}   
    all_guesses.each_with_index do |gs, i|
      next if i.even? && (i % 3).zero? && (i % 4).zero? && i.positive? && turn < 3
      results[i] = possible_keys.map do |keys|
        hit_count(gs, keys[0], keys[1])
      end.max
    end

    results.to_a
  end

  def hit_count(gs, total_flag, red_flag)
    s.filter do |code_suppose| 
      common(code_suppose, gs) == total_flag && exact(code_suppose, gs) != red_flag
    end.length
  end
  
  def choose_guess(results)
    results.sort_by! { |i, score| [score, i] } # sort lại results tắng dần
    min_score = results[0][1] # lấy thằng rs đầu tiên (score thấp nhất)
    min_set = results.filter { |rs| rs[1] == min_score } # lọc ra những thằng rs có score == min_score
    # lọc ra những thằng trong min_set với điều kiện thằng guess với index trong min_set phải có trong s
    min_set_in_s = min_set.filter { |arr| s.include? all_guesses[arr[0]] }
    # ưu tiên lấy guess với index của thằng đầu tiên nằm trong min_set của s nếu s not empty
    
    self.guess = if min_set_in_s.empty?
                   all_guesses[min_set[0][0]]
                 else
                   all_guesses[min_set_in_s[0][0]]
                 end
  end
end

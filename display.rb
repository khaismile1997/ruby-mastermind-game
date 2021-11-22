module Display
  TOP_LEFT = "\u2554"
  TOP_RIGHT = "\u2557"
  BOTTOM_LEFT = "\u255a"
  BOTTOM_RIGHT = "\u255d"
  HOR = "\u2550"
  VER = "\u2551"
  T_DOWN = "\u2566"
  T_UP = "\u2569"
  T_RIGHT = "\u2560"
  T_LEFT = "\u2563"
  T_ALL = "\u256c"

  def top_row
    TOP_LEFT + HOR * 13 + T_DOWN + HOR * 9 + TOP_RIGHT
  end

  def middle_row
    T_RIGHT + HOR * 13 + T_ALL + HOR * 9 + T_LEFT
  end

  def bottom_row
    BOTTOM_LEFT + HOR * 13 + T_UP + HOR * 9 + BOTTOM_RIGHT
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

  def draw_row(arr_peg, arr_key)
    arr_peg = arr_peg.map { |peg| peg_hash[peg] }
    arr_key = arr_key.map { |key| key_hash[key] }
    VER + ' ' + arr_peg.join('  ') + '  ' + VER + ' ' + arr_key.join(' ') + ' ' + VER
  end

  def clear_screen
    system('clear') || system('cls')
  end
end

require 'io/console'
require 'colorize'
require_relative 'board.rb'
require_relative 'empty_square.rb'
require 'byebug'

class Display
  WASD_DIFFS = {
    'a' => [0, -1],
    's' => [1, 0],
    'd' => [0, 1],
    'w' => [-1, 0],
    "\r" => [0, 0]
  }

  attr_reader :board, :debug_mode
  attr_accessor :cursor

  def initialize(board)
    @board = board
    @cursor = [0,0]
    @debug_mode = true
    #debugger
  end

  def get_move
      move_cursor
      cursor
  end

  def render
    chars_to_render = board.render
    chars_to_render.each_with_index do |row, row_index|
      row.each_with_index do |string, col_index|
        render_square(string, [row_index, col_index])
      end
      puts ""
    end
    debug_mode_print if debug_mode
  end

  def move_cursor
    loop do
      system('clear')
      render
      input = $stdin.getch
      next unless valid_input?(input)
      delta = WASD_DIFFS[input]
      break if delta == [0,0]
      self.cursor = add_coordinates(cursor, delta)
    end
  end

  def valid_input?(input)
    WASD_DIFFS.keys.include?(input)
  end

  def add_coordinates(x, y)
    [x.first + y.first, x.last + y.last]
  end

  def render_square(string, position)
    if position == cursor
      print string.colorize(:background => :yellow)
    elsif alternated_color?(position)
      print string.colorize(:background => :light_blue)
    else
      print string.colorize(:background => :red)
    end
  end

  def alternated_color?(position)
    row, col = position
    alternate = false

    if row % 2 == 0
      alternate = true
    end

    if col % 2 == 0
      alternate = alternate ? false : true
    end
    alternate
  end

  def debug_mode_print
    puts "Cursor: #{cursor.inspect}"
  end
end


if __FILE__ == $PROGRAM_NAME
  board = Board.new
  display = Display.new(board)
  display.get_move
end
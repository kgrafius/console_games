require 'colorize'
require_relative 'game_renderer'
module Games
  module Renderers
    class MinesweeperRendererAscii < GameRenderer

      def render
        # clear
        header
        status
        puts
        minefield
        puts
        prompt
      end

      def minefield
        # draw a simple header
        print "y".ljust(20)
        (0...cols).step { |c| print " #{c}".ljust(4) }
        puts
        puts 'x'
        puts

        # draw the current state of each row
        board_grid.each_with_index do |r, i|
          print i.to_s.ljust(20)
          r.each { |c| print format_cell(c) }
          puts ''
        end
      end

      def format_cell(cell)
        str = " #{cell.display_value} ".ljust(4).black.on_white
        if cell.visited?
          case cell.live_neighbors
          when 0
            str = str.white.on_black
          when 1
            str = str.light_blue.on_black
          when 2
            str = str.green.on_black
          else
            str = str.red.on_black
          end
        end
        str = str.white.on_blue if cell.flagged?
        str
      end

      def header
        puts <<-HEADER
    Game Rules:
    To win, all non-mine cells must be uncovered and all mine cells must be flagged. Opening a live cell 
    containing a mine immediately terminates the game. An uncovered cell containing a number indicate the 
    number of adjacent cells containing a mine.
    Commands:
      open x y - opens a cell, if the cell does not contain a mine, then all surrounding empty cells are opened   
      flag x y - flags a cell as containing a mine

        HEADER
      end

      def status
        puts "(#{unvisited_count}) unvisited cells and (#{mine_count}) mines.".yellow
      end

      def prompt
        print "(open|flag) x y >".green
      end
    end
  end
end
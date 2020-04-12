require_relative 'minesweeper_renderer_ascii'
require 'tty-table'
require 'pastel'
module Games
  module Renderers
    class MinesweeperRendererUnicode < MinesweeperRendererAscii

      def minefield
        table = TTY::Table.new board_values
        puts table.render(:unicode, padding: [0, 1, 0, 1]) { |r| r.border.separator = :each_row }
      end

      def board_values
        board_grid.map { |r| r.map { |c| format_cell(c) } }
      end

      def format_cell(cell)
        pastel = Pastel.new
        str = pastel.bold(cell.display_value)
        if cell.visited?
          case cell.live_neighbors
          when 0
            str = pastel.white.on_black(str)
          when 1
            str = pastel.bright_blue.on_black(str)
          when 2
            str = pastel.green.on_black(str)
          else
            str = pastel.red.on_black(str)
          end
        end
        str = pastel.white.on_blue(str) if cell.flagged?
        str
      end
    end
  end
end
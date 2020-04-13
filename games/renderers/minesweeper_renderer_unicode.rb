require_relative 'minesweeper_renderer_ascii'
require 'tty-table'
require 'pastel'
module Games
  module Renderers
    class MinesweeperRendererUnicode < MinesweeperRendererAscii

      def pastel
        @pastel ||= Pastel.new
      end

      def minefield
        table = TTY::Table.new(header: (0...cols).to_a.map{|c| pastel.yellow(c.to_s)}.unshift(''),
                               rows: board_values)
        puts table.render(:unicode, padding: [0, 1, 0, 1]) { |r| r.border.separator = :each_row }
      end

      def board_values
        bg = board_grid.map { |r| r.map { |c| format_cell(c) } }
        bg.each_with_index.map { |r, i| r.unshift(pastel.yellow(i.to_s)) }
      end

      def format_cell(cell)
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
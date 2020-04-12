require_relative '../banners'
require_relative 'board/board_game'
require_relative 'board/mine_cell'
require_relative 'renderers/minesweeper_renderer_unicode'


module Games
  class Minesweeper < BoardGame
    include Banners
    attr_reader :mine_count

    def initialize(**params)
      super(**{renderer_class: ::Games::Renderers::MinesweeperRendererAscii,
               cell_class: MineCell}.merge(params))
    end

    def play
      say "Welcome to Minesweeper"
      puts minesweeper_welcome
      renderer.render
      loop do
        input = STDIN.gets.chomp
        command, x, y = input.split /\s/
        case command.downcase
        when 'open', 'o'
          c = cell(x, y)
          unless mines_planted?
            # This will ensure that the first move will never land on a mine
            plant_mines(difficulty: params[:difficulty].to_f,
                        safe_x: x,
                        safe_y: y)
            calc_live_neighbors
          end

          if c.live
            puts "Position (#{x}, #{y}) was a live mine!"
            say "Game Over"
            puts game_over
            return
          else
            c.visit
            clear_adjacent_cells(x, y)
            puts(winner) && return if won?
          end
        when 'flag', 'f'
          cell(x, y).flag
        when 'quit', 'q'
          return
        else
          puts 'Invalid command'
        end
        refresh
      end
    end

    def won?
      mine_count >= unvisited_count
    end

    def unvisited_count
      board_grid.map { |r| r.map { |c| c.unvisited? ? 1 : 0 }.sum }.sum
    end

    private

    def mines_planted?
      board_grid.any? { |r| r.any? { |c| c.live? } }
    end

    def plant_mines(difficulty:,
                    safe_x: nil,
                    safe_y: nil)
      safe_x = Array(safe_x)
      safe_y = Array(safe_y)
      @mine_count = (rows * cols * difficulty).to_i
      planted = 0
      while planted < mine_count
        x = rand(0...rows)
        y = rand(0...cols)
        unless safe_x.include?(x) && safe_y.include?(y)
          cell(x, y).live = true
          planted += 1
        end
      end
    end

    def calc_live_neighbors
      board_grid.each_with_index do |r, r_idx|
        r.each_with_index do |cell, c_idx|
          live_neighbor_count = 0
          ([0, r_idx - 1].max..[r_idx + 1, rows - 1].min).each do |x|
            ([0, c_idx - 1].max..[c_idx + 1, cols - 1].min).each do |y|
              live_neighbor_count += 1 if cell(x, y).live
            end
            cell.live_neighbors = live_neighbor_count
          end
        end
      end
    end

    def clear_adjacent_cells(start_x, start_y)
      start_x = start_x.to_i
      start_y = start_y.to_i
      ([0, start_x - 1].max..[start_x + 1, rows - 1].min).each do |x|
        ([0, start_y - 1].max..[start_y + 1, cols - 1].min).each do |y|
          c = cell(x, y)
          if !c.live? && !c.visited?
            c.visit
            clear_adjacent_cells(x, y) unless c.live_neighbors > 0
          end
        end
      end
    end
  end
end
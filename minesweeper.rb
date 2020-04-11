# frozen_string_literal: true

require_relative 'banners.rb'
require_relative 'board_game.rb'
require_relative 'mine_cell.rb'
require_relative 'minesweeper_renderer.rb'
class Minesweeper < BoardGame
  include Banners
  attr_reader :mine_count

  def initialize(**params)
    super(**params.merge(cell_class: MineCell))
  end

  def init_game
    plant_mines(params[:difficulty].to_f)
    calc_live_neighbors
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

  def plant_mines(difficulty)
    @mine_count = (rows * cols * difficulty).to_i
    (0...mine_count).step do |_mc|
      cell(rand(0...rows), rand(0...cols)).live = true
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

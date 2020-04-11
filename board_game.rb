require_relative 'minesweeper_renderer.rb'
require 'forwardable'
class BoardGame
  extend Forwardable
  attr_reader :board_grid, :rows, :cols, :renderer, :params
  def_delegators :@renderer, :start, :render, :refresh

  def initialize(rows: 10,
                 cols: 10,
                 cell_class: Cell,
                 renderer_class: ::MinesweeperRenderer,
                 **params)
    @rows = rows
    @cols = cols
    @board_grid = Array.new(rows) { Array.new(cols) { cell_class.new } }
    @renderer = renderer_class.new(game: self)
    @params = params
    init_game
  end

  def init_game;  end

  def play
    raise 'You must implement the play method!'
  end

  def won?
    false
  end

  def cell(x, y)
    board_grid[x.to_i][y.to_i]
  end

  def say(what)
    # added just for fun - OSX Only
    return unless (/darwin/ =~ RUBY_PLATFORM) != nil
    `say "#{what}"`
  end
end
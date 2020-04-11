require_relative 'cell.rb'
class MineCell < Cell
  attr_accessor :live, :state, :live_neighbors

  %i{unvisited visited flagged}.each do |state|
    self.const_set(state.upcase, state)
  end

  def initialize(live: false, state: UNVISITED)
    @live = live
    @live_neighbors = 0
    @state = state
  end

  def display_value
    return 'F' if state == FLAGGED
    return live_neighbors > 0 ? live_neighbors.to_s : '-' if state == VISITED
    '?'
  end

  def flag
    self.state = FLAGGED
  end

  def visit
    self.state = VISITED
  end

  def visited?
    state == VISITED
  end

  def unvisited?
    state == UNVISITED
  end

  def flagged?
    state == FLAGGED
  end

  def live?
    live
  end
end
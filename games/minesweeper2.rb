require_relative 'minesweeper'
require_relative 'renderers/minesweeper_renderer_unicode'
module Games
  class Minesweeper2 < Minesweeper
    def initialize(**params)
      super(**params.merge(renderer_class: ::Games::Renderers::MinesweeperRendererUnicode))
    end
  end
end

require_relative 'minesweeper.rb'
require 'arg-parser'

class ConsoleGame
  include ArgParser::DSL

  purpose <<-EOT
        === ConsoleGame ===
        by Kurt Grafius
        Load and run a console game
        Default game is the classic 60's single player Minesweeper game.
  EOT

  keyword_arg :game, 'Name of game to play', default: 'Minesweeper'
  keyword_arg :rows, 'rows', default: 10
  keyword_arg :cols, 'cols', default: 10
  keyword_arg :difficulty, 'cols', default: 0.1

  def run
    if opts = parse_arguments
      @game = Object.const_get(opts.game).new(rows: opts.rows.to_i,
                                        cols: opts.cols.to_i,
                                        difficulty: opts.difficulty.to_f)
      @game.play
    else
      # False is returned if argument parsing was not completed
      # This may be due to an error or because the help command
      # was used (by specifying --help or /?). The #show_help?
      # method returns true if help was requested, otherwise if
      # a parse error was encountered, #show_usage? is true and
      # parse errors are in #parse_errors
      show_help? ? show_help : show_usage
    end
  end
end

ConsoleGame.new.run

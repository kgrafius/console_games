require 'arg-parser'
require 'tty-prompt'

GAME_DIR = './games'.freeze
Dir.glob("#{GAME_DIR}/*.rb").each do |f|
  require_relative "games/#{File.basename(f, ".rb")}"
end

class ConsoleGames
  include ArgParser::DSL

  purpose <<-EOT
        === ConsoleGame ===
        by Kurt Grafius
        Load and run from a list of console games
  EOT

  keyword_arg :rows, 'rows', default: 10
  keyword_arg :cols, 'cols', default: 10
  keyword_arg :difficulty, 'cols', default: 0.1

  def run
    if opts = parse_arguments

      prompt = TTY::Prompt.new
      game = prompt.select("Choose game to play?") do |menu|
        Dir.glob("#{GAME_DIR}/*.rb").each do |f|
          menu.choice File.basename(f, ".rb").titleize
        end
      end

      @game = Object.const_get("Games::#{game}").new(rows: opts.rows.to_i,
                                                     cols: opts.cols.to_i,
                                                     difficulty: opts.difficulty.to_f)
      @game.play
    else
      show_help? ? show_help : show_usage
    end
  end
end

ConsoleGames.new.run

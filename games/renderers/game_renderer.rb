require 'draper'
module Games
  module Renderers
    class GameRenderer < Draper::Decorator
      delegate_all

      def refresh
        clear
        render
      end

      def render
      end

      def clear
        system "clear" #|| system "cls"
      end
    end
  end
end
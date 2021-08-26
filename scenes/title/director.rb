module Title
  class Director < DirectorBase
    def initialize
      @bg = Image.load('images/bg_title.png')
      @bgm = Sound.new("sounds/opening.mid") #タイトルBGM選曲
      #@deci = Sound.new("sounds/decision.wav") #決定音選曲
    end

    def reload
      @bgm.play #タイトルBGMを流す
    end
  
    def play
      if Input.key_push?(K_SPACE)
          @bgm.stop #スペースキー入力でタイトル曲ストップ
          Scene.move_to(:game)
          #@deci.play
      end
      Window.draw(0, 0, @bg)
      draw_font_center(140, "G.G.O.D", 72, color: C_RED)
      draw_font_center(210, "選ばれし神", 38, color: C_RED)
      draw_font_center(550, "Push SPACE key to start", 38, color: C_BLUE)
    end
  end
end

module Title
  class Director < DirectorBase
    def initialize
      @bg = Image.load('images/bg_title.png')
      @bgm = Sound.new("sounds/opening.mid") #タイトルBGM選曲
    end

    def reload
      @bgm.play #タイトルBGMを流す
    end
  
    def play
      if Input.key_push?(K_SPACE)
          @bgm.stop #スペースキー入力でタイトル曲ストップ       
          Scene.move_to(:game)
      end
      Window.draw(0, 0, @bg)
      
      draw_font_center(550, "Push SPACE key to start", 38, color: C_BLUE)
    end
  end
end

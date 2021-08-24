module Title
  class Director < DirectorBase
    def initialize
      @bg = Image.load('images/bg_title.png')
    end

    def reload
    end
  
    def play
      Scene.move_to(:game) if Input.key_push?(K_SPACE)
      Window.draw(0, 0, @bg)
      draw_font_center(140, "G.G.O.D", 72, color: C_RED)
      draw_font_center(210, "サブタイトルを入力してください", 38, color: C_RED)
      draw_font_center(550, "Push SPACE key to start", 38, color: C_BLUE)
    end
  end
end

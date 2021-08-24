class DirectorBase
	@@font_set = {}

  # Sceneクラスから、move_toによるシーン切り替え時に自動的に呼び出されるメソッド
  def reload
    raise "継承先で必ずオーバーライドしてください。"
  end

  # 1フレーム分の描画処理
  def play
    raise "継承先で必ずオーバーライドしてください。"
  end

	private

	def draw_font_center(y, text, font_size, opt = {})
    font = get_font(font_size)
    text_width = font.get_width(text)
    x = (Window.width - text_width) / 2
    Window.draw_font(x, y, text, font, opt)
  end

	def get_font(size)
    if !@@font_set[size]
      @@font_set[size] = Font.new(size)
    end
    @@font_set[size]
  end
end
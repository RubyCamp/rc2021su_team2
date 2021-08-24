module Win
	class Director < DirectorBase
		attr_accessor :winner

		def initialize
			@bg = Image.load('images/bg_win.png')
			self.winner = nil
		end

		def reload
		end

		def play
			Scene.move_to(:title) if Input.key_push?(K_SPACE)
			Window.draw(0, 0, @bg)
			if self.winner
				draw_font_center(350, "P#{self.winner} Win!", 72, color: C_GREEN)
			else
				draw_font_center(350, "Even", 72, color: C_RED)
			end
		end
	end
end

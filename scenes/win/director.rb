module Win
	class Director < DirectorBase
		attr_accessor :winner

		def initialize
			@bg = Image.load('images/bg_win.png')
			@bgm = Sound.new("sounds/you_win.wav")
			self.winner = nil
		end

		def reload
			@bgm.play
		end

		def play
			Scene.move_to(:title) if Input.key_push?(K_SPACE)
			Window.draw(0, 0, @bg)	
		end
	end
end

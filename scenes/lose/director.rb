module Lose
	class Director < DirectorBase
		attr_accessor :loser

		def initialize
			@bg = Image.load('images/bg_lose.png')
      @bgm = Sound.new("sounds/you_lose.wav")
			self.loser = nil
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

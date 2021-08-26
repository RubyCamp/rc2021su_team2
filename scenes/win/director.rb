module Win
	class Director < DirectorBase
		attr_accessor :winner

		def initialize
		  @bg = Image.load('images/bg_win.png')
		  @bgm = Sound.new("sounds/you_win.wav")
		  @bgm.set_volume( 255, time=0 )
		  self.winner = nil
		end

		def reload
		  @bgm.play
		end

		def play
		  Scene.move_to(:title) if Input.key_push?(K_SPACE)
		  Window.draw(0, 0, @bg)
		  Scene.move_to(:title) if Input.key_push?(K_SPACE)#追加
		
		end
	end
end

module Lose
	class Director < DirectorBase
		attr_accessor :loser

		def initialize
		  @bg = Image.load('images/bg_lose.png')
    	  @bgm = Sound.new("sounds/you_lose.wav")
     	  @bgm.set_volume( 255, time=0 )
		  self.loser = nil
		end

		def reload
          @bgm.play
		end

		def play
		  Scene.move_to(:title) if Input.key_push?(K_SPACE)
		  Window.draw(0, 0, @bg)
		  Scene.move_to(:title) if Input.key_push?(K_SPACE) 


		end
	end
end

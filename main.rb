require 'dxruby'
require 'singleton'

require_relative 'libs/director_base'
require_relative 'libs/card'
require_relative 'libs/pointer'

require_relative 'scene'
require_relative 'scenes/game/director'
require_relative 'scenes/title/director'
require_relative 'scenes/win/director'

Window.width = 1024
Window.height = 728
Window.caption = "G.G.O.D"

Scene.add(Game::Director.new, :game)
Scene.add(Win::Director.new, :win)
Scene.add(Title::Director.new, :title)
Scene.move_to(:title)

Window.loop do
  break if Input.key_push?(K_ESCAPE)
  Scene.play
end

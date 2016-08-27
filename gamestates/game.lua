game = {}

player = require 'player'

function game:keypressed(key, code)
  if key == "escape" then love.event.quit()
  else print(key) end
end

function game:enter()

end

function game:update(dt)

end

function game:draw()
  love.graphics.scale(windowScale, windowScale)
  love.graphics.printf("welcome to game", 0, 0, 1000)
end

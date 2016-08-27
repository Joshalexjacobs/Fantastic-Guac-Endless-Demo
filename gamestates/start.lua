-- start.lua --

require 'levels/levelsDictionary'

menu = {} -- previously: Gamestate.new()

dictionary = {}

function menu:enter()
  dictionary = getDictionary()

  -- other
  loadController()
  love.window.setMode(windowWidth, windowHeight, {fullscreen=false, vsync=true})
end

function menu:update()
  -- empty for now
end

function menu:draw()
    love.graphics.printf("Press Space", 10, 0, 100)
end

function menu:keypressed(key, code)
    if key == 'space' then
        Gamestate.switch(game, dictionary[1].name) -- switch to game and send select level name
    elseif key =='escape' then love.event.quit() end -- if player hits esc then quit
end

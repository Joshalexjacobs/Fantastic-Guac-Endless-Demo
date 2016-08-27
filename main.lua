-- needed libraries
Gamestate = require 'lib/gamestate'
anim8 = require 'lib/anim8'
require 'lib/timer'

require 'gamestates/start'
require 'gamestates/game'

-- Global Functions --
function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

windowWidth, windowHeight, windowScale = 1280, 720, 4

function love.load(arg)
  math.randomseed(os.time())
  love.graphics.setDefaultFilter("nearest", "nearest")

  love.window.setMode(windowWidth, windowHeight, {fullscreen=false, vsync=true})

  Gamestate.registerEvents()
  Gamestate.switch(start)
end

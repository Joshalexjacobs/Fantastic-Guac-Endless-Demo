-- game.lua --

-- Includes: --

anim8 = require 'other/anim8' -- this should be local in the future
local sti = require "sti"

require 'enemies/enemyDictionary'
require 'enemies/enemies'

require 'other/controller'
require 'other/timer'

require 'levels/levelsDictionary'
require 'bullets'
require 'bubble'

local bump   = require 'collision/bump'
local math   = require "math"

local Camera = require "humpCamera"

player = require 'player'

require 'levels/zones'
require 'levels/levels'

local world = bump.newWorld() -- create a world with bump

game = {}

-- Globals: --
endLevel = false

gameTimer = {
  time = 0,
  lastEvent = 0
}

-- Camera boundaries
local bounds = {
  levelWidth   = 5000,
  levelHeight  = windowHeight, -- windowHeight at minimum
  left = 0,
  top = 0
}

local gui = {
  livesX = 5,
  livesY = 5,
  livesPadding = 18, -- 15
  livesSprite = "img/other/lives.png",
  livesSpriteSheet = nil,
  livesGrid = nil,
  livesAnimations = nil,
  livesCurAnim = 1,
}

local leftWall = {
  name = "leftWall",
  type = "pBlock",
  filter = function(item, other)
    if other.type == "player" then
      return 'slide'
    end
  end,
  x = 0,
  y = 0,
  h = 200,
  w = 10
}

local fade = {
  x = 0,
  y = 0,
  w = 384,
  h = 216, -- 180
  speed = 180,
  transparency = 255,
  volume = 0,
  fadeIn = function(dt, fade, music)
    if fade.transparency > 0 then
      fade.transparency = fade.transparency - fade.speed * dt
    end

    if fade.volume < 0.75 then
      fade.volume = fade.volume + 0.1 * dt
      music:setVolume(fade.volume)
    end
  end,
  fadeOut = function(dt, fade, music)
    if fade.transparency < 255 then
      fade.transparency = fade.transparency + fade.speed * dt
    end

    if fade.volume > 0 then
      fade.volume = fade.volume - 0.5 * dt
      music:setVolume(fade.volume)
    end
  end,
  draw = function(fade)
    setColor(0, 0, 0, fade.transparency)
    love.graphics.rectangle("fill", fade.x, fade.y, fade.w, fade.h)
    setColor(255, 255, 255, 255)
  end
}

-- Level specific functions
local levelFunctions = {}

--function game:enter(menu, levelName, res)
function game:enter(menu, levelName)
  tutMusic = love.audio.newSource("music/matrix.wav", stream)

  -- adjust window
  love.window.setMode(windowWidth, windowHeight, {fullscreen=false, vsync=true})

  -- seed math.random
  math.randomseed(os.time())
  love.graphics.setDefaultFilter("nearest", "nearest") -- set nearest pixel distance

  -- load level
  local pSkinV, pSkinH, tilemap, startPos = loadLevel(levelName, world, levelFunctions)

  -- load bullet and bubble
  loadBullet()
  loadBubbles()

  -- load tilemap
  map = sti(tilemap, {"bump"})

  map:bump_init(world)

  -- populate world collision (bump)
  for _, object in ipairs(map.objects) do
    if object.properties.collidable then
      world:add(object, object.x, object.y, object.width, object.height)
    end
  end

  world:add(leftWall, leftWall.x, leftWall.y, leftWall.w, leftWall.h)

  -- set level bounds
  bounds = level.bounds

  -- load player
  player.x = startPos -- set player starting position
  loadPlayer(world, pSkinV, pSkinH) -- load player and player sprites

  -- run level specific load
  if levelFunctions.load ~= nil then levelFunctions.load() end

  -- load gui
  gui.livesSpriteSheet = love.graphics.newImage(gui.livesSprite)
  gui.livesGrid = anim8.newGrid(16, 16, 32, 16, 0, 0, 0)
  gui.livesAnimations = {
    anim8.newAnimation(gui.livesGrid(1, 1), 0.1), -- 1 regular lives
    anim8.newAnimation(gui.livesGrid(2, 1), 0.1), -- 2 tutorial lives
  }

  -- load camera
  camera = Camera(math.floor( player.x + 20 + (193 * (windowScale - 1)) ), math.floor( 90 * windowScale ), 1, 0)
  camera.smoother = Camera.smooth.damped(3)
end

function game:timerEvents()
  if gameTimer.time >= 5 and gameTimer.lastEvent < 5 then
    addEnemy("cube", 200, 15, "right", world)
    gameTimer.lastEvent = 5
  elseif gameTimer.time >= 10 and gameTimer.lastEvent < 10 then
    addEnemy("cube", 100, 15, "right", world)
    addEnemy("cube", 300, 15, "right", world)
    gameTimer.lastEvent = 10
  elseif gameTimer.time >= 21 and gameTimer.lastEvent < 21 then
    addEnemy("cube", 100, 15, "right", world)
    addEnemy("cube", 200, 15, "right", world)
    addEnemy("cube", 300, 15, "right", world)
    gameTimer.lastEvent = 25
  elseif gameTimer.time >= 35 and gameTimer.lastEvent < 35 then
    addEnemy("cube", 100, 15, "right", world)
    addEnemy("cube", 200, 15, "right", world)
    addEnemy("cube", 300, 15, "right", world)
    gameTimer.lastEvent = 35
  elseif gameTimer.time >= 45 and gameTimer.lastEvent < 45 then
    addEnemy("cube", 150, 15, "right", world)
    addEnemy("cube", 200, 15, "right", world)
    addEnemy("cube", 250, 15, "right", world)
    addEnemy("cube", 300, 15, "right", world)
    gameTimer.lastEvent = 45
  end -- 60
end

function game:update(dt)
  gameTimer.time = gameTimer.time + dt
  game:timerEvents()
  --if tutMusic:isPlaying() == false then
    --love.audio.play(tutMusic)
  --end

  if endLevel == false then
    fade.fadeIn(dt, fade, tutMusic)
  elseif endLevel then
    fade.fadeOut(dt, fade, tutMusic)
  end

  -- if player wants to quit
  if love.keyboard.isDown('escape') or pressStart() then
    love.event.quit()
  end -- if player hits esc then quit

  -- update bounds
  local left, right = camera:position()
  bounds.left = left - ((216 * windowScale/1.2) - (20 * windowScale/1.2))

  leftWall.x = bounds.left
  world:move(leftWall, leftWall.x, leftWall.y, leftWall.filter)

  -- run level specific update
  if levelFunctions.update ~= nil then levelFunctions.update(dt) end

  -- update everything
  updatePlayer(dt, world)

  updateBullets(dt, bounds.left, 386, world)
  updateBubbles(dt, world)

  updateEnemies(dt, world)
  updateZones(player.x, player.w, bounds.left, world, dt)

  -- update gui
  -- gui.livesAnimations[gui.livesCurAnim]:update(dt)

  --camera:lockPosition(math.floor(player.x + 20 + (160 * (windowScale - 1))), math.floor(90 * windowScale))

  if player.lastDir == 1 then -- 193 is obtained by doing screenWidth (in pixels) / 2 = 193
    camera:lockX(math.floor(player.x + 20 + (193 * (windowScale / 1.2 - 1))) + 25 )
    camera:lockY(360)
  else
    camera:lockX(math.floor(player.x + 20 + (193 * (windowScale / 1.2 - 1))) - 25 )
    camera:lockY(360)
  end
end

function game:keyreleased(key, code)
  if key == 'n' and pressX() == false then
    player.jumpLock = false
  elseif key == 'm' or pressCircle() == false then
    player.shootLock = false
  end
end

function game:gamepadreleased( joystick, button )
  if button == 'a' then
    player.jumpLock = false
  elseif button == 'b' then
    player.shootLock = false
  end
end

function game:draw()
  love.graphics.setBackgroundColor(100, 100, 100)

  love.graphics.scale(windowScale / 1.2 , windowScale / 1.2)

  --[[ IF YOU DEACTIVATE CAMERA AND UNCOMMENT THESE LINES, THE TILED SEAM PROBLEM GOES AWAY ]]
  --local tx = math.floor(player.x - 90)
  --love.graphics.translate(-tx, 0)

  camera:attach()
    map:setDrawRange(math.floor(bounds.left), 0, 386, 216)
    map:draw()

    -- run level specific draw
    if levelFunctions.draw ~= nil then levelFunctions.draw() end

    drawPlayer()
    drawEnemies()
    drawBullets()
    drawBubbles()

    --drawZones()

    -- draw leftWall
    -- love.graphics.rectangle("line", leftWall.x, leftWall.y, leftWall.w, leftWall.h)
  camera:detach()

  -- draw gui
  setColor({255, 255, 255, 180}) -- set transparency

  for i = 0, player.lives - 1 do
    if i > 2 then break end
    gui.livesAnimations[gui.livesCurAnim]:draw(gui.livesSpriteSheet, gui.livesX + gui.livesPadding * i, gui.livesY, 0, 1, 1, 0, 0)
  end

  setColor({255, 255, 255, 255})

  love.graphics.print(tostring(love.timer.getFPS( )), 0.2, 0.2, 0, 0.35, 0.35) -- print fps in the top left corner of the screen

  local minute = math.floor(gameTimer.time / 59)
  local seconds = gameTimer.time % 59
  local displayTime = string.format("%02d:%02d", minute, seconds)

  love.graphics.print(displayTime, 190, 0.2, 0, 0.35, 0.35)

  -- draw fade
  fade.draw(fade)

end

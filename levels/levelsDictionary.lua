-- levelsDictionary.lua --

fairies = {}

local dictionary = {
    {
        name = "ancient computer",
        playerSkinV = "img/player/matrix playerBIG.png", -- vertical
        playerSkinH = "img/player/matrix proneBIG.png", -- horizontal
        tilemap = "tiled/at2.lua",
        startPos = 140, -- player's starting position
        bounds = { -- camera boundaries
          levelWidth = 1000, -- 8000
          levelHeight = 600,
          left = 0,
          top = 0
        },
        zones = {
          {
            name = "dynamic runners",
            x = 100,
            y = 45,
            w = 2000,
            h = 100,
            enemies = {
              --{name = "cube", count = 0, max = 1, side = "left", x = 200, y = 15, dynamic = false, spawnTimer = 0, spawnTimerMax = 2},
              --{name = "cube", count = 0, max = 1, side = "left", x = 300, y = 15, dynamic = false, spawnTimer = 0, spawnTimerMax = 2},
              --{name = "cube", count = 0, max = 1, side = "left", x = 100, y = 15, dynamic = false, spawnTimer = 0, spawnTimerMax = 2},
              --{name = "cube", count = 0, max = 1, side = "left", x = 400, y = 15, dynamic = false, spawnTimer = 0, spawnTimerMax = 2},

              {name = "wall", count = 0, max = 1, side = "right", x = -64, y = 0, dynamic = false, spawnTimer = 0, spawnTimerMax = 2},
              {name = "wall", count = 0, max = 1, side = "left", x = 644, y = 0, dynamic = false, spawnTimer = 0, spawnTimerMax = 2},

              --{name = "eye", count = 0, max = 1, side = "left", x = 200, y = 50, dynamic = false, spawnTimer = 0, spawnTimerMax = 2},
              --{name = "ded runner", count = 0, max = 1000, side = "left", x = 200, y = 120, dynamic = true, spawnTimer = 0, spawnTimerMax = 3},
              --{name = "wall", count = 0, max = 1, side = "right", x = 0, y = 0, dynamic = false, spawnTimer = 0, spawnTimerMax = 2}



              --{name = "runner", count = 0, max = 1000, side = "left", x = 200, y = 120, dynamic = true, spawnTimer = 0, spawnTimerMax = 3},
              --{name = "runner", count = 0, max = 1000, side = "right", x = -200, y = 120, dynamic = true, spawnTimer = 0, spawnTimerMax = 3},
              --{name = "grenade", count = 0, max = 1000, side = "left", x = 400, y = 85, dynamic = false, spawnTimer = 0, spawnTimerMax = 2},
              --{name = "grenade", count = 0, max = 1000, side = "right", x = 401, y = 85, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
              --{name = "prone-shooter", count = 0, max = 1, side = "right", x = 325, y = 160, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
              --{name = "laser-wall", count = 0, max = 1, side = "right", x = 150, y = 0, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
              --{name = "wizard", count = 0, max = 1, side = "left", x = 500, y = 17, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2}, -- x = 190
              --{name = "wizard", count = 0, max = 1, side = "right", x = 550, y = 25, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
              --{name = "gSlime", count = 0, max = 1, side = "left", x = 550, y = 25, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
              --{name = "gSlime", count = 0, max = 1, side = "left", x = 380, y = 140, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
              --{name = "cSlime", count = 0, max = 1, side = "left", x = 380, y = 0, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
              --{name = "cSlime", count = 0, max = 1, side = "left", x = 420, y = 0, dynamic = false, spawnTimer = 1, spawnTimerMax = 2.5},
              --{name = "cSlime", count = 0, max = 1, side = "left", x = 460, y = 0, dynamic = false, spawnTimer = 0, spawnTimerMax = 2.2},
            }
          },
        }, -- end of zones
        levelLoad = nil,
        levelUpdate = nil,
        levelDraw = nil
    }, -- end of level

} -- end of dictionary

function getLevel(levelName, level)
  for i = 1, #dictionary do
    if levelName == dictionary[i].name then
      level.name = dictionary[i].name
      level.bounds = dictionary[i].bounds
      level.zones = dictionary[i].zones

      -- player skins, location, and tilemap
      level.playerSkinV = dictionary[i].playerSkinV
      level.playerSkinH = dictionary[i].playerSkinH
      level.tilemap = dictionary[i].tilemap
      level.startPos = dictionary[i].startPos

      -- level functions
      level.levelLoad = dictionary[i].levelLoad
      level.levelUpdate = dictionary[i].levelUpdate
      level.levelDraw = dictionary[i].levelDraw
    end
  end
end

function getDictionary()
  return dictionary
end

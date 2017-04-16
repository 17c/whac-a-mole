--
-- Author: chenrh
-- Date: 2017-03-29 21:19:32
--

local scene =  require("Components/Scene")
local GameControl  = require("Game/GameControl")
local GameScene =  class("GameScene",
function() 
 return scene.create()
end)


function GameScene.extend(target)
   local t = tolua.getpeer(target)
   if not t then 
     t = {}
     tolua.setpeer(target,t)
   end
    setmetatable(t, GameScene)
    return target
end

function GameScene.create()
     local scene = GameScene.extend(scene.create())
     scene:init(conf)
     return scene
end



function GameScene:init(conf)
     GameControl.new(self)
end


return GameScene
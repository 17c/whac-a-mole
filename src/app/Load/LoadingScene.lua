local scene =  require("Components/Scene")
local LoadingControl = require("Load/LoadingControl")
local LoadingScene =  class("LoadingScene",
function() 
 return scene.create()
end)


function LoadingScene.extend(target)
   local t = tolua.getpeer(target)
   if not t then 
     t = {}
     tolua.setpeer(target,t)
   end
    setmetatable(t, LoadingScene)
    return target
end



function  LoadingScene:init(conf)
    LoadingControl.new(self)
end


function LoadingScene.create(conf)
   local scene = LoadingScene.extend(scene.create())
   scene:init(conf)
   return scene
end

function LoadingScene:onEnter()
 print("LoadingScene:onEnter")
end

function LoadingScene:onCleanup()
print("LoadingScene:onCleanup")
end
return LoadingScene
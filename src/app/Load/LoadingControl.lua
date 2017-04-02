local LoadingControl = class("LoadingControl")
local resTool  = require("Tools/resTool")

cc.FileUtils:getInstance():addSearchPath("res/Load")

function LoadingControl.extend(target)
   local t = tolua.getpeer(target)
   if not t then 
   	 t = {}
   	 tolua.setpeer(target,t)
   end
    setmetatable(t, LoadingControl)
    return target
end


function LoadingControl:ctor(scene)
  self.scene = scene
  self.layer = cc.Layer:create()
  self.resTool = resTool.new()
  self.resTool.addResource("LoadUI.plist","LoadUI.png")
  self.ui = self.resTool.getUIFromJsonFile("LoadUI.ExportJson")
  self.layer:addChild(self.ui,1)
  self.scene:addChild(self.layer,0)
  self:initUI()
  
end


function LoadingControl:initUI()
    local bg = Tool.createSprite("bg.png",false)
    self.layer:addChild(bg,0)
    bg:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)
    --self.layer:addChild(self.ui)
end


return LoadingControl
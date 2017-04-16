--
-- Author: chenrh
-- Date: 2017-03-29 21:28:00
--
local resTool  = require("Tools/resTool")
local MonsterControl =require("Game/Objects/MonsterControl")
local GameControl =  class("GameControl")

function GameControl:ctor(scene)
 self.scene  =  scene 
 self.UILayer = cc.Layer:create()
 resTool.addResource("hole/hole.plist","hole/hole.png")
 self.scene:addChild(self.UILayer)

 local root = resTool.getUIFromJsonFile("UI/MonsterPos.ExportJson")
 self.ui = root:getChildByName("center")
 self.UILayer:addChild(root,10)
 self.monsterControl  = MonsterControl.new(self.ui)
 self:initUI()
 self:initHole()
end

function GameControl:initUI()
 local bg = Tool.createSprite("game_bg.jpg",false)
 bg:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)
 self.UILayer:addChild(bg,0)
 self.monsterControl:MonsterController()
end

--初始化遮盖的hole
function GameControl:initHole()
  for i =1,9 do 
  local holePic = Tool.createSprite(string.format("h%d.png",i),true)
   holePic:setScale(0.7)
  local hole = self.ui:getChildByName(string.format("hole_%d",i))
  local holePosX,holePosY = hole:getPosition()
  holePic:setPosition(holePosX+3,holePosY-15)
  if i <= 3 then 
  self.ui:addChild(holePic,200)
  elseif i<=6 then 
  self.ui:addChild(holePic,400)
  elseif i<=9 then 
  self.ui:addChild(holePic,600)
  if i == 8 then 
    holePic:setPosition(holePosX+3,holePosY-20)
   end
 end
  end
end




return GameControl
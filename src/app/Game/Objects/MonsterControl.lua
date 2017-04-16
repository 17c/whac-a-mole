--
-- Author: chenrh
-- Date: 2017-04-03 22:38:58
--

local Monster = require("Monster/Monster")
local MonsterControl =class("MonsterControl")
function MonsterControl:ctor(ui)
 self.ui = ui 
 resTool.addResource("Monster/monster.plist","Monster/monster.png")
end

function MonsterControl:MonsterController()
	  local monster= Monster.createMonster(1)
    self:monsterBindHole(monster,1)
    -- local sp2 = Tool.createSprite("mouse_1.png",true)	
    --  self:monsterBindHole(sp2,2)
    -- local sp3 = Tool.createSprite("8.png",true)
    -- self:monsterBindHole(sp3,3)
    -- local sp4 = Tool.createSprite("5.png",true)
    -- self:monsterBindHole(sp4,4)
    -- local sp5 = Tool.createSprite("2.png",true)
    -- self:monsterBindHole(sp5,5)
    -- local sp6 = Tool.createSprite("1.png",true)
    -- self:monsterBindHole(sp6,6)
    -- local sp7 = Tool.createSprite("4.png",true)
    -- self:monsterBindHole(sp7,7)
    --  local sp9 = Tool.createSprite("9.png",true)	
    --  self:monsterBindHole(sp9,9)
end


--控制地鼠 出现在哪个洞中
function MonsterControl:monsterBindHole(monster,nums)
  local hole = self.ui:getChildByName(string.format("hole_%d",nums))
  local holePosX,holePosY = hole:getPosition()
  monster:setScale(0.7)
   local magicMonster= self:apearEffect(monster)
  if nums <=3 then 
  self.ui:addChild(magicMonster,100)
  elseif nums <=6 then
  self.ui:addChild(magicMonster,300)
  else
   self.ui:addChild(magicMonster,500)
  end
   magicMonster:setPosition(holePosX,holePosY+18)
end

--从洞中出现的效果，利用了ClippingNode
function MonsterControl:apearEffect(monster)
	monster:setPositionY(monster:getPositionY() -100)
  local clipNode= cc.ClippingNode:create()
  local stenc = cc.Node:create()
  local st1 = cc.Sprite:create("stenc.png")
  st1:setScale(0.7)
  stenc:addChild(st1)
  clipNode:setStencil(stenc)
  --设置monster的Tag为1000
  clipNode:addChild(monster,1,1000)
  local action1 = cc.EaseOut:create(cc.MoveBy:create(1.0,cc.p(0,90)),3.5)
  local action2 = cc.Sequence:create(
  cc.ScaleTo:create(0.1,0.84, 0.74,0.7),
  cc.ScaleTo:create(0.1,0.7, 0.7,0.7),
  cc.ScaleTo:create(0.1,0.77, 0.72,0.7),
  cc.ScaleTo:create(0.1,0.7, 0.7,0.7))
  monster:runAction(cc.Sequence:create(action1,action2))
   return clipNode
end

function MonsterControl:disApearEffect(MonsterClipNode)
	if MonsterClipNode:getChildByTag(1000) then 
    local monster= MonsterClipNode:getChildByTag(1000)
     local action1 = cc.EaseOut:create(cc.MoveBy:create(1.0,cc.p(0,-90)),3.5)
     local callFunc =  cc.CallFunc:create(function()
      print("我清理掉了我自己哟")
      MonsterClipNode:removeFromParent()
     end)
     monster:runAction(cc.Sequence:create(action1,callFunc))


    end
end
return MonsterControl




--
-- Author: chenrh
-- Date: 2017-04-11 22:50:25
--

local MonsterConf = require("Monster/MonsterConf")
local Monster = class("Monster",cc.Node)

local MonsterState = {
  normal  = 1 ,
  fear    = 2 
}

local MonsterType ={
  Mouse   = 1,
  Rabbit  = 2,
  Tigger  = 3,
  Hamster = 4,
  Panda   = 5
}

function Monster:ctor(MonsterType)
     self.data  = MonsterConf.initData(MonsterType)
     print(self.data.resource[MonsterState.normal])
     local sp = Tool.createSprite(self.data.resource[MonsterState.normal],true)
     self:addChild(sp,1,MonsterState.normal)
end


function Monster.createMonster(MonsterType)
  local monster = Monster.new(MonsterType)
  return monster
end


function Monster:changeState(status)
   if not self:getChildByTag(status):removeFromParent() then 
     self:getChildByTag(status):removeFromParent()
     local sp = Tool.createSprite(self.data.res[MonsterState.normal],true)
     self:addChild(sp,1,status)
   end

end


return Monster

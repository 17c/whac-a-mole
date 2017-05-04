--
-- Author: chenrh
-- Date: 2017-04-11 22:50:25
--

local MonsterConf = require("Monster/MonsterConf")
local Monster = class("Monster",cc.Node)

Monster.State = {
  normal  = 1 ,
  fear    = 2 
}

Monster.Type ={
  Mouse   = 1,
  Rabbit  = 2,
  Tigger  = 3,
  Hamster = 4,
  Panda   = 5
}

function Monster:ctor(MonsterType,state)
	 self.monsterType = MonsterType
--小怪兽的状态	 
	 self.state =state or Monster.State.normal 

	 self.monsterPic = nil
     self.data  = MonsterConf.initData(MonsterType)
     self:changeState()
     self:initTouchEvent()
     -- self:changeState()
end


function Monster.createMonster(MonsterType,state)
  local monster = Monster.new(MonsterType,state)
  return monster
end

--简单的状态机
function Monster:changeState()
	print(self.data.resource)
	 if not self.monsterPic then
	 	print("init")
	 	--Tool.createSprite(self.data.resource[Monster.State.normal],true)
        self.monsterPic =  ccui.ImageView:create(self.data.resource[Monster.State.normal],ccui.TextureResType.plistType)
        self:addChild(self.monsterPic,1)
        return 
	 end
     if self.state == Monster.State.normal then
     	 self.state = Monster.State.fear
     	 self.monsterPic:removeFromParent()
     	 print("normal",self.state)
      	self.monsterPic =  ccui.ImageView:create(self.data.resource[Monster.State.fear],ccui.TextureResType.plistType)
         self:addChild(self.monsterPic,1)
         return 
     end

     if self.state  == Monster.State.fear then
         self.state = Monster.State.normal
         self.monsterPic:removeFromParent()
         print("fear",self.state)
     	 self.monsterPic =  ccui.ImageView:create(self.data.resource[Monster.State.normal],ccui.TextureResType.plistType)
         self:addChild(self.monsterPic,1)
         return 
     end
end


function Monster:getScore()
  return self.data.MonsterReward[self.monsterType]
end

function Monster:getMonsterPic()
	return self.monsterPic
end

function Monster:initTouchEvent()

  local function onTouchEvent(_,touchType)
	   if touchType == ccui.TouchEventType.ended then 
	   -- Tool.customEventDispacher(self.data.reward)
     emgr:dispatchEvent({"score",nums=self.data.reward})
	   local hammer = Tool.createSprite("hammer.png",false)
	   -- hammer:setScale(1.3)
	   hammer:setPosition(self.monsterPic:getContentSize().width/2,self.monsterPic:getContentSize().height-15)
       self.monsterPic:addChild(hammer,1000)
       local act1  = cc.RotateBy:create(0.2, -50)
       local callFunc1 = cc.CallFunc:create(function()
       	hammer:stopAllActions()
        self:changeState()
        self.monsterPic:setTouchEnabled(false)
       	end)
       local seq = cc.Sequence:create(act1,callFunc1)
       hammer:runAction(seq)
	   print("clicked it")

      
	   end 	
  end
  self.monsterPic:setTouchEnabled(true)
  self.monsterPic:addTouchEventListener(onTouchEvent)

end
return Monster

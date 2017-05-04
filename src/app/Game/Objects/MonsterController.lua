--
-- Author: chenrh
-- Date: 2017-04-03 22:38:58
--怪兽控制器

local Monster = require("Monster/Monster")
local MonsterController =class("MonsterController")
local GameConfig        = require("Game/GameConfig") 
function MonsterController:ctor(ui)
--同时出现怪兽的最大数量
 self.synMonsterMaxNums       =   1
--同时出现的怪兽的数量
 self.synMonsterNums          =   0
--  怪兽出现时间的间隔
 self.monsterIntervalTime     =   1
-- 怪兽的队列表 
 self.monsterSpeed            =   1
 self.monsterList  = {}
 self.ui = ui 
 -- resTool.addResource("Monster/monster.plist","Monster/monster.png")
 self:registerTouchEvent()
end

-- function MonsterController:open()
--     self:open(chapter)

--     -- local sp2 = Tool.createSprite("mouse_1.png",true)	
--     --  self:monsterBindHole(sp2,2)
--     -- local sp3 = Tool.createSprite("8.png",true)
--     -- self:monsterBindHole(sp3,3)
--     -- local sp4 = Tool.createSprite("5.png",true)
--     -- self:monsterBindHole(sp4,4)
--     -- local sp5 = Tool.createSprite("2.png",true)
--     -- self:monsterBindHole(sp5,5)
--     -- local sp6 = Tool.createSprite("1.png",true)
--     -- self:monsterBindHole(sp6,6)
--     -- local sp7 = Tool.createSprite("4.png",true)
--     -- self:monsterBindHole(sp7,7)
--     --  local sp9 = Tool.createSprite("9.png",true)	
--     --  self:monsterBindHole(sp9,9)
-- end

--怪兽池，原目标是缓存怪兽 节约资源
function MonsterController:monsterPool()
  

end

--怪兽控制器 开关
function MonsterController:open()
 local globalScheduler = cc.Director:getInstance():getScheduler()
 local time  = 0 
 local function update(dt)
 if self.synMonsterNums < self.synMonsterMaxNums then                 
     self:makeMonster(chapter)
 end
      -- else

      -- end
 end
--第一次使用原生的呢,第一个参数为update，第二个参数为 间隔时间 当为0时为 每一帧 刷新，第三个参数 false为循环 true 一次
 self.schedulerID = globalScheduler:scheduleScriptFunc(update,0,false)
end

function MonsterController:pause()
  cc.Director:getInstance():getScheduler():pauseTarget(self.schedulerID)
end

function MonsterController:resume()
cc.Director:getInstance():getScheduler():resumeTarget(self.schedulerID)

end


--设置 可能同时出现怪兽的只数 （暂时，后期进行修改）
function MonsterController:setSynMonsterNums(nums)
self.synMonsterNums = nums
end


function MonsterController:close()

end

--[[

  Mouse   = 1,
  Rabbit  = 2,  资源不适合，暂时弃用
  Tigger  = 3, 
  Hamster = 4,
  Panda   = 5
]]
--制造Monster~
function MonsterController:makeMonster()
      math.randomseed(tostring(os.time()):reverse():sub(1, 7))
      local randomMath = math.random(10)
      local monsterType 
      if randomMath<=5 then
        monsterType = Monster.Type.Mouse
      elseif randomMath ==6 then
        monsterType = Monster.Type.Tigger
      elseif randomMath ==7 then
        monsterType = Monster.Type.Hamster
      else
        monsterType = Monster.Type.Panda
      end
     print("makeMonster"..monsterType)
     local monster= Monster.createMonster(monsterType)

     self:monsterBindHole(monster,self:initHolePos())
end

--初始化 出现洞穴的位置(随机数的方式)
function MonsterController:initHolePos()
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))    
    local holePos=  math.random(9)
    if self.monsterList[holePos] then
       print("monster exists",holePos)
-- -- 减少 怪兽 满图  overflow 的可能性
--       self.monsterQueue[holePos] = self.monsterQueue[holePos]+1
--       if self.monsterQueue[holePos] >= 3 then
--         print("monster already max")
--          return 
--       end
--       holePos = nil
--       self:initHolePos()
      return
    else
      -- self.monsterQueue[holePos] = 1
      print("initOk",holePos)

      return holePos
    end
end

--控制地鼠 出现在哪个洞，并控制小怪兽的正常
function MonsterController:monsterBindHole(monster,nums)
-- 随机数模拟器 确实存在这种可能性
  if not nums then 
  return 
  end
  local hole = self.ui:getChildByName(string.format("hole_%d",nums))
  local holePosX,holePosY = hole:getPosition()
  monster:setScale(0.7)
   local magicMonster= self:apearEffect(monster,nums)
  if nums <=3 then 
  self.ui:addChild(magicMonster,100)
  elseif nums <=6 then
  self.ui:addChild(magicMonster,300)
  else
   self.ui:addChild(magicMonster,500)
  end
   magicMonster:setPosition(holePosX,holePosY+18)
   
end

--根据关卡 来 增加游戏速度
function MonsterController:setGameSpeed(chapter)
    print(" GameConfig.getStageSpeed(chapter)"..GameConfig.getStageSpeed(chapter))
    self.monsterSpeed = GameConfig.getStageSpeed(chapter)
end


--从洞中正常出现及消失的效果，利用了ClippingNode
function MonsterController:apearEffect(monster,nums)
  self.synMonsterNums = self.synMonsterNums + 1

	monster:setPositionY(monster:getPositionY() -100)
  local clipNode= cc.ClippingNode:create()
--在列表中添加
  self.monsterList[nums] = clipNode
--stence 
  local stenc = cc.Node:create()
  local st1 = cc.Sprite:create("stenc.png")
  st1:setScale(0.7)
  stenc:addChild(st1)
  clipNode:setStencil(stenc)
  --设置monster的Tag为1000
  clipNode:addChild(monster,1,1000)
  -- 时间应该设置为控制的！(暂定这样)
  local action1 = cc.EaseOut:create(cc.MoveBy:create(1.0*self.monsterSpeed,cc.p(0,90)),3.5)
  local action2 = cc.Sequence:create(
  cc.ScaleTo:create(0.1*self.monsterSpeed,0.84, 0.74,0.7),
  cc.ScaleTo:create(0.1*self.monsterSpeed,0.7, 0.7,0.7),
  cc.ScaleTo:create(0.1*self.monsterSpeed,0.77, 0.72,0.7),
  cc.ScaleTo:create(0.1*self.monsterSpeed,0.7, 0.7,0.7))
  local action3 = cc.DelayTime:create(0.1*self.monsterSpeed)
  local callFunc  = cc.CallFunc:create(function()
  self:disApearEffect(clipNode,nums)
  end)
  monster:runAction(cc.Sequence:create(action1,action2,action3,callFunc))
   return clipNode
end


--自动消失的效果
function MonsterController:disApearEffect(MonsterClipNode,nums)
	if MonsterClipNode:getChildByTag(1000) then 
    local monster= MonsterClipNode:getChildByTag(1000)
     local action1 = cc.EaseOut:create(cc.MoveBy:create(1.0*self.monsterSpeed,cc.p(0,-90)),3.5)
     local callFunc =  cc.CallFunc:create(function()
      print("clear myself")
      self.synMonsterNums = self.synMonsterNums - 1
-- 清空怪物洞穴的表
      self.monsterList[nums] = nil
      MonsterClipNode:removeFromParent()
     end)
     monster:runAction(cc.Sequence:create(action1,callFunc))
    end
end


function MonsterController:registerTouchEvent()
   local listener = cc.EventListenerTouchOneByOne:create() 
    listener:setSwallowTouches(true) 
   local hammer = Tool.createSprite("hammer.png",false)
   self.ui:addChild(hammer,1000)
   hammer:setVisible(false)
   listener:registerScriptHandler(function(touch,event)
    print("touchBegin",touch:getLocation().x)
    local clickPos= self.ui:convertToNodeSpace(cc.p(touch:getLocation().x,touch:getLocation().y))
    hammer:setPosition(clickPos)
    hammer:setVisible(true)

    return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)  
   listener:registerScriptHandler(function(touch,event)
   print("touchMoved")
     local clickPos= self.ui:convertToNodeSpace(cc.p(touch:getLocation().x,touch:getLocation().y))
    hammer:setPosition(clickPos)
    hammer:setVisible(true)
    end, cc.Handler.EVENT_TOUCH_MOVED) 
   listener:registerScriptHandler(function(touch,event)
    print("touchEnded")
     hammer:setVisible(false)
    end, cc.Handler.EVENT_TOUCH_ENDED)

 local dispatcher =  cc.Director:getInstance():getEventDispatcher()
 dispatcher:addEventListenerWithSceneGraphPriority(listener, self.ui)

 -- self.ui:setTouchEnabled(true)  
end


return MonsterController




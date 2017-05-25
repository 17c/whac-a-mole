--
-- Author: chenrh
-- Date: 2017-03-29 21:28:00
--
local resTool           = require("Tools/resTool")
local ShopLayer         = require("Shop/ShopLayer")
local MonsterController = require("Game/Objects/MonsterController")
local GameConfig        = require("Game/GameConfig") 
local GameControl       = class("GameControl")


function GameControl:ctor(scene)
 self.scene  =  scene 
 self.UILayer = cc.Layer:create()
 -- resTool.addResource("hole/hole.plist","hole/hole.png")
 self.scene:addChild(self.UILayer)
 local root = resTool.getUIFromJsonFile("UI/MonsterPos.ExportJson")
 self.ui = root:getChildByName("center")
 self.UILayer:addChild(root,10)
 self.MonsterController  = MonsterController.new(self.ui)
 self.commonUILayer  =  cc.Layer:create()
 self.scene:addChild(self.commonUILayer,20)
 self:initCommonUI()
 self:initUI()
 self:initHole()
 self:initAllEvent()
end

function GameControl:initUI()
 local bg = Tool.createSprite("game_bg.jpg",false)
 bg:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)
 self.UILayer:addChild(bg,0)


end

function GameControl:initCommonUI()
--当前关卡  
 self.chapter = 1
---当前关卡可获得的积分倍数 
 self.scoreMultiple = 1
--当前总分数  
 self.totalScore = 0
--当前关卡获得的分数 
 self.curScore  =0 
-- 默认关卡时间为 30
 self.costTime  = 0
--总时间
 self.allTime   = 30


 self.commonUI = resTool.getUIFromJsonFile("UI/GameUI.ExportJson")
 --初始化值，其实这种复用的代码，应该封装为方法使用的
 self.lbTotalScore = Tool.getChildByName(self.commonUI,"lbTotalScore")
 self.lbTotalScore:setString(self.totalScore)
 self.lbCurScore = Tool.getChildByName(self.commonUI,"lbCurScore")
 self.lbCurScore:setString(self.curScore)
 self.lbNeedScore = Tool.getChildByName(self.commonUI,"lbNeedScore")
 self.lbNeedScore:setString(GameConfig.getStageScore(self.chapter))

 local pauseBtn   = Tool.getChildByName(self.commonUI,"pauseBtn")
 pauseBtn:addTouchEventListener(handler(self,self.initGamePauseMaskLayer))


 self.commonUI:setTouchEnabled(false)
--这种麻烦的调用 迟早是要换的
 -- self.TimerBar  = commonUI:getChildByName("top"):getChildByName("Image_6"):getChildByName("TimerBar")
 self.TimerBar  = Tool.getChildByName(self.commonUI,"TimerBar")
 self.TimerBar:setPercent(100)
 self.commonUILayer:addChild(self.commonUI)
 -- self.globalScheduler = cc.Director:getInstance():getScheduler()
 -- self.globalScehulerID = nil
 -- self.globalScehulerID  = self.globalScheduler:scheduleScriptFunc(handler(self,self.globalUpdate),1,false)
 self:GameStartCount()
end


function GameControl:GameStartCount()
   local Time = 2
   local imgTime = cc.Sprite:create("numbers/3.png")
   imgTime:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)
   self.scene:addChild(imgTime,100)
   self.CountScheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()

    if Time  > 0 then  
    imgTime:setTexture("numbers/"..Time..".png")
    Time = Time - 1
    else
     imgTime:setTexture("numbers/start.png")
     -- imgTime:setVisible(false)
     Tool.delayTimeCallBack(0.5,function()
     imgTime:removeFromParent()
     --游戏控制器开关哟
      self.MonsterController:open()
      end)

     -- imgTime:removeFromParent()
      self.globalScheduler = cc.Director:getInstance():getScheduler()
      self.globalScehulerID = nil
      self.globalScehulerID  = self.globalScheduler:scheduleScriptFunc(handler(self,self.globalUpdate),1,false)
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.CountScheduler)
    end
    
    end,0.5,false)
end

function GameControl:globalUpdate()
  local  percent = math.floor((self.allTime-self.costTime)/self.allTime*100)

    if  self.allTime -self.costTime >=0 then
     print("percent",percent)
--加时间，将时间增加超过100，做一个容错
     if percent >= 100 then
     percent = 100
     self.costTime = 0
     end
     
    self.TimerBar:setPercent(percent)
    self.costTime = self.costTime + 1
    else
--减时间，将时间减为了负 ，做一个容错      
     if percent <= 0  then
     percent = 0
     self.TimerBar:setPercent(percent)
     end
     
     if GameConfig.getStageScore(self.chapter) <=self.totalScore then      
       self:initPassMaskLayer()
      -- self.globalScheduler:pauseSchedulerAndActions()
      -- cc.Director:getInstance():getRunningScene():pause()
       print("pass")

        
     else 
       print("Game over")
       self:initGameOverMaskLayer()
     end


    end

end


--过关面板
function GameControl:initPassMaskLayer()

   if not self.shopFlag then
      ---   重置积分倍数
      self.scoreMultiple = 1
    end

--暂停游戏时间      
      self.globalScheduler:unscheduleScriptEntry(self.globalScehulerID)
--
    if self.totalScore > 100 and not self.shopFlag then
      self.shopFlag  =  1
      local shopLayer  = ShopLayer.new(self.totalScore)
        self.scene:addChild(shopLayer,1000)
        Tool.delayTimeCallBack(15,function()
          shopLayer:removeFromParent()
          self:initPassMaskLayer()
        end)
        return 
    end

      self.shopFlag  =  nil
      print("我进来了啦")
      local specialUpPanel= cc.LayerColor:create(cc.c3b(0, 0, 0))
      specialUpPanel:setOpacity(180)
      self.scene:addChild(specialUpPanel,1000)
--这是为了让monster变为无法点击      
      self.commonUI:setTouchEnabled(true)

      local approveLogo = Tool.createSprite("approve.png",false)
      approveLogo:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)
      specialUpPanel:addChild(approveLogo)
      local act1 = cc.DelayTime:create(0.45)
      local act2 = cc.ScaleTo:create(0.15,0.4)
      local act3 = cc.DelayTime:create(0.75)
      local act4 = cc.CallFunc:create(function()
--设置为可点击的,巧妙的利用了Widget的可点击性
        self.commonUI:setTouchEnabled(false)
        specialUpPanel:removeFromParent()
--重置时间       
       self.costTime = 0
--过关关卡
       self.chapter = self.chapter + 1 
--给游戏加速哟~~哈哈哈       
       self.MonsterController:setGameSpeed(self.chapter)      
--当前关卡 获得分数
       self.curScore = 0
        -- local lbCurScore = Tool.getChildByName(self.commonUI,"lbCurScore")
        self.lbCurScore:setString(self.curScore)
       --关卡分数的显示     
       local lbNeedScore = Tool.getChildByName(self.commonUI,"lbNeedScore")
       lbNeedScore:setString(GameConfig.getStageScore(self.chapter))

        self.globalScehulerID =self.globalScheduler:scheduleScriptFunc(handler(self,self.globalUpdate),1,false)
        end)

       approveLogo:runAction(cc.Sequence:create(act1,act2,act3,act4))
end

--游戏结束面板
function GameControl:initGameOverMaskLayer()
      -- resTool.addResource("resultPanel/resultPanel.plist","resultPanel/resultPanel.png")
      --ResultPanel的UI
      local ReusltPanelUI =  resTool.getUIFromJsonFile("resultPanel/ResultPanel.ExportJson")
      self.globalScheduler:unscheduleScriptEntry(self.globalScehulerID)
      local specialUpPanel= cc.LayerColor:create(cc.c3b(0, 0, 0))
       -- specialUpPanel:setTouchEnabled(false)
      specialUpPanel:addChild(ReusltPanelUI)
      specialUpPanel:setOpacity(180)
--还是老套路哟~
      self.commonUI:setTouchEnabled(true)

      self.scene:addChild(specialUpPanel,1000)
 

      -- local  lbTotalScore = Tool.getChildByName(ReusltPanelUI,"lbTotalScore")
      -- self.lbTotalScore:setString(self.totalScore)
      -- self.lbTotalScore:setColor(cc.c3b(255,255,0))

--初始化 最大值
     print("test")
     print(cc.UserDefault:getInstance():getIntegerForKey("MaxScore"))

     if cc.UserDefault:getInstance():getIntegerForKey("MaxScore") and cc.UserDefault:getInstance():getIntegerForKey("MaxScore")  < self.totalScore then
     
      cc.UserDefault:getInstance():setIntegerForKey("MaxScore", self.totalScore)
      cc.UserDefault:getInstance():flush()
-- 设置最大 分数 其实用atlas字体会更好的，就是我太懒了
     end
--结算最大分数     
       local  lbMaxScore = Tool.getChildByName(ReusltPanelUI,"lbMaxScore")
       lbMaxScore:setString(cc.UserDefault:getInstance():getIntegerForKey("MaxScore"))
       lbMaxScore:setColor(cc.c3b(255,0,0))
--结算总分数
       local totalScore  = Tool.getChildByName(ReusltPanelUI,"lbTotalScore")
       totalScore:setString(self.totalScore)
       totalScore:setColor(cc.c3b(255,0,0))


--游戏结束 动画特效
      local imgGameOver  =Tool.createSprite("GamOver.png",false)
      imgGameOver:setScale(0.1)
      specialUpPanel:addChild(imgGameOver)
      imgGameOver:setPosition(VisibleRect:width()/2,VisibleRect:height()/2+150)
      local act0 = cc.DelayTime:create(0.3)
      local act1 =cc.EaseOut:create(cc.MoveBy:create(0.15,cc.p(0,-75)),0.05)
      local act2 =cc.EaseOut:create(cc.MoveBy:create(0.08,cc.p(0,40)),0.03)
      local act3 =cc.EaseOut:create(cc.MoveBy:create(0.08,cc.p(0,-40)),0.03)
      local act4 =cc.EaseOut:create(cc.MoveBy:create(0.03,cc.p(0,15)),0.01)
      local act5 =cc.EaseOut:create(cc.MoveBy:create(0.03,cc.p(0,-15)),0.01)
      local act6 =cc.DelayTime:create(3.0)
      local act7 =cc.CallFunc:create(function()
         -- specialUpPanel:setTouchEnabled(true)
          -- 
--退出游戏    
           cc.Director:getInstance():popScene()

      end)
-- --注册点击事件
--       specialUpPanel:setTouchEnabled(true)
--       specialUpPanel:registerScriptTouchHandler(function(eventType)
--         print(eventType)
--            if eventType == "began"then
--            print("turn back 1")
-- --退出游戏    
--            return true
--          end

--          if eventType == "ended"then
--            print("turn back 2")

--          end
  
--         end) 


      imgGameOver:runAction(cc.Sequence:create(act1,act2,act3,act4,act5,act6,act7))
end



function GameControl:initGamePauseMaskLayer(_,eventType)
  if eventType == ccui.TouchEventType.ended then
    -- self:GameStartCount()
      self.globalScheduler:unscheduleScriptEntry(self.globalScehulerID)

      local specialUpPanel= cc.LayerColor:create(cc.c3b(0, 0, 0))
      -- specialUpPanel:setOpacity(220)
      self.scene:addChild(specialUpPanel,1000)
       -- resTool.addResource("pausePanel/pausePanel.plist","pausePanel/pausePanel.png")
   --   ResultPanel的UI
      local pausePanelUI =  resTool.getUIFromJsonFile("pausePanel/pausePanel.ExportJson")
      specialUpPanel:addChild(pausePanelUI)


     local restartBtn= Tool.getChildByName(pausePanelUI,"btnback")
     -- restartBtn:setTouchEnabled(true)
     restartBtn:addTouchEventListener(function(_,eventType)
     if eventType == ccui.TouchEventType.ended then
     -- cc.Director:getInstance():resume()
     -- pausePanelUI:removeFromParent()
     specialUpPanel:removeFromParent()
     self.globalScehulerID =self.globalScheduler:scheduleScriptFunc(handler(self,self.globalUpdate),1,false)
     end
     end)

      local btnIntroduc = Tool.getChildByName(pausePanelUI,"btnIntroduc")
      btnIntroduc:addTouchEventListener(
        function(_,eventType)
        if eventType == ccui.TouchEventType.ended then
          local popUpLayer= cc.LayerColor:create(cc.c3b(0, 0, 0))
          popUpLayer:setOpacity(180)
          local helpBg = ccui.ImageView:create("help.png",ccui.TextureResType.localType)
          helpBg:setScale(0.5)
          helpBg:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)
          popUpLayer:addChild(helpBg)
          self.scene:addChild(popUpLayer,2000)
          helpBg:setTouchEnabled(true)
          helpBg:addTouchEventListener(function(_,eventType)
           if eventType == ccui.TouchEventType.ended then
              popUpLayer:removeFromParent()
           end
           end)
         end
      end)

      local btnTurnBack =Tool.getChildByName(pausePanelUI,"btnTurnBack")
      btnTurnBack:addTouchEventListener(function(_,eventType)
        if eventType == ccui.TouchEventType.ended then
        cc.Director:getInstance():popScene()
        end
      end)

  end
end


function GameControl:showShopLayer()
  local shopLayer  = cc.Layer:create()
  local bg   =  cc.Sprite:create("shopbg.jpg")
  bg:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)
  shopLayer:addChild(bg)
  self.scene:addChild(shopLayer,1000)

end



function GameControl:onScoreEventCallBack(args)
     if type(args.nums) == "number"then 
      print("self.scoreMultiple",self.scoreMultiple)
     local addScore = args.nums*self.scoreMultiple
     self.totalScore = self.totalScore + addScore
     self.curScore   = self.curScore   + addScore
     self.lbTotalScore:setString(self.totalScore)
     self.lbCurScore:setString(self.curScore)
     elseif args.nums =="+10s" then
        self.costTime  = self.costTime - 10
     elseif args.nums =="-10s" then
        self.costTime  = self.costTime + 10
     end

end

function GameControl:onCostMoneyEventCallBack(args)
   self.totalScore = self.totalScore -args.nums
   self.lbTotalScore:setString(self.totalScore)
end

--初始化 事件
function GameControl:initAllEvent()
  ---注册分数事件
     emgr:addEventListener("score",handler(self,self.onScoreEventCallBack))

     emgr:addEventListener("costMoney",handler(self,self.onCostMoneyEventCallBack))
        ---添加buff
      emgr:addEventListener("buff",handler(self,self.onBuffEventCallBack))  
     -- Tool.addCustomEventListener("+100",function()
     --  print("+100")
     --  print("self.scoreMultiple",self.scoreMultiple)
     --  local addScore = 100*self.scoreMultiple
     --  self.totalScore = self.totalScore + addScore
     --  self.curScore   = self.curScore   + addScore
    
     --  self.lbTotalScore:setString(self.totalScore)
     --  self.lbCurScore:setString(self.curScore)
     -- end)
     -- Tool.addCustomEventListener("-100",function()
     --  print("-100")
     --  print("self.scoreMultiple",self.scoreMultiple)
     --  local addScore = -100*self.scoreMultiple
     --  self.totalScore = self.totalScore - addScore
     --  self.curScore   = self.curScore   - addScore
    
     --  self.lbTotalScore:setString(self.totalScore)
     --  self.lbCurScore:setString(self.curScore)
     --  end)

     --  Tool.addCustomEventListener("+500",function()
     --  print("+500")
     --  print("self.scoreMultiple",self.scoreMultiple)
     --  local addScore = 500*self.scoreMultiple
     --  self.totalScore = self.totalScore + addScore
     --  self.curScore   = self.curScore   + addScore
     --  self.lbTotalScore:setString(self.totalScore)
     --  self.lbCurScore:setString(self.curScore)
     --  end)

      -- Tool.addCustomEventListener("+10s",function()
      -- print("+10s")
      -- self.costTime  = self.costTime -10
      -- end)

      -- Tool.addCustomEventListener("-10s",function()
      -- print("-10s")
      -- self.costTime  = self.costTime + 10
      -- end)

end

function GameControl:onBuffEventCallBack(args)

   self.scoreMultiple  = GameConfig.getBuff(args.nums)

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
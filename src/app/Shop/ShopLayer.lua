--
-- Author: chenrh
-- Date: 2017-04-30 09:43:19
--


local ShopLayer = class("ShopLayer",function()
return cc.Layer:create()
end)

local shopItem  = require("Shop/ShopItem")
local shopConfig = require("Shop/ShopConfig")
function ShopLayer:ctor(totalScore)
   self.totalScore = totalScore
   self:initbg()
   self:initUI()
   self:initShop()

---25秒后自动清理自身面板
   -- self:clean()
end

function ShopLayer:initbg()
    local bg = Tool.createSprite("shopbg.jpg",false)
    bg:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)
    self:addChild(bg)
end


function ShopLayer:initUI()
	self.buyTips = ccui.Text:create()
    self.buyTips:setColor(cc.c3b(255,255,0))
    self.buyTips:enableOutline(cc.c3b(255,0,0), 4)
    self.buyTips:setFontSize(21)
    self.buyTips:setPosition(VisibleRect:width()/2,VisibleRect:height()/3)

    self:addChild(self.buyTips)
end

function ShopLayer:initShop()
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
	self.shopBox = ccui.Widget:create() 
    for i = 1,3 do 
    	local shopType = math.random(1,6)
        local item = shopItem.new(shopType)
        item:setTouchEnabled(true)
        item:setPosition(VisibleRect:width()/2-250+i*100,VisibleRect:height()/3)
        item:addTouchEventListener(handler(self,self.onTouchEventCallBack))
        self.shopBox:addChild(item,1,i)
    end
    self:addChild(self.shopBox,1)
end


function ShopLayer:onTouchEventCallBack(ref,touchType)
	if touchType ==  ccui.TouchEventType.ended then
      print("touched")
    -- for i = 1,3 do
    -- self.shopBox:getChildByTag(i):setVisible(false)
    -- end

    if self.totalScore < ref:getCostScore() then
    local tips =  ccui.Text:create()
    tips:setColor(cc.c3b(220,0,0))
    tips:enableOutline(cc.c3b(255,0,0), 4)
    tips:setFontSize(24)
    tips:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)
    tips:setString("你身上的钱不足哟")
    self:addChild(tips)
    ref:setTouchEnabled(false)
   
    local act1   = cc.MoveBy:create(2.5,cc.p(0,80))
    local act2   = cc.FadeOut:create(2.5)
    local spawn  = cc.Spawn:create(act1,act2)
    local act3   = cc.CallFunc:create(function()
     ref:setTouchEnabled(true)
    end) 
    -- local delay = cc.DelayTime:create(10)
    -- local func  = cc.CallFunc:create(function()
    -- --防止多点以后 CallBack导致的 Layer已经被释放掉的情况
    -- if self then
    -- self:removeFromParent()
    -- end
    -- end)
    tips:runAction(cc.Sequence:create(spawn,act3))
    return 
    end

---差价导致的金钱不足
    -- if tips then
    --   tips:stopAllActions()
    -- end

    emgr:dispatchEvent({"costMoney",nums= ref:getCostScore()})
    self.shopBox:setVisible(false)
    self.buff = math.random(1,6)
    emgr:dispatchEvent({"buff",nums = self.buff})   

    self.buyTips:setText(shopConfig.shopEffect[self.buff])

    local act1   = cc.MoveBy:create(2.5,cc.p(0,80))
    local act2   = cc.FadeOut:create(2.5)
    local spawn  = cc.Spawn:create(act1,act2)	
    local act3   = cc.DelayTime:create(0.5)
    local callFunc = cc.CallFunc:create(function()
-- self:removeFromParent()
    end)
    local sequence = cc.Sequence:create(spawn,act3,callFunc)
    self.buyTips:runAction(sequence)


   end
end


--自己清理自己
function ShopLayer:clean()
 Tool.delayTimeCallBack(25,function()
 	if self then
      self:removeFromParent()
  end
 end)



end

function ShopLayer:clear()
  self.time = 0
  local scheduler =  cc.Director:getInstance():getScheduler()
  scheduler:scheduleScriptFunc(handler(self,self.update),0,false)

end


function ShopLayer:update(dt)
    self.time = self.time +dt
    if self.time > 15 then
     self:removeFromParent()
    end
end



return ShopLayer
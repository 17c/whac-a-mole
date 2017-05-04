--
-- Author: Your Name
-- Date: 2017-04-30 09:45:32
--


local ShopItem  = class("ShopItem",function ()
	-- body
	return ccui.ImageView:create()
end)


local shopConfig  = require("app/Shop/ShopConfig")


function ShopItem:ctor(shopType)

    self:initUI(shopType)
    self:randomCostScore()
    -- self:initTouchEvent()
end


function ShopItem:initUI(shopType)
	--资源种类
	local ResType = shopConfig.shopResourceType[shopType]

    self:loadTexture(ResType..".png",ccui.TextureResType.plistType)
    self:setScale(0.7)
    self.tips = ccui.Text:create()
    self.tips:setFontName("Font/arial.ttf")
    self.tips:setColor(cc.c3b(255,255,255))
    self.tips:enableOutline(cc.c3b(255,0,0), 4)
    self.tips:setFontSize(21)
    self.tips:setPosition(self:getContentSize().width/2,self:getContentSize().height/4)
    self:addChild(self.tips)
end

function ShopItem:randomCostScore()
    local number = math.random(1,10)
    self.costScore = number*100
    self.tips:setText(self.costScore)
end



function ShopItem:initTouchEvent()
	self:setTouchEnabled(true)
    self:addTouchEventListener(handler(self,self.onTouchEventCallBack))

end

function ShopItem:getCostScore()
    return self.costScore
end




return ShopItem



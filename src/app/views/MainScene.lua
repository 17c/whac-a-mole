local MainScene = class("MainScene", cc.load("mvc").ViewBase)
cc.exports.VisibleRect = require("Tools/VisibleRect")
cc.exports.Tool  = require("Tools/Tool")
cc.exports.resTool  =require("Tools/resTool")
cc.FileUtils:getInstance():addSearchPath("src/app/")
cc.FileUtils:getInstance():addSearchPath("res/")

--场景管理器
cc.exports.emgr =  require("Tools/EventManager").create()



local ShopLayer = require("Shop/ShopLayer")

local resourcePlist = { 
    "UI/LoadUI",
    "UI/NewUi0",
    "pausePanel/pausePanel",
    "resultPanel/resultPanel",
    "hole/hole",
    "Monster/monster",
    "Shop/Shop"
}


local tipsList ={
    "这游戏还挺好玩的哟",
    "请耐心一点呢，马上就加载完成了呢！",
    "记得打开音效哦，虽然并没有音乐~"
}

function MainScene:startLoad()
    AudioEngine:getInstance():preloadMusic("music/Synth.mp3")
    AudioEngine:getInstance():preloadMusic("music/Jazz.mp3")

    self.count = 0 
    self.maxCount = #resourcePlist

    local texture =  cc.Director:getInstance():getTextureCache()
for i =1, #resourcePlist do
     texture:addImageAsync(resourcePlist[i]..".png",handler(self,self.loadComplete))
 end
 
end

function MainScene:loadComplete()
    self.count = self.count + 1 
    local percent = math.floor(self.count/self.maxCount*100)
    self.loadingBar:setPercent(percent)
    self.loadText:setText(percent.."%")
    if percent  == 100 then
        for i =1, #resourcePlist do
         resTool.addResource(resourcePlist[i]..".plist",resourcePlist[i]..".png")
        end

        local DelayNode = cc.Node:create()
        local delay  = cc.DelayTime:create(1.0)
        local callFunc = cc.CallFunc:create(function()
        
        self.tips:setText("Loading Complete..")
        end)
        local delay2   = cc.DelayTime:create(2.5)
        local callFunc2  =  cc.CallFunc:create(handler(self,self.enterGame))
        DelayNode:runAction(cc.Sequence:create(delay,callFunc,delay2,callFunc2))
        self:addChild(DelayNode)
    end
end



function MainScene:onCreate()
   

    local bg  =  cc.Sprite:create("bg.png")
    bg:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)
    self:addChild(bg)

    -- local menuItem = cc.MenuItemFont:create("Loading..")
    -- menuItem:registerScriptTapHandler(handler(self, self.onCallBackMenuItem))
    -- menuItem:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)

    -- local testItem = cc.MenuItemFont:create("test")
    -- testItem:setPosition(VisibleRect:width()/3,VisibleRect:height()/3)
    -- testItem:registerScriptTapHandler(handler(self, self.onCallBacktestItem))
    -- local menu=cc.Menu:create()
    -- -- menu:addChild(menuItem)
    -- menu:addChild(testItem)
    -- menu:setPosition(0,0)
    -- self:addChild(menu)
   

    local loadingBarbg = ccui.ImageView:create("loadingBar_1.png",ccui.TextureResType.localType)
    loadingBarbg:setScale(0.6)
    loadingBarbg:setPosition(VisibleRect:width()/2,VisibleRect:height()/7)
    self.loadText = ccui.Text:create()
    self.loadText:setFontName("Font/arial.ttf")
    self.loadText:enableOutline(cc.c3b(255,0,0), 2)
    self.loadText:setFontSize(18)
    self.loadText:setText("0%")
    self.loadText:setPosition(loadingBarbg:getContentSize().width/2,loadingBarbg:getContentSize().height/2)
    loadingBarbg:addChild(self.loadText,1)

    self.loadingBar = ccui.LoadingBar:create("loadingBar_2.png",ccui.TextureResType.localType)
    self.loadingBar:setPercent(0)
    self.loadingBar:setPosition(loadingBarbg:getContentSize().width/2,loadingBarbg:getContentSize().height/2)
    loadingBarbg:addChild(self.loadingBar)
   
    self.tips = ccui.Text:create()
    self.tips:setFontName("Font/arial.ttf")
    self.tips:setColor(cc.c3b(255,255,255))
    self.tips:enableOutline(cc.c3b(255,0,0), 4)
    self.tips:setFontSize(21)
    self.tips:setText("Loaing Game..")
    self.tips:setPosition(loadingBarbg:getContentSize().width/2,loadingBarbg:getContentSize().height*3/2)
    local act1  = cc.FadeOut:create(0.8)
    local act2  = cc.FadeIn:create(0.8)
    self.tips:runAction(cc.RepeatForever:create(cc.Sequence:create(act1,act2)))

    loadingBarbg:addChild(self.tips)
    self:addChild(loadingBarbg)
    self:startLoad()
   
end

function MainScene:enterGame()
   local scene  = require("Load/LoadingScene").create()
   cc.Director:getInstance():pushScene(scene)
end


function MainScene:onCallBacktestItem()
   self:addChild(ShopLayer.new(10))
end


return MainScene

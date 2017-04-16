local MainScene = class("MainScene", cc.load("mvc").ViewBase)
cc.exports.VisibleRect = require("Tools/VisibleRect")
cc.exports.Tool  = require("Tools/Tool")
cc.exports.resTool  =require("Tools/resTool")
cc.FileUtils:getInstance():addSearchPath("src/app/")
cc.FileUtils:getInstance():addSearchPath("res/")
function MainScene:onCreate()
    local menuItem = cc.MenuItemFont:create("Loading..")
    menuItem:registerScriptTapHandler(handler(self, self.onCallBackMenuItem))
    menuItem:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)

    local testItem = cc.MenuItemFont:create("test")
    testItem:setPosition(VisibleRect:width()/3,VisibleRect:height()/3)
    testItem:registerScriptTapHandler(handler(self, self.onCallBacktestItem))
    local menu=cc.Menu:create()
    menu:addChild(menuItem)
    menu:addChild(testItem)
    menu:setPosition(0,0)
    self:addChild(menu)
   
end

function MainScene:onCallBackMenuItem()
   local scene  = require("Load/LoadingScene").create()
   cc.Director:getInstance():pushScene(scene)
end


function MainScene:onCallBacktestItem()
   
end


return MainScene

local LoadingControl = class("LoadingControl")

cc.FileUtils:getInstance():addSearchPath("res/UI")

function LoadingControl.extend(target)
   local t = tolua.getpeer(target)
   if not t then 
   	 t = {}
   	 tolua.setpeer(target,t)
   end
    setmetatable(t, LoadingControl)
    return target
end


function LoadingControl:ctor(scene)
  self.scene = scene
  self.layer = cc.Layer:create()
  resTool.addResource("LoadUI.plist","LoadUI.png")

  
  self.ui = resTool.getUIFromJsonFile("LoadUI.ExportJson")
  self.layer:addChild(self.ui,1)
  self.scene:addChild(self.layer,0)
  self:initUI()
  
end


function LoadingControl:initUI()
    local bg = Tool.createSprite("bg.png",false)
    self.layer:addChild(bg,0)
    bg:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)
    --self.layer:addChild(self.ui)

    local rightPt  = self.ui:getChildByName("rightPt")
    local newBtn = rightPt:getChildByName("newBtn")
    print(tolua.type(newBtn))
    newBtn:addTouchEventListener(handler(self,self.onTouchNewBtn))
end

function LoadingControl:onTouchNewBtn(_,touchType)
  print("onTouchNewBtn")
  if touchType ==  ccui.TouchEventType.ended then 
     local scene = require("Game/GameScene").create()
      cc.Director:getInstance():pushScene(scene)
  end

  end





return LoadingControl
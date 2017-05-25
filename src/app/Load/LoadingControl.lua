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
  -- resTool.addResource("LoadUI.plist","LoadUI.png")

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
    local instrBtn = Tool.getChildByName(self.ui,"instrBtn")
    local setBtn = Tool.getChildByName(self.ui,"setBtn")
    print(tolua.type(newBtn))
    newBtn:addTouchEventListener(handler(self,self.onTouchNewBtn))
    instrBtn:addTouchEventListener(handler(self,self.onTouchIntroduction))
    setBtn:addTouchEventListener(handler(self, self.onTouchConfigCallBack))
end

function LoadingControl:onTouchNewBtn(_,touchType)
  print("onTouchNewBtn")
  if touchType ==  ccui.TouchEventType.ended then 
     local scene = require("Game/GameScene").create()
      cc.Director:getInstance():pushScene(scene)
  end

end


function LoadingControl:onTouchIntroduction(_,touchType)
 if touchType == ccui.TouchEventType.ended then
       local popUpLayer= cc.LayerColor:create(cc.c3b(0, 0, 0))
        popUpLayer:setOpacity(180)
        local helpBg = ccui.ImageView:create("help.png",ccui.TextureResType.localType)
        helpBg:setScale(0.5)
        helpBg:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)
        popUpLayer:addChild(helpBg)
        self.scene:addChild(popUpLayer)
        helpBg:setTouchEnabled(true)
        helpBg:addTouchEventListener(function(_,eventType)
           if eventType == ccui.TouchEventType.ended then
              popUpLayer:removeFromParent()
           end
        end)
 end
end



function LoadingControl:onTouchConfigCallBack(sender,touchType)
 if touchType  ~= ccui.TouchEventType.ended then return end
      local layer  = require("Music/MusicPanel").new()
      layer:setPosition(VisibleRect:width()/2,VisibleRect:height()/2)
      self.scene:addChild(layer)
end



return LoadingControl
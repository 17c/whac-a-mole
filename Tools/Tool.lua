local tool =class("Tool")
--自定义的CustomEvenListener
function tool.addCustomEventListener(eventName,callFunc)
     local dispatcher = cc.Director:getInstance():getEventDispatcher()
     local listener= cc.EventListenerCustom:create(eventName,callFunc)
     dispatcher:addEventListenerWithFixedPriority(listener, 1)
end


function tool.customEventDispacher(eventName)
     local  eventCustom = cc.EventCustom:new(eventName)
     local dispatcher = cc.Director:getInstance():getEventDispatcher()
     dispatcher:dispatchEvent(eventCustom)
end


function tool.addFrameCache(plistPath,pngPath)
local spriteFrame = cc.SpriteFrameCache:getInstance()
  --Resouce Load
  spriteFrame:addSpriteFrames(plistPath,pngPath)

end
function tool.createSprite(path,bool)
	local sprite
     if bool then
       sprite  = cc.Sprite:createWithSpriteFrame(path)
     else
       sprite = cc.Sprite:create(path)
     end

 return sprite

end

return tool






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


function tool.createSprite(path,bool)
	local sprite
     if bool then
       sprite  = cc.Sprite:createWithSpriteFrameName(path)
     else
       sprite = cc.Sprite:create(path)
     end

 return sprite

end


function tool.showTable(t)
  if type(t)~= "table" then 
    print("[error]: type not table")
   return 
end
 local function showTable(t,n)
   local sp = "*"
  for index,value in pairs(t) do 
      for i= 1,n do
      sp = sp.."*"
      end
      print(sp,index,value)
      if type(value) == "table" then
      showTable(t,n+1)
      end
  end
 end
  showTable(t,1)

end

return tool






local DemoScene =  class("DemoScene",
function ()
	return cc.Scene:create()
end)
 
function DemoScene.extend(target)
   local t = tolua.getpeer(target)
   if not t then 
   	 t = {}
   	 tolua.setpeer(target,t)
   end
    setmetatable(t, DemoScene)
    return target
end


function DemoScene.create(conf)
    local scene=DemoScene.extend(cc.Scene:create())
    scene:init(conf)
    return scene
end

function DemoScene:init(conf)
	--注册场景各种事件
    self:registerScriptHandler(function(event)
	if event == "enter" then 
     self:onEnter()
     print(event)
    elseif event == "exit"then 
     self:onExit()
     print(event)
    elseif event == "cleanup"then
     self:onCleanup()
     print(event)
    end
    end)
    
end

return DemoScene
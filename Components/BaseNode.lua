local BaseNode = class("BaseNode", function() return cc.Node:create() end)


function BaseNode.extend(target)
   local t = tolua.getpeer(target)
   if not t then 
     t = {}
     tolua.setpeer(target,t)
   end
    setmetatable(t, BaseNode)
    return target

end



function  BaseNode:init(conf)
     --注册场景各种事件

    self:registerScriptHandler(function(event)
  if event == "enter" then 
     self:onEnter()
    
    elseif event == "exit"then 
     self:onExit()
  
    elseif event == "cleanup"then
     self:onCleanup()
   
    end
    end)
    
end


function BaseNode.create(conf)
   local baseNode = BaseNode.extend(cc.Node:create())
   baseNode:init(conf)
   return baseNode
end



return BaseNode
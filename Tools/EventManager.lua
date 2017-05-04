--
-- Author: chenrh
-- Date: 2017-04-30 15:12:54
--自用的事件控制器，用于全局使用，本质上不建议直接调用这一层。


local EventManager =  class("EventManager")


---这里不用我们这样获取单例模式的
function EventManager:getInstance()

end

function EventManager:ctor()
   ---避免rehash导致的时间浪费
   -- self.eventList = {1,1,1,1,1,1,1,1,1}
   ---这样写的话，如果参数是1怎么办

      self.eventList = {}
end

function EventManager.create()
    local EventManager = EventManager.new()
    return EventManager
end


function EventManager:addEventListener(eventName,callback) 
	if not eventName or not callback then
	print("invalid arguments")
    return 
	end
   self.eventList[eventName] = callback
end

function EventManager:dispatchEvent(args,...)
	if not args then 
	print("invalid arguments")
	end

	local eventName  = args[1]
   if not self.eventList[eventName] then
     print("event isn't registered")
     return
   end
   local eventCallFunc = self.eventList[args[1]]
   eventCallFunc(args,...)
end


function EventManager:removeEventListener(eventName)
   if not eventName then
   print("invalid arguments")
   return 
   end

   if not self.eventList[eventName] then
     print("event isn't exist")
   return 
   end
   Tool.removeElementByKey(self.eventList,eventName) 
end


function EventManager:removeAllEventListeners()
  self.eventList = nil
  self.eventList = {}
end


function EventManager:clear()
   self.eventList =nil
end







return EventManager









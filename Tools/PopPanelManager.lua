--
-- Author: chenrh
-- Date: 2017-05-07 10:53:02
--

local PopPanelManager = class("PopPanelManager",cc.BaseNode)


local instance  =  nil

local popPanelZorder   =  100000


function PopPanelManager:getNewInstance()
  if  instance then
  	if instance.clear() then
  	instance:clear()
    end
	instance  = PopPanelManager.new()
  end 
  return instance
end

-- function PopPanelManager:getInstance()
--      if not instance then
--         instance  = PopPanelManager.new()
--      end
--      return instance 
-- end

-- 数组收集弹出面板数据
local PopPanelConf  = {
   "",
}
function PopPanelManager:ctor()
  -- Retain自己，其实没有这个必要
   self:safeRetain(self)
  --是否加锁 
   self.isLock                  = false
  --等待弹出面板 
   self.popPanelArray           = {}
  --事件监听器 
   self.eventListenrs           = {}
  --当前显示的Layer 
   self.currentShowLayer        = nil
  -- 锁
   self.key                     = nil
  -- 加锁的原因
   self.lockByReason            = nil
  --为了记录弹出面板的队列值 
   self.panelId                 = 1
end


--ShowLayerType 应该为系统参数配置的
function PopPanelManager:showLayer(ShowLayerType,args)
  --获取弹出层路径
    if not PopPanelConf[ShowLayerType]  then
       print("[error] ShowLayer is valid type")
       return 
    end
  --是否加锁
    if self.isLock then
    --插入popPanelArray等待队列中  这里其实需要优化，队列中的面板 并不符合实际要求
      self.popPanelArray[self.panelId] = {showLayerType,args}
      self.panelId = self.panelId + 1
    -- 显示加锁的原因
      self.showLockByReason()
      return 
    end
  
    --获取正在运行的场景
    local runningScene  =  cc.Director:getInstance():getRunningScene()
    --创建弹出面板
    local popPanel      =  require(PopPanelConf[showLayerType]).new(args) 
    --控制器加锁
    self.isLock  = true
    --加锁原因
    self.lockByReason  = string.formate(popPanel.__cname.."isShow")
    --弹出层的 层级设置为最高层级
    runningScene:addChild(popPanel,popPanelZorder)
    --当前显示的Layer 
    self.currentShowLayer = popPanel
    --注册事件监听
    self:addEventListener(popPanel.__cname)
end



--当弹出层被清理的时候回调
function PopPanelManager:onEventCallBack()
  --弹出层解锁
    self.isLock             = false 
  --加锁原因置空  
    self.lockByReason       = nil
  --当前显示的弹出面板为空  
    self.currentShowLayer   = nil


end


function PopPanelManager:clear()
  self:safeRelease(self)
  instance = nil 
end


function PopPanelManager:showLockByReason()
  print("Layer is Lock for "..self.lockByReason)
end



function PopPanelManager:safeRetain(obj)
   if obj and obj.retain() then
   obj:retain()
   end
end


function PopPanelManager:getLockByReason()
  return  self.lockByReson   
end


function PopPanelManager:isLock()
    return self.isLock
end


function PopPanelManager:removeLayer()



end


function PopPanelManager:lockByKey(key,reason)
if not self.key and self.isLock then
      print("[ERROR]: the current Scene isn't locked ")
      return 
end

if not reason then
print("[ERROR]: reason is null ")
      return 
end

-- key 
self.key = key 

--给场景加锁
self.isLock  = true 

--加锁原因
self.lockByReason =  reason

end




--解锁
function PopPanelManager:unLockByKey(key)
    if not self.key  and self.isLock then
      print("[ERROR]: the current Scene isn't locked ")
      return 
    end
--解锁
    if key == self.key then
    self.isLock  = false  
    self.key = nil
    self.lockByReason = nil
-- 查看队列中是否有等待的弹出面板
    if table.getn(self.popPanelArray)~= 0 then
     --队列最前端的Layer 
       local layerMessage = self.popPanelArray[1]
     --将Layer从队列中移除出去  
       table.remove(self.popPanelArray,1) 
     --显示弹出层  
        self:showLayer(layerMessage[1],layerMessage[2])
    end
    
    else 
       print("[ERROR]: Invalid key value")
    end
end

--强力解锁
function PopPanelManager:unLockByPower()
  print("[WARING]: This function maybe distroy PanelManager")
   self.isLock = false
end


--立即显示弹出层，无视是否加锁，第一个参数为弹出层的类型，第三个参数是 是否关闭当前的弹出层
function PopPanelManager:showLayerAtOnce(ShowLayerType,args,isClose)
     self.isLock = false 
     if isClose then
       self.currentShowLayer:removeFromParent()
     end
     self:showLayer(showLayerType,args)
end



function PopPanelManager:addEventListener(eventName, callback)
    self.eventListenrs[eventName] = callback
end

function PopPanelManager:removeEventListener(eventName)
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


function PopPanelManager:safeRelease(obj)
   if obj and obj.release() then
   	obj:release()
   end
end



return PopPanelManager
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

function tool.delayTimeCallBack(time,func)
   local Node  = cc.Node:create()
   cc.Director:getInstance():getRunningScene():addChild(Node)
   local delayTime   = cc.DelayTime:create(time)
   local callFunc    = cc.CallFunc:create(func)
   Node:runAction(cc.Sequence:create(delayTime,callFunc))
end



function  tool.getChildByName(root,name)
    -- if (!root)
    -- {
    --     return nullptr;
    -- }
    -- if (root->getName() == name)
    -- {
    --     return root;
    -- }
    -- const auto& arrayRootChildren = root->getChildren();
    -- for (auto& subWidget : arrayRootChildren)
    -- {
    --     Widget* child = dynamic_cast<Widget*>(subWidget);
    --     if (child)
    --     {
    --         Widget* res = seekWidgetByName(child,name);
    --         if (res != nullptr)
    --         {
    --             return res;
    --         }
    --     }
    -- }
    -- return nullptr;

    if not root then 
     return 
    end

    if root:getName() == name then 
     return root 
    end
    local rootArray  = root:getChildren()
    for i = 1,#rootArray do 
        local child = rootArray[i]
        if child then
          local res =tool.getChildByName(child,name)
            if res then 
              return res
            end
        end
    end
end


-- 删除table中的元素  
local function removeElementByKey(tbl,key)  
    --新建一个临时的table  
    local tmp ={}  
  
    --把每个key做一个下标，保存到临时的table中，转换成{1=a,2=c,3=b}   
    --组成一个有顺序的table，才能在while循环准备时使用#table  
    for i in pairs(tbl) do  
        table.insert(tmp,i)  
    end  
  
    local newTbl = {}  
    --使用while循环剔除不需要的元素  
    local i = 1  
    while i <= #tmp do  
        local val = tmp [i]  
        if val == key then  
            --如果是需要剔除则remove   
            table.remove(tmp,i)  
         else  
            --如果不是剔除，放入新的tabl中  
            newTbl[val] = tbl[val]  
            i = i + 1  
         end  
     end  
    return newTbl  
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



--- 应该是所有的组件都可以使用吧，其实还是主要争对的是cc组件
function tool.addTouchEventListener(node,callFunc)
       --创建一个单点触屏事件  
       local listener = cc.EventListenerTouchOneByOne:create()  
       --注册触屏开始事件  
      listener:registerScriptHandler(callFunc,cc.Handler.EVENT_TOUCH_BEGAN)
      listener:registerScriptHandler(callFunc,cc.Handler.EVENT_TOUCH_MOVED )
      listener:registerScriptHandler(callFunc,cc.Handler.EVENT_TOUCH_ENDED )
      listener:registerScriptHandler(callFunc,cc.Handler.EVENT_TOUCH_CANCELLED )
       local eventDispatcher = cc.Director:getInstance():getEventDispatcher()  
      --事件派发器 注册一个node事件  
       eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)  
end



function tool.registerScriptHandler(node,callFunc)
   node:registerScriptHandler(callFunc)
end


return tool






local resTool  = class("resTool")

function resTool.addResource(plistPath,pngPath)
   local spriteFrame = cc.SpriteFrameCache:getInstance()
   spriteFrame:addSpriteFrames(plistPath,pngPath)
end


function resTool.getUIFromJsonFile(FilePath)
local uiNode = ccs.GUIReader:getInstance():widgetFromJsonFile(FilePath)
   return uiNode


end


return resTool
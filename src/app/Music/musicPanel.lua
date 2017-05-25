--
-- Author: chenrh
-- Date: 2017-05-23 22:25:55
--

local resTool           = require("Tools/resTool")
local MusicPanel  =  class("MusicPanel",function()
return cc.Layer:create()
end)

local MUSIC_FILE = "sound/Synth.mp3"
local isSelectedMusic = true

---手撸一个界面。
function MusicPanel:ctor(args)
  self.args = args
  self:registerScriptHandler(handler(self,self.eventHandler))

end


function MusicPanel:eventHandler(event)
    if event == "enter" then
     self:onEnter()
    elseif event == "exit" then
     self:onExit()
    elseif event =="cleanup"then
     self:onCleanup()
    end
end

function MusicPanel:initBg()
  self.bgLayer = cc.Sprite:create("music/bg.png")
  -- self.bgLayer:setScale(0.5)
  self:addChild(self.bgLayer)
end

function MusicPanel:initUI()
  

    local lbSoundEffect = cc.Label:createWithTTF("SoundEffect:","Font/arial.ttf",18)
    lbSoundEffect:setPosition(self.bgLayer:getContentSize().width/2-20,self.bgLayer:getContentSize().height/2+20)
    self.bgLayer:addChild(lbSoundEffect)

      -- 音效
    local soundEffOnMenuItem = cc.MenuItemImage:create("music/on.png", "music/on.png")
    local soundEffOffMenuItem = cc.MenuItemImage:create("music/off.png", "music/off.png")
    self.soundEffToggleMenuItem = cc.MenuItemToggle:create(soundEffOnMenuItem, soundEffOffMenuItem)
    self.soundEffToggleMenuItem:setPosition(self.bgLayer:getContentSize().width/2+80,self.bgLayer:getContentSize().height/2+20)
    self.soundEffToggleMenuItem:setScale(0.25)
    self.soundEffToggleMenuItem:registerScriptTapHandler(handler(self,self.onTouchSoundEffItemCallBack))

    local lbBackgoundMusic = cc.Label:createWithTTF("BackgoundMusic:","Font/arial.ttf",18)
    lbBackgoundMusic:setPosition(self.bgLayer:getContentSize().width/2-20,self.bgLayer:getContentSize().height/2-50)
    self.bgLayer:addChild(lbBackgoundMusic)

    ---背景音
    local soundBgOnMenuItem = cc.MenuItemImage:create("music/on.png", "music/on.png")
    local soundBgOffMenuItem = cc.MenuItemImage:create("music/off.png", "music/off.png")
    self.soundBgToggleMenuItem = cc.MenuItemToggle:create(soundBgOnMenuItem, soundBgOffMenuItem)
    self.soundBgToggleMenuItem:setPosition(self.bgLayer:getContentSize().width/2+80,self.bgLayer:getContentSize().height/2-50)
    self.soundBgToggleMenuItem:setScale(0.25)
    self.soundBgToggleMenuItem:registerScriptTapHandler(handler(self,self.onTouchSoundItemCallBack))

    local okMenuItem = cc.MenuItemImage:create(
        "music/ok-down.png",
        "music/ok-up.png")
    okMenuItem:setPosition(self.bgLayer:getContentSize().width/2,self.bgLayer:getContentSize().height/2-98)
    okMenuItem:setScale(0.3)
    okMenuItem:registerScriptTapHandler(handler(self,self.onTouchOkBtnCallBack))

    local menu = cc.Menu:create()
    menu:setPosition(cc.p(0,0))
    menu:addChild(self.soundEffToggleMenuItem)
    menu:addChild(self.soundBgToggleMenuItem)
    menu:addChild(okMenuItem)
    self.bgLayer:addChild(menu)
end


function MusicPanel:onTouchOkBtnCallBack()
    self:removeFromParent()
end


function MusicPanel:onTouchSoundEffItemCallBack(sender)
end



function MusicPanel:onTouchSoundItemCallBack(sender,toutType)
    if self.soundBgToggleMenuItem:getSelectedIndex() == 1 then
    AudioEngine.stopMusic()
    else
    AudioEngine.playMusic(MUSIC_FILE,true)
    end
end


function MusicPanel:onEnter()
  self:initBg()
  self:initUI()
end



function MusicPanel:onCleanup()


end


function MusicPanel:onExit()

end


function MusicPanel:init()


end


return MusicPanel
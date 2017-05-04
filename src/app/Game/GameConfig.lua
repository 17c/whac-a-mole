--
-- Author: chenrh
-- Date: 2017-04-23 08:55:41
--



local GameConfig = class("GameConfig")



--游戏的关卡数量  积分
local stage  =  {
	[1]   = 1000,
	[2]   = 2000,
	[3]   = 3000,
    [4]   = 5000,
    [5]   = 7000,
    [6]   = 9000,
    [7]   = 10000,
    [8]   = 11000,
    [9]   = 14000,
    [10]   = 18000,
    [11]   = 20000,
    [12]   = 21000,
}

--不同关卡的游戏速度（游戏速度的倍数 越小越快）
local  stageSpeed  ={
	[1]   = 1.0,
	[2]   = 0.8,
	[3]   = 0.7,
    [4]   = 0.6,
    [5]   = 0.5,
    [6]   = 0.5,
    [7]   = 0.5,
    [8]   = 0.3,
    [9]   = 0.3,
    [10]   = 0.3,
    [11]   = 0.3,
    [12]   = 0.3,
}


local buff = {
    [1]  = 1.1,
    [2]  = 1.2,
    [3]  = 1.3,
    [4]  = 1.4,
    [5]  = 1.5,
    [6]  = 1.6,
}

function GameConfig.getStageScore(stageNumber)
   return stage[stageNumber]
end

function GameConfig.getStageSpeed(stageNumber)
   return stageSpeed[stageNumber]
end

function GameConfig.getBuff(buffNumber)
    return buff[buffNumber]
end

return GameConfig
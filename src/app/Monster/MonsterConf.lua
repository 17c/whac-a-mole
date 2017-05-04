--
-- Author: chenrh
-- Date: 2017-04-11 22:59:01
--



local MonsterConf  = class("MonsterConf")


MonsterConf.MonsterResource ={
  [1]   = {"mouse_1.png","mouse_2.png"},
  [2]   = {"rabbit_1.png","rabbit_2.png"},
  [3]   = {"tigger_1.png","tigger_2.png"},
  [4]   = {"hamster_1.png","hamster_2.png"},
  [5]   = {"panda_1.png","panda_2.png"}
}



MonsterConf.MonsterReward = {
  [1]   =  100,
  [2]   = -100,
  [3]   =  500,
  [4]   = "+10s",
  [5]   = "-10s",

}

function MonsterConf.initData(MonsterType)
  local list = {}
  list.reward = MonsterConf.MonsterReward[MonsterType]
  list.resource    = MonsterConf.MonsterResource[MonsterType]

   return list
end

return MonsterConf




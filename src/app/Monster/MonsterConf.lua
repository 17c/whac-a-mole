--
-- Author: chenrh
-- Date: 2017-04-11 22:59:01
--



local MonsterConf  = class("MonsterConf")


MonsterConf.MonsterType ={
  Mouse   = 1,
  Rabbit  = 2,
  Tigger  = 3,
  Hamster = 4,
  Panda   = 5
}

MonsterConf.MonsterResource ={
  [MonsterConf.MonsterType.Mouse]   = {"mouse_1.png","mouse_2.png"},
  [MonsterConf.MonsterType.Rabbit]  = {"rabbit_1.png","rabbit_2.png"},
  [MonsterConf.MonsterType.Tigger]  = {"tigger_1.png","tigger_2.png"},
  [MonsterConf.MonsterType.Hamster] = {"hamster_1.png","hamster_2.png"},
  [MonsterConf.MonsterType.Panda]   = {"panda_1.png","panda_2.png"}
}

MonsterConf.MonsterState = {
  normal  = 1 ,
  fear    = 2 
}
MonsterConf.MonsterReward = {
  [MonsterConf.MonsterType.Mouse]   = "buff1",
  [MonsterConf.MonsterType.Rabbit]  = "buff2",
  [MonsterConf.MonsterType.Tigger]  = 500,
  [MonsterConf.MonsterType.Hamster] = 100,
  [MonsterConf.MonsterType.Panda]   = -100


}

function MonsterConf.initData(MonsterType)
  local list = {}
  list.reward = MonsterConf.MonsterReward[MonsterType]
  list.resource    = MonsterConf.MonsterResource[MonsterType]

   return list
end

return MonsterConf




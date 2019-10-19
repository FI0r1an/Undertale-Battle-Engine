local UTB = {}
local json = require( "lib/json" )
function UTB:New()
  local a = setmetatable({}, self)
  self.__index = self
  a.New = nil
  return a
end

UTB.Circle = require("src/circle")
UTB.Button = require("src/button")
UTB.Box = require("src/box")
UTB.Heart = require("src/heart")
UTB.Dialogue = require("src/dialogue")
UTB.Turn = require("src/turn")
UTB.TurnManager = require("src/turn_manager")
UTB.Collision = require"src/collision"
UTB.Background = {
  Update = function (dt)
    
  end,
  Draw = function ()
    
  end
}
UTB.Boss = {
  BossAlive = 0,
  Add = function( boss )
    UTB.Boss.BossAlive = UTB.Boss.BossAlive + 1
    table.insert( UTB.Boss.Boss, boss )
  end,
  Boss = {},
  Dialogue = {},
  Update = function ( dt )
    for k,v in pairs( UTB.Boss.Boss ) do
      v:Update( dt )
      if v.Health <= 0 and not v.IsDead and not UTB.Button.Pressed then
        v:Dead()
      end
      if v.Health <= 0 and #v.Circle.cir <= 0 and not v.Count then
        UTB.Boss.BossAlive = UTB.Boss.BossAlive - 1
        v.Count = true
      end
    end
    if UTB.Boss.BossAlive <= 0 and not UTB.Boss.End then
      UTB.Boss.End = true
      GLOBAL_TURN_MANAGER.CurrentTurn = UTB.Turn:New()
      GLOBAL_DIALOGUE:Init("* You won.", GLOBAL_UT_BATTLE.Font, 1)
      GLOBAL_DIALOGUE:Reset()
      GLOBAL_DIALOGUE.x,GLOBAL_DIALOGUE.y = 40, 270
    end
    if UTB.Boss.BossAlive <= 0 then
      Turn = true
      if GLOBAL_DIALOGUE.Done then
        love.event.quit()
      end
    end
  end,
  End = false,
  Draw = function ()
    for k,v in pairs( UTB.Boss.Boss ) do
      v:Draw()
    end
  end
}
UTB.BossObject = require("src/boss")

function UTB:Shake(r, x, y)
  love.window.setPosition(x + love.math.random(-r/2,r/2), y+love.math.random(-r/2,r/2))
end

function UTB:Play(name)
  local path = "mod/" .. name .. "/"
  local file = love.filesystem.newFile(path .. "battle.json", "r")
  local data = file:read( file:getSize() )
  file:release()
  data = json.decode( data )
  UTB.Data = data
  love.window.setTitle("Loading")
  for k,v in pairs( data ) do
    if k == "GLOBAL_SETTING" then
      for _,V in pairs( v ) do
        _G[_] = V
      end
    elseif k == "Boss" then
      for __,VV in pairs( v ) do
        local boss = UTB.BossObject:New()
        for _,V in pairs( VV ) do
          boss[_] = V
        end
        boss.Name = __
        boss.OriX, boss.OriY = boss.x, boss.y
        boss.Update = require( path .. __ .. "/Update" )
        boss.Draw = require( path .. __ .. "/Draw" )
        boss.Init = require( path .. __ .. "/Init" )
        boss:Init(path .. __ .. "/")
        UTB.Boss.Add( boss )
      end
    end
  end
  require(path .. "init")(path)
end

function UTB.Print(str, x, y)
  love.graphics.print(str, x, y)---love.graphics.getFont():getHeight()/2)
end

GLOBAL_UT_BATTLE = UTB:New()
GLOBAL_UT_BATTLE.Font = love.graphics.newImageFont( "res/font.png", [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]] )
GLOBAL_UT_BATTLE.FontScale = 1
GLOBAL_UT_BATTLE.Font:setFilter( "nearest", "nearest", 1 )

GLOBAL_TURN_MANAGER = UTB.TurnManager:New()

return UTB
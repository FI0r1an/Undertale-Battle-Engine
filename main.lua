love.graphics.setDefaultFilter( "nearest", "nearest", 1 )
GLOBAL_UT_BATTLE = require("src/init"):New()
GLOBAL_UT_BATTLE.Font = love.graphics.newImageFont( "res/font.png", [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]] )
GLOBAL_UT_BATTLE.FontScale = 1
GLOBAL_UT_BATTLE.Font:setFilter( "nearest", "nearest", 1 )
PLAYER_NAME = "cluck"
PLAYER_LEVEL = 1
Turn = true
Player = {
  Health = 20,
  MaxHealth = 20,
  Kr = 0,
  MaxKr = 0,
  Damage = 15,
  Item = { [1]="Dog", [2]="Dogg", [3]="Doggg" },
  ItemHealth = { [1]=50, [2]=10, [3]=50 }
}
GLOBAL_DIALOGUE = require( "src/dialogue" ):New(GLOBAL_BATTLE_DIALOGUE)
GLOBAL_DIALOGUE.x,GLOBAL_DIALOGUE.y = 40, 270

function love.update( dt )
  GLOBAL_UT_BATTLE.Button.Update( dt )
  GLOBAL_UT_BATTLE.Heart:Update( dt )
  GLOBAL_DIALOGUE:Update( dt )
  GLOBAL_UT_BATTLE.Boss.Update( dt )
  Turn = true
end

function love.draw()
  GLOBAL_UT_BATTLE.Box.Draw()
  GLOBAL_DIALOGUE:Draw()
  GLOBAL_UT_BATTLE.Boss.Draw()
  GLOBAL_UT_BATTLE.Button.Draw()
  GLOBAL_UT_BATTLE.Heart:Draw()
end

function love.keypressed( k )
  GLOBAL_UT_BATTLE.PressedKey = k
  GLOBAL_UT_BATTLE.Button.KeyPressed( k )
end

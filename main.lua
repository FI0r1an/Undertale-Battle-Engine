love.graphics.setDefaultFilter( "nearest", "nearest", 1 )
tween = require"lib/tween"
require"src/init"

MobileAlpha = 0
MobileMode = false
local sys = love.system.getOS()
if sys == "iOS" or sys == "Android" then
  MobileMode = true
  MobileAlpha = .25
  Joystick = require"mobile/joystick":New()
  Button = require"mobile/joystick":New()
  Button.ButtonActive = 1
  Button.Size = 45
  Button.ButtonSize = 45
  Button:SetPosition(520, 240)
  function Button:ButtonEvent()
    GLOBAL_UT_BATTLE.PressedKey = "z"
    if GLOBAL_UT_BATTLE.Boss.BossAlive >= 1 then
      GLOBAL_UT_BATTLE.Button.KeyPressed( "z" )
    end
    self.id = nil
  end
  Button1 = require"mobile/joystick":New()
  Button1.ButtonActive = 1
  Button1.Size = 45
  Button1.ButtonSize = 45
  Button1:SetPosition(520, 360)
  function Button1:ButtonEvent()
    GLOBAL_UT_BATTLE.PressedKey = "x"
    if GLOBAL_UT_BATTLE.Boss.BossAlive >= 1 then
      GLOBAL_UT_BATTLE.Button.KeyPressed( "x" )
    end
    self.id = nil
  end
end

Key = {
  Up = "up",
  Left = "left",
  Right = "right",
  Down = "down",
  Enter = "z",
  Exit = "x"
}

function DrawOutline()
  love.graphics.setColor( 0, 0, 0, 1 )
  love.graphics.rectangle( 'fill', GLOBAL_UT_BATTLE.Box.x+GLOBAL_UT_BATTLE.Box.LineWidth, GLOBAL_UT_BATTLE.Box.y+GLOBAL_UT_BATTLE.Box.LineWidth, GLOBAL_UT_BATTLE.Box.Width-GLOBAL_UT_BATTLE.Box.LineWidth*2, GLOBAL_UT_BATTLE.Box.Height-GLOBAL_UT_BATTLE.Box.LineWidth*2 )
  love.graphics.setColor(1, 1, 1, 1)
end

--Key.Up Key.Left Key.Right Key.Down Key.Enter Key.Exit
PLAYER_NAME = "chara"
PLAYER_LEVEL = 19
if Turn == nil then
  Turn = true
end
Player = {
  Health = 92,
  MaxHealth = 92,
  Kr = 0,
  MaxKr = 0,
  Damage = 10,
  MinDamage = 10,
  Item = { [1]="PI", [2]="Pie", [3]="Pie" },
  ItemHealth = { [1]=-3.1415926, [2]=50, [3]=50 },
  Dead = function ()
    love.event.quit()
  end,
  KrTime = 0,
  KrUpdate = function (dt)
    Player.KrTime = Player.KrTime + dt
    if Player.KrTime >= 1 then
      Player.KrTime = 0
    end
    if math.floor(Player.KrTime*10) >= 4 and math.floor(Player.KrTime*10) < 5 then
      if Player.Health > 1 then
        Player.Health = Player.Health - 1
        Player.Kr = Player.Kr + 1
      else
        Player.Kr = Player.Kr - 1
        if Player.Health <= 1 then
          Player.Health = 0
        end
      end
    end
  end,
  Hurt = function (d,dt)
    Player.KrUpdate(dt)
    Player.Health = Player.Health - d
  end
}

GLOBAL_UT_BATTLE:Play("sans")

GLOBAL_DIALOGUE = require( "src/dialogue" ):New(GLOBAL_BATTLE_DIALOGUE, GLOBAL_UT_BATTLE.Font, 1)
GLOBAL_DIALOGUE.x,GLOBAL_DIALOGUE.y = 40, 270
GLOBAL_DIALOGUE.Done = not Turn

Depth = {
  {Draw = DrawOutline},
  {Draw = GLOBAL_TURN_MANAGER.Draw, Parent = GLOBAL_TURN_MANAGER},
  {Draw = GLOBAL_UT_BATTLE.Box.Draw},
  {Draw = GLOBAL_DIALOGUE.Draw, Parent = GLOBAL_DIALOGUE},
  {Draw = GLOBAL_UT_BATTLE.Boss.Draw},
  {Draw = GLOBAL_UT_BATTLE.Button.Draw},
  {Draw = GLOBAL_UT_BATTLE.Heart.Draw, Parent = GLOBAL_UT_BATTLE.Heart},
  {Draw = GLOBAL_TURN_MANAGER.FrontDraw, Parent = GLOBAL_TURN_MANAGER},
}

love.window.setTitle("Undertale")
shader = love.graphics.newShader([[
vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
  vec4 tcolor = vec4(1,1,1,0.5);
	int seg = 4;
  float s = 0.015;
  vec4 texture = Texel(tex, texture_coords)*vec4(0.2,0.2,0.2,1);
	return color*texture;
}
]])

function love.update( dt )
  gdt = dt
  GLOBAL_UT_BATTLE.Button.Update( gdt )
  GLOBAL_UT_BATTLE.Heart:Update( gdt )
  GLOBAL_DIALOGUE:Update( gdt )
  GLOBAL_UT_BATTLE.Boss.Update( gdt )
  GLOBAL_UT_BATTLE.Box.Update(gdt)
  GLOBAL_TURN_MANAGER:Update(gdt)
  --Turn = true
  --GLOBAL_UT_BATTLE:Shake(50, x, y)
  if Player.Health <= 0 then
    Player:Dead()
  end
  --GLOBAL_UT_BATTLE.Background.Update(dt)
  collectgarbage("collect")
end

function love.draw()
  --love.graphics.setShader(shader)
  for k,v in ipairs(Depth) do
    v.Draw(v.Parent)
  end
  --[[love.graphics.setShader()
  GLOBAL_UT_BATTLE.Background.Draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(GLOBAL_UT_BATTLE.Font)
  love.graphics.printf("Sudden Changes",320-168,210,168*2,"center")
  love.graphics.printf("子弹地狱",320-60,240,120,"center")]]
end

function love.keypressed( k )
  GLOBAL_UT_BATTLE.PressedKey = k
  if GLOBAL_UT_BATTLE.Boss.BossAlive >= 1 then
    GLOBAL_UT_BATTLE.Button.KeyPressed( k )
  end
end

function love.keyreleased( k )
  GLOBAL_UT_BATTLE.ReleasedKey = k
end

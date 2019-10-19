

local function CutImage( image, w, h )
    local q = {}

    for i = 1, h do
        for j = 1, w do
            local nq = love.graphics.newQuad(
                (j-1)*image:getWidth()/w, (i-1)*image:getHeight()/h,
                image:getWidth()/w, image:getHeight()/h,
                image:getWidth(), image:getHeight()
            )
            table.insert( q, nq )
        end
    end

    image:release()

    return q
end

local Button = {}
function Button.Reset()
  Button.TargetChoiceState = 1
  Button.Pressed = false
  Button.TargetX1 = 0
  Button.TargetValue = 0
  Button.TargetDir = love.math.random(1, 2)
  if Button.TargetDir == 1 then
    Button.TargetX = 610-10
  else
    Button.TargetX = 30
  end
  Button.SliceState = 1
  Button.Sin = 0
  Button.TargetWidth = 1
  Button.TargetY = 0
  Button.x = 0
  Button.y = 0
  Button.Choice = 1
  Button.MenuChoice = 1
  Button.MenuSecChoice = 1
  Button.MenuState = 1
  for k, v in pairs(Button.Button) do
    v.CurFrame = 1
  end
end
Button.Pressed = false
Button.Target = love.graphics.newImage("res/spr_target_0.png")
Button.TargetChoiceState = 1
Button.TargetValue = 0
Button.TargetDir = love.math.random(1, 2)
if Button.TargetDir == 1 then
  Button.TargetX = 610-10
else
  Button.TargetX = 30
end
Button.Slice = {
  love.graphics.newImage("res/spr_slice_o_0.png"),
  love.graphics.newImage("res/spr_slice_o_1.png"),
  love.graphics.newImage("res/spr_slice_o_2.png"),
  love.graphics.newImage("res/spr_slice_o_3.png"),
  love.graphics.newImage("res/spr_slice_o_4.png"),
  love.graphics.newImage("res/spr_slice_o_5.png")
}
Button.SliceState = 1
Button.TargetWidth = 1
Button.TargetY = 0
Button.Damage = love.graphics.newFont("res/damage.TTF", 40)
Button.TargetChoice = {love.graphics.newImage("res/spr_targetchoice_0.png"), love.graphics.newImage("res/spr_targetchoice_1.png")}

Button.Button = {
    {
        Image = love.graphics.newImage( "res/spr_fight_strip2.png" ),
        ImageFrame = 2,
        CurFrame = 2,
        Quad = CutImage( love.graphics.newImage( "res/spr_fight_strip2.png" ), 2, 1 )
    },
    {
        Image = love.graphics.newImage( "res/spr_act_strip2.png" ),
        ImageFrame = 2,
        CurFrame = 1,
        Quad = CutImage( love.graphics.newImage( "res/spr_act_strip2.png" ), 2, 1 )
    },
    {
        Image = love.graphics.newImage( "res/spr_item_strip2.png" ),
        ImageFrame = 2,
        CurFrame = 1,
        Quad = CutImage( love.graphics.newImage( "res/spr_item_strip2.png" ), 2, 1 )
    },
    {
        Image = love.graphics.newImage( "res/spr_mercy_strip2.png" ),
        ImageFrame = 2,
        CurFrame = 1,
        Quad = CutImage( love.graphics.newImage( "res/spr_mercy_strip2.png" ), 2, 1 )
    }
}
Button.AllButtons = #Button.Button
Button.x = 0
Button.y = 0
Button.Choice = 1
Button.MenuChoice = 1
Button.MenuSecChoice = 1
Button.MenuState = 1
Button.Sin = 0
Button.DamageValue = "MISS"
Button.DamageColor = {.9,.9,.9,1}
Button.TargetX1 = 0
Button.List = {
  "Fight",
  "Act",
  "Item",
  "Mercy"
}
Button.Fight = {
  Update = function( dt )
    local h = GLOBAL_UT_BATTLE.Heart
    
    if Button.MenuState == 1 then
      h.x = 60
      h.y = (Button.MenuChoice - 1)*40 + 278
      if GLOBAL_UT_BATTLE.PressedKey == Key.Down then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuChoice + 1 <= #GLOBAL_UT_BATTLE.Boss.Boss then
          Button.MenuChoice = Button.MenuChoice + 1
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Up then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuChoice - 1 >= 1 then
          Button.MenuChoice = Button.MenuChoice - 1
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Enter then
        GLOBAL_UT_BATTLE.PressedKey = nil
        Button.MenuState = 2
      end
    elseif Button.MenuState == 2 then
      h.x, h.y = Button.x + 32 + (46+Button.Button[Button.Choice].Image:getWidth()/Button.Button[Button.Choice].ImageFrame) * (Button.Choice-1) + 8,
      Button.y + 430 + 12
      Button.TargetValue = Button.TargetValue + dt*20
      if Button.TargetDir == 1 then
        Button.TargetX = Button.TargetX - Button.TargetValue
      else
        Button.TargetX = Button.TargetX + Button.TargetValue
      end
      if Button.TargetX > 610 or Button.TargetX < 10 then
        Button.DamageValue = "MISS"
        Button.DamageColor = {.9,.9,.9,1}
        Button.MenuState = 4
        GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice]:MissEvent()
      end
      if GLOBAL_UT_BATTLE.PressedKey == Key.Enter then
        Button.MenuState = 3
        if GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].CanMiss then
          Button.DamageValue = "MISS"
          Button.DamageColor = {.9,.9,.9,1}
        else
          Button.DamageValue = Player.Damage
          Button.DamageColor = {1,0,0,1}
        end
        
        GLOBAL_UT_BATTLE.PressedKey = nil
      end
    elseif Button.MenuState == 3 then
      Button.TargetChoiceState = Button.TargetChoiceState + dt*10
      if Button.TargetChoiceState > 3 then
        Button.TargetChoiceState = 1
      end
      if Button.SliceState >= #Button.Slice+1 then
        Button.MenuState = 4
        GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice]:FightEvent()
      end
      Button.SliceState = Button.SliceState + dt*10
    elseif Button.MenuState == 4 then
      local b = GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice]
      if not tonumber(Button.DamageValue) then
        b:Hurt(0)
      else
        Button.DamageValue = math.max(Player.MinDamage, math.floor(Player.Damage * math.abs(1-math.abs(Button.TargetX-290)/580)))
        b:Hurt(Button.DamageValue)
      end
      b:Shake()
      Button.TargetY = b.OriY
      Button.TargetValue = 0
      Button.TargetX1 = b.OriX
      Button.MenuState = 5
    elseif Button.MenuState == 5 then
      Button.TargetChoiceState = Button.TargetChoiceState + dt*20
      if Button.TargetChoiceState > 3 then
        Button.TargetChoiceState = 1
      end
      if Button.TargetValue >= dt*30 then
        Button.TargetValue = Button.TargetValue + dt
        if Button.TargetWidth <= 0 then
          Button.Reset()
          Turn = false
        end
        Button.TargetWidth = Button.TargetWidth - dt*1.5
      else
        if Button.TargetY > GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].OriY then else
          Button.Sin = Button.Sin + dt*2
          Button.TargetY = GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].OriY+1 - math.abs(math.sin(Button.Sin)*50)
        end
        if GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].State == "Idle" then
          Button.TargetValue = Button.TargetValue + dt*2
        end
      end
    end
  end,
  Draw = function ()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont( GLOBAL_UT_BATTLE.Font )
    if Button.MenuState == 1 then
      for k,v in pairs( GLOBAL_UT_BATTLE.Boss.Boss ) do
        GLOBAL_UT_BATTLE.Print( "* " .. v.Name, 96, 230 + k*40 )
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle('fill', 280, 240+k*40-3, v.MaxHealth, 20)
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.rectangle('fill', 280, 240+k*40-3, v.Health, 20)
        love.graphics.setColor(1, 1, 1, 1)
      end
    elseif Button.MenuState >= 2 then
      love.graphics.setColor(1, 1, 1, Button.TargetWidth)
      love.graphics.draw(Button.Target, 320-Button.Target:getWidth()*Button.TargetWidth/2, GLOBAL_UT_BATTLE.Box.y+GLOBAL_UT_BATTLE.Box.LineWidth*2.5, 0, Button.TargetWidth, 1)
      love.graphics.setColor(1, 1, 1, 1)
      if Button.MenuState <= 5 then
        love.graphics.draw(Button.TargetChoice[math.min(#Button.TargetChoice+1, math.floor(Button.TargetChoiceState))], Button.TargetX, GLOBAL_UT_BATTLE.Box.y+GLOBAL_UT_BATTLE.Box.LineWidth)
      end
    end
    if Button.MenuState == 3 then
      love.graphics.draw(Button.Slice[math.min(#Button.Slice, math.floor(Button.SliceState))], GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].OriX-19, GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].OriY-77, 0, 1.5)
    end
    if Button.MenuState == 5 then
      love.graphics.setFont(Button.Damage)
      love.graphics.setColor(unpack(Button.DamageColor))
      GLOBAL_UT_BATTLE.Print(Button.DamageValue, Button.TargetX1-Button.Damage:getWidth("a")*#tostring(Button.DamageValue)/2, Button.TargetY)
    end
  end
}
Button.Act = {
  Update = function( dt )
    local h = GLOBAL_UT_BATTLE.Heart
    
    if Button.MenuState == 1 then
      h.x = 60
      h.y = (Button.MenuChoice - 1)*40 + 278
      if GLOBAL_UT_BATTLE.PressedKey == Key.Down then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuChoice + 1 <= #GLOBAL_UT_BATTLE.Boss.Boss then
          Button.MenuChoice = Button.MenuChoice + 1
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Up then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuChoice - 1 >= 1 then
          Button.MenuChoice = Button.MenuChoice - 1
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Enter then
        GLOBAL_UT_BATTLE.PressedKey = nil
        Button.MenuState = 2
      end
    elseif Button.MenuState == 2 then
      if Button.MenuSecChoice % 2 == 0 then
        h.x = 320
      else
        h.x = 60
      end
      h.y = (math.ceil(Button.MenuSecChoice/2)-1)*40 + 278
      if GLOBAL_UT_BATTLE.PressedKey == Key.Up then
        if Button.MenuSecChoice - 2 >= 1 then
          Button.MenuSecChoice = Button.MenuSecChoice - 2
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Down then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuSecChoice + 2 <= #GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].ActOption then
          Button.MenuSecChoice = Button.MenuSecChoice + 2
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Left then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuSecChoice - 1 >= 1 then
          Button.MenuSecChoice = Button.MenuSecChoice - 1
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Right then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuSecChoice + 1 <= #GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].ActOption then
          Button.MenuSecChoice = Button.MenuSecChoice + 1
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Enter then
        GLOBAL_UT_BATTLE.PressedKey = nil
        h.x, h.y = Button.x + 32 + (46+Button.Button[Button.Choice].Image:getWidth()/Button.Button[Button.Choice].ImageFrame) * (Button.Choice-1) + 8,
        Button.y + 430 + 12
        GLOBAL_DIALOGUE:Init( GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].ActOption[Button.MenuSecChoice].Dialogue() )
        GLOBAL_DIALOGUE.x,GLOBAL_DIALOGUE.y = 40, 270
        GLOBAL_DIALOGUE:Reset()
        Button.MenuState = 3
      end
    elseif Button.MenuState == 3 then
      if GLOBAL_DIALOGUE.Done then
        GLOBAL_DIALOGUE:Init( GLOBAL_BATTLE_DIALOGUE )
        GLOBAL_DIALOGUE.x,GLOBAL_DIALOGUE.y = 40, 270
        GLOBAL_DIALOGUE:Reset()
        GLOBAL_DIALOGUE.Done = true
        GLOBAL_DIALOGUE.Char = {}
        GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].ActOption[Button.MenuSecChoice].Time = GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].ActOption[Button.MenuSecChoice].Time + 1
        GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].ActOption[Button.MenuSecChoice].Event()
        Turn = false
        Button.Reset()
      end
    end
  end,
  Draw = function ()
    love.graphics.setFont( GLOBAL_UT_BATTLE.Font )
    if Button.MenuState == 1 then
      for k,v in pairs( GLOBAL_UT_BATTLE.Boss.Boss ) do
        GLOBAL_UT_BATTLE.Print( "* " .. v.Name, 96, 230 + k*40 )
      end
    elseif Button.MenuState == 2 then
      for k,v in ipairs( GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].ActOption ) do
        if k % 2 == 0 then
          GLOBAL_UT_BATTLE.Print( "* " .. v.Name, 356, (math.ceil(k/2)-1)*40 + 270 )
        else
          GLOBAL_UT_BATTLE.Print( "* " .. v.Name, 96, (math.ceil(k/2)-1)*40 + 270 )
        end
      end
    end
  end
}
Button.Item = {
  Update = function( dt )
    if #Player.Item == 0 then
      Button.Reset()
    end
    local h = GLOBAL_UT_BATTLE.Heart
    if Button.MenuState == 1 then
      if Button.MenuChoice % 2 == 0 then
        h.x = 320
      else
        h.x = 60
      end
      h.y = (math.ceil(Button.MenuChoice/2)-1)*40 + 278
      if GLOBAL_UT_BATTLE.PressedKey == Key.Up then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuChoice - 2 >= 1 then
          Button.MenuChoice = Button.MenuChoice - 2
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Down then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuChoice + 2 <= #Player.Item then
          GLOBAL_UT_BATTLE.PressedKey = nil
          Button.MenuChoice = Button.MenuChoice + 2
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Left then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuChoice - 1 >= 1 then
          Button.MenuChoice = Button.MenuChoice - 1
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Right then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuChoice + 1 <= #Player.Item then
          Button.MenuChoice = Button.MenuChoice + 1
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Enter then
        GLOBAL_UT_BATTLE.PressedKey = nil
        h.x, h.y = Button.x + 32 + (46+Button.Button[Button.Choice].Image:getWidth()/Button.Button[Button.Choice].ImageFrame) * (Button.Choice-1) + 8,
        Button.y + 430 + 12
        local str
        if Player.Health + Player.ItemHealth[Button.MenuChoice] >= Player.MaxHealth then
          str = "* Your hp maxs out!"
        else
          str = "* You recovered " .. Player.ItemHealth[Button.MenuChoice] .. " hps!"
        end
        GLOBAL_DIALOGUE:Init( "* You ate " .. Player.Item[Button.MenuChoice] .. "./" .. str )
        GLOBAL_DIALOGUE.x,GLOBAL_DIALOGUE.y = 40, 270
        GLOBAL_DIALOGUE:Reset()
        Button.MenuState = 3
      end
    elseif Button.MenuState == 3 then
      if GLOBAL_DIALOGUE.Done then
        GLOBAL_DIALOGUE:Init( GLOBAL_BATTLE_DIALOGUE )
        GLOBAL_DIALOGUE.x,GLOBAL_DIALOGUE.y = 40, 270
        GLOBAL_DIALOGUE:Reset()
        GLOBAL_DIALOGUE.Done = true
        GLOBAL_DIALOGUE.Char = {}
        Button.Reset()
        Button.Pressed = false
        for k,v in pairs( GLOBAL_UT_BATTLE.Boss.Boss ) do
          v.Item = v.Item + 1
          v:ItemEvent()
        end
        if Player.Health + Player.ItemHealth[Button.MenuChoice] >= Player.MaxHealth then
          Player.Health = Player.MaxHealth
        else
          Player.Health = Player.Health + Player.ItemHealth[Button.MenuChoice]
        end
        table.remove( Player.Item, Button.MenuChoice )
        Turn = false
      end
    end
  end,
  Draw = function()
    love.graphics.setFont( GLOBAL_UT_BATTLE.Font )
    love.graphics.setColor( 1, 1, 1, 1 )
    if Button.MenuState == 1 then
      for k,v in ipairs( Player.Item ) do
        if k % 2 == 0 then
          GLOBAL_UT_BATTLE.Print( "* " .. v, 356, (math.ceil(k/2)-1)*40 + 270 )
        else
          GLOBAL_UT_BATTLE.Print( "* " .. v, 96, (math.ceil(k/2)-1)*40 + 270 )
        end
      end
    end
  end
}
Button.Mercy = {
  Update = function ( dt )
    local h = GLOBAL_UT_BATTLE.Heart
    
    if Button.MenuState == 1 then
      h.x = 60
      h.y = (Button.MenuChoice - 1)*40 + 278
      if GLOBAL_UT_BATTLE.PressedKey == Key.Down then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuChoice + 1 <= #GLOBAL_UT_BATTLE.Boss.Boss then
          Button.MenuChoice = Button.MenuChoice + 1
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Up then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuChoice - 1 >= 1 then
          Button.MenuChoice = Button.MenuChoice - 1
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Enter then
        GLOBAL_UT_BATTLE.PressedKey = nil
        Button.MenuState = 2
      end
    elseif Button.MenuState == 2 then
      h.x = 60
      h.y = (Button.MenuSecChoice - 1)*20 + 278
      if GLOBAL_UT_BATTLE.PressedKey == Key.Down then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuSecChoice + 1 <= #GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].MercyOption then
          Button.MenuSecChoice = Button.MenuSecChoice + 1
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Up then
        GLOBAL_UT_BATTLE.PressedKey = nil
        if Button.MenuSecChoice - 1 >= 1 then
          Button.MenuSecChoice = Button.MenuSecChoice - 1
        end
      elseif GLOBAL_UT_BATTLE.PressedKey == Key.Enter then
        GLOBAL_UT_BATTLE.PressedKey = nil
        Turn = false
        Button.Reset()
        GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].MercyOption[Button.MenuSecChoice].Event()
        GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].MercyOption[Button.MenuSecChoice].Time = GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].MercyOption[Button.MenuSecChoice].Time + 1
      end
    end
  end,
  Draw = function ()
    love.graphics.setFont( GLOBAL_UT_BATTLE.Font )
    if Button.MenuState == 1 then
      for k,v in pairs( GLOBAL_UT_BATTLE.Boss.Boss ) do
        GLOBAL_UT_BATTLE.Print( "* " .. v.Name, 96, 230 + k*40 )
      end
    elseif Button.MenuState == 2 then
      for k,v in pairs( GLOBAL_UT_BATTLE.Boss.Boss[Button.MenuChoice].MercyOption ) do
        GLOBAL_UT_BATTLE.Print( "* " .. v.Name, 96, 230 + k*40 )
      end
    end
  end
}

function Button.Update( dt )
  if Turn then
    GLOBAL_UT_BATTLE.Heart.CanMove = false
    local h = GLOBAL_UT_BATTLE.Heart
    if not Button.Pressed then
      h.x, h.y = Button.x + 32 + (46+Button.Button[Button.Choice].Image:getWidth()/Button.Button[Button.Choice].ImageFrame) * (Button.Choice-1) + 8,
      Button.y + 430 + 12
    else
      Button[Button.List[Button.Choice]].Update( dt )
    end
  else
    GLOBAL_UT_BATTLE.Heart.CanMove = true
    for i = 1, Button.AllButtons do
      Button.Button[i].CurFrame = 1
    end
  end
end

function Button.Draw()
    love.graphics.setColor( 1, 1, 1, 1 )

    for i = 1, Button.AllButtons do
        love.graphics.draw( Button.Button[i].Image, Button.Button[i].Quad[Button.Button[i].CurFrame],
        Button.x + 32 + (46+Button.Button[i].Image:getWidth()/Button.Button[i].ImageFrame) * (i-1),
        Button.y + 430 )
    end

    love.graphics.setColor(1, 1, 1, 1)
    if Button.Pressed then
      Button[Button.List[Button.Choice]].Draw()
    end
end

function Button.KeyPressed( k )
  if Turn then
    if not Button.Pressed then
      if k == Key.Enter then
        GLOBAL_UT_BATTLE.PressedKey = nil
        Button.MenuChoice, Button.MenuSecChoice, Button.MenuState = 1, 1, 1
        GLOBAL_DIALOGUE.Char = {}
        GLOBAL_DIALOGUE.Done = true
        Button.Pressed = true
      elseif k == Key.Left then
        GLOBAL_UT_BATTLE.PressedKey = nil
        Button.Choice = Button.Choice - 1
        if Button.Choice < 1 then
          Button.Choice = #Button.Button
        end
        for k,v in pairs( Button.Button ) do
          v.CurFrame = 1
        end
        Button.Button[Button.Choice].CurFrame = 2
      elseif k == Key.Right then
        GLOBAL_UT_BATTLE.PressedKey = nil
        Button.Choice = Button.Choice + 1
        if Button.Choice > #Button.Button then
          Button.Choice = 1
        end
        for k,v in pairs( Button.Button ) do
          v.CurFrame = 1
        end
        Button.Button[Button.Choice].CurFrame = 2
      end
    else
      if k == Key.Exit and Button.MenuState == 1 then
        GLOBAL_UT_BATTLE.PressedKey = nil
        Button.Pressed = false
        Button.MenuChoice = 1
        GLOBAL_DIALOGUE:Reset()
      elseif k == Key.Exit and Button.MenuState == 2 then
        GLOBAL_UT_BATTLE.PressedKey = nil
        Button.MenuState = 1
        Button.MenuSecChoice = 1
      end
    end
  end
end

return Button
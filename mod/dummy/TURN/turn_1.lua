return function (p)
  local blt = require(p .. "TURN/bullet")
  local b = blt:New(p .. "TURN/spr_bullet.png", 320, 300, 2)
  local t = GLOBAL_UT_BATTLE.Turn:New()
  function t:Init(tm)
    tm.TurnTime = 200
    b.x, b.y = 320, 300
  end
  function t:Update(dt)
    if b:Update(dt) then
      self:DestroyFrontDraw(1, "bullet")
      b.x, b.y = 0, 0
    end
  end
  function t:Start(tm)
    GLOBAL_UT_BATTLE.Box.SizeTo(580, 300)
    self:AddFrontDraw(function ()
        b:Draw()
      end,"bullet",1)
  end
  function t:End(tm)
    GLOBAL_UT_BATTLE.Box.SizeTo(580, 140)
    self:DestroyFrontDraw(1, "bullet")
  end
  return t
end
local b = {
  x,
  y,
  OriX,
  OriY,
  Name,
  IsMercy = false,
  State = "Idle",
  CanMiss = false,
  Count = false,
  Alpha = 0,
  MercyEvent = function () end,
  FightEvent = function () end,
  ItemEvent = function () end,
  MissEvent = function () end,
  Mercy = 0,
  Fight = 0,
  Act = 0,
  Item = 0,
  Health = 100,
  MaxHealth = 100,
  Circle,
  IsDead = false,
  MercyOption = {
    {
      Name = "Spare",
      Time = 0,
      Event = function ()
        
      end
    }
  },
  ActOption = {
    {
      Name = "Talk",
      Time = 0,
      Event = function ()
        
      end,
      Dialogue = function ()
        return "* sans doesn\'t want to talk."
      end
    },
    {
      Name = "Punch",
      Time = 0,
      Event = function ()
        
      end,
      Dialogue = function ()
        return "* You tried to punch sans./* But sans refused."
      end
    }
  }
}

function b:Dialogue(str, font, fs, x, y, bubble)
  local d = GLOBAL_UT_BATTLE.Dialogue:New(str, font, fs)
  d.x, d.y = x, y
  d.Bubble = bubble
  return d
end

function b:Shake()
  local x, y = love.window.getPosition()
  --GLOBAL_UT_BATTLE:Shake(0, 0, 30)
end

function b:Dead()
  self.IsDead = true
  self.Alpha = 1
  self.Circle.x, self.Circle.y = self.DeadX, self.DeadY
  self.Circle:loadImage()
  self.Circle:checkImage()
end

function b:Hurt(damage)
  self.Health = self.Health - damage
  if self.Health <= 0 then
    self:Dead()
  end
end

function b:New()
  local a = setmetatable( {}, self )
  self.__index = self
  a.New = nil
  return a
end

function b:Update( dt )
  --custom
end

function b:Draw()
  --custom
end

return b
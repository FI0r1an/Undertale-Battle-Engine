local blt = require("src/object"):New({
    Sprite,
    x,
    y,
    Width,
    Height,
    Scale
  })

function blt:New(spr, x, y, s)
  local a = setmetatable({}, self)
  self.__index = self
  for k, v in pairs(a) do
    a:Enable(v, true, true)
  end
  a.Sprite = love.graphics.newImage(spr)
  a.x, a.y = x, y
  a.OriX = x
  a.Scale = s
  a.Width = a.Sprite:getWidth()*s
  a.Height = a.Sprite:getHeight()*s
  a.Value = 0
  return a
end

function blt:Update(dt)
  self.Value = self.Value + dt*2
  self.x = self.OriX + math.sin(self.Value)*50
  local x, y = GLOBAL_UT_BATTLE.Heart.x, GLOBAL_UT_BATTLE.Heart.y
  if x+8 > self.x and x-8 < self.x+self.Width and
     y+8 > self.y and y-8 < self.y+self.Height then
    Player.Health = Player.Health - 10
    return true
  end
  return false
end

function blt:Draw()
  love.graphics.draw(self.Sprite, self.x, self.y, 0, self.Scale)
end

return blt
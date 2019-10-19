local vec2 = require"mobile/vector"
Joystick = {
  x = 160,
  y = 240,
  Size = 90,
  ButtonSize = 30,
  ButtonX = 160,
  ButtonY = 240,
  IsTouched = false,
  IsPressedButton = false,
  id = 0,
  ButtonActive = false
}

function Joystick:New()
  local a = setmetatable({}, self)
  self.__index = self
  return a
end

function Joystick:SetPosition(x, y)
  self.x, self.y, self.ButtonX, self.ButtonY = x, y, x, y
end

function Joystick:Update(t)
  local cx, cy = t.x, t.y
  local dist = vec2(self.x, self.y):distanceTo(vec2(cx, cy))
  if dist <= self.Size then
    if self.id == 0 then self.id = t.id end
  end
  if self.IsTouched and self.ButtonActive then
    self:ButtonEvent()
  end
  if self.id == t.id then
    self.id = t.id
    if dist <= self.ButtonSize then
      self.IsPressedButton = true
    end
    if dist <= self.Size then
      self.IsTouched = true
      if self.IsPressedButton and not self.ButtonActive then
        self.ButtonX = cx
        self.ButtonY = cy
      end
      
    else
      if self.IsTouched then
        local vec = vec2(cx-self.x, cy-self.y)
        vec:normalized()
        if self.IsPressedButton and not self.ButtonActive then
          self.ButtonX = self.Size * vec.x+self.x
          self.ButtonY = self.Size * vec.y+self.y
        end
      end
    end
  end
  
  return (self.x-self.ButtonX)/self.Size, (self.y-self.ButtonY)/self.Size
end

function Joystick:Reset()
  self.id = 0
  self.IsTouched = false
  self.IsPressedButton = false
  self.ButtonX, self.ButtonY = self.x, self.y
end

function Joystick:Draw()
  love.graphics.circle("fill", self.x, self.y, self.Size)
  love.graphics.circle("fill", self.ButtonX, self.ButtonY, self.ButtonSize)
end

return Joystick
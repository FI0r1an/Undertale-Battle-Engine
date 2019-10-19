HeartSprite = {
  love.graphics.newImage("res/spr_heart.png"),
  love.graphics.newImage("res/spr_heart_blue.png")
}
local Heart = {
  x = 0,
  y = 0,
  Scale = 1,
  CanMove = false,
  Speed = 200,
  Width = 16,
  Height = 16,
  Mode = 1,
  Alpha = 1,
  Gravity = 12/30,
  AddSpeed = 0,
  Angle = 0,
  Direction = math.rad(90),
  JumpTime = 0,
  JumpHigh = 6,
  Jump = 1
}

function Heart:Update( dt )
  if self.CanMove then
    local bx, by, bw, bh = GLOBAL_UT_BATTLE.Box.x, GLOBAL_UT_BATTLE.Box.y, GLOBAL_UT_BATTLE.Box.Width, GLOBAL_UT_BATTLE.Box.Height
    local blw = GLOBAL_UT_BATTLE.Box.LineWidth
    if self.Mode == 1 then
      self.Angle = 0
      if love.keyboard.isDown(Key.Left) then
        self.x = self.x - self.Speed*dt
      elseif love.keyboard.isDown(Key.Right) then
        self.x = self.x + self.Speed*dt
      end
      if love.keyboard.isDown(Key.Up) then
        self.y = self.y - self.Speed*dt
      elseif love.keyboard.isDown(Key.Down) then
        self.y = self.y + self.Speed*dt
      end
    elseif self.Mode == 2 then
      self.Angle = self.Direction
      local xs, ys = math.sin(self.Direction)*self.Speed, math.cos(self.Direction)*self.Speed
      if math.floor(xs) == 0 then xs = self.Speed end
      if math.floor(ys) == 0 then ys = self.Speed end
      if love.keyboard.isDown(Key.Down) then
        self.y = self.y - xs*dt
      elseif love.keyboard.isDown(Key.Up) then
        self.y = self.y + xs*dt
      end
      if love.keyboard.isDown(Key.Right) and self.Jump == 0 then
        if self.JumpTime < self.JumpHigh*dt then
          self.AddSpeed = 3
          self.x = self.x + 100*dt*self.AddSpeed
        end
        self.JumpTime = self.JumpTime + dt
      end
      if GLOBAL_UT_BATTLE.ReleasedKey == Key.Right or self.JumpTime >= self.JumpHigh*dt then
        self.AddSpeed = 0
        self.JumpTime = 0
        GLOBAL_UT_BATTLE.ReleasedKey = nil
        self.Jump = 1
      end
      if self.Jump == 1 then
        self.AddSpeed = self.AddSpeed + 1
        self.x = self.x - self.Gravity*100*dt*self.AddSpeed
        if self.x-self.Width/2*self.Scale <= bx+blw then
          self.Jump = 0
          self.JumpTime = 0
        end
      end
    end
    
    if self.x+self.Width/2*self.Scale > bx+bw-blw then
      self.x = bx+bw-self.Width*self.Scale
    end
    if self.y+self.Height/2*self.Scale > by+bh-blw then
      self.y = by+bh-self.Height/2*self.Scale-blw
    end
    if self.x-self.Width/2*self.Scale < bx+blw then
      self.x = bx+self.Width/2*self.Scale+blw
    end
    if self.y-self.Height/2*self.Scale < by+blw then
      self.y = by+self.Height/2*self.Scale+blw
    end
  end
end

function Heart:Draw()
  love.graphics.setColor(1, 1, 1, self.Alpha)
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.Angle)
  love.graphics.draw( HeartSprite[self.Mode], -self.Width/2*self.Scale, -self.Height/2*self.Scale, 0, self.Scale )
  love.graphics.origin()
end

return Heart

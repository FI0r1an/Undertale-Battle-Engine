return function (self, dt)
  if self.IsDead then
    self.Circle:update(dt)
  end
end
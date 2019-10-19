return function (self, p)
  self.Image = love.graphics.newImage(p .. "spr_dummybattle_0.png")
  self.ActOption = {
    {
      Name = "Check",
      Time = 0,
      Event = function ()
        
      end,
      Dialogue = function ()
        return "* Dummy!/* Dummy!"
      end
    },
    {
      Name = "Talk",
      Time = 0,
      Event = function ()
        
      end,
      Dialogue = function ()
        return "* . . ."
      end
    }
  }
  self.Circle = GLOBAL_UT_BATTLE.Circle:new(p .. "spr_dummybattle_0.png")
  self.Width, self.Height = self.Image:getDimensions()
  self.DeadX, self.DeadY = self.x-self.Width/2, self.y-self.Height/2
end
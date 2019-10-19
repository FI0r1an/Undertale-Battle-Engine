local t = require"src/object":New({
    Update = function (self, dt)
      
    end,
    Init = function (self, tm)
      
    end,
    Start = function (self, tm)
      
    end,
    End = function (self, tm)
      
    end,
    Drawable = {},
    AddDraw = function (self, draw, name, depth)
      if depth then
        if not self.Drawable[depth] then
          self.Drawable[depth] = {}
        end
        self.Drawable[depth][name] = draw
      else
        self.Drawable[#self.Drawable+1][name] = draw
      end
    end,
    DestroyDraw = function (self, depth, name)
      if name then
        self.Drawable[depth][name] = nil
      else
        table.remove(self.Drawable, depth)
      end
    end,
    FrontDrawable = {},
    AddFrontDraw = function (self, draw, name, depth)
      if depth then
        if not self.FrontDrawable[depth] then
          self.FrontDrawable[depth] = {}
        end
        self.FrontDrawable[depth][name] = draw
      else
        self.FrontDrawable[#self.FrontDrawable+1][name] = draw
      end
    end,
    DestroyFrontDraw = function (self, depth, name)
      if name then
        self.FrontDrawable[depth][name] = nil
      else
        table.remove(self.FrontDrawable, depth)
      end
    end
  })



return t
local tm = require"src/object":New({
    CurrentTurn,
    TurnTime = 100,
    TurnTimer = 0,
    Timer = true,
    AllTurn = {},
    CurrentTurnNum = 1,
    LastTurnNum = 0,
    IsRepeat = true,
    Inited = false,
    IsRandom = false,
    Path,
    Load = function (self, name)
      self:NewTurn(require(self.Path .. "TURN/" .. name)(self.Path), 1)
    end,
    NewTurn = function (self, turn, num)
      table.insert(self.AllTurn, num, turn)
      self.CurrentTurnNum = num
      self.CurrentTurn = self.AllTurn[num]
      self.CurrentTurn:Init(self)
    end,
    EndTurn = function (self)
      self.CurrentTurn:End(self)
      Turn = true
      self.Inited = false
      GLOBAL_DIALOGUE:Reset()
      if self.IsRepeat then
        if self.IsRandom then
          self.LastTurnNum = self.CurrentTurnNum
          while self.LastTurnNum ~= self.CurrentTurnNum do
            self.CurrentTurnNum = love.math.random(1, #self.AllTurn)
          end
        else
          self.CurrentTurnNum = self.CurrentTurnNum + 1
          if self.CurrentTurnNum > #self.AllTurn then
            self.CurrentTurnNum = 1
          end
        end
      else
        if self.IsRandom then
          self.LastTurnNum = self.CurrentTurnNum
          while self.LastTurnNum ~= self.CurrentTurnNum do
            self.CurrentTurnNum = love.math.random(1, #self.AllTurn)
          end
        else
          self.CurrentTurnNum = self.CurrentTurnNum + 1
        end
      end
      self.CurrentTurn = self.AllTurn[self.CurrentTurnNum]
      self.CurrentTurn:Init(self)
      GLOBAL_UT_BATTLE.Button.Button[GLOBAL_UT_BATTLE.Button.Choice].CurFrame = 2
    end
  },
  {
    
  })

function tm:Update(dt)
  if not Turn then
    if not self.Inited then
      self.CurrentTurn:Start(self)
      self.Inited = true
    end
    self.CurrentTurn:Update(dt)
    if self.Timer then
      self.TurnTimer = self.TurnTimer + dt
      if self.TurnTimer >= self.TurnTime*dt then
        self.TurnTimer = 0
        self:EndTurn()
      end
    end
  end
end

function tm:Draw()
  love.graphics.setColor(1, 1, 1, 1)
  for k, v in ipairs(self.CurrentTurn.Drawable) do
    for _, V in pairs(v) do
      V()
    end
  end
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill", 0, 0, GLOBAL_UT_BATTLE.Box.x, 480)
  love.graphics.rectangle("fill", GLOBAL_UT_BATTLE.Box.x+GLOBAL_UT_BATTLE.Box.Width, 0, 640-GLOBAL_UT_BATTLE.Box.x+GLOBAL_UT_BATTLE.Box.Width, 480)
  love.graphics.rectangle("fill", 0, 0, 640, GLOBAL_UT_BATTLE.Box.y)
  love.graphics.rectangle("fill", 0, GLOBAL_UT_BATTLE.Box.y+GLOBAL_UT_BATTLE.Box.Height, 640, 480-GLOBAL_UT_BATTLE.Box.y+GLOBAL_UT_BATTLE.Box.Height)
end

function tm:FrontDraw()
  love.graphics.setColor(1, 1, 1, 1)
  for k, v in ipairs(self.CurrentTurn.FrontDrawable) do
    for _, V in pairs(v) do
      V()
    end
  end
end

return tm
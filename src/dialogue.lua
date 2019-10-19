local Dialogue = {}

utf8 = require"utf8"

function utf8.sub(str, i, j)
  if i == 0 and j == 0 then
    return nil
  end
  local ii = i
  local jj = j
  if ii < 0 then ii = utf8.len(str)-math.abs(ii) + 1 end
  if jj < 0 then jj = utf8.len(str)-math.abs(jj) + 1 end
  local r = ""
  local s = utf8.offset(str, ii)
  for p = ii+1, jj+1 do
    local e = utf8.offset(str, p) - 1
    r = r .. str:sub(s, e)
    s = e+1
  end
  return r
end

function utf8.isutf8(str)
  for i = 1, utf8.len(str) do
    if utf8.codepoint(utf8.sub(str, i, i)) > 400 then
      return true
    end
  end
  return false
end

function utf8.noutf8(str)
  local r = ""
  for i = 1, utf8.len(str) do
    if utf8.codepoint(utf8.sub(str, i, i)) > 400 then
      r = r .. Key.Exit
    else
      r = r .. utf8.sub(str, i, i)
    end
  end
  return r
end

function utf8.string(str)
  local r = ""
  for i = 1, utf8.len(str) do
    if utf8.codepoint(utf8.sub(str, i, i)) > 400 then
      r = r .. utf8.sub(str, i, i)
    end
  end
  return r
end

function Dialogue:New(text, f, fs)
    local a = {}
    setmetatable(a, self)
    self.__index = self
    a:Init(text, f, fs)
    return a
end

function Dialogue:Reset()
  self.Done = false
  self.Char = {}
  self.Count = 0
  self.TextX = 0
  self.TextY = 0
  self.TextNum = 0
  self.TextLine = 0
  self.ColorCount = #self.Colors - 1
  self.CharColor = { 255, 255, 255 }
end

function Dialogue:Init(text, f, fs)
  self.Offset = 2
  self.SpeDraw = {}

    local function GetColor(text)
        local sp = 1
        local ss, all_ = string.gsub(utf8.noutf8(text), '<', '<')
        local all = 0
        local col = {}
        
        while all < all_ do
            local s1, e1 = string.find(utf8.noutf8(text), '<', sp)
            local s2, e2 = string.find(utf8.noutf8(text), '>', sp)
            local color = utf8.sub(utf8.noutf8(text), s1+1, s2-1)
            sp = e2 + 1
            all = all + 1
            table.insert(col, {color, e2})
        end
        return col
    end

    local function Split(str, char)
        local t = {}
        local eP = 0
        for i=1,utf8.len(str) do
            if utf8.sub(str,i,i) == char then
                table.insert(t,utf8.sub(str,eP+1,i-1))
                eP = i
            end
        end
        table.insert(t,utf8.sub(str,eP+1,-1))
        return t
    end

    self.Done = false
    self.UnTypeText = text
    self.Time = 2
    self.Count = 0
    self.TextNum = 0
    
    self.FontScale = fs or 1
    self.Font = f or GLOBAL_UT_BATTLE.Font
    self.Colors = GetColor(self.UnTypeText)
    self.Char = {}
    self.CharColor = {1,1,1,1}
    self.ColorCount = #self.Colors-1
    self.Text = self.UnTypeText
    self.x = 0
    self.y = 0
    self.TextX = 0
    self.TextY = 0
    self.Alpha = 1
    self.CanSkip = false
    for k, v in pairs(self.Colors) do
        self.Text = string.gsub(self.Text, '<' .. v[1] .. '>', '')
        local rgba = Split(v[1], ',')
        for _, V in pairs(rgba) do
            V = tonumber(V) or 0
        end
        v.color = rgba
    end
end

function Dialogue:AddChar(dt)
    self.Count = self.Count + dt
    if self.Count >= self.Time*dt then
        self.Count = 0
        self.TextNum = self.TextNum + 1
        
        local char = utf8.sub(self.Text, self.TextNum, self.TextNum)
        
        self.TextX = self.TextX + self.Font:getWidth(utf8.sub(self.Text, self.TextNum-1, self.TextNum-1) or "a")*self.FontScale
        
        if char == '/' then
          self.TextX = 0
          self.TextY = self.TextY + self.Font:getHeight()*self.FontScale
        else
            for k, v in pairs(self.Colors) do
                local s = 0
                for i = 1, #self.Colors - self.ColorCount do
                    s = s + 2 + #self.Colors[i][1]
                end
                if self.TextNum+s-1 == v[2] then
                    self.ColorCount = self.ColorCount - 1
                    if self.ColorCount < 0 then
                        self.ColorCount = #self.Colors-1
                    end
                    self.CharColor = v.color
                end
            end
            table.insert(self.Char,
            {
                char = char,
                x = self.TextX,
                y = self.TextY,
                xs = self.TextX,
                ys = self.TextY,
                i = 0,
                color = self.CharColor,
                t = love.math.random(25, 100),
                a = love.math.random(0, 360)
            })
        end
    end
end

function Dialogue:Update(dt)
    if not self.Done then
      for k,v in pairs(self.Char) do
        v.i = v.i + dt
        if v.i >= v.t*dt then
          v.i = 0
          if v.x == v.xs and v.y == v.ys then
            v.x = v.xs + math.sin(v.a)*self.Offset
            v.y = v.ys + math.cos(v.a)*self.Offset
            v.t = 5
          else
            v.x = v.xs
            v.y = v.ys
            v.t = love.math.random(50, 150)
            v.a = love.math.random(0, 360)
          end
        end
      end
      if self.TextNum < utf8.len(self.Text) then
        self:AddChar(dt)
      end
      if self.CanSkip then
        if GLOBAL_UT_BATTLE.PressedKey == Key.Exit then
          repeat
            self:AddChar(dt)
          until (self.TextNum >= utf8.len(self.Text))
        end
      end
      if self.TextNum >= utf8.len(self.Text) and GLOBAL_UT_BATTLE.PressedKey == Key.Enter then
        self.Done = true
        self.Alpha = 0
        GLOBAL_UT_BATTLE.PressedKey = ""
      else
        GLOBAL_UT_BATTLE.PressedKey = ""
      end
    end
end

function Dialogue:Bubble()
  
end

function Dialogue:Draw()
    love.graphics.setColor(1, 1, 1, self.Alpha)
    love.graphics.setFont(self.Font)
    
    self:Bubble()
    
    love.graphics.translate(self.x, self.y)
    for k, v in pairs(self.Char) do
      love.graphics.setColor( unpack(v.color) )
      love.graphics.print(v.char, v.x, v.y, 0, self.FontScale)
    end
    for k,v in pairs(self.SpeDraw) do
      love.graphics.draw(v.Image, self.Char[v.num].x, self.Char[v.num].y, 0, self.FontScale)
    end
    love.graphics.translate(-self.x, -self.y)
end

return Dialogue
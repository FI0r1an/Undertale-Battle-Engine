
local w = {}
w.Timer = 0
w.Drawing = {}
w.Size = 360/12
w.Scale = 20
w.Height = 50

function w:Init(n)
	self.Music = love.audio.newSource(n, "static")
  self.Music:setLooping(true)
  self.Data = love.sound.newSoundData(n)
  self.SampleRate = self.Data:getSampleRate()
end

function w:Update(dt)
	self.Timer = self.Timer+dt
	if self.Timer>dt then
		self.Timer = 0
		for i = 1, self.Size do
			local h = self.Height*math.log((0.1+math.abs(self.Data:getSample((self.Music:tell("seconds")*self.SampleRate+i-1))*self.Scale)))
      self.Drawing[i] = h>(self.Drawing[i] or 0) and h or (self.Drawing[i] or 0)*math.pow(0.01,dt)
		end
	end
end

function w:Draw()
  for k,v in pairs(self.Drawing) do
    love.graphics.setColor(v/75, 0, .2, 1)
    love.graphics.push()
    love.graphics.translate(320, 240)
    love.graphics.rotate(k)
    love.graphics.rectangle('fill', 15, 90, 10, v*1.2)
    love.graphics.pop()
  end
end

function w:New(n)
  local a = setmetatable({}, self)
  self.__index = self
  a:Init(n)
  return a
end

return w
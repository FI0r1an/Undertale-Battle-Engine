local circle = {}

function circle:new(i)
  local a = {}
  setmetatable(a,self)
  self.__index = self
  a.img = love.graphics.newImage(i)
  a.width,a.height = a.img:getWidth(),a.img:getHeight()
  a.cir = {}
  a.color = {0,0,0,0}
  a.sparateValue = {0,0}
  a.size = 2
  return a
end

function circle:loadImage()
  love.graphics.setColor(1, 1, 1, 1)
  self.canvas = love.graphics.newCanvas()
  love.graphics.setCanvas(self.canvas)
  love.graphics.draw(self.img,0,0)
  love.graphics.setCanvas()
  self.imageData = self.canvas:newImageData()
end

function circle:checkImage()
  self.cir = {}
  for i=0,self.width/self.size do
    for j=0,self.height/self.size do
      local dir = love.math.random(-10, 10)
      if dir == 0 then dir = 10 end
      dir = dir / 10
      local r, g, b, a = self.imageData:getPixel(i*self.size,j*self.size)
      local c = (r+g+b)/3
      if a > 0 or c > 0 then
        self:createCircle({
          color = {c, c, c, 1},
          x = self.x+i*self.size-self.sparateValue[1]*i*self.size,
          y = self.y+j*self.size-self.sparateValue[2]*j*self.size,
          size = self.size,
          speed = 1,
          dir = dir,
          addSpeed = 0.5,
          s = love.math.random(25,50)})
      end
    end
  end
end

function circle:sparate(x,y)
  self.sparateValue[1] = self.sparateValue[1] + x
  self.sparateValue[2] = self.sparateValue[2] + y
  self:checkImage()
end

function circle:createCircle(t) -- {color,x,y,size,speed,addSpeed}
  table.insert(self.cir,t)
end

function circle:destroyCircle(k)
  table.remove(self.cir,k)
end

function circle:update(dt)
  for k,v in pairs(self.cir) do
    if v.size - dt*v.size > 0 then
      v.size = v.size - dt*v.size
    end
    v.speed = v.speed + v.addSpeed
    v.color[4] = v.color[4] - 1/255*dt*10
    v.y = v.y - v.speed*v.s*dt
    v.x = v.x - v.speed*v.s*dt*v.dir
    if v.y + v.size/2 < 0 then
      self:destroyCircle(k)
    end
  end
end

function circle:draw()
  for k,v in pairs(self.cir) do
    love.graphics.setColor(unpack(v.color))
    love.graphics.circle('fill',v.x,v.y,v.size)
  end
end

return circle
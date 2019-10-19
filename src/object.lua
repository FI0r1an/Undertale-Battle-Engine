local obj = {
  Children = {},
  Parent = {},
  ClassName = "Object",
  Name = "Object",
  Setable = {},
  Getable = {}
}

function obj:FindChild(key, name)
  if type(self[key]) == "table" and name then
    return self[key][name]
  end
  if self[key] == nil then
    return self.Children[key]
  end
  return self[key]
end

function obj:ExistChild(key, name)
  if type(self[key]) == "table" and name then
    return not self[key][name] == nil
  end
  if not self[key] then
    return not self.Children[key] == nil
  end
  return not self[key] == nil
end

function obj:FindFirstParent()
  local p = self.Parent
  while true do
    if not p.Parent or #p.Parent <= 0 then
      break
    end
    p = p.Parent
  end
  return p
end

function obj:UpdateEvent(dt)
  
end

function obj:Update(dt)
  self:UpdateEvent(dt)
end

function obj:Destroy()
  self.Parent.Children[self.Name] = nil
  self.Parent = nil
  self:ClearAllChildren()
end

function obj:Disable(key)
  self.Setable[key] = nil
  self.Getable[key] = nil
end

function obj:Enable(key, set, get)
  if set then
    self.Setable[key] = true
  end
  if get then
    self.Getable[key] = true
  end
end

function obj:Get(key, name)
  if type(self[key]) == "table" and name and self.Getable[key] then
    return self[key][name]
  end
  return self[key]
end

function obj:Set(k, value, name, arg)
  if type(self[k]) ~= "function" and self.Getable[k] then
    if type(self[k]) == "table" and name then
      self[k][name] = value
    else
      self[k] = value
    end
    if self["Call" .. k .. "Event"] then
      self["Call" .. k .. "Event"](self, value, arg)
    end
  end
end

function obj:ClearAllChildren()
  for k, v in pairs(self.Children) do
    self.Children[k] = nil
  end
end

function obj:GetChildren()
  return self.Children
end

function obj:CallParentEvent(value)
  value.Children[self.Name] = self
end

for k, v in pairs(obj) do
  obj:Enable(k, true, true)
end

obj:Disable("ClassName")
obj:Disable("Setable")
obj:Disable("Getable")

obj.New = function(self, t, static)
  local a = setmetatable(t or {}, self)
  self.__index = self
  for k, v in pairs(a) do
    a:Disable(v)
    a:Enable(v, false, true)
  end
  return a
end

return obj
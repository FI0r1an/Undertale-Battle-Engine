return function (p)
  love.window.setTitle("Loading")
  GLOBAL_TURN_MANAGER.Path = p
  GLOBAL_TURN_MANAGER:Load("turn_1")
  local audio = love.audio.newSource(p .. "mus_battle.ogg", "static")
  audio:setLooping(true)
  audio:play()
end
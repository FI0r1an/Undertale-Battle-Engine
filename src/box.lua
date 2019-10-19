local Box = {}
Box.LineWidth = 5
Box.x = 30
Box.y = 250
Box.Width = 580
Box.Color = {1,1,1,1}
Box.Height = 140
Box.Hpname = love.graphics.newImageFont( "res/hpname.png", [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]] )
Box.Hp = love.graphics.newImage( "res/hp.png" )

function Box.SizeTo(w, h)
  Box.SizeTween = tween.new(1, Box, {Width = w, Height = h})
end

function Box.MoveTo(x, y)
  Box.MoveTween = tween.new(1, Box, {x = x, y = y})
end

function Box.Update(dt)
  if Box.SizeTween then
    Box.SizeTween:update(dt)
  end
  if Box.MoveTween then
    Box.MoveTween:update(dt)
  end
end

function Box.Draw(  )
  love.graphics.setColor( 255, 255, 255 )
  love.graphics.setFont( Box.Hpname )
  love.graphics.print( PLAYER_NAME .. "  " .. "lv " .. PLAYER_LEVEL, 30, 400 )
  love.graphics.draw( Box.Hp, 248, 405 )
  love.graphics.setColor( 255, 0, 0 )
  love.graphics.rectangle( "fill", 280, 400, Player.MaxHealth, 20 )
  love.graphics.setColor( 0, 255, 0 )
  love.graphics.rectangle( "fill", 280, 400, Player.Kr, 20 )
  love.graphics.setColor( 255, 255, 0 )
  love.graphics.rectangle( "fill", 280, 400, Player.Health, 20 )
  love.graphics.setColor( 1, 1, 1, 1 )
  love.graphics.print( Player.Health .. " / " .. Player.MaxHealth, 280 + Player.MaxHealth + 14, 400 )
  love.graphics.setColor( unpack(Box.Color) )
  love.graphics.rectangle( 'fill', Box.x, Box.y, Box.Width, Box.LineWidth )
  love.graphics.rectangle( 'fill', Box.x, Box.y + Box.Height, Box.Width, -Box.LineWidth )
  love.graphics.rectangle( 'fill', Box.x, Box.y, Box.LineWidth, Box.Height )
  love.graphics.rectangle( 'fill', Box.x + Box.Width, Box.y, -Box.LineWidth, Box.Height )
end

return Box
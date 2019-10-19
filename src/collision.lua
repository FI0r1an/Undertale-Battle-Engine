local c = {}

function c.AABB(lx, uy, w, h, lxx, uyy, ww, hh)
  if lx+w > lxx and uy+h > uyy and lx < lxx+ww and uy < uyy+hh then
    return true
  end
  return false
end

function c.AABBWithRotate(cx, cy, w, h, cxx, cyy, ww, hh, a)
  local aa = -a
  local x = ((cx-cxx) * math.cos(aa) - (cy-cyy) * math.sin(aa))+cxx
  local y = ((cx-cxx) * math.sin(aa) + (cy-cyy) * math.cos(aa))+cyy
  return c.AABB(x-w/2, y-h/2, w, h, cxx-ww/2, cyy-hh/2, ww, hh)
end

function c.AABBWithRotateCorner(cx, cy, w, h, lxx, uyy, ww, hh, a)
  local aa = -a
  local cxx, cyy = lxx+ww/2, uyy+hh/2
  local x = ((cx-cxx) * math.cos(aa) - (cy-cyy) * math.sin(aa))+cxx
  local y = ((cx-cxx) * math.sin(aa) + (cy-cyy) * math.cos(aa))+cyy
  return c.AABB(x-w/2, y-h/2, w, h, cxx-ww/2, cyy-hh/2, ww, hh)
end

return c
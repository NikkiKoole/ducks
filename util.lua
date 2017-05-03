function distance(x, y, x1, y1)
   local dx = x - x1
   local dy = y - y1
   local dist = math.sqrt(dx * dx + dy * dy)
   return dist
end

function pointInCircle(x,y, circle)
   if not x or not y then return false end
   local dist = distance(x, y, circle.x, circle.y)
   return dist < circle.radius
end

function map(x, in_min, in_max, out_min, out_max)
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

function lerp(a, b, t)
   return a + (b - a) * t
end

function lerp3(a, b, t)
   return {lerp(a[1],b[1],t), lerp(a[2],b[2],t), lerp(a[3],b[3],t)}
end

function clamp(v, a, b)
   if (v < a) then return a end
   if (v > b) then return b end
   return v
end

function compareY(a,b)
  return a.y < b.y
end
return {
   distance = distance,
   pointInCircle = pointInCircle,
   map = map,
   lerp = lerp,
   lerp3 = lerp3,
   compareY = compareY
}

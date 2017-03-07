local dusk_data = {
   {0x22, 0x3e, 0x4e};
   {0x2d, 0x49, 0x59};
   {0x35, 0x51, 0x64};
   {0x3f, 0x5c, 0x6e};
   {0x4a, 0x68, 0x77};
   {0x57, 0x70, 0x7e};
   {0x65, 0x79, 0x88};
   {0x70, 0x85, 0x8a};
   {0x7f, 0x8b, 0x8d};
   {0x8c, 0x8d, 0x8a};
   {0x97, 0x86, 0x7b};
   {0x98, 0x6b, 0x5a};
   {0x71, 0x42, 0x3c};
}

local evening_data = {
   {0x0b, 0x1c, 0x37};
   {0x0d, 0x1e, 0x3d};
   {0x0f, 0x1f, 0x44};
   {0x11, 0x21, 0x4b};
   {0x15, 0x26, 0x53};
   {0x12, 0x2d, 0x61};
   {0x10, 0x36, 0x6c};
   {0x17, 0x41, 0x76};
   {0x20, 0x4b, 0x84};
   {0x2d, 0x59, 0x92};
   {0x3e, 0x6c, 0x9a};
   {0x55, 0x7a, 0x9e};
   {0x64, 0x7c, 0x90};
}

local day_data = {
   {0x52, 0x7e, 0xb1};
   {0x57, 0x84, 0xb7};
   {0x5e, 0x8b, 0xbe};
   {0x61, 0x92, 0xc5};
   {0x68, 0x99, 0xcb};
   {0x6e, 0x9f, 0xd1};
   {0x73, 0xa4, 0xd6};
   {0x7d, 0xab, 0xdb};
   {0x82, 0xb0, 0xde};
   {0x8a, 0xb6, 0xdd};
   {0x8e, 0xb9, 0xdc};
   {0x9a, 0xb9, 0xd6};
   {0x9a, 0xb6, 0xce};

}

local night_data = {
   {0x02, 0x2a, 0x4e};
   {0x02, 0x28, 0x4c};
   {0x02, 0x26, 0x49};
   {0x02, 0x23, 0x44};
   {0x02, 0x21, 0x3e};
   {0x01, 0x1d, 0x39};
   {0x01, 0x1b, 0x34};
   {0x01, 0x17, 0x2e};
   {0x01, 0x15, 0x29};
   {0x02, 0x13, 0x26};
   {0x00, 0x10, 0x1d};
   {0x00, 0x0c, 0x19};
   {0x01, 0x0b, 0x16};

}

function gradient(colors)
   local direction = colors.direction or "horizontal"
   if direction == "horizontal" then
      direction = true
   elseif direction == "vertical" then
      direction = false
   else
      error("Invalid direction '" .. tostring(direction) "' for gradient.  Horizontal or vertical expected.")
   end
   local result = love.image.newImageData(direction and 1 or #colors, direction and #colors or 1)
   for i, color in ipairs(colors) do
      local x, y
      if direction then
         x, y = 0, i - 1
      else
         x, y = i - 1, 0
      end
      result:setPixel(x, y, color[1], color[2], color[3], color[4] or 255)
   end
   result = love.graphics.newImage(result)
   result:setFilter('linear', 'linear')
   return result
end

function drawInRect(img, x, y, w, h, r, ox, oy, kx, ky)
   return -- tail call for a little extra bit of efficiency
      love.graphics.draw(img, x, y, r, w / img:getWidth(), h / img:getHeight(), ox, oy, kx, ky)
end

function drawSkyGradientAndSetFGColor(t)
   if (t < 0.5) then
      local t1 = t*2
      local gr = gradient {
         direction = 'horizontal';
         lerp3(day_data[1], dusk_data[1], t1);
         lerp3(day_data[2], dusk_data[2], t1);
         lerp3(day_data[3], dusk_data[3], t1);
         lerp3(day_data[4], dusk_data[4], t1);
         lerp3(day_data[5], dusk_data[5], t1);
         lerp3(day_data[6], dusk_data[6], t1);
         lerp3(day_data[7], dusk_data[7], t1);
         lerp3(day_data[8], dusk_data[8], t1);
         lerp3(day_data[9], dusk_data[9], t1);
         lerp3(day_data[10], dusk_data[10], t1);
         lerp3(day_data[11], dusk_data[11], t1);
         lerp3(day_data[12], dusk_data[12], t1);
         lerp3(day_data[13], dusk_data[13], t1);
      }
      drawInRect(gr, 0,0, 1024*2, 768*1.2)
      love.graphics.setColor(0xff,                 0xff - ((t1/2)*0xff)   , 0xff - ((t1/4)*0xff) )

   elseif (t >= 0.5) then
      local t1 = (t-0.5)*2
      local gr = gradient {
         direction = 'horizontal';
         lerp3(dusk_data[1],night_data[1], t1);
         lerp3(dusk_data[2],night_data[2], t1);
         lerp3(dusk_data[3],night_data[3], t1);
         lerp3(dusk_data[4],night_data[4], t1);
         lerp3(dusk_data[5],night_data[5], t1);
         lerp3(dusk_data[6],night_data[6], t1);
         lerp3(dusk_data[7],night_data[7], t1);
         lerp3(dusk_data[8],night_data[8], t1);
         lerp3(dusk_data[9],night_data[9], t1);
         lerp3(dusk_data[10],night_data[10], t1);
         lerp3(dusk_data[11],night_data[11], t1);
         lerp3(dusk_data[12],night_data[12], t1);
         lerp3(dusk_data[13],night_data[13], t1);
      }

      drawInRect(gr, 0,0, 1024*2, 768*1.2)
      love.graphics.setColor(0xff - ((t1/1.0)*0xff), (0xff/2) - ((t1/2)*0xff) , (0xff*0.75) - ((t1/4)*0xff)  )
   end
end

return {
   drawSkyGradientAndSetFGColor = drawSkyGradientAndSetFGColor
}

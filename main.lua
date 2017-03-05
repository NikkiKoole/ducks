local flux = require 'vendor/flux'
local push = require 'vendor/push'
require 'vendor/slam'
local lovebird = require 'vendor/lovebird'
lovebird.port = 3333 -- http://localhost:3333

function getDisplayObject(img, x, y, pivotX, pivotY)
   return {
      img = img,
      pivot = {x=pivotX, y=pivotY},
      local_transform = {
         position = {x=x, y=y},
         scale = {x=1, y=1},
         radian = 0,
      },
      world_transform = {
         position = {x=0, y=0},
         scale = {x=1, y=1},
         radian = 0,
      },
   }
end

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


function makeGoose(x, y, startX, endX, startY, scale)
   local goose = {}
   goose.waterlevel = {y=160}
   goose.dx = 0
   goose.y = y
   goose.x = x
   goose.scaleX = scale
   goose.scaleY = scale
   goose.scale = scale
   goose.geese_canvas = nil
   goose.temp_canvas = nil
   goose.sound_instance = nil
   goose.old_x = nil
   goose.startX = startX
   goose.endX = endX
   goose.startY = startY

   goose.geese_root = getDisplayObject(nil, 150,200,0.5 * geese_torso_img:getWidth(), 1.0 * geese_torso_img:getHeight())
   goose.geese_back_foot = getDisplayObject(geese_foot_img, 0, -25, 1.0 * geese_foot_img:getWidth(), 0 * geese_foot_img:getHeight())
   goose.geese_back_foot.local_transform.radian = math.rad(-40);
   goose.geese_front_foot = getDisplayObject(geese_foot_img, 15, -10, 1.0 * geese_foot_img:getWidth(), 0 * geese_foot_img:getHeight())
   goose.geese_front_foot.local_transform.radian = math.rad(-40);
   goose.geese_torso = getDisplayObject(geese_torso_img, 0, 0, 0.5 * geese_torso_img:getWidth(), 1.0 * geese_torso_img:getHeight())
   goose.geese_eye = getDisplayObject(geese_eye_img, -65, -155, 0.5 * geese_eye_img:getWidth(), 1.0 * geese_eye_img:getHeight())
   goose.geese_beak_top = getDisplayObject(geese_beak_top_img, -78, -160, 1.0 * geese_beak_top_img:getWidth(), 1.0 * geese_beak_top_img:getHeight() )
   goose.geese_beak_top.local_transform.radian = math.rad(-20);
   goose.geese_beak_bottom = getDisplayObject(geese_beak_bottom_img, -78, -160, 1.0 * geese_beak_bottom_img:getWidth(), 0 * geese_beak_bottom_img:getHeight() )
   goose.geese_beak_bottom.local_transform.radian = math.rad(10);
   goose.geese_gradient = getDisplayObject(geese_gradient_img, 0, 50, 0.5 * geese_gradient_img:getWidth(), 1.0 * geese_gradient_img:getHeight())
   goose.geese_gradient.multiply = true

   addChild(goose.geese_root, goose.geese_back_foot)
   addChild(goose.geese_root, goose.geese_torso)
   addChild(goose.geese_root, goose.geese_front_foot)
   addChild(goose.geese_torso, goose.geese_beak_top)
   addChild(goose.geese_torso, goose.geese_beak_bottom)
   addChild(goose.geese_torso, goose.geese_eye)

   return goose
end



function love.load()
   music = love.audio.newSource("sounds/clarinet_duck_jaunty.ogg", 'static')
   music:setLooping(true)
   music:setPitch(1.0)
   love.audio.play(music)

   --geese_honk = love.audio.newSource({'sounds/geese_honk_1.ogg', 'sounds/geese_honk_1.ogg', 'sounds/geese_honk_3.ogg', 'sounds/geese_honk_4.ogg'}, 'static')
   --TLfres.setScreen({w=1024, h=768}, 1024*2, false, false)

   gameWidth, gameHeight = 1024*2, 768*2 --fixed game resolution
   local windowWidth, windowHeight = love.window.getDesktopDimensions()
   -- love.window.setMode(windowWidth, windowHeight, {highdpi=true})
   push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {highdpi=true, canvas=true, resizable=true})
   love.graphics.setBackgroundColor(0x7A, 0xB4, 0xF8)


   geese_honk1 = love.audio.newSource('sounds/geese_honk_1.ogg', 'static')
   boing = love.audio.newSource('sounds/boing.wav', 'static')


   geese_torso_img = love.graphics.newImage("images/geese_torso2.png")
   geese_eye_img = love.graphics.newImage("images/geese_eye.png")
   geese_foot_img = love.graphics.newImage("images/geese_foot.png")
   geese_beak_top_img = love.graphics.newImage("images/geese_beak_top.png")
   geese_beak_bottom_img = love.graphics.newImage("images/geese_beak_bottom.png")
   geese_beak_bottom_img:setFilter('nearest','nearest')
   geese_gradient_img = love.graphics.newImage("images/gradient.png")


   mallard_male_torso_img = love.graphics.newImage("images/mallard_male_torso.png")
   mallard_male_foot_img = love.graphics.newImage("images/mallard_male_foot.png")
   mallard_male_beak_top_img = love.graphics.newImage("images/mallard_male_beak_top.png")
   mallard_male_beak_bottom_img = love.graphics.newImage("images/mallard_male_beak_bottom.png")
   mallard_eye_img = love.graphics.newImage("images/mallard_eye.png")

   mallard_male_root = getDisplayObject(nil, 150,200,0.5 * mallard_male_torso_img:getWidth(), 1.0 * mallard_male_torso_img:getHeight())
   mallard_male_torso = getDisplayObject(mallard_male_torso_img, 0, 0, 0.5 * mallard_male_torso_img:getWidth(), 1.0 * mallard_male_torso_img:getHeight())

   mallard_male_back_foot = getDisplayObject(mallard_male_foot_img, 0, -20, 1.0 * mallard_male_foot_img:getWidth(), 0 * mallard_male_foot_img:getHeight())
   mallard_male_back_foot.local_transform.radian = math.rad(0);
   mallard_male_front_foot = getDisplayObject(mallard_male_foot_img, 15, -10, 1.0 *mallard_male_foot_img:getWidth(), 0 * mallard_male_foot_img:getHeight())
   mallard_male_front_foot.local_transform.radian = math.rad(0);

   mallard_male_beak_top = getDisplayObject(mallard_male_beak_top_img, -50, -90, 1.0 * mallard_male_beak_top_img:getWidth(), 1.0 * mallard_male_beak_top_img:getHeight() )
   mallard_male_beak_top.local_transform.radian = math.rad(0);
   mallard_male_beak_bottom = getDisplayObject(mallard_male_beak_bottom_img, -50, -90, 1.0 * mallard_male_beak_bottom_img:getWidth(), 0 * mallard_male_beak_bottom_img:getHeight() )
   mallard_male_beak_bottom.local_transform.radian = math.rad(0);
   mallard_male_eye = getDisplayObject(mallard_eye_img, -40, -87, 0.5 * mallard_eye_img:getWidth(), 1.0 * mallard_eye_img:getHeight())




   addChild(mallard_male_root, mallard_male_back_foot)
   addChild(mallard_male_root, mallard_male_torso)
   addChild(mallard_male_root, mallard_male_front_foot)
   addChild(mallard_male_torso, mallard_male_beak_top)
   addChild(mallard_male_torso, mallard_male_beak_bottom)
   addChild(mallard_male_torso, mallard_male_eye)

   grass_img = love.graphics.newImage("images/grass.png")
   bushes_back_img = love.graphics.newImage("bushes_back.png")
   bushes_front_img = love.graphics.newImage("images/bushes_front.png")
   sun_img = love.graphics.newImage("images/sun.png")

   tree_1_img = love.graphics.newImage("images/tree1.png")
   tree_2_img = love.graphics.newImage("images/tree2.png")

   pond_img = love.graphics.newImage("images/pond.png")

   backdrop = getDisplayObject(nil, 0, 0)
   --grass = getDisplayObject(grass_img, 0, (768*2) - 829)
   grass = getDisplayObject(grass_img, 0, 770)
   bushes_back = getDisplayObject(bushes_back_img, 160, 950)
   bushes_front = getDisplayObject(bushes_front_img, 110, 940)
   tree1 = getDisplayObject(tree_1_img, 20, 100)
   tree2 = getDisplayObject(tree_2_img, 1050, 100)
   pond = getDisplayObject(pond_img, 150, 1100)
   sun = getDisplayObject(sun_img, 1700, 200, 0.5 * sun_img:getWidth(),  0.5 * sun_img:getHeight())
   sun.origin = {x=1700, y=200}
   sun.dragging = { allowed = true, active = false, diffX = 0, diffY = 0}
   sun.tweenPos = nil
   sun.tweenScale = nil

   addChild(backdrop, sun)
   addChild(backdrop, grass)
   addChild(backdrop, pond)
   addChild(backdrop, bushes_back)
   addChild(backdrop, tree1)
   addChild(backdrop, tree2)
   addChild(backdrop, bushes_front)
   addChild(backdrop, mallard_male_root)



   multiple_geese = {}

   local geese1 = makeGoose(500,1200, 500,1600,1200, 1.1)
   multiple_geese[1] = geese1
   wobble(geese1)
   swim_paddle_feet(geese1)
   swim(geese1)

   local geese2 = makeGoose(1400, 1250, 500,1600,1250, 1.2)
   multiple_geese[2] = geese2
   wobble(geese2)
   swim_paddle_feet(geese2)
   swim(geese2)

   local geese3 = makeGoose(800, 1300, 500,1600, 1300, 1.3)
   multiple_geese[3] = geese3
   wobble(geese3)
   swim_paddle_feet(geese3)
   swim(geese3)

   local geese4 = makeGoose(1000, 1350, 500,1600, 1350, 1.4)
   multiple_geese[4] = geese4
   wobble(geese4)
   swim_paddle_feet(geese4)
   swim(geese4)

   local geese5 = makeGoose(600, 1400, 500,1600, 1400, 1.5)
   multiple_geese[5] = geese5
   wobble(geese5)
   swim_paddle_feet(geese5)
   swim(geese5)


   pause = false
end


function growShrinkSun()
   flux.to(sun.local_transform.scale, 0.5, {x=1.3, y=1.3})
   flux.to(sun.local_transform.scale, 1, {x=1, y=1}):delay(0.5)

end

function tweenSunBackToOrigin()
   --sun.local_transform.position = sun.origin

   sun.tweenPos = flux.to(sun.local_transform.position, 4.5, {x=sun.origin.x, y=sun.origin.y}):ease("elasticout")
   sun.tweenScale = flux.to(sun.local_transform.scale, 1.5, {x=1, y=1}):delay(.15)
end


function quak(geese3)
   flux.to(geese3.geese_beak_top.local_transform, 0.4, {radian=math.rad(10)})
   flux.to(geese3.geese_beak_top.local_transform, 0.2, {radian=math.rad(-20)}):delay(0.4)

   flux.to(geese3.geese_beak_bottom.local_transform, 0.4, {radian=math.rad(-10)})
   flux.to(geese3.geese_beak_bottom.local_transform, 0.2, {radian=math.rad(10)}):delay(0.4)
end

function swim_paddle_feet(geese2)
   local function closure() swim_paddle_feet(geese2) end

   local duration = 0.5
   --if (math.abs(geese2.dx) < 1 ) then duration = 1.0 end

   if (geese2.geese_back_foot.local_transform.radian <= math.rad(-40)) then
      flux.to(geese2.geese_back_foot.local_transform, duration, {radian=math.rad(40)})
      flux.to(geese2.geese_front_foot.local_transform, duration, {radian=math.rad(-40)}):oncomplete(closure)
   else
      flux.to(geese2.geese_back_foot.local_transform, duration, {radian=math.rad(-41)})
      flux.to(geese2.geese_front_foot.local_transform, duration, {radian=math.rad(40)}):oncomplete(closure)
   end
end


function swim(geese2)
   --local distance = (geese2.endX - geese2.startX)
   local function closure() swim(geese2) end
   if (geese2.x == geese2.startX) then
      flux.to(geese2, 0.4, {scaleX = geese2.scale*-1}):ease("quadinout")
      flux.to(geese2, 9, {x=geese2.endX}):ease("quadinout"):delay(0.5):oncomplete(closure)
   elseif (geese2.x == geese2.endX) then
      flux.to(geese2, 0.4, {scaleX = geese2.scale}):ease("quadinout")
      flux.to(geese2, 9, {x=geese2.startX}):ease("quadinout"):delay(0.5):oncomplete(closure)
   else

      if math.random() < 0.5 then
         local distance = (geese2.endX - geese2.x)
         flux.to(geese2, 0.4, {scaleX = geese2.scale*-1}):ease("quadinout")
         flux.to(geese2, distance/122, {x=geese2.endX}):ease("quadinout"):delay(0.5):oncomplete(closure)
      else
         local distance = (geese2.x - geese2.startX)

         flux.to(geese2, 0.4, {scaleX = geese2.scale}):ease("quadinout")
         flux.to(geese2, distance/122, {x=geese2.startX}):ease("quadinout"):delay(0.5):oncomplete(closure)
      end
   end
end


function wobble(geese2)
   local function closure() wobble(geese2) end

   if (geese2.y == geese2.startY) then
      flux.to( geese2, 1, {y=geese2.startY+10}):ease("quadinout"):oncomplete(closure)
      flux.to( geese2.waterlevel, 1, {y=160}):ease("quadinout")
   else
      flux.to( geese2, 1, {y=geese2.startY}):ease("quadinout"):oncomplete(closure)
      flux.to( geese2.waterlevel, 1, {y=170}):ease("quadinout")
   end
end

function init_world_transform(item)
   item.world_transform = {};
   item.world_transform.position = {x=0, y=0};
   item.world_transform.scale = {x=0, y=0};
   item.world_transform.radian = 0
end


function recursive_print_values(root, prefix)
   print(prefix .. root.name)
   print(prefix .. "local transform")
   print(prefix .. root.local_transform.position.x);
   print(prefix .. root.local_transform.position.y);
   print(prefix .. root.local_transform.scale.x);
   print(prefix .. root.local_transform.scale.y);
   print(prefix .. root.local_transform.radian);
   print(prefix .. "world transform")
   print(prefix .. root.world_transform.position.x);
   print(prefix .. root.world_transform.position.y);
   print(prefix .. root.world_transform.scale.x);
   print(prefix .. root.world_transform.scale.y);
   print(prefix .. root.world_transform.radian);

   if (root.children) then
      for i, child in ipairs(root.children) do
         recursive_print_values(child, prefix .. "    ")
      end
   end
end


function local_to_parent(parent, x, y)
  local px, py = x, y
  -- scale
  px, py = px*parent.world_transform.scale.x, py*parent.world_transform.scale.y
  -- rotate
  local ca = math.cos(parent.world_transform.radian)
  local sa = math.sin(parent.world_transform.radian)
  local tx = ca*px - sa*py
  local ty = sa*px + ca*py
  px, py = tx, ty
  -- translate
  px = px + parent.world_transform.position.x
  py = py + parent.world_transform.position.y
  return px, py
end

function recursive_draw(root)
   if root.parent then
      x, y = local_to_parent(root.parent, root.local_transform.position.x, root.local_transform.position.y)
      scaleX = root.parent.world_transform.scale.x * root.local_transform.scale.x
      scaleY = root.parent.world_transform.scale.y * root.local_transform.scale.y
      radian = root.parent.world_transform.radian + root.local_transform.radian
   else
      x = root.local_transform.position.x
      y = root.local_transform.position.y
      scaleX = root.local_transform.scale.x
      scaleY = root.local_transform.scale.x
      radian = root.local_transform.radian
   end

   root.world_transform.position.x = x
   root.world_transform.position.y = y
   root.world_transform.scale.x = scaleX
   root.world_transform.scale.y = scaleY
   root.world_transform.radian = radian

   if root.img then
      if root.multiply then
         love.graphics.setBlendMode("multiply")
      elseif root.premultiply then
         love.graphics.setBlendMode("alpha", "premultiplied")
      else
         love.graphics.setBlendMode("alpha")
      end
      love.graphics.draw(root.img, x, y, radian, scaleX, scaleY, root.pivot.x, root.pivot.y)
   end

   if root.children then
      for i, child in ipairs(root.children) do
            recursive_draw(child)
      end
   end
end

function getIndex(array, item)
    for k,v in ipairs(array) do
        if v == item then return k end
    end
    return -1
end
function removeChild(parent, child)
   if not parent.children then return nil end
   index = getIndex(parent.children, child)
   if index > -1 then
      table.remove(parent.children, index)
      child.parent = nil
      return child
   end
   return nil
end
function addChild(parent, child)
   if not parent.children then
      parent.children = {}
   end
   table.insert(parent.children, child)
   child.parent = parent;
end

function love.visible(value)
   pause = not value
end
function love.focus(value)
   pause = not value
end

function love.update(dt)
   if love.keyboard.isDown("escape") then love.event.quit() end
   if pause then return end
   lovebird.update()
   for i, g in ipairs(multiple_geese) do
      g.old_x = g.x
   end

   flux.update(dt)
   for i, g in ipairs(multiple_geese) do
      g.dx = g.old_x - g.x
   end


   if love.keyboard.isDown("p") then
      local screenshot = love.graphics.newScreenshot();
      screenshot:encode('png', os.time() .. '.png');
   end

   -- if sun.dragging.active then
   --    local x1, y1 = push:toGame(x, y)
   --    if (x1 and y1) then
   --       if x1 then sun.local_transform.position.x = x1 - sun.dragging.diffX end
   --       if y1 then sun.local_transform.position.y = y1 - sun.dragging.diffY end
   --       local dist = distance(sun.origin.x, sun.origin.y, sun.local_transform.position.x, sun.local_transform.position.y)
   --       local scale = 1.0 + (dist/1000)
   --       sun.local_transform.scale.x = scale
   --       sun.local_transform.scale.y = scale
   --    end
   -- end

end

function love.mousemoved( x, y, dx, dy)
   if sun.dragging.active then
      local x1, y1 = push:toGame(x, y)
      if (x1 and y1) then
         if x1 then sun.local_transform.position.x = x1 - sun.dragging.diffX end
         if y1 then sun.local_transform.position.y = y1 - sun.dragging.diffY end
         local dist = distance(sun.origin.x, sun.origin.y, sun.local_transform.position.x, sun.local_transform.position.y)
         local scale = 1.0 + (dist/1000)
         sun.local_transform.scale.x = scale
         sun.local_transform.scale.y = scale
      end
   end
end


function love.resize(w, h)
  push:resize(w, h)
end

function love.mousepressed(x, y, button)
   if button == 1 then
      local x1, y1 = push:toGame(x, y)
      for i, g in ipairs(multiple_geese) do
         if pointInCircle(x1, y1, g.geese_canvas.body_circle) or pointInCircle(x1, y1, g.geese_canvas.head_circle)  then
            if g.sound_instance then
               g.sound_instance:stop()
            end
            g.sound_instance = geese_honk1:play()
            g.sound_instance:setPitch(.95 + math.random() * .1)
            quak(g)
         end
      end

      if (pointInCircle(x1, y1, {x=sun.local_transform.position.x, y=sun.local_transform.position.y, radius=110})) then
         --growShrinkSun()
         if sun.tweenPos then sun.tweenPos:stop() end
         if sun.tweenScale then sun.tweenScale:stop() end

         sun.dragging.active = true
         sun.dragging.diffX = x1 - sun.local_transform.position.x
         sun.dragging.diffY = y1 - sun.local_transform.position.y
      end
   end
end

function love.mousereleased(x, y, button)
   if (sun.dragging.active) then
      sun.dragging.active = false
      boing:stop()
      tweenSunBackToOrigin()
      boing:setPitch(0.75 + math.random()*0.5)
      boing:play()
   end

end


function getGradientedGeeseCanvas(geese2)
   canvas = love.graphics.newCanvas(300, 250)
   love.graphics.setCanvas(canvas)
   love.graphics.clear()
   love.graphics.setColor(0xff,0xff,0xff)
   recursive_draw(geese2.geese_root)
   love.graphics.setBlendMode("multiply")
   love.graphics.draw(geese2.geese_gradient.img, 0,  geese2.waterlevel.y, 0, 1, 1, 0, 0)
   love.graphics.setBlendMode("alpha")
   love.graphics.setCanvas()
   return canvas
end

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

function drawinrect(img, x, y, w, h, r, ox, oy, kx, ky)
    return -- tail call for a little extra bit of efficiency
    love.graphics.draw(img, x, y, r, w / img:getWidth(), h / img:getHeight(), ox, oy, kx, ky)
end

function lerp(a, b, t)
	return a + (b - a) * t
end

function lerp3(a, b, t)
   return {lerp(a[1],b[1],t), lerp(a[2],b[2],t), lerp(a[3],b[3],t)}

end

dusk_data = {
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

evening_data = {
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

day_data = {
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

night_data = {
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


function love.draw()

   -- initialize temp canvasses for all geese
   love.graphics.setColor(0xff,0xff,0xff)
   for i, g in ipairs(multiple_geese) do
      g.temp_canvas = getGradientedGeeseCanvas(g)
   end

   -- draw all individueal canvasses for geese
   for i, g in ipairs(multiple_geese) do
      geese_canvas = getDisplayObject(g.temp_canvas, g.x, g.y, 150, 200)
      geese_canvas.local_transform.scale.x = g.scaleX
      geese_canvas.local_transform.scale.y = g.scaleY
      geese_canvas.premultiply= true

      geese_canvas.body_circle = {x=geese_canvas.local_transform.position.x,  y=geese_canvas.local_transform.position.y-50, radius=80*geese_canvas.world_transform.scale.x}
      geese_canvas.head_circle = {x=geese_canvas.local_transform.position.x  + (g.scaleX * -50),  y=geese_canvas.local_transform.position.y-50-100, radius=40*geese_canvas.world_transform.scale.x}
      --geese_canvas.sound_instance = nil;

      addChild(backdrop, geese_canvas)
      g.geese_canvas = geese_canvas
   end

   push:start()


   --love.graphics.setColor( 100, 100, 255, 255)
   --love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)

   --love.graphics.setColor(0xff,0xff,0xff)

   local t = sun.local_transform.position.y/love.graphics.getHeight()
   if t < 0 then t = 0 end
   if t > 1 then t = 1 end

   -- if t < 0.5 then this will be day - dusk transformtaion
   -- if t > 0.5 then this will be dusk to night transformtaion


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


      drawinrect(gr, 0,0, 1024*2, 768*1.2)
      love.graphics.setColor(0xff,                 0xff - ((t1/2)*0xff)   ,0xff)

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

      drawinrect(gr, 0,0, 1024*2, 768*1.2)
      love.graphics.setColor(0xff - ((t1/1.5)*0xff), (0xff/2) - ((t1/2)*0xff) ,0xff )
   end



    recursive_draw(backdrop)


   -- for i, g in ipairs(multiple_geese) do
   --    love.graphics.setColor(0xff,0x00,0xff)
   --    love.graphics.circle("fill", g.geese_canvas.body_circle.x, g.geese_canvas.body_circle.y, g.geese_canvas.body_circle.radius, 40);
   --    love.graphics.setColor(0xff,0x00,0x00)
   --    love.graphics.circle("fill", g.geese_canvas.head_circle.x, g.geese_canvas.head_circle.y, g.geese_canvas.head_circle.radius, 40);
   -- end

   for i, g in ipairs(multiple_geese) do
      removeChild(backdrop, g.geese_canvas)
   end

   -- local sun_dist = math.abs(sun.origin.y - sun.local_transform.position.y)/5
   -- local red_tint = 0
   -- if sun_dist > 100 and sun_dist < 150 then
   --    red_tint = math.abs(125 - sun_dist)
   --    red_tint = 125 - red_tint
   -- end
   -- local sun_blue = math.abs(sun.origin.x - sun.local_transform.position.x)/10

   -- --love.graphics.setColor( red_tint, red_tint, sun_blue, sun_dist)
   -- love.graphics.setColor( 100, 100, 255, 255)
   -- love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
   -- love.graphics.setBlendMode("alpha")
   -- love.graphics.setBlendMode("alpha", "premultiplied")
   -- --love.graphics.setCanvas()




   --love.graphics.draw(foreground_canvas)




   push:finish()
end

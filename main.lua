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

function pointInCircle(x,y, circle)
   if not x or not y then return false end
   local dx = x - circle.x
   local dy = y - circle.y
   local dist = math.sqrt(dx * dx + dy * dy)
   return dist < circle.radius
end


function makeGoose(x, y, startX, endX, startY, scale)
   local geese = {}
   geese.waterlevel = {y=160}
   geese.dx = 0
   geese.y = y
   geese.x = x
   geese.scaleX = scale
   geese.scaleY = scale
   geese.scale = scale
   geese.geese_canvas = nil
   geese.temp_canvas = nil
   geese.sound_instance = nil
   geese.old_x = nil
   geese.startX = startX
   geese.endX = endX
   geese.startY = startY

   geese.geese_root = getDisplayObject(nil, 150,200,0.5 * geese_torso_img:getWidth(), 1.0 * geese_torso_img:getHeight())
   geese.geese_back_foot = getDisplayObject(geese_foot_img, 0, -25, 1.0 * geese_foot_img:getWidth(), 0 * geese_foot_img:getHeight())
   geese.geese_back_foot.local_transform.radian = math.rad(-40);
   geese.geese_front_foot = getDisplayObject(geese_foot_img, 15, -10, 1.0 * geese_foot_img:getWidth(), 0 * geese_foot_img:getHeight())
   geese.geese_front_foot.local_transform.radian = math.rad(-40);
   geese.geese_torso = getDisplayObject(geese_torso_img, 0, 0, 0.5 * geese_torso_img:getWidth(), 1.0 * geese_torso_img:getHeight())
   geese.geese_eye = getDisplayObject(geese_eye_img, -65, -155, 0.5 * geese_eye_img:getWidth(), 1.0 * geese_eye_img:getHeight())
   geese.geese_beak_top = getDisplayObject(geese_beak_top_img, -78, -160, 1.0 * geese_beak_top_img:getWidth(), 1.0 * geese_beak_top_img:getHeight() )
   geese.geese_beak_top.local_transform.radian = math.rad(-20);
   geese.geese_beak_bottom = getDisplayObject(geese_beak_bottom_img, -78, -160, 1.0 * geese_beak_bottom_img:getWidth(), 0 * geese_beak_bottom_img:getHeight() )
   geese.geese_beak_bottom.local_transform.radian = math.rad(10);
   geese.geese_gradient = getDisplayObject(geese_gradient_img, 0, 50, 0.5 * geese_gradient_img:getWidth(), 1.0 * geese_gradient_img:getHeight())
   geese.geese_gradient.multiply = true

   addChild(geese.geese_root, geese.geese_back_foot)
   addChild(geese.geese_root, geese.geese_torso)
   addChild(geese.geese_root, geese.geese_front_foot)
   addChild(geese.geese_torso, geese.geese_beak_top)
   addChild(geese.geese_torso, geese.geese_beak_bottom)
   addChild(geese.geese_torso, geese.geese_eye)

   return geese
end



function love.load()



   music = love.audio.newSource('sounds/clarinet_duck_jaunty.ogg', 'stream')
   music:setLooping(true)
   music:setPitch(1.0)
   love.audio.play(music)

   --geese_honk = love.audio.newSource({'sounds/geese_honk_1.ogg', 'sounds/geese_honk_1.ogg', 'sounds/geese_honk_3.ogg', 'sounds/geese_honk_4.ogg'}, 'static')

   --TLfres.setScreen({w=1024, h=768}, 1024*2, false, false)
   local gameWidth, gameHeight = 1024*2, 768*2 --fixed game resolution
   local windowWidth, windowHeight = love.window.getDesktopDimensions()
   -- love.window.setMode(windowWidth, windowHeight, {highdpi=true})
   push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {highdpi=true, canvas=true})
   love.graphics.setBackgroundColor(0x7A, 0xB4, 0xF8)


   geese_honk1 = love.audio.newSource({'sounds/geese_honk_1.ogg'}, 'static')

   geese_torso_img = love.graphics.newImage("images/geese_torso2.png")
   geese_eye_img = love.graphics.newImage("images/geese_eye.png")
   geese_foot_img = love.graphics.newImage("images/geese_foot.png")
   geese_beak_top_img = love.graphics.newImage("images/geese_beak_top.png")
   geese_beak_bottom_img = love.graphics.newImage("images/geese_beak_bottom.png")
   geese_beak_bottom_img:setFilter('nearest','nearest')
   geese_gradient_img = love.graphics.newImage("images/gradient.png")

   backdrop_img = love.graphics.newImage("images/backdrop.png")
   bushes_back_img = love.graphics.newImage("bushes_back.png")
   bushes_front_img = love.graphics.newImage("images/bushes_front.png")
   sun_img = love.graphics.newImage("images/sun.png")

   tree_1_img = love.graphics.newImage("images/tree1.png")
   tree_2_img = love.graphics.newImage("images/tree2.png")

   pond_img = love.graphics.newImage("images/pond.png")

   backdrop = getDisplayObject(backdrop_img, 0, 0)
   bushes_back = getDisplayObject(bushes_back_img, 160, 950)
   bushes_front = getDisplayObject(bushes_front_img, 110, 940)
   tree1 = getDisplayObject(tree_1_img, 20, 100)
   tree2 = getDisplayObject(tree_2_img, 1050, 100)
   pond = getDisplayObject(pond_img, 150, 1100)
   sun = getDisplayObject(sun_img, 1700, 200, 0.5 * sun_img:getWidth(),  0.5 * sun_img:getHeight())



   addChild(backdrop, pond)
   addChild(backdrop, sun)
   addChild(backdrop, bushes_back)
   addChild(backdrop, tree1)
   addChild(backdrop, tree2)
   addChild(backdrop, bushes_front)



   multiple_geese = {}
   local geese = makeGoose(500,1200, 500,1600,1200, 1.1)
   multiple_geese[1] = geese
   wobble(geese)
   swim_paddle_feet(geese)
   swim(geese)

   local geese4 = makeGoose(1400, 1250, 500,1600,1250, 1.2)
   multiple_geese[2] = geese4
   wobble(geese4)
   swim_paddle_feet(geese4)
   swim(geese4)

   local geese2 = makeGoose(800, 1300, 500,1600, 1300, 1.3)
   multiple_geese[3] = geese2
   wobble(geese2)
   swim_paddle_feet(geese2)
   swim(geese2)

   local geese3 = makeGoose(1000, 1400, 500,1600, 1400, 1.4)
   multiple_geese[4] = geese3
   wobble(geese3)
   swim_paddle_feet(geese3)
   swim(geese3)
end


function growShrinkSun()
   flux.to(sun.local_transform.scale, 0.5, {x=1.3, y=1.3})
   flux.to(sun.local_transform.scale, 1, {x=1, y=1}):delay(0.5)

end


function quak(geese3)
   print("geese beak top id: ", geese3.geese_beak_top)
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
   --print(distance/9) -- 122px per sec.
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

function love.update(dt)
   lovebird.update()
   for i, g in ipairs(multiple_geese) do
      g.old_x = g.x
   end

   flux.update(dt)
   for i, g in ipairs(multiple_geese) do
      g.dx = g.old_x - g.x
   end

   if love.keyboard.isDown("escape") then love.event.quit() end
   if love.keyboard.isDown("p") then
      local screenshot = love.graphics.newScreenshot();
      screenshot:encode('png', os.time() .. '.png');
   end

end

function love.mousepressed(x, y, button)
   if button == 1 then
      local x1, y1 = push:toGame(x, y)
      --local transformation = TLfres.getTransform()
      for i, g in ipairs(multiple_geese) do
         if pointInCircle(x1, y1, g.geese_canvas.body_circle) or pointInCircle(x1, y1, g.geese_canvas.head_circle)  then
            if g.sound_instance then
               g.sound_instance:stop()
            end
            g.sound_instance = geese_honk1:play()
            g.sound_instance:setPitch(.95 + math.random() * .1)
            quak(g)
            print("qauk", g)
         end
      end

      if (pointInCircle(x1, y1, {x=sun.local_transform.position.x, y=sun.local_transform.position.y, radius=110})) then
         growShrinkSun()
      end
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



function love.draw()
   love.graphics.setColor(0xff,0xff,0xff)
   for i, g in ipairs(multiple_geese) do
      g.temp_canvas = getGradientedGeeseCanvas(g)
   end


   push:start()
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

   push:finish()
end

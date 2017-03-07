local flux = require 'vendor/flux'
local push = require 'vendor/push'

require 'scene_graph'
require 'util'
require 'vendor/slam'
require 'gradient'

local lovebird = require 'vendor/lovebird'
lovebird.port = 3333 -- http://localhost:3333

function makeGoose(x, y, startX, endX, startY, scale, waterLevel)
   local goose = {}
   goose.waterlevel = {y=waterLevel}
   goose.startWaterlevel = {y=waterLevel}
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

   goose.root = getDisplayObject(nil, 250, 200,0.5 * geese_torso_img:getWidth(), 1.0 * geese_torso_img:getHeight())
   goose.back_foot = getDisplayObject(geese_foot_img, 0, -25, 1.0 * geese_foot_img:getWidth(), 0 * geese_foot_img:getHeight())
   goose.back_foot.local_transform.radian = math.rad(-40)
   goose.front_foot = getDisplayObject(geese_foot_img, 15, -10, 1.0 * geese_foot_img:getWidth(), 0 * geese_foot_img:getHeight())
   goose.front_foot.local_transform.radian = math.rad(-40)
   goose.torso = getDisplayObject(geese_torso_img, 0, 0, 0.5 * geese_torso_img:getWidth(), 1.0 * geese_torso_img:getHeight())
   goose.eye = getDisplayObject(geese_eye_img, -65, -160, 0.5 * geese_eye_img:getWidth(), 0.5 * geese_eye_img:getHeight())
   goose.eye_close = getDisplayObject(geese_eye_close_img, -65, -165, 0.5 * geese_eye_close_img:getWidth(), 0 * geese_eye_close_img:getHeight())

   goose.eye_close.local_transform.scale.y = 0

   goose.beak_top = getDisplayObject(geese_beak_top_img, -78, -160, 1.0 * geese_beak_top_img:getWidth(), 1.0 * geese_beak_top_img:getHeight() )
   goose.beak_top.local_transform.radian = math.rad(-20);
   goose.beak_bottom = getDisplayObject(geese_beak_bottom_img, -78, -160, 1.0 * geese_beak_bottom_img:getWidth(), 0 * geese_beak_bottom_img:getHeight() )
   goose.beak_bottom.local_transform.radian = math.rad(10);
   goose.gradient = getDisplayObject(geese_gradient_img, 0, 50, 0.5 * geese_gradient_img:getWidth(), 1.0 * geese_gradient_img:getHeight())
   goose.gradient.multiply = true

   goose.tweens = {back_foot=nil, front_foot=nil, posx=nil, posy=nil, scale=nil, waterlevel=nil, eye_lid1=nil, eye_lid2=nil}


   addChild(goose.root, goose.back_foot)
   addChild(goose.root, goose.torso)
   addChild(goose.root, goose.front_foot)
   addChild(goose.torso, goose.beak_top)
   addChild(goose.torso, goose.beak_bottom)
   addChild(goose.torso, goose.eye)
   addChild(goose.torso, goose.eye_close)

   return goose
end


function makeMallardChick(x, y, startX, endX, startY, scale, waterLevel)
   local mallard_chick = {}
   mallard_chick.waterlevel = {y=waterLevel}
   mallard_chick.startWaterlevel = {y=waterLevel}

   mallard_chick.dx = 0
   mallard_chick.y = y
   mallard_chick.x = x
   mallard_chick.scaleX = scale
   mallard_chick.scaleY = scale
   mallard_chick.scale = scale
   mallard_chick.geese_canvas = nil
   mallard_chick.temp_canvas = nil
   mallard_chick.sound_instance = nil
   mallard_chick.old_x = nil
   mallard_chick.startX = startX
   mallard_chick.endX = endX
   mallard_chick.startY = startY

   mallard_chick.root = getDisplayObject(nil, 250,200,0.5 * mallard_chick_torso_img:getWidth(), 1.0 * mallard_chick_torso_img:getHeight())
   mallard_chick.torso = getDisplayObject(mallard_chick_torso_img, 0, 0, 0.5 * mallard_chick_torso_img:getWidth(), 1.0 * mallard_chick_torso_img:getHeight())

   mallard_chick.back_foot = getDisplayObject(mallard_chick_foot_img, 0, -20, 1.0 * mallard_chick_foot_img:getWidth(), 0 * mallard_chick_foot_img:getHeight())
   mallard_chick.back_foot.local_transform.radian = math.rad(0);
   mallard_chick.front_foot = getDisplayObject(mallard_chick_foot_img, 15, -10, 1.0 *mallard_chick_foot_img:getWidth(), 0 * mallard_chick_foot_img:getHeight())
   mallard_chick.front_foot.local_transform.radian = math.rad(0);

   mallard_chick.beak_top = getDisplayObject(mallard_chick_beak_top_img, -32, -70, 1.0 * mallard_chick_beak_top_img:getWidth(), 1.0 * mallard_chick_beak_top_img:getHeight() )
   mallard_chick.beak_top.local_transform.radian = math.rad(0);
   mallard_chick.beak_bottom = getDisplayObject(mallard_chick_beak_bottom_img, -32, -70, 1.0 * mallard_chick_beak_bottom_img:getWidth(), 0 * mallard_chick_beak_bottom_img:getHeight() )
   mallard_chick.beak_bottom.local_transform.radian = math.rad(0);
   mallard_chick.eye = getDisplayObject(mallard_eye_img, -20, -67, 0.5 * mallard_eye_img:getWidth(), 1.0 * mallard_eye_img:getHeight())

   mallard_chick.gradient = getDisplayObject(geese_gradient_img, 0, 50, 0.5 * geese_gradient_img:getWidth(), 1.0 * geese_gradient_img:getHeight())
   mallard_chick.gradient.multiply = true
   mallard_chick.eye_close = getDisplayObject(geese_eye_close_img, -20, -77, 0.5 * geese_eye_close_img:getWidth(), 0 * geese_eye_close_img:getHeight())
   mallard_chick.eye_close.local_transform.scale.y = 0

   mallard_chick.tweens = {back_foot=nil, front_foot=nil, posx=nil, posy=nil, scale=nil, waterlevel=nil, eye_lid1=nil, eye_lid2=nil}

   addChild(mallard_chick.root,  mallard_chick.back_foot)
   addChild(mallard_chick.root,  mallard_chick.torso)
   addChild(mallard_chick.root,  mallard_chick.front_foot)
   addChild(mallard_chick.torso, mallard_chick.beak_top)
   addChild(mallard_chick.torso, mallard_chick.beak_bottom)
   addChild(mallard_chick.torso, mallard_chick.eye)
   addChild(mallard_chick.torso, mallard_chick.eye_close)
   return mallard_chick
end


function makeMallardMale(x, y, startX, endX, startY, scale, waterLevel)
   local mallard_male = {}
   mallard_male.waterlevel = {y=waterLevel}
   mallard_male.startWaterlevel = {y=waterLevel}

   mallard_male.dx = 0
   mallard_male.y = y
   mallard_male.x = x
   mallard_male.scaleX = scale
   mallard_male.scaleY = scale
   mallard_male.scale = scale
   mallard_male.geese_canvas = nil
   mallard_male.temp_canvas = nil
   mallard_male.sound_instance = nil
   mallard_male.old_x = nil
   mallard_male.startX = startX
   mallard_male.endX = endX
   mallard_male.startY = startY

   mallard_male.root = getDisplayObject(nil, 250,200,0.5 * mallard_male_torso_img:getWidth(), 1.0 * mallard_male_torso_img:getHeight())
   mallard_male.torso = getDisplayObject(mallard_male_torso_img, 0, 0, 0.5 * mallard_male_torso_img:getWidth(), 1.0 * mallard_male_torso_img:getHeight())

   mallard_male.back_foot = getDisplayObject(mallard_male_foot_img, 0, -20, 1.0 * mallard_male_foot_img:getWidth(), 0 * mallard_male_foot_img:getHeight())
   mallard_male.back_foot.local_transform.radian = math.rad(0);
   mallard_male.front_foot = getDisplayObject(mallard_male_foot_img, 15, -10, 1.0 *mallard_male_foot_img:getWidth(), 0 * mallard_male_foot_img:getHeight())
   mallard_male.front_foot.local_transform.radian = math.rad(0);

   mallard_male.beak_top = getDisplayObject(mallard_male_beak_top_img, -50, -90, 1.0 * mallard_male_beak_top_img:getWidth(), 1.0 * mallard_male_beak_top_img:getHeight() )
   mallard_male.beak_top.local_transform.radian = math.rad(0);
   mallard_male.beak_bottom = getDisplayObject(mallard_male_beak_bottom_img, -50, -90, 1.0 * mallard_male_beak_bottom_img:getWidth(), 0 * mallard_male_beak_bottom_img:getHeight() )
   mallard_male.beak_bottom.local_transform.radian = math.rad(0);
   mallard_male.eye = getDisplayObject(mallard_eye_img, -40, -87, 0.5 * mallard_eye_img:getWidth(), 1.0 * mallard_eye_img:getHeight())

   mallard_male.gradient = getDisplayObject(geese_gradient_img, 0, 50, 0.5 * geese_gradient_img:getWidth(), 1.0 * geese_gradient_img:getHeight())
   mallard_male.gradient.multiply = true
   mallard_male.eye_close = getDisplayObject(geese_eye_close_img, -40, -97, 0.5 * geese_eye_close_img:getWidth(), 0 * geese_eye_close_img:getHeight())
   mallard_male.eye_close.local_transform.scale.y = 0

   mallard_male.tweens = {back_foot=nil, front_foot=nil, posx=nil, posy=nil, scale=nil, waterlevel=nil, eye_lid1=nil, eye_lid2=nil}

   addChild(mallard_male.root,  mallard_male.back_foot)
   addChild(mallard_male.root,  mallard_male.torso)
   addChild(mallard_male.root,  mallard_male.front_foot)
   addChild(mallard_male.torso, mallard_male.beak_top)
   addChild(mallard_male.torso, mallard_male.beak_bottom)
   addChild(mallard_male.torso, mallard_male.eye)
   addChild(mallard_male.torso, mallard_male.eye_close)
   return mallard_male
end

function makeMallardFemale(x, y, startX, endX, startY, scale, waterLevel)
   local mallard_female = {}
   mallard_female.waterlevel = {y=waterLevel}
   mallard_female.startWaterlevel = {y=waterLevel}

   mallard_female.dx = 0
   mallard_female.y = y
   mallard_female.x = x
   mallard_female.scaleX = scale
   mallard_female.scaleY = scale
   mallard_female.scale = scale
   mallard_female.geese_canvas = nil
   mallard_female.temp_canvas = nil
   mallard_female.sound_instance = nil
   mallard_female.old_x = nil
   mallard_female.startX = startX
   mallard_female.endX = endX
   mallard_female.startY = startY

   mallard_female.root = getDisplayObject(nil, 250,200,0.5 * mallard_female_torso_img:getWidth(), 1.0 * mallard_female_torso_img:getHeight())
   mallard_female.torso = getDisplayObject(mallard_female_torso_img, 0, 0, 0.5 * mallard_female_torso_img:getWidth(), 1.0 * mallard_female_torso_img:getHeight())

   mallard_female.back_foot = getDisplayObject(mallard_female_foot_img, 0, -20, 1.0 * mallard_female_foot_img:getWidth(), 0 * mallard_female_foot_img:getHeight())
   mallard_female.back_foot.local_transform.radian = math.rad(0);
   mallard_female.front_foot = getDisplayObject(mallard_female_foot_img, 15, -10, 1.0 *mallard_female_foot_img:getWidth(), 0 * mallard_female_foot_img:getHeight())
   mallard_female.front_foot.local_transform.radian = math.rad(0);

   mallard_female.beak_top = getDisplayObject(mallard_female_beak_top_img, -50, -90, 1.0 * mallard_female_beak_top_img:getWidth(), 1.0 * mallard_female_beak_top_img:getHeight() )
   mallard_female.beak_top.local_transform.radian = math.rad(0);
   mallard_female.beak_bottom = getDisplayObject(mallard_female_beak_bottom_img, -50, -90, 1.0 * mallard_female_beak_bottom_img:getWidth(), 0 * mallard_female_beak_bottom_img:getHeight() )
   mallard_female.beak_bottom.local_transform.radian = math.rad(0);
   mallard_female.eye = getDisplayObject(mallard_eye_img, -40, -87, 0.5 * mallard_eye_img:getWidth(), 1.0 * mallard_eye_img:getHeight())

   mallard_female.gradient = getDisplayObject(geese_gradient_img, 0, 50, 0.5 * geese_gradient_img:getWidth(), 1.0 * geese_gradient_img:getHeight())
   mallard_female.gradient.multiply = true
   mallard_female.eye_close = getDisplayObject(geese_eye_close_img, -40, -97, 0.5 * geese_eye_close_img:getWidth(), 0 * geese_eye_close_img:getHeight())
   mallard_female.eye_close.local_transform.scale.y = 0

   mallard_female.tweens = {back_foot=nil, front_foot=nil, posx=nil, posy=nil, scale=nil, waterlevel=nil, eye_lid1=nil, eye_lid2=nil}

   addChild(mallard_female.root,  mallard_female.back_foot)
   addChild(mallard_female.root,  mallard_female.torso)
   addChild(mallard_female.root,  mallard_female.front_foot)
   addChild(mallard_female.torso, mallard_female.beak_top)
   addChild(mallard_female.torso, mallard_female.beak_bottom)
   addChild(mallard_female.torso, mallard_female.eye)
   addChild(mallard_female.torso, mallard_female.eye_close)
   return mallard_female
end


function compareY(a,b)
  return a.y < b.y
end
function love.load()
   day_music = love.audio.newSource("sounds/clarinet_duck_jaunty.ogg", 'static')
   --

   day_music:setLooping(true)
   day_music:setPitch(1.0)
   love.audio.play(day_music)



   night_music = love.audio.newSource("sounds/nighttime.ogg", 'static')
   night_music:setLooping(true)
   night_music:setPitch(1.0)
   night_music:setVolume(0.0)
   love.audio.play(night_music)

   --love.audio.stop(night_music)


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
   geese_eye_close_img = love.graphics.newImage("images/geese_eye_close.png")
   geese_foot_img = love.graphics.newImage("images/geese_foot.png")
   geese_beak_top_img = love.graphics.newImage("images/geese_beak_top.png")
   geese_beak_bottom_img = love.graphics.newImage("images/geese_beak_bottom.png")
   geese_beak_bottom_img:setFilter('nearest','nearest')
   geese_gradient_img = love.graphics.newImage("images/gradient.png")


   mallard_male_torso_img = love.graphics.newImage("images/mallard_male_torso.png")
   mallard_male_foot_img = love.graphics.newImage("images/mallard_male_foot.png")
   mallard_male_beak_top_img = love.graphics.newImage("images/mallard_male_beak_top.png")
   mallard_male_beak_bottom_img = love.graphics.newImage("images/mallard_male_beak_bottom.png")

   mallard_female_torso_img = love.graphics.newImage("images/mallard_female_torso.png")
   mallard_female_foot_img = love.graphics.newImage("images/mallard_female_foot.png")
   mallard_female_beak_top_img = love.graphics.newImage("images/mallard_female_beak_top.png")
   mallard_female_beak_bottom_img = love.graphics.newImage("images/mallard_female_beak_bottom.png")

   mallard_chick_torso_img = love.graphics.newImage("images/mallard_chick_torso.png")
   mallard_chick_foot_img = love.graphics.newImage("images/mallard_chick_foot.png")
   mallard_chick_beak_top_img = love.graphics.newImage("images/mallard_chick_beak_top.png")
   mallard_chick_beak_bottom_img = love.graphics.newImage("images/mallard_chick_beak_bottom.png")


   mallard_eye_img = love.graphics.newImage("images/mallard_eye.png")



   grass_img = love.graphics.newImage("images/grass.png")
   bushes_back_img = love.graphics.newImage("images/bushes_back2.png")
   bushes_front_img = love.graphics.newImage("images/bushes_front.png")
   sun_img = love.graphics.newImage("images/sun.png")
   moon_img = love.graphics.newImage("images/moon.png")

   tree_1_img = love.graphics.newImage("images/tree1.png")
   tree_2_img = love.graphics.newImage("images/tree2.png")

   pond_img = love.graphics.newImage("images/pond.png")

   backdrop = getDisplayObject(nil, 0, 0)

   grass = getDisplayObject(grass_img, 0, 770)
   bushes_back = getDisplayObject(bushes_back_img, 160, 950)
   bushes_front = getDisplayObject(bushes_front_img, 110, 940)
   tree1 = getDisplayObject(tree_1_img, 20, 100)
   tree2 = getDisplayObject(tree_2_img, 1050, 100)
   pond = getDisplayObject(pond_img, 150, 1100)
   sun = getDisplayObject(sun_img, 1700, 200, 0.5 * sun_img:getWidth(),  0.5 * sun_img:getHeight())
   moon = getDisplayObject(moon_img, (1024*2) - 1700, (768*2) - 200, 0.5 * moon_img:getWidth(),  0.5 * moon_img:getHeight())
   moon.color = {255,255,255,255}
   sun.origin = {x=1700, y=200}
   sun.dragging = { allowed = true, active = false, diffX = 0, diffY = 0}
   sun.tweens = {pos=nil, scale=nil}


   addChild(backdrop, sun)
   addChild(backdrop, moon)

   addChild(backdrop, grass)
   addChild(backdrop, pond)
   addChild(backdrop, bushes_back)
   addChild(backdrop, tree1)
   addChild(backdrop, tree2)
   addChild(backdrop, bushes_front)

   --local mallard = makeMallardMale(500,1200, 500,1600,1200, 1.1)
   --addChild(backdrop, mallard.root)

   multiple_geese = {}

   for i=1, 30, 1
   do
      --x, y, startX, endX, startY, scale, waterLevel
      local startX = 500
      local endX = 1600
      local startY = 1200
      local endY = 1400

      local x = love.math.random(startX, endX)
      local y = love.math.random(startY, endY)
      local scale = map(y, startY, endY, 0.8, 1.3)

      local bird = nil;
      if (love.math.random() < 0.5) then
         if (love.math.random() < 0.5) then
            if (love.math.random() < 0.5) then
               bird = makeMallardMale(x, y, startX, endX, y, scale, 175)
            else
               bird = makeMallardFemale(x, y, startX, endX, y, scale, 175)
            end
         else
             bird = makeMallardChick(x, y, startX, endX, y, scale, 175)
         end

      else
         bird = makeGoose(x, y, startX, endX, y, scale, 160)
      end
      multiple_geese[i] = bird

   end
   table.sort(multiple_geese, compareY)


   startOrStopSwimming('start')
   pause = false
   all_asleep = false
end


function startOrStopSwimming(v)
   if v == 'start' then
      for i, g in ipairs(multiple_geese) do
         if g.tweens.posy then g.tweens.posy:stop() end
         if g.tweens.waterlevel then g.tweens.waterlevel:stop() end
         if g.tweens.posx then g.tweens.posx:stop() end
         if g.tweens.back_foot then  g.tweens.back_foot:stop() end
         if g.tweens.front_foot then g.tweens.front_foot:stop() end
         if g.tweens.eye_lid1 then g.tweens.eye_lid1:stop() end
         if g.tweens.eye_lid2 then g.tweens.eye_lid2:stop() end
         swim_paddle_feet(g)
         swim(g)
         wobble(g)
         g.eye_close.local_transform.scale.y = 0
         blinkEyesOccasionaly(g)
      end
   elseif v == 'stop' then
      for i, g in ipairs(multiple_geese) do
         if g.tweens.posy then g.tweens.posy:stop() end
         if g.tweens.waterlevel then g.tweens.waterlevel:stop() end
         if g.tweens.posx then g.tweens.posx:stop() end
         if g.tweens.back_foot then  g.tweens.back_foot:stop() end
         if g.tweens.front_foot then g.tweens.front_foot:stop() end
         if g.tweens.eye_lid1 then g.tweens.eye_lid1:stop() end
         if g.tweens.eye_lid2 then g.tweens.eye_lid2:stop() end
         g.eye_close.local_transform.scale.y = 1
         wobble(g)
      end
   end
end

function assInSky(goose)
   flux.to( goose.torso.local_transform, 1, {radian = math.rad(-90)}):ease("elasticout")
   flux.to( goose.torso.local_transform, 1, {radian=0}):delay(1 +  love.math.random(8)):ease("elasticout")
end


function growShrinkSun()
   flux.to(sun.local_transform.scale, 0.5, {x=1.3, y=1.3})
   flux.to(sun.local_transform.scale, 1, {x=1, y=1}):delay(0.5)
end

function tweenSunBackToOrigin()
   sun.tweens.pos = flux.to(sun.local_transform.position, 4.5, {x=sun.origin.x, y=sun.origin.y}):ease("elasticout")
   sun.tweens.scale = flux.to(sun.local_transform.scale, 1.5, {x=1, y=1}):delay(.15)
end


function quak(geese3)
   flux.to(geese3.beak_top.local_transform, 0.4, {radian=math.rad(10)})
   flux.to(geese3.beak_top.local_transform, 0.2, {radian=math.rad(-20)}):delay(0.4)
   flux.to(geese3.beak_bottom.local_transform, 0.4, {radian=math.rad(-10)})
   flux.to(geese3.beak_bottom.local_transform, 0.2, {radian=math.rad(10)}):delay(0.4)
end

function blinkEyesOccasionaly(geese2)
   local function closure() blinkEyesOccasionaly(geese2) end
   geese2.tweens.eye_lid1 =  flux.to(geese2.eye_close.local_transform.scale, .1, {y=1.0}):delay(3)
   geese2.tweens.eye_lid2 = flux.to(geese2.eye_close.local_transform.scale, love.math.random()*0.2 + 0.1, {y=0}):delay(3.1):oncomplete(closure)
end


function swim_paddle_feet(geese2)
   local function closure() swim_paddle_feet(geese2) end
   local duration = 0.5

   if (geese2.back_foot.local_transform.radian <= math.rad(-40)) then
      geese2.tweens.back_foot = flux.to(geese2.back_foot.local_transform, duration, {radian=math.rad(40)})
      geese2.tweens.front_foot = flux.to(geese2.front_foot.local_transform, duration, {radian=math.rad(-40)}):oncomplete(closure)
   else
      geese2.tweens.back_foot = flux.to(geese2.back_foot.local_transform, duration, {radian=math.rad(-41)})
      geese2.tweens.front_foot = flux.to(geese2.front_foot.local_transform, duration, {radian=math.rad(40)}):oncomplete(closure)
   end
end


function swim(geese2)
   --local distance = (geese2.endX - geese2.startX)
   local function closure() swim(geese2) end

   if (geese2.x == geese2.startX) then
      geese2.tweens.scale = flux.to(geese2, 0.4, {scaleX = geese2.scale*-1}):ease("quadinout")
      geese2.tweens.posx = flux.to(geese2, 9, {x=geese2.endX}):ease("quadinout"):delay(0.5):oncomplete(closure)
   elseif (geese2.x == geese2.endX) then
      geese2.tweens.scale = flux.to(geese2, 0.4, {scaleX = geese2.scale}):ease("quadinout")
      geese2.tweens.posx = flux.to(geese2, 9, {x=geese2.startX}):ease("quadinout"):delay(0.5):oncomplete(closure)
   else
      if love.math.random() < 0.5 then
         local distance = (geese2.endX - geese2.x)
         local speed = love.math.random(100,122)
         geese2.tweens.scale = flux.to(geese2, 0.4, {scaleX = geese2.scale*-1}):ease("quadinout")
         geese2.tweens.posx = flux.to(geese2, distance/speed, {x=geese2.endX}):ease("quadinout"):delay(0.5):oncomplete(closure)
      else
         local distance = (geese2.x - geese2.startX)
         local speed = love.math.random(100,122)
         geese2.tweens.scale = flux.to(geese2, 0.4, {scaleX = geese2.scale}):ease("quadinout")
         geese2.tweens.posx = flux.to(geese2, distance/speed, {x=geese2.startX}):ease("quadinout"):delay(0.5):oncomplete(closure)
      end
   end
end


function wobble(geese2)
   local function closure() wobble(geese2) end

   if (geese2.y == geese2.startY) then
      geese2.tweens.posy = flux.to( geese2, 1, {y=geese2.startY+10}):ease("quadinout"):oncomplete(closure)
      geese2.tweens.waterlevel = flux.to( geese2.waterlevel, 1, {y=geese2.startWaterlevel.y}):ease("quadinout")
   else
      geese2.tweens.posy = flux.to( geese2, 1, {y=geese2.startY}):ease("quadinout"):oncomplete(closure)
      geese2.tweens.waterlevel = flux.to( geese2.waterlevel, 1, {y=geese2.startWaterlevel.y + 10}):ease("quadinout")
   end
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

   moon.local_transform.position.x = (1024*2) - sun.local_transform.position.x
   moon.local_transform.position.y = (768*2) - sun.local_transform.position.y
   moon.local_transform.scale.x = sun.local_transform.scale.x
   moon.local_transform.scale.y = sun.local_transform.scale.y

   local day_pitch = map(sun.local_transform.position.y, 200, 768*2, 1.00, 0.5)
   day_pitch = clamp(day_pitch, 0, 1)
   day_music:setPitch(day_pitch)

   local day_volume = map(sun.local_transform.position.y, 0, 768*2, 1.0, -0.5)
   day_volume = clamp(day_volume, 0, 1)

   local night_volume = map(sun.local_transform.position.y, 0, 768*2, -0.5, 1.0)
   night_volume = clamp(night_volume, 0, 1)

   local night_pitch = map(sun.local_transform.position.y, 200, 768*2, 0.7, 1.0)
   night_pitch = clamp(night_pitch, 0, 1)
   night_music:setPitch(night_pitch)

   day_music:setVolume(day_volume)
   night_music:setVolume(night_volume)


   if (sun.local_transform.position.y > moon.local_transform.position.y and  not all_asleep) then
      all_asleep = true
      startOrStopSwimming('stop')
   elseif (sun.local_transform.position.y < moon.local_transform.position.y and all_asleep) then
      all_asleep = false
      startOrStopSwimming('start')
   end
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
   --if button == 1 then
   local x1, y1 = push:toGame(x, y)
   local pressed_goose = nil
   for i, g in ipairs(multiple_geese) do
      if (g.geese_canvas) then
         if pointInCircle(x1, y1, g.geese_canvas.body_circle) or pointInCircle(x1, y1, g.geese_canvas.head_circle)  then
             pressed_goose = g;
         end
      end
   end

   if (pressed_goose) then
      if pressed_goose.sound_instance then
         pressed_goose.sound_instance:stop()
      end
      pressed_goose.sound_instance = geese_honk1:play()
      pressed_goose.sound_instance:setPitch(.95 + love.math.random() * .1)
      if (love.math.random() < 0.9) then
         quak(pressed_goose)
      else
         assInSky(pressed_goose)
      end
   end


   if (pointInCircle(x1, y1, {x=sun.local_transform.position.x, y=sun.local_transform.position.y, radius=110})) then
      --growShrinkSun()
      if sun.tweens.pos then sun.tweens.pos:stop() end
      if sun.tweens.scale then sun.tweens.scale:stop() end

      sun.dragging.active = true
      sun.dragging.diffX = x1 - sun.local_transform.position.x
      sun.dragging.diffY = y1 - sun.local_transform.position.y
   end
   --end
end

function love.mousereleased(x, y, button)
   if (sun.dragging.active) then
      sun.dragging.active = false
      boing:stop()
      tweenSunBackToOrigin()
      boing:setPitch(0.75 + love.math.random()*0.5)
      boing:play()
   end
end

function getGradientedGeeseCanvas(geese2)
   canvas = love.graphics.newCanvas(500, 250)
   love.graphics.setCanvas(canvas)
   love.graphics.clear()
   love.graphics.setColor(0xff,0xff,0xff)
   recursiveDraw(geese2.root)
   love.graphics.setBlendMode("multiply")
   love.graphics.draw(geese2.gradient.img, 0,  geese2.waterlevel.y, 0, 1, 1, 0, 0)
   love.graphics.setBlendMode("alpha")
   love.graphics.setCanvas()
   return canvas
end

function love.draw()

   love.graphics.setColor(0xff,0xff,0xff)
   for i, g in ipairs(multiple_geese) do
      g.temp_canvas = getGradientedGeeseCanvas(g)
   end

   for i, g in ipairs(multiple_geese) do
      geese_canvas = getDisplayObject(g.temp_canvas, g.x, g.y, 250, 200)
      geese_canvas.local_transform.scale.x = g.scaleX
      geese_canvas.local_transform.scale.y = g.scaleY
      geese_canvas.premultiply= true


      addChild(backdrop, geese_canvas)
      geese_canvas.body_circle = {x=geese_canvas.local_transform.position.x,
                                  y=geese_canvas.local_transform.position.y + ( g.scaleY * -50),
                                  radius= 80 * g.scaleY}

      geese_canvas.head_circle = {x=geese_canvas.local_transform.position.x  + (g.scaleX * -50),
                                  y=geese_canvas.local_transform.position.y + (g.scaleY * -150),
                                  radius=50 * g.scaleY}
      g.geese_canvas = geese_canvas
   end

   push:start()

   --local t = sun.local_transform.position.y/love.graphics.getHeight()
   local t = map(sun.local_transform.position.y, 200, love.graphics.getHeight(), 0, 1)
   drawSkyGradientAndSetFGColor(clamp(t, 0, 1))

   recursiveDraw(backdrop)

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

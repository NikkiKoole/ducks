local flux = require 'vendor/flux'
local push = require 'vendor/push'

require 'scene_graph'
require 'util'
require 'vendor/slam'
require 'gradient'
require 'autobatch'

local lovebird = require 'vendor/lovebird'




function makeGoose(x, y, startX, endX, startY, scale, waterLevel)
   local goose = {}
   goose.type = 'goose'
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

   goose.root = getDisplayObject(nil, nil, 250, 200,0.5 * atlas_birds['geese_torso2'].w, 1.0 * atlas_birds['geese_torso2'].h)
   goose.back_foot = getDisplayObject(birds_atlas_img, atlas_birds['geese_foot'].q,  0, -25, 1.0 * atlas_birds['geese_foot'].w, 0 * atlas_birds['geese_foot'].h)
   goose.back_foot.local_transform.radian = math.rad(-40)
   goose.front_foot = getDisplayObject(birds_atlas_img, atlas_birds['geese_foot'].q,  15, -10, 1.0 * atlas_birds['geese_foot'].w, 0 * atlas_birds['geese_foot'].h)
   goose.front_foot.local_transform.radian = math.rad(-40)
   goose.torso = getDisplayObject(birds_atlas_img, atlas_birds['geese_torso2'].q,  0, 0, 0.5 * atlas_birds['geese_torso2'].w, 1.0 * atlas_birds['geese_torso2'].h)
   goose.eye = getDisplayObject(birds_atlas_img, atlas_birds['geese_eye'].q,  -65, -160, 0.5 * atlas_birds['geese_eye'].w, 0.5 * atlas_birds['geese_eye'].h)
   goose.eye_close = getDisplayObject(birds_atlas_img, atlas_birds['geese_eye_close'].q, -65, -165, 0.5 * atlas_birds['geese_eye_close'].w, 0 * atlas_birds['geese_eye_close'].h)

   goose.eye_close.local_transform.scale.y = 0

   goose.beak_top = getDisplayObject(birds_atlas_img, atlas_birds['geese_beak_top'].q, -78, -160, 1.0 * atlas_birds['geese_beak_top'].w, 1.0 * atlas_birds['geese_beak_top'].h )
   goose.beak_top.local_transform.radian = math.rad(-20);
   goose.beak_bottom = getDisplayObject(birds_atlas_img, atlas_birds['geese_beak_bottom'].q, -78, -160, 1.0 * atlas_birds['geese_beak_bottom'].w, 0 * atlas_birds['geese_beak_bottom'].h )
   goose.beak_bottom.local_transform.radian = math.rad(10);
   goose.gradient = getDisplayObject(birds_atlas_img, atlas_birds['gradient'].q,  0, 50, 0.5 *  atlas_birds['gradient'].w, 1.0 *  atlas_birds['gradient'].h)
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
   mallard_chick.type = 'chick'

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

   mallard_chick.root = getDisplayObject(nil, nil, 250,200,0.5 * atlas_birds['mallard_chick_torso'].w, 1.0 * atlas_birds['mallard_chick_torso'].h)
   mallard_chick.torso = getDisplayObject(birds_atlas_img, atlas_birds['mallard_chick_torso'].q,  0, 0, 0.5 * atlas_birds['mallard_chick_torso'].w, 1.0 * atlas_birds['mallard_chick_torso'].h)

   mallard_chick.back_foot = getDisplayObject(birds_atlas_img, atlas_birds['mallard_chick_foot'].q, 0, -20, 1.0 * atlas_birds['mallard_chick_foot'].w, 0 * atlas_birds['mallard_chick_foot'].h)
   mallard_chick.back_foot.local_transform.radian = math.rad(0);
   mallard_chick.front_foot = getDisplayObject(birds_atlas_img, atlas_birds['mallard_chick_foot'].q, 15, -10, 1.0 *atlas_birds['mallard_chick_foot'].w, 0 * atlas_birds['mallard_chick_foot'].h)
   mallard_chick.front_foot.local_transform.radian = math.rad(0);

   mallard_chick.beak_top = getDisplayObject(birds_atlas_img, atlas_birds['mallard_chick_beak_top'].q, -32, -70, 1.0 *  atlas_birds['mallard_chick_beak_top'].w, 1.0 *  atlas_birds['mallard_chick_beak_top'].h )
   mallard_chick.beak_top.local_transform.radian = math.rad(-20);
   mallard_chick.beak_bottom = getDisplayObject(birds_atlas_img, atlas_birds['mallard_chick_beak_bottom'].q, -32, -70, 1.0 * atlas_birds['mallard_chick_beak_bottom'].w, 0 * atlas_birds['mallard_chick_beak_bottom'].h )
   mallard_chick.beak_bottom.local_transform.radian = math.rad(10);
   mallard_chick.eye = getDisplayObject(birds_atlas_img,  atlas_birds['mallard_eye'].q, -20, -67, 0.5 * atlas_birds['mallard_eye'].w, 1.0 * atlas_birds['mallard_eye'].h)

   mallard_chick.gradient = getDisplayObject(birds_atlas_img, atlas_birds['gradient'].q, 0, 50, 0.5 * atlas_birds['gradient'].w, 1.0 * atlas_birds['gradient'].h)
   mallard_chick.gradient.multiply = true
   mallard_chick.eye_close = getDisplayObject(birds_atlas_img, atlas_birds['geese_eye_close'].q, -20, -77, 0.5 * atlas_birds['geese_eye_close'].w, 0 * atlas_birds['geese_eye_close'].h)
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
   mallard_male.type = 'mallard'

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
   mallard_male.root = getDisplayObject(nil,nil, 250,200,0.5 * atlas_birds['mallard_male_torso'].w, 1.0 * atlas_birds['mallard_male_torso'].h)
   mallard_male.torso = getDisplayObject(birds_atlas_img, atlas_birds['mallard_male_torso'].q, 0, 0, 0.5 * atlas_birds['mallard_male_torso'].w, 1.0 *atlas_birds['mallard_male_torso'].h)

   mallard_male.back_foot = getDisplayObject(birds_atlas_img, atlas_birds['mallard_male_foot'].q, 0, -20, 1.0 *atlas_birds['mallard_male_foot'].w, 0 * atlas_birds['mallard_male_foot'].h)
   mallard_male.back_foot.local_transform.radian = math.rad(0);
   mallard_male.front_foot = getDisplayObject(birds_atlas_img, atlas_birds['mallard_male_foot'].q, 15, -10, 1.0 *atlas_birds['mallard_male_foot'].w, 0 * atlas_birds['mallard_male_foot'].h)
   mallard_male.front_foot.local_transform.radian = math.rad(0);

   mallard_male.beak_top = getDisplayObject(birds_atlas_img, atlas_birds['mallard_male_beak_top'].q, -50, -90, 1.0 * atlas_birds['mallard_male_beak_top'].w, 1.0 * atlas_birds['mallard_male_beak_top'].h )
   mallard_male.beak_top.local_transform.radian = math.rad(-20);
   mallard_male.beak_bottom = getDisplayObject(birds_atlas_img, atlas_birds['mallard_male_beak_bottom'].q, -50, -90, 1.0 * atlas_birds['mallard_male_beak_bottom'].w, 0 * atlas_birds['mallard_male_beak_bottom'].h )
   mallard_male.beak_bottom.local_transform.radian = math.rad(10);
   mallard_male.eye = getDisplayObject(birds_atlas_img, atlas_birds['mallard_eye'].q, -40, -87, 0.5 * atlas_birds['mallard_eye'].w, 1.0 * atlas_birds['mallard_eye'].h)

   mallard_male.gradient = getDisplayObject(birds_atlas_img, atlas_birds['gradient'].q, 0, 50, 0.5 * atlas_birds['gradient'].w, 1.0 * atlas_birds['gradient'].h)
   mallard_male.gradient.multiply = true
   mallard_male.eye_close = getDisplayObject(birds_atlas_img, atlas_birds['geese_eye_close'].q, -40, -97, 0.5 * atlas_birds['geese_eye_close'].w, 0 * atlas_birds['geese_eye_close'].h)
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
   mallard_female.type = 'mallard'

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

   mallard_female.root = getDisplayObject(nil,nil, 250,200,0.5 * atlas_birds['mallard_female_torso'].w, 1.0 * atlas_birds['mallard_female_torso'].h)
   mallard_female.torso = getDisplayObject(birds_atlas_img, atlas_birds['mallard_female_torso'].q, 0, 0, 0.5 * atlas_birds['mallard_female_torso'].w, 1.0 * atlas_birds['mallard_female_torso'].h)

   mallard_female.back_foot = getDisplayObject(birds_atlas_img, atlas_birds['mallard_female_foot'].q, 0, -20, 1.0 * atlas_birds['mallard_female_foot'].w, 0 * atlas_birds['mallard_female_foot'].h)
   mallard_female.back_foot.local_transform.radian = math.rad(0);
   mallard_female.front_foot = getDisplayObject(birds_atlas_img, atlas_birds['mallard_female_foot'].q, 15, -10, 1.0 *atlas_birds['mallard_female_foot'].w, 0 * atlas_birds['mallard_female_foot'].h)
   mallard_female.front_foot.local_transform.radian = math.rad(0);

   mallard_female.beak_top = getDisplayObject(birds_atlas_img, atlas_birds['mallard_female_beak_top'].q, -50, -90, 1.0 * atlas_birds['mallard_female_beak_top'].w, 1.0 * atlas_birds['mallard_female_beak_top'].h )
   mallard_female.beak_top.local_transform.radian = math.rad(-20);
   mallard_female.beak_bottom = getDisplayObject(birds_atlas_img, atlas_birds['mallard_female_beak_bottom'].q, -50, -90, 1.0 * atlas_birds['mallard_female_beak_bottom'].w, 0 * atlas_birds['mallard_female_beak_bottom'].h )
   mallard_female.beak_bottom.local_transform.radian = math.rad(10);
   mallard_female.eye = getDisplayObject(birds_atlas_img, atlas_birds['mallard_eye'].q, -40, -87, 0.5 * atlas_birds['mallard_eye'].w, 1.0 * atlas_birds['mallard_eye'].h)

   mallard_female.gradient = getDisplayObject(birds_atlas_img, atlas_birds['gradient'].q, 0, 50, 0.5 *  atlas_birds['gradient'].w, 1.0 *  atlas_birds['gradient'].h)
   mallard_female.gradient.multiply = true
   mallard_female.eye_close = getDisplayObject(birds_atlas_img, atlas_birds['geese_eye_close'].q, -40, -97, 0.5 * atlas_birds['geese_eye_close'].w, 0 * atlas_birds['geese_eye_close'].h)
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



function love.load()
   lovebird.port = 3333 -- http://localhost:3333
   love.math.setRandomSeed(6 )


   terrain_atlas_img = love.graphics.newImage('atlas/terrain.png')
   birds_atlas_img = love.graphics.newImage('atlas/birds.png')
   entities_atlas_img = love.graphics.newImage('atlas/entities.png')
   require('atlas.terrain')
   require('atlas.birds')
   require('atlas.entities')

   for k, v in pairs(atlas_terrain) do
      atlas_terrain[k].q = love.graphics.newQuad(v.x, v.y, v.w, v.h, terrain_atlas_img:getWidth(), terrain_atlas_img:getHeight())
   end
   for k, v in pairs(atlas_birds) do
      atlas_birds[k].q = love.graphics.newQuad(v.x, v.y, v.w, v.h, birds_atlas_img:getWidth(), birds_atlas_img:getHeight())
   end
   for k, v in pairs(atlas_entities) do
      atlas_entities[k].q = love.graphics.newQuad(v.x, v.y, v.w, v.h, entities_atlas_img:getWidth(), entities_atlas_img:getHeight())
   end


   day_music = love.audio.newSource("sounds/clarinet_duck_jaunty.ogg", 'static')

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
   duck_honk1 = love.audio.newSource('sounds/duck.ogg', 'static')
   boing = love.audio.newSource('sounds/boing.wav', 'static')
   splash1 = love.audio.newSource('sounds/splash1.ogg', 'static')

   backdrop = getDisplayObject(nil,nil, 0, 0)

   grass = getDisplayObject(terrain_atlas_img,        atlas_terrain['backdrop'].q, 0, 770)
   foreground = getDisplayObject(terrain_atlas_img,   atlas_terrain['foreground'].q , 0, 1320)
   bushes_back = getDisplayObject(terrain_atlas_img,  atlas_terrain['bushes_back2'].q, 160, 950)
   bushes_front = getDisplayObject(terrain_atlas_img, atlas_terrain['bushes_front'].q, 110, 940)


   tree1 = getDisplayObject(entities_atlas_img, atlas_entities['tree1'].q, 20, 100)
   tree2 = getDisplayObject(entities_atlas_img, atlas_entities['tree2'].q, 1050, 100)
   sun = getDisplayObject(entities_atlas_img, atlas_entities['sun'].q, 1700, 200, 0.5 * atlas_entities['sun'].w,  0.5 * atlas_entities['sun'].h)
   moon = getDisplayObject(entities_atlas_img, atlas_entities['moon'].q, (1024*2) - 1700, (768*2) - 200, 0.5 * atlas_entities['moon'].w,  0.5 * atlas_entities['moon'].h)
   cloud1 = getDisplayObject(entities_atlas_img, atlas_entities['cloud1'].q, 100, 200, 0.5 * atlas_entities['cloud1'].w,  0.5 * atlas_entities['cloud1'].h)
   cloud2 = getDisplayObject(entities_atlas_img, atlas_entities['cloud2'].q, 1800, 300, 0.5 * atlas_entities['cloud2'].w,  0.5 * atlas_entities['cloud2'].h)
   cloud3 = getDisplayObject(entities_atlas_img, atlas_entities['cloud3'].q, 1400, 400, 0.5 * atlas_entities['cloud3'].w,  0.5 * atlas_entities['cloud3'].h)

   plane = getDisplayObject(entities_atlas_img, atlas_entities['plane'].q, 500, 400, 0.5 * atlas_entities['plane'].w,  0.5 * atlas_entities['plane'].h)
   plane.local_transform.scale = {x= 0.3, y=0.3}
   plane_light_white = getDisplayObject(entities_atlas_img, atlas_entities['light'].q, -40, -40, 0.5 * atlas_entities['light'].w,  0.5 * atlas_entities['light'].h)
   plane_light_white.color = {255,255,255,255}
   plane_light_red = getDisplayObject(entities_atlas_img, atlas_entities['light'].q, -30, 45, 0.5 * atlas_entities['light'].w,  0.5 * atlas_entities['light'].h)
   plane_light_red.color = {255,0,0,255}

   plane2 = getDisplayObject(entities_atlas_img, atlas_entities['plane'].q, 2500, 500, 0.5 * atlas_entities['plane'].w,  0.5 * atlas_entities['plane'].h)
   plane2.local_transform.scale = {x= -0.2, y=0.2}
   plane2_light_white = getDisplayObject(entities_atlas_img, atlas_entities['light'].q, -40, -40, 0.5 * atlas_entities['light'].w,  0.5 * atlas_entities['light'].h)
   plane2_light_white.color = {255,255,255,255}
   plane2_light_red = getDisplayObject(entities_atlas_img, atlas_entities['light'].q, -30, 45, 0.5 * atlas_entities['light'].w,  0.5 * atlas_entities['light'].h)
   plane2_light_red.color = {255,0,0,255}


   moon.color = {255,255,255,255}
   sun.origin = {x=1700, y=200}
   sun.dragging = { allowed = true, active = false, diffX = 0, diffY = 0}
   sun.tweens = {pos=nil, scale=nil}

   addChild(backdrop, sun)
   addChild(backdrop, moon)
   addChild(plane, plane_light_white)
   addChild(plane, plane_light_red)
   addChild(backdrop, plane)

   addChild(plane2, plane2_light_white)
   addChild(plane2, plane2_light_red)
   addChild(backdrop, plane2)

   addChild(backdrop, cloud1)
   addChild(backdrop, cloud2)
   addChild(backdrop, cloud3)


   addChild(backdrop, grass)

   addChild(backdrop, bushes_back)
   addChild(backdrop, tree1)
   addChild(backdrop, tree2)
   addChild(backdrop, bushes_front)

   addChild(backdrop, foreground)

   --local mallard = makeMallardMale(500,1200, 500,1600,1200, 1.1)
   --addChild(backdrop, mallard.root)

   multiple_geese = {}

   for i=1, 10, 1
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
      if (love.math.random() < 0.7) then
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
      bird.temp_canvas2 = love.graphics.newCanvas(400, 350)
      multiple_geese[i] = bird
      --addChild(backdrop, bird.root)

   end
   table.sort(multiple_geese, compareY)

   flyPlane(plane)
   flyPlane(plane2)
   --moveCloud(cloud1)
   --moveCloud(cloud2)
   --moveCloud(cloud3)

   startOrStopSwimming('start')
   --pause = true
   all_asleep = false
end

-- function moveCloud(cloud)
--    local function closure() moveCloud(cloud) end
--    flux.to(cloud.local_transform.position, love.math.random(60, 120), {x=love.math.random(2048), y=love.math.random(500)}):oncomplete(closure)
-- end



function flyPlane(plane, delay)
   local function closure()
      local new_scale = love.math.random(0.1, 0.6)
      plane.local_transform.position.y = 700--love.math.random(0, 800)
      plane.local_transform.scale.x = new_scale
      plane.local_transform.scale.y = new_scale
      if (plane.local_transform.position.x > 2048) then plane.local_transform.scale.x = plane.local_transform.scale.x * -1 end
      flyPlane(plane, true)
   end

   local my_delay = 0;
   if delay then my_delay = 5 end
   if plane.local_transform.position.x < 1024 then
      -- we fly out of the screen to the right
      flux.to(plane.local_transform.position, 6 / plane.local_transform.scale.y, {x=2500}):delay(my_delay):oncomplete(closure)
   else
      -- we fly out to the left
      flux.to(plane.local_transform.position, 6 / plane.local_transform.scale.y, {x=-500}):oncomplete(closure)
   end
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
   if geese3.sound_instance then
      geese3.sound_instance:stop()
   end
   if (geese3.type == 'goose') then
      geese3.sound_instance = geese_honk1:play()
      geese3.sound_instance:setPitch(.95 + love.math.random() * .1)
   elseif (geese3.type == 'mallard') then
      geese3.sound_instance = duck_honk1:play()
      geese3.sound_instance:setPitch(.95 + love.math.random() * .1)
   elseif (geese3.type == 'chick') then
      geese3.sound_instance = duck_honk1:play()
      geese3.sound_instance:setPitch(1.5 + love.math.random() * .1)
   end



   local multiplier = 1
   if (geese3.type == 'mallard' or geese3.type == 'chick') then multiplier = 0.5 end

   flux.to(geese3.beak_top.local_transform, 0.4*multiplier, {radian=math.rad(10)})
   flux.to(geese3.beak_top.local_transform, 0.2*multiplier, {radian=math.rad(-20)}):delay(0.4)
   flux.to(geese3.beak_bottom.local_transform, 0.4*multiplier, {radian=math.rad(-10)})
   flux.to(geese3.beak_bottom.local_transform, 0.2*multiplier, {radian=math.rad(10)}):delay(0.4)
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

   plane_light_white.color = {255,255,255, clamp(255 * (night_volume*1.5), 0, 255)}
   plane_light_red.color = {255,0,0, clamp(255 * (night_volume*1.5), 0, 255)}
   plane2_light_white.color = {255,255,255, clamp(255 * (night_volume*1.5), 0, 255)}
   plane2_light_red.color = {255,0,0, clamp(255 * (night_volume*1.5), 0, 255)}

   if (sun.local_transform.position.y > moon.local_transform.position.y and  not all_asleep) then
      all_asleep = true
      startOrStopSwimming('stop')
   elseif (sun.local_transform.position.y < moon.local_transform.position.y and all_asleep) then
      all_asleep = false
      startOrStopSwimming('start')
   end

   cloud1.local_transform.position.x = cloud1.local_transform.position.x + love.math.random()/10.0
   if cloud1.local_transform.position.x > 2500 then
      cloud1.local_transform.position.x = -500
      cloud1.local_transform.position.y = love.math.random(0,500)
   end
   cloud2.local_transform.position.x = cloud2.local_transform.position.x + love.math.random()/10.0
   if cloud2.local_transform.position.x > 2500 then
      cloud2.local_transform.position.x = -500
      cloud2.local_transform.position.y = love.math.random(0,500)
   end
   cloud3.local_transform.position.x = cloud3.local_transform.position.x + love.math.random()/10.0
   if cloud3.local_transform.position.x > 2500 then
      cloud3.local_transform.position.x = -500
      cloud3.local_transform.position.y = love.math.random(0,500)
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


      if (g.geese_canvas and (g.torso.local_transform.radian == 0)) then
         if ((g.geese_canvas.body_circle and pointInCircle(x1, y1, g.geese_canvas.body_circle)) or
            (g.geese_canvas.head_circle and pointInCircle(x1, y1, g.geese_canvas.head_circle))) then
                 pressed_goose = g
         end
      end
   end

   if (pressed_goose) then

      -- if pressed_goose.sound_instance then
      --    pressed_goose.sound_instance:stop()
      -- end
      -- if (pressed_goose.type == 'goose') then
      --    pressed_goose.sound_instance = geese_honk1:play()
      --    pressed_goose.sound_instance:setPitch(.95 + love.math.random() * .1)
      -- elseif (pressed_goose.type == 'mallard') then
      --    pressed_goose.sound_instance = duck_honk1:play()
      --    pressed_goose.sound_instance:setPitch(.95 + love.math.random() * .1)
      -- elseif (pressed_goose.type == 'chick') then
      --    pressed_goose.sound_instance = duck_honk1:play()
      --    pressed_goose.sound_instance:setPitch(1.5 + love.math.random() * .1)
      -- end



      if (love.math.random() < 0.9) then
         quak(pressed_goose)
      else
         if pressed_goose.sound_instance then
          pressed_goose.sound_instance:stop()
         end
         pressed_goose.sound_instance = splash1:play()
         pressed_goose.sound_instance:setPitch(.95 + love.math.random() * .1)
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
   --canvas = love.graphics.newCanvas(400, 350)

   love.graphics.setCanvas(geese2.temp_canvas2)
   love.graphics.clear()


   love.graphics.setColor(0xff,0xff,0xff)

   recursiveDraw(geese2.root)
   --love.graphics.setBlendMode("alpha", "premultiplied")

   love.graphics.setBlendMode("subtract")
   if (geese2.gradient.img) then
      love.graphics.draw(geese2.gradient.img, 0,  geese2.waterlevel.y, 0, 1, 1, 0, 0)
   end
   love.graphics.setBlendMode("alpha")
   love.graphics.setCanvas()
   return geese2.temp_canvas2
end

function love.draw()

   love.graphics.setColor(0xff,0xff,0xff)
   for i, g in ipairs(multiple_geese) do
      g.temp_canvas = getGradientedGeeseCanvas(g)
   end

   removeChild(backdrop, foreground)

   for i, g in ipairs(multiple_geese) do
      geese_canvas = getDisplayObject(g.temp_canvas,nil, g.x, g.y, 250, 200)
      geese_canvas.local_transform.scale.x = g.scaleX
      geese_canvas.local_transform.scale.y = g.scaleY
      geese_canvas.premultiply = true


      addChild(backdrop, geese_canvas)
      local radius = 80;
      if g.type == 'chick' then radius = 50 end
      if g.type == 'mallard' then radius = 70 end


      geese_canvas.body_circle = {x=geese_canvas.local_transform.position.x,
                                  y=geese_canvas.local_transform.position.y + ( g.scaleY * -50),
                                  radius= radius * g.scaleY}

      if (g.type == 'goose') then
         geese_canvas.head_circle = {x=geese_canvas.local_transform.position.x  + (g.scaleX * -50),
                                     y=geese_canvas.local_transform.position.y + (g.scaleY * -150),
                                     radius=50 * g.scaleY}
      else
         geese_canvas.head_circle = nil
      end
      g.geese_canvas = geese_canvas
   end

   push:start()

   --local t = sun.local_transform.position.y/love.graphics.getHeight()
   local t = map(sun.local_transform.position.y, 200, love.graphics.getHeight(), 0, 1)
   drawSkyGradientAndSetFGColor(clamp(t, 0, 1))

   addChild(backdrop, foreground)

   recursiveDraw(backdrop)

   -- for i, g in ipairs(multiple_geese) do
   --    if  g.geese_canvas.body_circle then
   --       love.graphics.setColor(0xff,0x00,0xff, 0x88)
   --       love.graphics.circle("fill", g.geese_canvas.body_circle.x, g.geese_canvas.body_circle.y, g.geese_canvas.body_circle.radius, 40);
   --    end
   --    if g.geese_canvas.head_circle then
   --       love.graphics.setColor(0xff,0x00,0x00, 0x88)
   --       love.graphics.circle("fill", g.geese_canvas.head_circle.x, g.geese_canvas.head_circle.y, g.geese_canvas.head_circle.radius, 40);
   --    end
   -- end

   for i, g in ipairs(multiple_geese) do
      removeChild(backdrop, g.geese_canvas)
   end

   push:finish()
end

flux = require 'flux'
require "TLfres"

function love.load()
   TLfres.setScreen({w=1024*2, h=768*2}, 1024*2, false, false)
   love.graphics.setBackgroundColor(0x7A, 0xB4, 0xF8)
   -- mallard1 = love.graphics.newImage("images/tree1.png")
   -- sun = love.graphics.newImage("images/tree2.png")
   -- cloud1 = love.graphics.newImage("images/bushes_front.png")

   geese_torso_img = love.graphics.newImage("images/geese_torso.png")
   geese_torso_img:setFilter('nearest','nearest')
   geese_eye_img = love.graphics.newImage("images/geese_eye.png")
   geese_foot_img = love.graphics.newImage("images/geese_foot.png")
   geese_beak_top_img = love.graphics.newImage("images/geese_beak_top.png")
   geese_beak_bottom_img = love.graphics.newImage("images/geese_beak_bottom.png")
   geese_foot_img:setFilter('nearest','nearest')
   geese_gradient_img = love.graphics.newImage("images/gradient.png")


   backdrop_img = love.graphics.newImage("images/backdrop.png")
   bushes_back_img = love.graphics.newImage("images/bushes_back.png")
   bushes_front_img = love.graphics.newImage("images/bushes_front.png")

   tree_1_img = love.graphics.newImage("images/tree1.png")
   tree_2_img = love.graphics.newImage("images/tree2.png")

   pond_img = love.graphics.newImage("images/pond.png")

   -- geese_eye
   -- geese_torso
   -- geese_foot
   -- geese_beak_bottom
   -- geese_beak_top
   -- geese_eye

   backdrop = {
      name="backdrop",
      img = backdrop_img,
      pivot = {x=0, y=0},
      local_transform = {
         position = {x=0, y=0},
         scale = {x=1, y=1},
         radian = 0,
      },
   }
   bushes_back = {
      name="bushes_back",
      img = bushes_back_img,
      pivot = {x=0, y=0},
      local_transform = {
         position = {x=160, y=950},
         scale = {x=1, y=1},
         radian = 0,
      },
   }
   bushes_front = {
      name="bushes_front",
      img = bushes_front_img,
      pivot = {x=0, y=0},
      local_transform = {
         position = {x=110, y=940},
         scale = {x=1, y=1},
         radian = 0,
      },
   }
   tree1 = {
      name="tree1",
      img = tree_1_img,
      pivot = {x=0, y=0},
      local_transform = {
         position = {x=20, y=100},
         scale = {x=1, y=1},
         radian = 0,
      },
   }
   tree2 = {
      name="tree2",
      img = tree_2_img,
      pivot = {x=0, y=0},
      local_transform = {
         position = {x=1050, y=100},
         scale = {x=1, y=1},
         radian = 0,
      },
   }


   pond = {
      name="pond",
      img = pond_img,
      pivot = {x=0, y=0},
      local_transform = {
         position = {x=150, y=1100},
         scale = {x=1, y=1},
         radian = 0,
      },
   }

   geese_root = {
      name="root",
      img = nil,
      pivot = {x=0.5 * geese_torso_img:getWidth(), y=1.0 * geese_torso_img:getHeight()},
      local_transform = {
         position = {x=1024, y=500},
         scale = {x=1, y=1},
         radian = 0,
      },
   }
   geese_back_foot = {
      name="back_foot",
      img = geese_foot_img,
      pivot = {x=1.0 * geese_foot_img:getWidth(), y=0 * geese_foot_img:getHeight()},
      local_transform = {
         position = {x=0, y=-25},
         scale = {x=1, y=1},
         radian = 0,
      },
   }
   geese_front_foot = {
      name="front_foot",
      img = geese_foot_img,
      pivot = {x=1.0 * geese_foot_img:getWidth(), y=0 * geese_foot_img:getHeight()},
      local_transform = {
         position = {x=15, y=-10},
         scale = {x=1, y=1},
         radian = 0,
      },
   }
   geese_torso = {
      name="torso",
      img = geese_torso_img,
      pivot = {x=0.5 * geese_torso_img:getWidth(), y=1.0 * geese_torso_img:getHeight()},
      local_transform = {
         position = {x=0, y=0},
         scale = {x=1, y=1},
         radian = 0,
      },
   }
   geese_eye = {
      name="eye",
      img = geese_eye_img,
      pivot = {x=0.5 * geese_eye_img:getWidth(), y=1.0 * geese_eye_img:getHeight()},
      local_transform = {
         position = {x=-65, y=-155},
         scale = {x=1.0, y=1.0},
         radian = 0,
      },
   }
   geese_beak_top = {
      name="eye",
      img = geese_beak_top_img,
      pivot = {x=1.0 * geese_beak_top_img:getWidth(), y=1.0 * geese_beak_top_img:getHeight()},
      local_transform = {
         position = {x=-75, y=-160},
         scale = {x=1.0, y=1.0},
         radian = 0,
      },
   }
   geese_beak_bottom = {
      name="eye",
      img = geese_beak_bottom_img,
      pivot = {x=1.0 * geese_beak_bottom_img:getWidth(), y=0 * geese_beak_bottom_img:getHeight()},
      local_transform = {
         position = {x=-75, y=-160},
         scale = {x=1.0, y=1.0},
         radian = 0,
      },
   }
   geese_gradient = {
      name="gradient",
      multiply = true,
      img = geese_gradient_img,
      pivot = {x=0.5 * geese_gradient_img:getWidth(), y=1.0 * geese_gradient_img:getHeight()},
      local_transform = {
         position = {x=0, y=50},
         scale = {x=1.0, y=1.0},
         radian = 0,
      },
   }

   init_world_transform(backdrop)
   init_world_transform(bushes_back)
   init_world_transform(bushes_front)
   init_world_transform(pond)
   init_world_transform(tree1)
   init_world_transform(tree2)

   init_world_transform(geese_root)
   init_world_transform(geese_back_foot)
   init_world_transform(geese_torso)
   init_world_transform(geese_front_foot)
   init_world_transform(geese_eye)
   init_world_transform(geese_beak_top)
   init_world_transform(geese_beak_bottom)
   init_world_transform(geese_gradient)


   addChild(backdrop, pond)
   addChild(backdrop, bushes_back)
   addChild(backdrop, tree1)
   addChild(backdrop, tree2)
   addChild(backdrop, bushes_front)


   addChild(backdrop, geese_root)
   addChild(geese_root, geese_back_foot)
   addChild(geese_root, geese_torso)
   addChild(geese_root, geese_front_foot)
   addChild(geese_torso, geese_beak_top)
   addChild(geese_torso, geese_beak_bottom)
   addChild(geese_torso, geese_eye)

   --addChild(geese_root, geese_gradient)
   -- flux.to(root.local_transform, 10.0, {radian = math.rad(360)}):delay(0.5)
   -- flux.to(child.local_transform, 3.7, {radian = math.rad(360*5) }):delay(2)
   -- flux.to(child.local_transform.scale, 4.7, {x=0.7, y=0.7 }):delay(2)
   -- flux.to(child.local_transform.scale, .7, {x=1, y=1 }):delay(7)
   -- flux.to(grand_child.local_transform.scale, 4.7, {x=1.0/0.7, y=1.0/0.7 }):delay(2)
   -- flux.to(grand_child.local_transform.scale, 2, {x=1.0, y=1.0 }):delay(7)
   flux.to( geese_front_foot.local_transform, 5.7, {radian = math.rad(-360*6)}):delay(3)


   canvas = love.graphics.newCanvas(600, 600)
   love.graphics.setCanvas(canvas)
   love.graphics.clear()
   love.graphics.draw(geese_torso.img, 200, 200, 0, 1, 1, geese_torso.pivot.x, geese_torso.pivot.y)
   love.graphics.setBlendMode("multiply")
   love.graphics.draw(geese_gradient.img, 100, 70, 0, 1, 1.5, 0, 0)
   love.graphics.setBlendMode("alpha")
   love.graphics.setCanvas()
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
   flux.update(dt)
   if love.keyboard.isDown("escape") then love.event.quit() end
   if love.keyboard.isDown("p") then
      local screenshot = love.graphics.newScreenshot();
      screenshot:encode('png', os.time() .. '.png');
      --data = Canvas:newImageData( 0, 0, 1024*2, 768*2 )
   end

end

function love.mousepressed(x, y, button)
   if button == 1 then
      local transformation = TLfres.getTransform()
      print(x/transformation.sx, y/transformation.sy)
   end
end

function love.draw()
   TLfres.transform()
   love.graphics.setColor(0xff,0xff,0xff)

   recursive_draw(backdrop)
   love.graphics.setBlendMode("alpha", "premultiplied")
   love.graphics.draw(canvas, 400, 1000)
   love.graphics.setBlendMode("alpha")
   TLfres.letterbox(4,3, {255,0,255,255})
end

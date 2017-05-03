#!/bin/bash

../../atlas/atlas -f "atlas_birds['%s'] = {x=%d, y=%d, w=%d, h=%d, q=nil}" -p 2 -o atlas/birds.png -t atlas/birds.lua images/birds
../../atlas/atlas -f "atlas_terrain['%s'] = {x=%d, y=%d, w=%d, h=%d, q=nil}" -p 2 -o atlas/terrain.png -t atlas/terrain.lua images/terrain
../../atlas/atlas -f "atlas_entities['%s'] = {x=%d, y=%d, w=%d, h=%d, q=nil}" -p 2 -o atlas/entities.png -t atlas/entities.lua images/entities

echo "atlas_birds = {}"|cat - atlas/birds.lua > /tmp/out && mv /tmp/out atlas/birds.lua
echo "atlas_terrain = {}"|cat - atlas/terrain.lua > /tmp/out && mv /tmp/out atlas/terrain.lua
echo "atlas_entities = {}"|cat - atlas/entities.lua > /tmp/out && mv /tmp/out atlas/entities.lua

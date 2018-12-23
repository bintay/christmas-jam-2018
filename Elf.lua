local Elf = Object:extend('Elf');

local Coal = require('Coal');

function Elf:new (world, x, y, player) 
   self.number = math.random(10000, 99999);
   self.player = player;
   self.remove = false;
   
   self.collider = world:newRectangleCollider(x, y, assets.images.elf:getWidth() * 3, assets.images.elf:getHeight() * 3);
   self.collider:setLinearDamping(1.5);
   self.collider:setCollisionClass('bad');

   self.coal = {};

   Timer.after(math.random(0, 200) / 100, function ()
      Timer.every(math.random(150, 250) / 100, function ()
         if (self.player.collider and not self.remove) then
            if (self.collider:getX() - self.player.collider:getX() < 800) then
               self.coal[#self.coal + 1] = Coal(world, self.collider:getX() - 12, self.collider:getY() - 12);
               love.audio.stop(assets.audio.snowball);
               love.audio.play(assets.audio.snowball);
            end
         end
      end);
   end)
end

function Elf:draw ()
   if (not self.remove) then
      love.graphics.setColor(255, 255, 255);
      love.graphics.setFont(fonts.small);
      love.graphics.draw(assets.images.elf, self.collider:getX(), self.collider:getY() + 0 * math.sin(2.5 * love.timer.getTime()) - assets.images.elf:getHeight() * 3 / 2, 0, 3, 3, assets.images.elf:getWidth() / 2);
      love.graphics.setColor(0, 0, 0);
      love.graphics.print('Elf #' .. self.number, self.collider:getX() + 8 - assets.images.elf:getWidth() * 3 / 2, self.collider:getY() + assets.images.elf:getHeight() * 3 / 2 + 8 + 0 * math.sin(2.5 * love.timer.getTime()));

      love.graphics.setColor(255, 255, 255);

      coalToRemove = {};
      for k, v in pairs(self.coal) do
         if (not self.coal[k].remove) then
            self.coal[k]:draw();
         else
            coalToRemove[#coalToRemove + 1] = k;
         end
      end

      for k, v in pairs(coalToRemove) do
         table.remove(self.coal, v);
      end

      if (self.collider:enter('snowball')) then
         self.collider:destroy();
         for k, v in pairs(self.coal) do
            if (self.coal[k].collider and not self.coal[k].remove) then
               self.coal[k].collider:destroy();
            end
         end
         self.remove = true;
      end
   end
end

return Elf;

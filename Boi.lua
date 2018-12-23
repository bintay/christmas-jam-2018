local Boi = Object:extend('Boi');

function Boi:new (world) 
   self.world = world;
   self.force = 50000;
   self.position = Vector.new(-assets.images.boi:getWidth() * 3, 128);
   self.dir = 1;
   self.health = 100;
   self.super = false;
end

function Boi:draw ()
   love.graphics.setColor(255, 255, 255);
   love.graphics.setFont(fonts.small);
   if (self.canMove) then
      love.graphics.draw(assets.images.boi, self.collider:getX(), self.collider:getY() + 6 * math.sin(2.5 * love.timer.getTime()) - assets.images.boi:getHeight() * 3 / 2, 0, 3 * self.dir, 3, assets.images.boi:getWidth() / 2);
      love.graphics.setColor(0, 0, 0);
      love.graphics.print('Mr. Goodboi', self.collider:getX() + 16 - assets.images.boi:getWidth() * 3 / 2, self.collider:getY() + assets.images.boi:getHeight() * 3 / 2 + 16+ 6 * math.sin(2.5 * love.timer.getTime()));
   else
      love.graphics.draw(assets.images.boi, self.position.x, self.position.y + 6 * math.sin(2.5 * love.timer.getTime()), 0, 3);
      love.graphics.setColor(0, 0, 0);
      love.graphics.print('Mr. Goodboi', self.position.x + 16, self.position.y + assets.images.boi:getHeight() * 3 + 16 + 6 * math.sin(2.5 * love.timer.getTime()));
   end
end

function Boi:update (dt)
   if (self.canMove) then
      if (not self.collider) then
         self.collider = self.world:newRectangleCollider(self.position.x, self.position.y, assets.images.boi:getWidth() * 3, assets.images.boi:getHeight() * 3);
         self.collider:setLinearDamping(1.5);
         self.collider:setCollisionClass('good');
      end
      if (love.keyboard.isDown('w', 'up')) then
         self.collider:applyForce(0, -self.force);
      end

      if (love.keyboard.isDown('s', 'down')) then
         self.collider:applyForce(0, self.force);
      end

      if (love.keyboard.isDown('a', 'left')) then
         self.collider:applyForce(-self.force, 0);
         self.dir = -1;
      end

      if (love.keyboard.isDown('d', 'right')) then
         self.collider:applyForce(self.force, 0);
         self.dir = 1;
      end

      if (self.collider:enter('coal')) then
         local coalData = self.collider:getEnterCollisionData('coal');
         local coal = coalData.collider:getObject();
         if (coal and not coal.remove) then
            self.health = self.health - 5;
            coal.collider:destroy();
            coal.remove = true;
         end
      end

      if (self.collider:enter('health')) then
         local healthData = self.collider:getEnterCollisionData('health');
         local health = healthData.collider:getObject();
         if (health and not health.remove) then
            self.health = math.min(self.health + 25, 100);
            health.collider:destroy();
            health.remove = true;
         end
      end

      if (self.collider:enter('super')) then
         local superData = self.collider:getEnterCollisionData('super');
         local super = superData.collider:getObject();
         if (super and not super.remove and not self.super) then
            self.super = true;
            Timer.every(0.03, function ()
               shootSnowball();
            end, math.floor(4 / 0.03));
            Timer.after(4, function ()
               self.super = false;
            end)
            super.collider:destroy();
            super.remove = true;
         end
      end

      if (self.health <= 0) then
         gameover = "";
         local message = {"You", " Are", " Naughty"};
         local k = 1;
         Timer.after(2, function ()
            Timer.every(1, function () 
               gameover = gameover .. message[k];
               k = k + 1;
            end, 3);
         end);
      end
   end
end

return Boi;

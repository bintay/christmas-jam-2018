local Health = Object:extend('Health');

function Health:new (world, x, y) 
   self.collider = world:newRectangleCollider(x, y, assets.images.health:getWidth() * 3, assets.images.health:getHeight() * 3);
   self.collider:setCollisionClass('health');
   self.collider:setObject(self);
   self.collider:applyAngularImpulse(1);
   self.remove = false;
end

function Health:draw ()
   love.graphics.setColor(255, 255, 255);
   if (not self.remove) then
      love.graphics.draw(assets.images.health, self.collider:getX() - assets.images.health:getWidth() * 3 / 2, self.collider:getY() - assets.images.health:getHeight() * 3 / 2, 0, 3);
   end
end

return Health;

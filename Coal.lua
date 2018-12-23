local Coal = Object:extend('Coal');

function Coal:new (world, x, y) 
   self.collider = world:newRectangleCollider(x, y, assets.images.coal:getWidth() * 3, assets.images.coal:getHeight() * 3);
   self.collider:setCollisionClass('coal');
   self.collider:setObject(self);
   local force = Vector.new(1500, 0);
   force:rotateInplace(math.random(math.floor(1000 * math.pi / 3 * 2), math.floor(1000 * math.pi / 6 * 5)) / 1000);
   self.collider:applyLinearImpulse(force.x, -force.y);
   self.remove = false;
end

function Coal:draw ()
   love.graphics.setColor(255, 255, 255);
   if (not self.remove) then
      love.graphics.draw(assets.images.coal, self.collider:getX() - assets.images.coal:getWidth() * 3 / 2, self.collider:getY() - assets.images.coal:getHeight() * 3 / 2, 0, 3);
      self.collider:applyForce(0, 5000);
      if (self.collider:getY() > love.graphics.getHeight() + 24) then
         self.collider:destroy();
         self.remove = true;
      end
   end
end

return Coal;

local Snowball = Object:extend('Snowball');

function Snowball:new (world, x, y, dir) 
   self.collider = world:newRectangleCollider(x, y, assets.images.snowball:getWidth() * 3, assets.images.snowball:getHeight() * 3);
   self.collider:setCollisionClass('snowball');
   local force = Vector.new(math.random(1000, 2000), 0);
   force:rotateInplace(math.random(math.floor(1000 * math.pi / 6), math.floor(1000 * math.pi / 3)) / 1000);
   self.collider:applyLinearImpulse(dir * force.x, -force.y);
   self.collider:setObject(self);
   self.remove = false;
end

function Snowball:draw ()
   love.graphics.setColor(255, 255, 255);
   if (not self.remove) then
      love.graphics.draw(assets.images.snowball, self.collider:getX() - assets.images.snowball:getWidth() * 3 / 2, self.collider:getY() - assets.images.snowball:getHeight() * 3 / 2, 0, 3);
      self.collider:applyForce(0, 5000);
      if (self.collider:getY() > love.graphics.getHeight() + 24) then
         self.collider:destroy();
         self.remove = true;
      end
   end
end

return Snowball;

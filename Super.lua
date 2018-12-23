local Super = Object:extend('Super');

function Super:new (world, x, y) 
   self.collider = world:newRectangleCollider(x, y, assets.images.super:getWidth() * 3, assets.images.super:getHeight() * 3);
   self.collider:setCollisionClass('super');
   self.collider:setObject(self);
   self.collider:applyAngularImpulse(1);
   self.remove = false;
end

function Super:draw ()
   love.graphics.setColor(255, 255, 255);
   if (not self.remove) then
      love.graphics.draw(assets.images.super, self.collider:getX() - assets.images.super:getWidth() * 3 / 2, self.collider:getY() - assets.images.super:getHeight() * 3 / 2, 0, 3);
   end
end

return Super;

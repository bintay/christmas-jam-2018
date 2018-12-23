local Hole = Object:extend('Hole');

function Hole:new (world, x, y) 
   self.collider = world:newRectangleCollider(x, y, assets.images.hole:getWidth() * 3, assets.images.hole:getHeight() * 3);
   self.collider:setType('static');
   self.collider:setCollisionClass('wall');
end

function Hole:draw ()
   love.graphics.setColor(255, 255, 255);
   love.graphics.draw(assets.images.hole, self.collider:getX() - assets.images.hole:getWidth() * 3 / 2, self.collider:getY() - assets.images.hole:getHeight() * 3 / 2, 0, 3);
end

return Hole;

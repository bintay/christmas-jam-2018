local Santa = Object:extend('Santa');

function Santa:new ()
   self.flicker = false;
   self.bad = false;
   self.position = Vector.new(love.graphics.getHeight() / 2 - assets.images.santa_good:getWidth() / 2, 
                              32);
   self.permabad = false;
   self.angle = 0;

   Timer.every(0.1, function () 
      if (self.permabad or self.flicker and math.random(0, 100) <= 20) then
         self.bad = true;
      elseif (not permabad) then
         self.bad = false;
      end
   end)
end

function Santa:draw ()
   love.graphics.setColor(255, 255, 255);
   if (self.bad) then
      love.graphics.draw(assets.images.santa_bad, 
                         self.position.x + 32 * 3, 
                         self.position.y + 6 * math.sin(2.5 * love.timer.getTime()) + 58 * 3, 
                         self.angle, 
                         3,
                         3,
                         32,
                         58
                         );
   else
      love.graphics.draw(assets.images.santa_good, 
                         self.position.x + 32 * 3, 
                         self.position.y + 6 * math.sin(2.5 * love.timer.getTime()) + 58 * 3, 
                         self.angle, 
                         3,
                         3,
                         32,
                         58
                         );
   end
end

return Santa;
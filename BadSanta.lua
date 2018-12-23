local BadSanta = Object:extend('BadSanta');

local StoryEvent = require('StoryEvent');
local SpeechBox = require('SpeechBox');
local InitialEvent = require('InitialEvent');
local WaitEvent = require('WaitEvent');
local SetPropertyEvent = require('SetPropertyEvent');
local InterpolatePropertyEvent = require('InterpolatePropertyEvent');
local RunEvent = require('RunEvent');

local Coal = require('Coal');

function BadSanta:new (world, player) 
   self.world = world;
   self.health = 100;
   self.super = false;
   self.collider = self.world:newRectangleCollider(7700, 128, assets.images.santa_bad:getWidth() * 3, assets.images.santa_bad:getHeight() * 3);
   self.collider:setLinearDamping(1.5);
   self.collider:setCollisionClass('bad');
   self.shoot = true;
   self.coal = {};
   self.player = player;
   self.died = false;

   Timer.after(math.random(0, 200) / 100, function ()
      Timer.every(math.random(150, 250) / 100, function ()
         if (self.player.collider and not self.remove and self.health > 0) then
            if (self.collider:getX() - self.player.collider:getX() < 800) then
               self.coal[#self.coal + 1] = Coal(world, self.collider:getX() - 12, self.collider:getY() - 12);
               love.audio.stop(assets.audio.snowball);
               love.audio.play(assets.audio.snowball);
            end
         end
      end);
   end);
end

function BadSanta:draw ()
   love.graphics.setColor(255, 255, 255);
   love.graphics.setFont(fonts.small);
   if (self.health > 0) then
      love.graphics.draw(assets.images.santa_bad, self.collider:getX(), self.collider:getY() + 6 * math.sin(2.5 * love.timer.getTime()) - assets.images.santa_bad:getHeight() * 3 / 2, 0, -3, 3, assets.images.santa_bad:getWidth() / 2);
      love.graphics.translate(self.collider:getX() - 48 - assets.images.santa_bad:getHeight() * 3 / 2, self.collider:getY() - 48 - assets.images.santa_bad:getHeight() * 3 / 2 + 6 * math.sin(2.5 * love.timer.getTime()));
      love.graphics.setColor(0, 0, 0);
      love.graphics.rectangle('fill', 15, 15, 288, 48);
      love.graphics.setColor(255, 255, 255);
      love.graphics.rectangle('fill', 18, 18, 288 - 6, 42);
      love.graphics.setColor(224 / 255, 111 / 255, 139 / 255);
      love.graphics.rectangle('fill', 21, 21, math.max(0, math.floor((288 - 12) * self.health / 100 / 3) * 3), 36);
      love.graphics.setColor(1, 1, 1);
      love.graphics.rectangle('fill', 24, 24, math.max(0, math.floor((288 - 12) * self.health / 100 / 3) * 3 - 6), 30);
      love.graphics.translate(-(self.collider:getX() - 48 - assets.images.santa_bad:getHeight() * 3 / 2), -(self.collider:getY() - 48 - assets.images.santa_bad:getHeight() * 3 / 2 + 6 * math.sin(2.5 * love.timer.getTime())));
   else
      love.graphics.draw(assets.images.santa_good, self.collider:getX(), self.collider:getY() + 6 * math.sin(2.5 * love.timer.getTime()) - assets.images.santa_bad:getHeight() * 3 / 2, 0, -3, 3, assets.images.santa_bad:getWidth() / 2);
   end
   love.graphics.setColor(0, 0, 0);
   love.graphics.print('Santa', self.collider:getX() + 48 - assets.images.santa_bad:getWidth() * 3 / 2, self.collider:getY() + assets.images.santa_bad:getHeight() * 3 / 2 + 16 + 6 * math.sin(2.5 * love.timer.getTime()));

   for k, v in pairs(self.coal) do
      self.coal[k]:draw();
   end
end

function BadSanta:update (dt)
   if (self.collider:enter('snowball')) then
      local coalData = self.collider:getEnterCollisionData('snowball');
      local snowball = coalData.collider:getObject();
      if (snowball and not snowball.remove) then
         self.health = self.health - 5;
         snowball.collider:destroy();
         snowball.remove = true;
      end
   end

   if (self.health <= 0 and not self.died) then
      self.died = true;
      love.audio.stop(assets.audio.music2);
      love.audio.play(assets.audio.christmas_town);
      storyEvents = InitialEvent();
      storyEvents
         :next(SpeechBox('Santa: Rebooting... do not unplug system'))
         :next(SpeechBox('Santa: Mr. Goodboi, You\'ve made the nice list once again!'))
         :next(WaitEvent(0.25))
         :next(SpeechBox('Santa: Merry christmas!'))
         :next(RunEvent(function ()
            gameover = "";
            local message = {"You", " Are\n", "Nice"};
            local k = 1;
            Timer.after(2, function ()
               Timer.every(1, function () 
                  gameover = gameover .. message[k];
                  k = k + 1;
               end, 3);
            end);
         end));
      storyEvents:start();
   end

   coalToRemove = {};
   for k, v in pairs(self.coal) do
      if (self.coal[k].remove) then
         coalToRemove[#coalToRemove + 1] = k;
      end
   end

   for k, v in pairs(coalToRemove) do
      table.remove(self.coal, v);
   end
end

return BadSanta;

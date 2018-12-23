math.randomseed(love.timer.getTime());

Object = require('libraries.classic');
Cargo = require('libraries.cargo');
Timer = require('libraries.hump.timer');
Vector = require('libraries.hump.vector');
Camera = require('libraries.hump.camera');
Gamestate = require('libraries.hump.gamestate');
Windfield = require('libraries.windfield');

local StoryEvent = require('StoryEvent');
local SpeechBox = require('SpeechBox');
local InitialEvent = require('InitialEvent');
local WaitEvent = require('WaitEvent');
local SetPropertyEvent = require('SetPropertyEvent');
local InterpolatePropertyEvent = require('InterpolatePropertyEvent');

local Santa = require('Santa');
local Boi = require('Boi');
local Hole = require('Hole');
local Snowball = require('Snowball');
local Elf = require('Elf');
local Health = require('Health');
local Super = require('Super');
local BadSanta = require('BadSanta');

assets = {};
storyEvents = {};
fonts = {};
gameover = nil;

local camera;
local santa;
local player;
local world;
local holes;
local snowballs;
local elves;
local powerups;
local badSanta;
local snowParticles;

function love.load (args)

   love.graphics.setBackgroundColor(255, 255, 255);

   assets = Cargo.init({
      dir = 'assets',
         loaders = {
            jpg = love.graphics.newImage
         },
      processors = {
         ['images/'] = function(image, filename)
            image:setFilter('nearest', 'nearest')
         end,
         ['audio/'] = function (audio, filename)
            audio:setVolume(0.25);
         end
      }
   });

   fonts.small = love.graphics.newFont('assets/fonts/slkscre.ttf', 16);
   fonts.normal = love.graphics.newFont('assets/fonts/slkscre.ttf', 32);
   fonts.big = love.graphics.newFont('assets/fonts/slkscre.ttf', 48);
   fonts.huge = love.graphics.newFont('assets/fonts/slkscre.ttf', 72);

   love.graphics.setFont(fonts.normal);

   camera = Camera(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2);

   world = Windfield.newWorld();
   world:addCollisionClass('wall', {});
   world:addCollisionClass('health', {});
   world:addCollisionClass('super', {});
   world:addCollisionClass('good', {});
   world:addCollisionClass('snowball', {ignores = {'snowball', 'wall', 'good', 'health', 'super'}});
   world:addCollisionClass('bad', {});
   world:addCollisionClass('coal', {ignores = {'wall', 'bad', 'coal', 'health', 'super'}});
   world:setGravity(0, 0);

   walls = {
      world:newRectangleCollider(0, -50, 8000, 50),
      world:newRectangleCollider(0, love.graphics.getHeight(), 8000, 50),
      world:newRectangleCollider(-50, 0, 50, love.graphics.getHeight()),
      world:newRectangleCollider(8000, 0, 50, love.graphics.getHeight())
   };

   for k, v in pairs(walls) do
      walls[k]:setType('static');
      walls[k]:setCollisionClass('wall');
   end

   santa = Santa();
   player = Boi(world);

   elves = {};
   holes = {};
   powerups = {};

   for x = 600, 8000, 400 do
      if (math.random(1, 3) == 1) then
         holes[#holes + 1] = Hole(world, x, math.random(50, love.graphics.getHeight() - 50));
      end

      for i = 1, math.random(1, 3) do
         holes[#holes + 1] = Elf(world, x + i * 100, math.random(50, love.graphics.getHeight() - 50), player);
      end

      if (math.random(1, 5) == 1) then
         powerups[#powerups + 1] = Health(world, x + 200, math.random(50, love.graphics.getHeight() - 50));
      elseif (math.random(1, 5) == 1 and x < 5000) then
         powerups[#powerups + 1] = Super(world, x + 200, math.random(50, love.graphics.getHeight() - 50));
      end
   end

   badSanta = BadSanta(world, player);

   snowParticles = love.graphics.newParticleSystem(assets.images.snow);
   snowParticles:setColors(178/255, 220/255, 239/255, 1);
   snowParticles:setDirection(math.pi / 3);
   snowParticles:setPosition(4000, -50);
   snowParticles:setEmissionArea('uniform', 4400, 50);
   snowParticles:setEmissionRate(20);
   snowParticles:setParticleLifetime(12);
   snowParticles:setTangentialAcceleration(-10, 10);
   snowParticles:setSizes(9, 3, 0);
   snowParticles:setSpeed(50, 100);

   snowballs = {};

   love.audio.play(assets.audio.music1);
   Timer.after(15, function () 
      assets.audio.music2:setLooping(true);
      love.audio.play(assets.audio.music2);
   end)

   storyEvents = {};
   storyEvents = InitialEvent();
   storyEvents
      :next(SpeechBox('Santa: HO HO HO! MERRY CHRISTMAS!'))
      :next(SpeechBox('Santa: Mr. Goodboi, You\'ve made the nice list once again!'))
      :next(WaitEvent(0.25))
      :next(SetPropertyEvent(santa, 'flicker', true))
      :next(WaitEvent(0.25))
      :next(SpeechBox('Santa: Ho ho.'))
      :next(WaitEvent(0.5))
      :next(SpeechBox('Santa: Merry chr chr chr chr chr ist eee mas'))
      :next(WaitEvent(0.5))
      :next(SetPropertyEvent(santa, 'permabad', true))
      :next(SetPropertyEvent(santa, 'bad', true))
      :next(SpeechBox('Santa: Santa.exe has encountered an error'))
      :next(SpeechBox('Santa: M.r Goooooodbo, you naught good so naughty'))
      :next(SpeechBox('Santa: Dun\'t woory, m ieee elves will take ca a a a a re of you'))
      :next(InterpolatePropertyEvent(santa.position, 'x', love.graphics.getWidth() * 2 / 3, 0.5, 'quad'))
      :next(InterpolatePropertyEvent(santa, 'angle', 0.5, 0.5, 'quad', true))
      :next(InterpolatePropertyEvent(santa.position, 'x', love.graphics.getWidth() * 3, 2))
      :next(WaitEvent(1))
      :next(SetPropertyEvent(santa.position, 'x', 10000))
      :next(InterpolatePropertyEvent(player.position, 'x', 120, 2, 'in-out-quad', true))
      :next(SetPropertyEvent(player, 'canMove', true))
      :next(WaitEvent(2))
      :next(SpeechBox('Hint: Press [space] to throw a snowball'))
      :next(WaitEvent(1))
   storyEvents:start();
end

function love.update (dt)
   Timer.update(dt);
   snowParticles:update(dt);
   if (gameover) then

   else
      player:update(dt);
      world:update(dt);
      badSanta:update(dt);
   end
end

function love.draw ()
   if (gameover) then
      if (#elves > 0) then
         for k, v in pairs(elves) do
            v.remove = true;
            v.collider:destroy();
         end
         elves = {};
      end
      love.graphics.setBackgroundColor(0, 0, 0);
      love.graphics.setColor(247 / 255, 226 / 255, 107 / 255);
      love.graphics.setFont(fonts.huge);
      love.graphics.printf(gameover, 0, 196, love.graphics.getWidth(), 'center');
      love.graphics.setColor(1, 1, 1);
      love.graphics.printf(gameover, 3, 196 + 3, love.graphics.getWidth(), 'center');
   else
      if (player.collider) then
         camera.x = math.max(love.graphics.getWidth() / 2, player.collider:getX() + love.graphics.getWidth() / 4);
      else
         camera.x = math.max(love.graphics.getWidth() / 2, player.position.x + 32 * 3 + love.graphics.getWidth() / 4);
      end

      camera:attach();

      for x = 0, 8800, 18 * 3 do
         love.graphics.setColor(1, 1, 1);
         if (math.floor(love.timer.getTime() * 2) % 2 == 0) then
            love.graphics.draw(assets.images.lights, x, love.graphics.getHeight() - 16 * 3, 0, 3);
         else
            love.graphics.draw(assets.images.lights, x - 9 * 3, love.graphics.getHeight() - 16 * 3, 0, 3);
         end
      end
      
      for k, v in pairs(holes) do
         holes[k]:draw();
      end

      snowballsToRemove = {};
      for k, v in pairs(snowballs) do
         if (not snowballs[k].remove) then
            snowballs[k]:draw();
         else
            snowballsToRemove[#snowballsToRemove + 1] = k;
         end
      end

      for k, v in pairs(snowballsToRemove) do
         table.remove(snowballs, v);
      end

      if (not badSanta.died) then
         elvesToRemove = {};
         for k, v in pairs(elves) do
            if (not elves[k].remove) then
               elves[k]:draw();
            else
               elvesToRemove[#elvesToRemove + 1] = k;
            end
         end

         for k, v in pairs(elvesToRemove) do
            table.remove(elves, v);
         end
      end

      for k, v in pairs(powerups) do
         v:draw();
      end

      santa:draw();
      player:draw();
      badSanta:draw();

      love.graphics.setColor(1, 1, 1);
      love.graphics.draw(snowParticles);

      camera:detach();

      love.graphics.setColor(0, 0, 0);
      love.graphics.rectangle('fill', 15, 15, 288, 48);
      love.graphics.setColor(255, 255, 255);
      love.graphics.rectangle('fill', 18, 18, 288 - 6, 42);
      love.graphics.setColor(224 / 255, 111 / 255, 139 / 255);
      love.graphics.rectangle('fill', 21, 21, math.floor((288 - 12) * player.health / 100 / 3) * 3, 36);
      love.graphics.setColor(1, 1, 1);
      love.graphics.rectangle('fill', 24, 24, math.floor((288 - 12) * player.health / 100 / 3) * 3 - 6, 30);

      if (player.super and math.floor(love.timer.getTime() * 4) % 2 == 0) then
         love.graphics.setColor(247 / 255, 226 / 255, 107 / 255);
         love.graphics.rectangle('fill', 3, 3, 3, love.graphics.getHeight() - 6);
         love.graphics.rectangle('fill', love.graphics.getWidth() - 6, 3, 3, love.graphics.getHeight() - 6);
         love.graphics.rectangle('fill', 3, 3, love.graphics.getWidth() - 6, 3);
         love.graphics.rectangle('fill', 3, love.graphics.getHeight() - 6, love.graphics.getWidth() - 6, 3);
         love.graphics.setColor(178 / 255, 220 / 255, 239 / 255);
         love.graphics.rectangle('fill', 9, 9, 3, love.graphics.getHeight() - 18);
         love.graphics.rectangle('fill', love.graphics.getWidth() - 12, 9, 3, love.graphics.getHeight() - 18);
         love.graphics.rectangle('fill', 9, 9, love.graphics.getWidth() - 18, 3);
         love.graphics.rectangle('fill', 9, love.graphics.getHeight() - 12, love.graphics.getWidth() - 18, 3);
      elseif (player.super and math.floor(love.timer.getTime() * 4) % 2 == 1) then
         love.graphics.setColor(178 / 255, 220 / 255, 239 / 255);
         love.graphics.rectangle('fill', 3, 3, 3, love.graphics.getHeight() - 6);
         love.graphics.rectangle('fill', love.graphics.getWidth() - 6, 3, 3, love.graphics.getHeight() - 6);
         love.graphics.rectangle('fill', 3, 3, love.graphics.getWidth() - 6, 3);
         love.graphics.rectangle('fill', 3, love.graphics.getHeight() - 6, love.graphics.getWidth() - 6, 3);
         love.graphics.setColor(247 / 255, 226 / 255, 107 / 255);
         love.graphics.rectangle('fill', 9, 9, 3, love.graphics.getHeight() - 18);
         love.graphics.rectangle('fill', love.graphics.getWidth() - 12, 9, 3, love.graphics.getHeight() - 18);
         love.graphics.rectangle('fill', 9, 9, love.graphics.getWidth() - 18, 3);
         love.graphics.rectangle('fill', 9, love.graphics.getHeight() - 12, love.graphics.getWidth() - 18, 3);
      end

      storyEvents:draw();
   end
end

function love.keypressed (key)
   if (key == 'space' and player.collider and not gameover) then
      shootSnowball();
   end
end

function shootSnowball ()
   if (player.dir < 0) then
      snowballs[#snowballs + 1] = Snowball(world, player.collider:getX() - 42, player.collider:getY() + 32, player.dir);
   else
      snowballs[#snowballs + 1] = Snowball(world, player.collider:getX() + 32, player.collider:getY() + 32, player.dir);
   end
   love.audio.stop(assets.audio.snowball);
   love.audio.play(assets.audio.snowball);
end

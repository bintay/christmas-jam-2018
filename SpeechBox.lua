local StoryEvent = require('StoryEvent');

local SpeechBox = StoryEvent:extend('SpeechBox')

function SpeechBox:new (text)
   SpeechBox.super(self);

   self.text = text;
   self.interpolatedText = "";
   self.currentPosition = 0;
end

function StoryEvent:draw ()
   love.graphics.setColor(255, 255, 255);
   love.graphics.setFont(fonts.normal);
   local x = love.graphics.getWidth() / 2 - 196 * 3 / 2;
   local y = love.graphics.getHeight() - 64 * 4;
   love.graphics.draw(assets.images.textbox, x, y, 0, 3);
   love.graphics.printf(self.interpolatedText, x + 32, y + 16, 196 * 3 - 64);
end

function SpeechBox:start ()
   SpeechBox.super.start(self);

   assets.audio.voice:setLooping(true);
   love.audio.play(assets.audio.voice);

   Timer.every(0.03, function ()
      self.interpolatedText = self.interpolatedText .. self.text:sub(self.currentPosition, self.currentPosition);
      self.currentPosition = self.currentPosition + 1;
   end, #self.text + 1);

   Timer.after(0.03 * (#self.text + 1), function ()
      love.audio.pause(assets.audio.voice);
   end);

   Timer.after(0.03 * (#self.text + 1) + 2, function () 
      self:done();
   end);
end

return SpeechBox;
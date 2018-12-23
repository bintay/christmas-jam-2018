local StoryEvent = require('StoryEvent');

local RunEvent = StoryEvent:extend('RunEvent')

function RunEvent:new (callback)
   RunEvent.super(self);
   self.callback = callback
end

function RunEvent:draw ()
   
end

function RunEvent:start ()
   RunEvent.super.start(self);

   self.callback();

   self:done();
end

return RunEvent;

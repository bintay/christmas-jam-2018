local StoryEvent = require('StoryEvent');

local InitialEvent = StoryEvent:extend('InitialEvent')

function InitialEvent:new ()
   InitialEvent.super(self);
end

function InitialEvent:draw ()
   
end

function InitialEvent:start ()
   InitialEvent.super.start(self);
   self:done();
end

return InitialEvent;
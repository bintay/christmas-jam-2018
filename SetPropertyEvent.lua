local StoryEvent = require('StoryEvent');

local SetPropertyEvent = StoryEvent:extend('SetPropertyEvent')

function SetPropertyEvent:new (object, property, value)
   SetPropertyEvent.super(self);
   self.object = object;
   self.property = property;
   self.value = value;
end

function SetPropertyEvent:draw ()

end

function SetPropertyEvent:start ()
   SetPropertyEvent.super.start(self);

   self.object[self.property] = self.value;

   self:done();
end

return SetPropertyEvent;

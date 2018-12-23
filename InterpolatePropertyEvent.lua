local StoryEvent = require('StoryEvent');

local InterpolatePropertyEvent = StoryEvent:extend('InterpolatePropertyEvent')

function InterpolatePropertyEvent:new (object, property, value, duration, method, blocking)
   InterpolatePropertyEvent.super(self);
   self.object = object;
   self.property = property;
   self.value = value;
   self.duration = duration;
   self.method = method or 'linear';
   self.blocking = blocking or false;
end

function InterpolatePropertyEvent:draw ()

end

function InterpolatePropertyEvent:start ()
   InterpolatePropertyEvent.super.start(self);

   local target = {}
   target[self.property] = self.value;

   Timer.tween(self.duration, self.object, target, self.method);

   if (self.blocking) then
      Timer.after(self.duration, function ()
         self:done();
      end);
   else
      self:done();
   end
end

return InterpolatePropertyEvent;

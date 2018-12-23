local StoryEvent = require('StoryEvent');

local WaitEvent = StoryEvent:extend('WaitEvent')

function WaitEvent:new (duration)
   WaitEvent.super(self);
   self.duration = duration;
end

function WaitEvent:draw ()

end

function WaitEvent:start ()
   WaitEvent.super.start(self);
   Timer.after(self.duration, function () 
      self:done();
   end);
end

return WaitEvent;
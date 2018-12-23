local StoryEvent = Object:extend('StoryEvent')

function StoryEvent:new ()
   self.onDone = nil;
   self.started = false;
end

function StoryEvent:draw ()

end

function StoryEvent:start ()
   self.started = true;
end

function StoryEvent:next (event)
   self.onDone = event;
   return event;
end

function StoryEvent:done ()
   if (self.onDone) then
      storyEvents = self.onDone;
      self.onDone:start();
   end
end

return StoryEvent;
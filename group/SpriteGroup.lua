luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+scripts/)')..'?.lua;'
local Sprite = require'asleep.Sprite'
local SpriteGroup = Sprite.extend('SpriteGroup')

SpriteGroup.onUpdate = function(I,e)
 SpriteGroup.super.update(I,e)
end

return SpriteGroup
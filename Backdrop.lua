luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require'Sprite'
require'Color'
require'Event'

debugPrint('hey, this module isn\'t finished yet! (Backdrop)')

Backdrop = Sprite.extend('Backdrop')

Backdrop.update = function(I,e)
 Backdrop.super.update(I,e)
end

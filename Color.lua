luaDebugMode = true
package.path = package.path..debug.getinfo(1,'S').source:sub(2):match('(.+asleep.)')..'?.lua;'
require "Class"

Color = Class.new('Color')

Color.setField('r', 0,'default', function(I,k,v,c)I.rawset('r',v)I.updateValues('rgba')end)
Color.setField('g', 0,'default', function(I,k,v,c)I.rawset('g',v)I.updateValues('rgba')end)
Color.setField('b', 0,'default', function(I,k,v,c)I.rawset('b',v)I.updateValues('rgba')end)
Color.setField('a', 0,'default', function(I,k,v,c)I.rawset('a',v)I.updateValues('rgba')end)
Color.setField('hexCode', 0,'default', function(I,k,v,c)I.rawset('hexCode',v)I.updateValues('hexCode')end)
Color.setField('subCode', 0,'default', function(I,k,v,c)I.rawset('hexCode',v)I.updateValues('hexCode')end) 
Color.setField('intValue', 0,'default', function(I,k,v,c)I.rawset('intValue',v)I.updateValues('intValue')end) 

Color.setField('updateValues', function(I, from)
 from = from:gsub('%s+', ''):lower()
 local tbl = {}
 if from == 'hex' or from == 'hexcode' then
  tbl = Color.makeTable(I.rawget('hexCode'), 'fromHex')
 elseif from == 'int' or from == 'intvalue' then
  tbl = Color.makeTable(I.rawget('intValue'), 'fromInt')
 else
  tbl = Color.makeTable({I.rawget('r'),I.rawget('g'),I.rawget('b'),I.rawget('a')}, 'fromTable')
 end
 I.rawset('r',tbl[1])
 I.rawset('g',tbl[2])
 I.rawset('b',tbl[3])
 I.rawset('a',tbl[4])
 I.rawset('hexCode',tbl[5])
 I.rawset('subCode',tbl[5]:sub(-6))
 I.rawset('intValue',tbl[6])
end)

Color.makeTable = function(c, origin)
 local tbl = {}
 if origin == 'fromHex' then
  local h = c:match('(%x+)'):upper()
  if not h then h = 'FFFFFFFF' end
  if h:len() < 8 then
   h = 'FF'..h:sub(-6)
   while h:len() < 8 do
    h = h..'0'
   end
  end
  local intCol = bit.tobit(tonumber(h or 'FFFFFF',16))
  local a = bit.band(bit.rshift(intColor or -1,24), 0xFF)
  local r = bit.band(bit.rshift(intColor or -1,16),0xFF)
  local g = bit.band(bit.rshift(intColor or -1,8),0xFF)
  local b = bit.band(intColor or -1,0xFF)
  tbl[1]=r
  tbl[2]=g
  tbl[3]=b
  tbl[4]=a
  tbl[5]=h
  tbl[6]=intCol
 end
 if origin == 'fromInt' then
  local a = bit.band(bit.rshift(c,24), 0xFF)
  local r = bit.band(bit.rshift(c,16),0xFF)
  local g = bit.band(bit.rshift(c,8),0xFF)
  local b = bit.band(c,0xFF)
  tbl[1]=r
  tbl[2]=g
  tbl[3]=b
  tbl[4]=a
  tbl[6]=c
  r = (string.format('%2X',r)):gsub(' ','0')
  g = (string.format('%2X',g)):gsub(' ','0')
  b = (string.format('%2X',b)):gsub(' ','0')
  a = (string.format('%2X',a)):gsub(' ','0')
  tbl[5] = a..r..g..b
 end
 if origin == 'fromTable' then
  local r,g,b,a = (c[1] or 0), (c[2] or 0), (c[3] or 0), (c[4] or 255)
  if r > 255 then r = 255 end
  if g > 255 then g = 255 end
  if b > 255 then b = 255 end
  if a > 255 then a = 255 end
  if r < 0 then r = 0 end
  if g < 0 then g = 0 end
  if b < 0 then b = 0 end
  if a < 0 then a = 0 end
  tbl[1]=r
  tbl[2]=g
  tbl[3]=b
  tbl[4]=a
  r = (string.format('%2X',r)):gsub(' ','0')
  g = (string.format('%2X',g)):gsub(' ','0')
  b = (string.format('%2X',b)):gsub(' ','0')
  a = (string.format('%2X',a)):gsub(' ','0')
  local h = a..r..g..b
  tbl[5] = h
  tbl[6] = bit.tobit(tonumber(h,16))
 end
 return tbl
end

Color.new = function(c)
 local I = Color.createInstance()
 if type(c) == 'string' then
  I.rawset('hexCode',c)
  I.updateValues('hex')
 elseif type(c) == 'number' then
  I.rawset('intValue',c)
  I.updateValues('int')
 elseif type(c) == 'table' then
  I.rawset('r', (c[1] or 0))
  I.rawset('g', (c[2] or 0))
  I.rawset('b', (c[3] or 0))
  I.rawset('a', (c[4] or 255))
  I.updateValues('rgba')
 else
  return nil
 end
 local mt = getmetatable(I)
 mt.__unm = function(a)
  a.r = 255-a.r
  a.g = 255-a.g
  a.b = 255-a.b
  a.updateValues('rgba')
  return a
 end
 setmetatable(I,mt)
 return I
end

setmetatable(Color, {
 __index = function(t,k)
  k = k:lower()
  if k=='white'then return Color.new('FFFFFFFF')end
  if k=='lightgray'then return Color.new('FFDDDDDD')end
  if k=='gray'then return Color.new('FF888888')end
  if k=='darkgray'then return Color.new('FF444444')end
  if k=='black'then return Color.new('FF000000')end

  if k=='red'then return Color.new('FFFF0000')end
  if k=='orange'then return Color.new('FFF88F00')end
  if k=='yellow'then return Color.new('FFFFFF00')end
  if k=='green'then return Color.new('FF00FF00')end
  if k=='cyan'then return Color.new('FF00FFFF')end
  if k=='blue'then return Color.new('FF0000FF')end
  if k=='purple'then return Color.new('FF8800FF')end
  if k=='magenta'then return Color.new('FFFF00FF')end

  if k=='pink'then return Color.new('FFFF88ff')end
  if k=='brown'then return Color.new('FF884400')end
  if k=='lime'then return Color.new('FF44FF44')end

  if k == 'player' or k == 'bf' or k == 'boyfriend' or k == 'player1' or k == 'p1' then
   return Color.new(getProperty('boyfriend.healthColorArray'))
  end
  if k == 'dad' or k == 'opp' or k == 'opponent' or k == 'player2' or k == 'p2' then
   return Color.new(getProperty('dad.healthColorArray'))
  end
  if k == 'gf' or k == 'girlfriend' or k == 'player3' or k == 'p3' then
   return Color.new(getProperty('gf.healthColorArray'))
  end

  if k=='random'then return Color.new({getRandomInt(0,255),getRandomInt(0,255),getRandomInt(0,255)})end
  return nil
 end
})

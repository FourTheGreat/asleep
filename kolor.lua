function tobit(value)
  value = value % 0x100000000
  if value >= 0x80000000 then
    value = value - 0x100000000
  end
  return value
end
local Color = {}
Color.parse = function(c)
  local h = ''
  if type(c) == 'number' then
    return Color.check(c) and c or tobit(tonumber('FFFFFFFF', 16))
  end
  if type(c) == 'table' then
    for i, v in pairs(c) do
      if v > 255 then c[i] = 255 end
      if v < 0 then c[i] = 0 end
    end
local f = function(i)return string.format('%2X', i)end
    local a = (f(c[4] or 255)):gsub(' ','0')
    local r = (f(c[1] or 0)):gsub(' ','0')
    local g = (f(c[2] or 0)):gsub(' ','0')
    local b = (f(c[3] or 0)):gsub(' ','0')
    h = a..r..g..b
  end
  if type(c) == 'string' then
    h = c
    if h:len() < 8 then
      h = 'FF'..h
    end
    h = h:sub(-8):upper()
  end
  local col=tobit((tonumber(h,16)or tonumber('FFFFFFFF',16)))
  return Color.check(col) and col or tobit(tonumber('FFFFFFFF', 16))
end

Color.totable = function(c)
  local a = bit32.band(bit32.rshift(c,24), 0xFF)
  local r = bit32.band(bit32.rshift(c,16),0xFF)
  local g = bit32.band(bit32.rshift(c,8),0xFF)
  local b = bit32.band(c,0xFF)

  return {[1]=r,[2]=g,[3]=b,[4]=a,
  ['alpha']=a,['red']=r,['green']=g,['blue']=b,
  ['a'] = a,
  ['r'] = r,
  ['g'] = g,
  ['b'] = b,
  }
end

Color.tostring = function(c)
  local a = bit32.band(bit32.rshift(c,24), 0xFF)
  local r = bit32.band(bit32.rshift(c,16),0xFF)
  local g = bit32.band(bit32.rshift(c,8),0xFF)
  local b = bit32.band(c,0xFF)

  return string.format('%2X%2X%2X%2X',a,r,g,b):gsub(' ','0')
end

Color.check = function(c)
  return type(c) == "number" and c >= tobit(tonumber('FF000000', 16)) and c <= tobit(tonumber('FFFFFFFF', 16))
end

Color.new = function(n,c)
  Color[n] = Color.parse(c)
  return col
end

Color.new('white', 'FFFFFFFF')
Color.new('lightgray', 'FFDDDDDD')
Color.new('gray', 'FF888888')
Color.new('darkgray', 'FF444444')
Color.new('black', 'FF000000')

Color.new('red', 'FFFF0000')
Color.new('orange', 'FFFF8800')
Color.new('yellow', 'FFFFFF00')
Color.new('green', 'FF00FF00')
Color.new('cyan', 'FF00FFFF')
Color.new('blue', 'FF0000FF')
Color.new('magenta', 'FFFF00FF')
Color.new('purple', 'FF8800FF')

setmetatable(Color,{
  __index = function(t,k)
    if rawget(Color, k:lower()) then
      return rawget(Color, k:lower())
    end
    if k == 'player' or k == 'boyfriend' or k == 'bf' then
    	return Color.parse(getProperty('boyfriend.healthColorArray'))
    end
    if k == 'opponent' or k == 'dad' then
    	return Color.parse(getProperty('dad.healthColorArray'))
    end
    if k == 'girlfriend' or k == 'gf' then
    	return Color.parse(getProperty('gf.healthColorArray'))
    end
    if Color.parse(k) then return Color.parse(k) end
    return tobit(tonumber('000000', 16))
  end,
  newindex = function(t,k,v)
    local n = k:lower()
    if ('new parse check'):find(n) then return end
    Color[n] = v
  end
})
return Color
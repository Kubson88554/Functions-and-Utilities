--By Jumper#4155, shortened and adapted to work with my library
function clamp(x,s,l) return x < s and s or x > l and l or x end
function seatheadpos(lookX,lookY,headorigin)
local azimuth = clamp(lookX, -0.277, 0.277) * 0.408 * pi2
local elevation =  clamp(lookY, -0.125, 0.125) * 0.9 * pi2 + 0.404 + m.abs(azimuth/0.7101) * 0.122
local distance = m.cos(azimuth) * 0.1523
return vec(m.sin(azimuth)*0.1523, m.cos(elevation)*distance+0.161, m.sin(elevation)*distance-0.023)
end

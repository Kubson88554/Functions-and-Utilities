--By Jumper#4155, shortened and adapted to work with my library
clamp = function(x,s,l) return x < s and s or x > l and l or x end

headazim = clamp(lookX, -0.277, 0.277) * 0.408 * pi2
headelev =  clamp(lookY, -0.125, 0.125) * 0.9 * pi2 + 0.404 + m.abs(headazim/0.7101) * 0.122
 
distance = m.cos(headazim) * 0.1523
headpos = vec(m.sin(headazim)*0.1523, m.cos(headelev)*distance-0.839, m.sin(headelev)*distance-0.023)

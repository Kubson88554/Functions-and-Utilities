clamp = function(x,s,l) return x < s and s or x > l and l or x end

headazim = clamp(lookX, -0.277, 0.277) * 0.408 * pi2
headelev =  clamp(lookY, -0.125, 0.125) * 0.9 * pi2 + 0.404 + math.abs(headazim/0.7101) * 0.122
 
distance = math.cos(headazim) * 0.1523
headpos = vec(math.sin(headazim)*0.1523, math.cos(headelev)*distance-0.839, math.sin(headelev)*distance-0.023)

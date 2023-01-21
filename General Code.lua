ign = input.getNumber; osn = output.setNumber; igb = input.getBool; osb = output.setBool;
pgn = property.getNumber; pgb = property.getBool; pgt = property.getText; m = math; pi = m.pi; pi2 = pi*2

--Basic Functions
function vec(x,y,z) --defines a vector
return {x=x or 0,y=y or 0,z=z or 0}
end
function add(a,b) --adds 2 vectors
return vec(a.x+b.x, a.y+b.y, a.z+b.z)
end
function mult(a,b) --multiplies 2 vectors
return vec(a.x*b.x, a.y*b.y, a.z*b.z)
end
function multf(a,n) --multiplies a vector by a factor
return vec(a.x*n, a.y*n, a.z*n)
end
function invert(a) --inverts a vector
return multf(a,-1)
end
function subt(a,b) --subtracts a vector from another
return add(a,invert(b))
end
function length(a) --gets length of a vector
return m.sqrt(a.x*a.x+a.y*a.y+a.z*a.z)
end
function divf(a,n) --divides vector by a factor
return multf(a,1/n)
end
function norm(a) --normalizes a vector
return divf(a,length(a))
end
function dot(a,b) --dot product between 2 vectors
return a.x*b.x+a.y*b.y+a.z*b.z
end
function cross(a,b) --cross product between 2 vectors
return vec(a.y*b.z-a.z*b.y, a.z*b.x-a.x*b.z, a.x*b.y-a.y*b.x)
end
function reject(a,b) --rejects a vector by another
return subt(a, multf(norm(b), dot(a, norm(b))))
end
function reflect(a,b,factor) --reflects a vector across another
return subt(a, multf(reject(a, b), factor or 2))
end
function stoc(hor,ver,d) --spherical to cartesian conversion
local d=d or 1
return vec(m.sin(hor)*m.cos(ver)*d, m.cos(hor)*m.cos(ver)*d, m.sin(ver)*d)
end

--Advanced Functions
function tolocal(a,r,f,u) --converts a vector to local frame of reference
return vec(dot(r,a),dot(f,a),dot(u,a))
end
function torelative(a,r,f,u) --converts a vector to relative frame of reference
return add(add(multf(r,a.x), multf(f,a.y)), multf(u,a.z))
end
function tospherical(a) --cartesian to spherical conversion
return length(a),m.atan(a.y,a.x),m.asin(a.z/length(a))
end
function toplane(p1,p2,p3) --converts 3 points into a normal vector and distance (plane)
local normal=cross(norm(subt(p3,p1)),norm(subt(p2,p1)))
return normal,dot(normal,invert(p1))
end
function intersect(p1,p2,normal,d) --calculates intersection point of line made between 2 vectors through a plane (general equation)
local ab=subt(p2,p1)
local t=(-(d+dot(normal,p1)))/dot(normal,ab)
return vec(p1.x+ab.x*t,p1.y+ab.y*t,p1.z+ab.z*t)
end
function intersect3p(p1,p2,p3,v1,v2)  --calculates intersection point of line made between 2 vectors through a plane (3 point plane)
local normal=cross(norm(subt(p3,p1)),norm(subt(p2,p1)))
local d=dot(normal,invert(p1))
local ab=subt(p2,p1)
local t=(-(d+dot(normal,p1)))/dot(normal,ab)
return vec(p1.x+ab.x*t,p1.y+ab.y*t,p1.z+ab.z*t)
end
function clamp(x,s,l) return x < s and s or x > l and l or x --clamp (used for seat to head position function)
end
function seatheadpos(lookX,lookY,headorigin) --calculates head position
local azimuth=clamp(lookX,-0.277,0.277)*0.408*pi2
local elevation=clamp(lookY,-0.125,0.125)*0.9*pi2+0.404+m.abs(azimuth/0.7101)*0.122
local distance = m.cos(azimuth)*0.1523
return add(vec(m.sin(azimuth)*0.1523,m.cos(elevation)*distance+0.1,m.sin(elevation)*distance-0.023),headorigin)
end
function debugvec(v,name) --sends components of a vector to debug
debug.log("VECTOR ".. name .." COMPONENTS:")debug.log(v.x)debug.log(v.y)debug.log(v.z)debug.log("------------------")
end
function toHUD(HUDp1,HUDp2,HUDp3,p1,p2) --calculates intersection point display on HUD
local HUDfwd,HUDright=norm(subt(HUDp2,HUDp1)),norm(subt(HUDp3,HUDp1))
local HUDnormal=norm(cross(HUDright,HUDfwd))
local intsct=intersect(p1,p2,HUDnormal,dot(HUDnormal,invert(HUDp1)))
local pixel=add(multf(tolocal(subt(intsct,HUDp1),HUDright,HUDfwd,HUDnormal),128),vec(-1,1,0))
local inHUD=pixel.x>0 and pixel.y>0 and pixel.x<96 and y<96
return pixel.x,pixel.y,inHUD
end
function tomonitor(p,cam,zoom,w,h) --calculates point display on monitor
local fov=zoom*(0.025-2.2)+2.2
local center_x=w/2; local center_y=h/2
local aspect=(center_x-128*0.025)/(center_y-128*0.025)
local fov_y=m.tan(fov/2); local fov_x=fov_y*aspect
local pcam=subt(p,cam)
local pixel=vec(pcam.y>0 and center_x*(1+pcam.x/pcam.y/fov_x) or 0,pcam.y>0 and h-center_y*(1+pcam.z/pcam.y/fov_y) or 0,0)
return pixel.x,pixel.y
end

--compass and tilt to facing vectors
compf = ign(7) * -pi2
tiltf = ign(8) * pi2
compr = ign(9) * -pi2
tiltr = ign(10) * pi2

right=stoc(compr,tiltr)
fwd=stoc(compf,tiltf)
up=cross(right,fwd)

m=math
function vec(x,y,z)
return {x=x or 0,y=y or 0,z=z or 0}
end
function add(a,b)
return vec(a.x+b.x, a.y+b.y, a.z+b.z)
end
function mult(a,b)
return vec(a.x*b.x, a.y*b.y, a.z*b.z)
end
function multf(a,n)
return vec(a.x*n, a.y*n, a.z*n)
end
function invert(a)
return multf(a,-1)
end
function subt(a,b)
return add(a,invert(b))
end
function length(a)
return m.sqrt(a.x*a.x+a.y*a.y+a.z*a.z)
end
function divf(a,n)
return multf(a,1/n)
end
function norm(a)
return divf(a,length(a))
end
function dot(a,b)
return a.x*b.x+a.y*b.y+a.z*b.z
end
function cross(a,b)
return vec(a.y*b.z-a.z*b.y, a.z*b.x-a.x*b.z, a.x*b.y-a.y*b.x)
end
function reject(a,b)
return subt(a, multf(norm(b), dot(a, norm(b))))
end
function reflect(a, b, factor)
return subt(a, multf(reject(a, b), factor or 2))
end
function stoc(hor,ver,d)
local d=d or 1
return vec(m.sin(hor)*m.cos(ver)*d, m.cos(hor)*m.cos(ver)*d, m.sin(ver)*d)
end
function tolocal(a,r,f,u)
return vec(dot(r,a),dot(f,a),dot(u,a))
end
function torelative(a,r,f,u)
return add(add(multf(r,a.x), multf(f,a.y)), multf(u,a.z))
end
function tospherical(a)
return length(a),m.atan(a.y,a.x),m.asin(a.z/length(a))
end
function p3toplane(a,b,c)
local normal=cross(subt(c,a),subt(b,a))
return normal,dot(normal,invert(a))
end
function intersect(a,b,normal,d)
local ab=subt(b,a)
local t=(-(d+dot(normal,a)))/dot(normal,ab)
return vec(a.x+ab.x*t,a.y+ab.y*t,a.z+ab.z*t)
end

compf = ign(7) * -pi2
tiltf = ign(8) * pi2
compr = ign(9) * -pi2
tiltr = ign(10) * pi2

right=stoc(compr,tiltr)
fwd=stoc(compf,tiltf)
up=cross(right,fwd)

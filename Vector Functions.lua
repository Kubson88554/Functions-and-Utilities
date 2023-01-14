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
function debugvec(a)
debug.log("VECTOR COMPONENTS:")debug.log(a.x)debug.log(a.y)debug.log(a.z)debug.log("------------------")
end

--minified
m=math;function vec(a,b,c)return{x=a or 0,y=b or 0,z=c or 0}end;function add(d,e)return vec(d.x+e.x,d.y+e.y,d.z+e.z)end;function mult(d,e)return vec(d.x*e.x,d.y*e.y,d.z*e.z)end;function multf(d,f)return vec(d.x*f,d.y*f,d.z*f)end;function invert(d)return multf(d,-1)end;function subt(d,e)return add(d,invert(e))end;function length(d)return m.sqrt(d.x*d.x+d.y*d.y+d.z*d.z)end;function divf(d,f)return multf(d,1/f)end;function norm(d)return divf(d,length(d))end;function dot(d,e)return d.x*e.x+d.y*e.y+d.z*e.z end;function cross(d,e)return vec(d.y*e.z-d.z*e.y,d.z*e.x-d.x*e.z,d.x*e.y-d.y*e.x)end;function reject(d,e)return subt(d,multf(norm(e),dot(d,norm(e))))end;function reflect(d,e,g)return subt(d,multf(reject(d,e),g or 2))end;function stoc(h,i,j)local j=j or 1;return vec(m.sin(h)*m.cos(i)*j,m.cos(h)*m.cos(i)*j,m.sin(i)*j)end;function tolocal(d,k,l,n)return vec(dot(k,d),dot(l,d),dot(n,d))end;function torelative(d,k,l,n)return add(add(multf(k,d.x),multf(l,d.y)),multf(n,d.z))end;function tospherical(d)return length(d),m.atan(d.y,d.x),m.asin(d.z/length(d))end;function p3toplane(d,e,o)local p=cross(subt(o,d),subt(e,d))return p,dot(p,invert(d))end;function intersect(d,e,p,j)local q=subt(e,d)local r=-(j+dot(p,d))/dot(p,q)return vec(d.x+q.x*r,d.y+q.y*r,d.z+q.z*r)end

--compass and tilt to facing vectors
compf = ign(7) * -pi2
tiltf = ign(8) * pi2
compr = ign(9) * -pi2
tiltr = ign(10) * pi2

right=stoc(compr,tiltr)
fwd=stoc(compf,tiltf)
up=cross(right,fwd)

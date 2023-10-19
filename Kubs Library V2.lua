--Basic Functions
function vec(x,y,z,w) --defines a vector
return {x=x or 0,y=y or 0,z=z or 0, w=w or 0}
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

function project(a,b) --projects a vector by another
return multf(norm(b), dot(a, norm(b)))
end

function reject(a,b) --rejects a vector by another
return subt(a, multf(norm(b), dot(a, norm(b))))
end

function reflect(a,b,factor) --reflects a vector across another
return subt(a, multf(reject(a, b), factor or 2))
end

function spherical_to_cart(hor,ver,d) --spherical to cartesian conversion
local d=d or 1
return vec(m.sin(hor)*m.cos(ver)*d, m.cos(hor)*m.cos(ver)*d, m.sin(ver)*d)
end

function vecDelta(a,spot) --gets delta of a vector
    if not vecDeltaTable then
    vecDeltaTable = {}
    vecDeltaTable[spot] = {oldVec = vec(),deltaVec = vec()}
    elseif not vecDeltaTable[spot] then
    vecDeltaTable[spot] = {oldVec = vec(),deltaVec = vec()}
    end
    vecDeltaTable[spot].deltaVec = subt(a,vecDeltaTable[spot].oldVec)
    vecDeltaTable[spot].oldVec = a
    return vecDeltaTable[spot].deltaVec
end

--Advanced Functions
function to_local_frame(a,r,f,u) --converts a vector to local frame of reference
return vec(dot(r,a),dot(f,a),dot(u,a))
end

function to_global_frame(a,r,f,u) --converts a vector to global frame of reference, origin set at vehicle
return add(add(multf(r,a.x), multf(f,a.y)), multf(u,a.z))
end

function cart_to_spherical_yx(a) --cartesian to spherical conversion (+counter clockwise, 0 at x axis)
    return length(a),m.atan(a.x,a.y),m.asin(a.z/length(a))
end

function cart_to_spherical_xy(a) --cartesian to spherical conversion (+clockwise, 0 at y axis)
return length(a),m.atan(a.x,a.y),m.asin(a.z/length(a))
end

function rotate_about_vec(a,b,n) --rotates a vector n degrees about b vector
return add(add(multf(a,m.cos(n)),multf((cross(b,a)),m.sin(n))),multf((multf(b,dot(b,a))),1-m.cos(n)))
end

function debug_vec(v,name) --sends components of a vector to debug
debug.log("VECTOR ".. name)debug.log(v.x)debug.log(v.y)debug.log(v.z)debug.log("---")
end

function mat3(values) --makes a 3x3 matrix
    local m = {}
    for i=1,3 do m[i]={}
        for j=1,3 do m[i][j] = values and values[(i*3-3)+j] or 0 end
    end
    return m
end

function mat3_mul(m1,m2) --multiplies two 3x3 matrices
    local m = {}
    for i=1,3 do m[i]={}
        for j=1,3 do 
            m[i][j] = 0
            for k=1,3 do
                m[i][j] = m[i][j] + m1[i][k]*m2[k][j]
            end
        end
    end
    return m
end

function mat3_mul_vec(mat,v) --multiplies a vector by a 3x3 matrix
	local result = {}
	result.x = v.x*mat[1][1]+v.y*mat[2][1]+v.z*mat[3][1]
	result.y = v.x*mat[1][2]+v.y*mat[2][2]+v.z*mat[3][2]
	result.z = v.x*mat[1][3]+v.y*mat[2][3]+v.z*mat[3][3]
	return result
end

function clamp(x,s,l) return x < s and s or x > l and l or x --clamp (used for seat to head position function)
end

function seatheadpos(lookX,lookY,headorigin) --calculates head position
    local azimuth=clamp(lookX,-0.277,0.277)*0.408*pi2
    local elevation=clamp(lookY,-0.125,0.125)*0.9*pi2+0.404+m.abs(azimuth/0.7101)*0.122
    local distance = m.cos(azimuth)*0.1523
    return add(vec(m.sin(azimuth)*0.1523,m.cos(elevation)*distance+0.161,m.sin(elevation)*distance-0.023),headorigin)
end

function to_hud(point,hud_offset,head_depth,w,h) --calculates local point display on HUD
    point_offset = subt(point,hud_offset)
    head_pos = seatheadpos(ign(10),ign(11),vec(0,-head_depth,0))
    pos_x=(-head_pos.y*point_offset.x)/(point_offset.y-head_pos.y)-0.0075
    pos_y=(-head_pos.y*point_offset.z)/(point_offset.y-head_pos.y)-0.01
    pixel_x=pos_x*(96/0.7)+w/2+head_pos.x*(96/0.7)
    pixel_y=-pos_y*(96/0.7)+h/2-head_pos.z*(96/0.7)
    return pixel_x,pixel_y
end

function to_monitor(point,cam,zoom,w,h) --calculates local point display on monitor
    local fov=zoom*(0.025-2.2)+2.2
    local center_x=w/2; local center_y=h/2
    local aspect=(center_x-128*0.025)/(center_y-128*0.025)
    local fov_y=m.tan(fov/2); local fov_x=fov_y*aspect
    local pcam=subt(point,cam)
    local pixel_x,pixel_y=pcam.y>0 and center_x*(1+pcam.x/pcam.y/fov_x) or 0, pcam.y>0 and h-center_y*(1+pcam.z/pcam.y/fov_y) or 0
    return pixel_x,pixel_y
end

function pid(p,i,d) --PID
    return{p=p,i=i,d=d,E=0,D=0,I=0,
        run=function(s,sp,pv)
            local E,D,A
            E = sp-pv
            D = E-s.E
            A = math.abs(D-s.D)
            s.E = E
            s.D = D
            s.I = A<E and s.I +E*s.i or s.I*0.5
            return E*s.p +(A<E and s.I or 0) +D*s.d
        end
    }
end

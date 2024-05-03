ign = input.getNumber; osn = output.setNumber; igb = input.getBool; osb = output.setBool; pgn = property.getNumber; pgb = property.getBool; pgt = property.getText;
m = math; pi = m.pi; pi2 = pi*2; cos = m.cos; acos = m.acos; sin = m.sin; asin = m.asin; tan = m.tan; atan = m.atan; sqrt = m.sqrt; abs = m.abs

--Basic Vector Functions

-- VectorNew
function vec(x,y,z)
    return {x=x or 0,y=y or 0,z=z or 0}
end


-- VectorAdd
function add(a,b)
    return vec(a.x+b.x, a.y+b.y, a.z+b.z)
end


-- VectorMultiply
function mult(a,b)
    return vec(a.x*b.x, a.y*b.y, a.z*b.z)
end


-- VectorMultiplyFactor
function multf(a,n)
return vec(a.x*n, a.y*n, a.z*n)
end


-- --VectorInvert
function inv(a)
    return multf(a,-1)
end


-- VectorSubtract
function subt(a,b)
    return add(a,inv(b))
end


-- VectorLength
function length(a)
    return sqrt(a.x*a.x+a.y*a.y+a.z*a.z)
end


-- VectorDivideFactor
function divf(a,n)
    return multf(a,1/n)
end


-- VectorNormalize
function norm(a)
    return divf(a,length(a))
end


-- VectorDot
function dot(a,b)
    return a.x*b.x+a.y*b.y+a.z*b.z
end


-- VectorCross
function cross(a,b)
    return vec(a.y*b.z-a.z*b.y, a.z*b.x-a.x*b.z, a.x*b.y-a.y*b.x)
end


-- VectorProject
function proj(a,b)
    return multf(norm(b), dot(a, norm(b)))
end


-- VectorReject
function rej(a,b)
    return subt(a, multf(norm(b), dot(a, norm(b))))
end


-- VectorReflect
function ref(a,b,n)
    return subt(a, multf(reject(a, b), n or 2))
end


-- VectorSphericalToCartesian
function spher_to_cart(d,hor,ver)
    local d=d or 1
    return vec(sin(hor)*cos(ver)*d, cos(hor)*cos(ver)*d, sin(ver)*d)
end


-- VectorDelta
function vec_delta(a,spot)
    if not vec_delta_table then
    vec_delta_table = {}
    vec_delta_table[spot] = {oldVec = vec(),deltaVec = vec()}
    elseif not vec_delta_table[spot] then
    vec_delta_table[spot] = {oldVec = vec(),deltaVec = vec()}
    end
    vec_delta_table[spot].deltaVec = subt(a,vec_delta_table[spot].oldVec)
    vec_delta_table[spot].oldVec = a
    return vec_delta_table[spot].deltaVec
end


--Advanced Vector Functions


-- PhysToBasis (zyx)
function phys_to_basis(rz, ry, rx)
    local cx, cy, cz = cos(rx), cos(ry), cos(rz)
    local sx, sy, sz = sin(rx), sin(ry), sin(rz)
    local right, fwd = vec(cy*cz, -sy, cy*sz), vec(sx*sz+cx*sy*cz, cx*cy, -sx*cz+cx*sy*sz)
    return right, fwd, cross(right, fwd)
end


-- PhysToYawPitchRoll (zyx)
function phys_to_ypr(rz, ry, rx)
    local cx,cy,cz=cos(rx),cos(ry),cos(rz)
    local sx,sy,sz=sin(rx),sin(ry),sin(rz)
    return atan(sx*sz+cx*sy*cz, cx*cy), asin(-sx*cz+cx*sy*sz), atan(cy*sz, cx*cz+sx*sy*sz)
end


-- YawPitchRollToBasis (zxy)
function ypr_to_basis(rz, rx, ry)
    local cx, cy, cz = cos(rx), cos(ry), cos(rz)
    local sx, sy, sz = sin(rx), sin(ry), sin(rz)
    local right, fwd = vec(-sz*sx*sy+cz*cy, -sz*cy-cz*sx*sy, cx*sy), vec(sz*cx, cz*cx, sx)
    return right, fwd, cross(right, fwd)
end


-- BasisToYPR
function basis_to_ypr(r, f, u)
    return atan(f.x, f.y), asin(f.z), atan(r.z, u.z)
end


-- VectorGlobalToLocalFrame
function to_local_frame(a,r,f,u)
    return vec(dot(r,a),dot(f,a),dot(u,a))
end


-- VectorLocalToGlobalFrame
function to_global_frame(a,r,f,u)
    return add(add(multf(r,a.x), multf(f,a.y)), multf(u,a.z))
end


-- VectorCartesianToSphericalXY
function cart_to_spher_xy(a)
    return length(a),atan(a.x,a.y),asin(a.z/length(a))
end


-- VectorCartesianToSphericalYX
function cart_to_spher_yx(a)
    return length(a),atan(a.y,a.x),asin(a.z/length(a))
end


-- VectorRotateAboutAnother
function rotate_about_vec(a,b,n)
    return add(add(multf(a,cos(n)),multf((cross(b,a)),sin(n))),multf((multf(b,dot(b,a))),1-cos(n)))
end


-- VectorDebug
function debug_vec(v,name)
debug.log("VECTOR ".. name)debug.log(v.x)debug.log(v.y)debug.log(v.z)debug.log("---")
end


-- MatrixNew
function mat3(values)
    local m = {}
    for i=1,3 do m[i]={}
        for j=1,3 do m[i][j] = values and values[(i*3-3)+j] or 0 end
    end
    return m
end


-- MatrixMultiply
function mat3_mul(m1,m2)
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


-- MatrixMultiplyVector
function mat3_mul_vec(mat,v)
    local result = {}
    result.x = v.x*mat[1][1]+v.y*mat[2][1]+v.z*mat[3][1]
    result.y = v.x*mat[1][2]+v.y*mat[2][2]+v.z*mat[3][2]
    result.z = v.x*mat[1][3]+v.y*mat[2][3]+v.z*mat[3][3]
    return result
end


-- SeatHeadPosition (requires clamp)
function seat_head_pos(lookX,lookY,head_origin)
    local azimuth = clamp(lookX,-0.277,0.277)*0.408*pi2
    local elevation = clamp(lookY,-0.125,0.125)*0.9*pi2+0.404+abs(azimuth/0.7101)*0.122
    local distance = cos(azimuth)*0.1523
    return add(vec(sin(azimuth)*0.1523,cos(elevation)*distance+0.161,sin(elevation)*distance-0.023),head_origin)
end


-- PositionToHUD
function to_hud(point,hud_pos,head_depth,lookX,lookY,w,h)
    local point_offset = subt(point,hud_pos)
    local head_pos = seat_head_pos(lookX,lookY,vec(0,-head_depth,0))
    local pos_x = (-head_pos.y*point_offset.x)/(point_offset.y-head_pos.y)-0.0075
    local pos_y = (-head_pos.y*point_offset.z)/(point_offset.y-head_pos.y)-0.01
    local pixel_x = pos_x*(96/0.7)+w/2+head_pos.x*(96/0.7)
    local pixel_y = -pos_y*(96/0.7)+h/2-head_pos.z*(96/0.7)
    return pixel_x,pixel_y
end


-- PositionToMonitor
function to_monitor(point,cam_pos,zoom,w,h)
    local fov = zoom*(0.025-2.2)+2.2
    local center_x = w/2; local center_y=h/2
    local aspect = (center_x-128*0.025)/(center_y-128*0.025)
    local fov_y = tan(fov/2); local fov_x=fov_y*aspect
    local pcam = subt(point,cam_pos)
    local pixel_x,pixel_y = pcam.y>0 and center_x*(1+pcam.x/pcam.y/fov_x) or 0, pcam.y>0 and h-center_y*(1+pcam.z/pcam.y/fov_y) or 0
    return pixel_x,pixel_y
end


--Misc Functions


-- PID
function pid(p,i,d)
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


-- Clamp
function clamp(x,s,l)
    return x < s and s or x > l and l or x
end


-- Map
function map(x, in_min, in_max, out_min, out_max)
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end


-- Map (Clamped input)
function map_c(x, in_min, in_max, out_min, out_max)
    return (x < in_min and in_min or x > in_max and in_max or x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

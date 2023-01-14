ign = input.getNumber; osn = output.setNumber; igb = input.getBool; osb = output.setBool;
pgn = property.getNumber; pgb = property.getBool; m = math; pi = m.pi; pi2 = pi*2

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
function p3toplane(a,b,c)
local normal=norm(cross(subt(c,a),subt(b,a)))
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
function clamp(x,s,l) return x < s and s or x > l and l or x end

HUDp1=vec(pgn("HUD 1 X"),pgn("HUD 1 Y"),pgn("HUD 1 Z"))
HUDp2=vec(pgn("HUD 2 X"),pgn("HUD 2 Y"),pgn("HUD 2 Z"))
HUDp3=vec(pgn("HUD 3 X"),pgn("HUD 3 Y"),pgn("HUD 3 Z"))
HUDnormal,d=p3toplane(HUDp1,HUDp2,HUDp3)
inHUD,intsct = false, vec()

headorigin=vec(pgn("HEAD X"),pgn("HEAD Y"),pgn("HEAD Z"))

altoffset=vec(pgn("ALT X"),pgn("ALT Y"),pgn("ALT Z"))

function onTick()
	
	compf=ign(7)*-pi2;tiltf=ign(8)*pi2;compr=ign(9)*-pi2;tiltr=ign(10)*pi2
	right=stoc(compr,tiltr)
	fwd=stoc(compf,tiltf)
	up=cross(right,fwd)
	
	tgtpos = vec(ign(1),ign(2),ign(3))
	detected = length(tgtpos)>0
	gpspos = vec(ign(4),ign(5),ign(6)-(torelative(altoffset,right,fwd,up).z))
	lookX,lookY = ign(11),ign(12)
	
	headazim = clamp(lookX, -0.277, 0.277) * 0.408 * pi2
	headelev =  clamp(lookY, -0.125, 0.125) * 0.9 * pi2 + 0.404 + m.abs(headazim/0.7101) * 0.122
	distance = m.cos(headazim) * 0.1523
	headoffset = vec(m.sin(headazim)*0.1523, m.cos(headelev)*distance+0.096, m.sin(headelev)*distance-0.023)
	headpos = add(headorigin,headoffset)
	
	reltgtpos = subt(tgtpos,gpspos)
	localtgtpos = tolocal(reltgtpos,right,fwd,up)
	headtgtpos = subt(localtgtpos,headpos)
	
	if dot(HUDnormal,headtgtpos) > 0 and detected then
		inHUD = true
		intsct = intersect(headpos,localtgtpos,HUDnormal,d)
		HUDfwd,HUDright=norm(subt(HUDp2,HUDp1)),norm(subt(HUDp3,HUDp1))
		HUDintsct = multf(tolocal(subt(intsct,HUDp1),HUDright,HUDfwd,HUDnormal),128)
	else
		inHUD = false
	end

end

function onDraw()
	if inHUD then
		screen.setColor(0, 255, 0)
		screen.drawRect((HUDintsct.x-1)-3, (HUDintsct.y+1)-3, 6, 6)
	end
end

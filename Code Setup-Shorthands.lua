ign = input.getNumber; osn = output.setNumber; igb = input.getBool; osb = output.setBool;
pgn = property.getNumber; pgb = property.getBool; pgt = property.getText; m = math; pi = m.pi; pi2 = pi*2

rx,ry,rz=ign(4),ign(5),ign(6)

cx,cy,cz=cos(rx),cos(ry),cos(rz)
sx,sy,sz=sin(rx),sin(ry),sin(rz)

right = vec(cy*cz,-sy,cy*sz)
fwd = vec(sx*sz+cx*sy*cz,cx*cy,-sx*cz+cx*sy*sz)
up = cross(right,fwd)

m=math
if firsttick then
	width = screen.getWidth()
	height = screen.getHeight()
    	center_x = width/2
    	center_y = height/2
    	aspect = (center_x - 128 * border) / (center_y - 128 * border)
    	firsttick = false
end
fov_y = m.tan(fov/2)
fov_x = fov_y * aspect
if(v.z<0) then v.z = 0 end
los = subt(point,campos)
campoint = vec(dot(los,right),dot(los,fwd),dot(los,up))
if campoint.y > 0 then
	pixel_x = center_x * (1 + campoint.x / campoint.y / fov_x)
	pixel_y = center_y * (1 + campoint.z / campoint.y / fov_y)
    end
end

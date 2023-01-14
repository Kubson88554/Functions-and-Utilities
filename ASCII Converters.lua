--converts username to ASCII (First number is 1 for proper send over composite)
userascii = "1"
for i=1, #user do
	userascii = userascii..string.format("%03d", user:byte(i))
end

------------------------------------------

--converts ASCII to username (Gets rid of the 1)
userascii = tostring(userascii):sub(2,13)
user = ""
for i=1, #userascii, 3 do
	user = user..string.char(userascii:sub(i,i+3-1))
end

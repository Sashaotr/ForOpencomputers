local RM = require("RobotMovies")
local r = require("robot")
print("������ ������")
local a = io.read()
local height = tonumber(a) or 1
RM.UP(height)
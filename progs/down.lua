local RM = require("RobotMovies")
local r = require("robot")
print("Введите высоту:")
local a = io.read()
local height = tonumber(a) or 1
RM.DOWN(height)
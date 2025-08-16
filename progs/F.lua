local RM = require("RobotMovies")
print("Введите длину:")
local length = tonumber(io.read()) or 1
RM.F(length)
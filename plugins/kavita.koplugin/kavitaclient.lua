local UIManager = require("ui/uimanager")
local logger = require("logger")
local socketutil = require("socketutil")

local KavitaClient = {}

function KavitaClient:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return KavitaClient

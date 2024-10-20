local Blitbuffer = require("ffi/blitbuffer")
local FrameContainer = require("ui/widget/container/framecontainer")
local UIManager = require("ui/uimanager")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local logger = require("logger")
local _ = require("gettext")
local Screen = require("device").screen
local Geom = require("ui/geometry")
local T = require("ffi/util").template
local Widget = require("ui/widget/widget")

local KavitaView = WidgetContainer:extend({
    title = _("Kavita"),
})

function KavitaView:init()
    self[1] = FrameContainer:new({
        padding = 0,
        bordersize = 0,
        background = Blitbuffer.COLOR_WHITE,
        Widget:new({
            dimen = Geom:new({
                x = 0,
                y = 0,
                w = Screen:getWidth(),
                h = Screen:getHeight(),
            }),
        }),
    })
end

function KavitaView:onShow()
    UIManager:setDirty(self, function()
        return "ui", self[1].dimen -- i.e., FrameContainer
    end)
end

function KavitaView:onCloseWidget()
    UIManager:setDirty(nil, function()
        return "ui", self[1].dimen
    end)
end

function KavitaView:showView()
    logger.dbg("show Kavita view")
    UIManager:show(KavitaView:new({
        dimen = Screen:getSize(),
        covers_fullscreen = true, -- hint for UIManager:_repaint()
    }))
end

function KavitaView:onClose()
    logger.dbg("close OPDS catalog")
    UIManager:close(self)
    return true
end

return KavitaView

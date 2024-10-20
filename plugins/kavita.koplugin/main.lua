local Dispatcher = require("dispatcher")
local UIManager = require("ui/uimanager")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local InputDialog = require("ui/widget/inputdialog")
local _ = require("gettext")

local Kavita = WidgetContainer:extend({
    name = "kavita",
    is_doc_only = false,
})

function Kavita:onDispatcherRegisterActions()
    Dispatcher:registerAction(
        "show_kavita",
        { category = "none", event = "ShowKavita", title = _("Kavita"), filemanager = true }
    )
end

function Kavita:init()
    self:onDispatcherRegisterActions()
    self.ui.menu:registerToMainMenu(self)
end

function Kavita:showKavita()
    local KavitaView = require("kavitaview")
    local filemanagerRefresh = function()
        self.ui:onRefresh()
    end
    function KavitaView:onClose()
        UIManager:close(self)
        local FileManager = require("apps/filemanager/filemanager")
        if FileManager.instance then
            filemanagerRefresh()
        else
            FileManager:showFiles(G_reader_settings:readSetting("download_dir"))
        end
    end

    KavitaView:showView()
end

function Kavita:onShowKavita()
    self:showKavita()
    return true
end

function Kavita:addToMainMenu(menu_items)
    if not self.ui.view then
        menu_items.kavita = {
            text = _("Kavita"),
            callback = function()
                self:showKavita()
            end,
        }
    end
    menu_items.kavita_settings = {
        -- its name is "calibre", but all our top menu items are uppercase.
        text = _("Kavita Settings"),
        sub_item_table = {
            {
                text = _("Server URL"),
                callback = function()
                    local url_dialog
                    url_dialog = InputDialog:new({
                        title = _("Set URL to Kavita server"),
                        input = G_reader_settings:readSetting("kavita_url") or "",
                        buttons = {
                            {
                                {
                                    text = _("Cancel"),
                                    id = "close",
                                    callback = function()
                                        UIManager:close(url_dialog)
                                    end,
                                },
                                {
                                    text = _("Set URL"),
                                    callback = function()
                                        local url = url_dialog:getInputText()
                                        G_reader_settings:saveSetting("kavita_url", url)
                                        UIManager:close(url_dialog)
                                    end,
                                },
                            },
                        },
                    })
                    UIManager:show(url_dialog)
                    url_dialog:onShowKeyboard()
                end,
            },
        },
    }
end

return Kavita

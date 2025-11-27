-- Du MUSST HIER DEINEN tatsächlichen Link zur main.lua einfügen!
-- Beispiel: Wenn du main.lua auf GitHub hochlädst, nutze den Raw-Link.
local LIBRARY_URL = "HIER_URL_ZU_DEINER_MAIN.LUA_EINFUEGEN"

local NexusUI = loadstring(game:HttpGet(LIBRARY_URL))()

local success, result = pcall(function()
    loadfile("Interface.lua")(NexusUI)
end)

if not success then
    warn("NexusUI Interface Fehler: " .. result)
    NexusUI:Notify({Title = "UI Fehler", Content = "Das Interface konnte nicht geladen werden.", Type = "Danger"})
end

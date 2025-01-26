local localPlayer = game:GetService("Players").localPlayer

local PlayerList = {}
for x, y in pairs(game:GetService("Players"):GetChildren()) do
    PlayerList[y.Name] = y.Team
end

local Chams = {}
for x,y in pairs(localPlayer.PlayerGui:GetChildren()) do
    if y.ClassName == "Highlight" then
        table.insert(Chams, y)
    end
end

local Settings = {
    Chams = {
        Enabled = true,
        Color = Color3.fromHex('ff89a4'),
        Transparency = 0.5,
        Teammates = true,
        Outline = {
            Color = Color3.fromHex('ff89a4'),
            Transparency = 0.5,
        },
    },
}

function UpdateChams()
    for _, p in pairs(Chams) do
        if Settings.Chams.Enabled then
            if p.Adornee ~= nil then
                if PlayerList[p.Adornee.Name] ~= localPlayer.Team then
                    p.Enabled = true
                else
                    p.Enabled = Settings.Chams.Teammates
                end
            end
            p.FillColor = Settings.Chams.Color
            p.FillTransparency = Settings.Chams.Transparency

            p.OutlineColor = Settings.Chams.Outline.Color
            p.OutlineTransparency = Settings.Chams.Outline.Transparency
            p.DepthMode = 'AlwaysOnTop'
        else
            p.Enabled = false
        end
    end
end


local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'RatHack Arsenal | (づ｡◕‿‿◕｡)づ',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    ['CHAMS'] = Window:AddTab('Chams'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddButton('Dex Explorer', function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
MenuGroup:AddButton('Rejoin', function() game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId) end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'Comma', NoUI = true, Text = 'Menu keybind' })

ChamsTab =  Tabs['CHAMS']:AddLeftGroupbox('Chams')
ChamsTab:AddToggle('ChamsToggle', {
    Text = 'Enabled',
    Default = Settings.Chams.Enabled,
    Callback = function(Value)
        Settings.Chams.Enabled = Value
    end
}):AddColorPicker('ChamsColorPicker', {
    Title = 'Chams color',
    Default = Settings.Chams.Color,

    Callback = function(Value)
        Settings.Chams.Color = Value
    end
})
ChamsTab:AddSlider('ChamsTransparency', {
    Text = 'Chams transparency',
    Default = Settings.Chams.Transparency,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        Settings.Chams.Transparency = Value
    end
})

ChamsTab:AddLabel('Outline color'):AddColorPicker('OutlineColorPicker', {
    Title = 'Outline color',
    Default = Settings.Chams.Outline.Color,

    Callback = function(Value)
        Settings.Chams.Outline.Color = Value
    end
})
ChamsTab:AddSlider('OutlineTransparency', {
    Text = 'Outline transparency',
    Default = Settings.Chams.Outline.Transparency,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        Settings.Chams.Outline.Transparency = Value
    end
})
ChamsTab:AddToggle('ShowTeammates', {
    Text = "Teammates",
    Default = Settings.Chams.Teammates,
    Callback = function(Value)
        Settings.Chams.Teammates = Value
    end
})

Options.ChamsColorPicker:OnChanged(function()
    UpdateChams()
end)
Options.ChamsTransparency:OnChanged(function()
    UpdateChams()
end)
Options.OutlineColorPicker:OnChanged(function()
    UpdateChams()
end)
Options.OutlineTransparency:OnChanged(function()
    UpdateChams()
end)
Toggles.ChamsToggle:OnChanged(function()
    UpdateChams()
end)
Toggles.ShowTeammates:OnChanged(function()
    UpdateChams()
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

writefile('RatHack/themes/RatHack.json', '{"MainColor":"171717","AccentColor":"ff89a4","OutlineColor":"373737","BackgroundColor":"131313","FontColor":"ff89a4"}') -- Could really find a different way to do this
if not isfile('RatHack/themes/default.txt') then
    writefile('RatHack/themes/default.txt', 'RatHack.json')
end

ThemeManager:SetFolder('RatHack')
SaveManager:SetFolder('RatHack/Arsenal')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()

Library:SetWatermarkVisibility(Watermark)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;
local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;
    Library:SetWatermark(('RatHack Arsenal | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

local Delay = 1.5
local Timer = 0
local Loop = game:GetService("RunService").Heartbeat:Connect(function(Time)
    Timer = Timer + Time
    if Timer >= Delay then
        Timer = Timer - Delay
        UpdateChams()
    end
end)

Library.KeybindFrame.Visible = false;

Library:OnUnload(function()
    WatermarkConnection:Disconnect()

    Loop:Disconnect()
    Loop = nil

    for _, q in pairs(Chams) do
        q.Enabled = false
    end

    print('Unloaded!')
    Library.Unloaded = true
end)
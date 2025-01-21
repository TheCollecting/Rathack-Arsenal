local camera = workspace.CurrentCamera

local playerList = {}
local playerText = {}
local playerBox = {}
local localPlayer = game:GetService("Players").LocalPlayer;

local esp = {
    teamcheck = true,
    size = 16,
    color = Color3.fromHex('ff00fb'),
    colortext = Color3.fromHex('ff00fb'),
}

function initPlayerText()
    for i = 0, 16 do
        text = Drawing.new("Text")
        text.Center = true
        text.Size = 16
        text.Color = Color3.fromHex('ff00fb')
        table.insert(playerText, text)
    end
end

function clearPlayerText()
    for _, z in pairs(playerText) do
        z:Remove()
    end
end

function initPlayerBox()
    table.clear(playerBox)
    for i = 0, 16 do
        box = Drawing.new("Square")
        box.Color = Color3.fromHex('ff00fb')
        box.Visible = false
        box.Thickness = 1
        box.Filled = false
        table.insert(playerBox, box)
    end
end

function clearPlayerBox()
    for _, i in pairs(playerBox) do
        i:Remove()
    end
end

function hideAllPlayerText()
    for _, i in pairs(playerText) do
        i.Visible = false
    end
end
function hideAllPlayerBox()
    for _, i in pairs(playerBox) do
        i.Visible = false
    end
end
function initPlayerList()
    table.clear(playerList)
    for _, x in pairs(game:GetService("Players"):GetPlayers()) do
        table.insert(playerList, x)
    end
end

initPlayerList()
initPlayerText()
initPlayerBox()

local ESPLoop = game:GetService("RunService").RenderStepped:Connect(function() 
    -- initPlayerList()
    -- initPlayerText()
    hideAllPlayerText()
    hideAllPlayerBox()
    for g, l in pairs(game:GetService("Players"):getPlayers()) do
        if l ~= localPlayer then
             if localPlayer.team ~= l.Team or not esp.teamcheck then
                text = playerText[g]
               -- print(#playerList)
               -- print(g)
                box = playerBox[g]
               -- if l.Character then
                local textpos = workspace.Camera:WorldToViewportPoint(l.Character.Head.Position + Vector3.new(0, 3, 0))
                local head = workspace.Camera:WorldToViewportPoint(l.Character.Head.Position + Vector3.new(0, 0.5, 0))
                local legpos = workspace.Camera:WorldToViewportPoint(l.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
                local rootpos = workspace.Camera:WorldToViewportPoint(l.Character.HumanoidRootPart.Position)

                local playerPos = l.Character:GetModelCFrame()
                local pos, onScreen = workspace.Camera:WorldToViewportPoint(Vector3.new(playerPos.X, playerPos.Y, playerPos.Z))

                 if onScreen then
                    box.Size = Vector2.new(2000 / rootpos.Z, head.Y + 0.5 - legpos.Y)
                    box.Position = Vector2.new(rootpos.X - box.Size.X / 2, rootpos.Y - box.Size.Y / 2)
                    box.Color = esp.colortext
                    box.Visible = true

                    text.Size = esp.size
                    text.Color = esp.color
                    text.Visible = true
                    text.Position = Vector2.new(textpos.X, textpos.Y)
                    text.Text = l.name
                    else
                        text.Visible = false
                        box.Visible = false
                  end
               -- else
                  --  text.Visible = false
                   -- box.Visible = false
               -- end
            else
                   text.Visible = false
                   box.Visible = false
            end
        else
                    text.Visible = false
                    box.Visible = false
        end
    end
end)

-- UI BELOW
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
    ['ESP'] = Window:AddTab('Visuals'),
    ['MISC'] = Window:AddTab('MISC'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

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

Library.KeybindFrame.Visible = false;

Library:OnUnload(function()
    WatermarkConnection:Disconnect()

    ESPLoop:Disconnect()
    ESPLoop = nil

    for _, m in pairs(playerBox) do
        m:Remove()
    end
    for _, v in pairs(playerText) do
        v:Remove()
    end

    -- clearPlayerText()

    print('Unloaded!')
    Library.Unloaded = true
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddButton('Dex Explorer', function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
MenuGroup:AddButton('Rejoin', function() game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId) end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'Comma', NoUI = true, Text = 'Menu keybind' })

local uiToggles = Tabs['UI Settings']:AddRightGroupbox('UI Toggles')
uiToggles:AddToggle('Keybinds', {
    Text = 'Show keybinds',
    Default = Library.KeybindFrame.Visible,
    Tooltil = 'ill fucking kill you dude STOP',
    Callback = function(Value)
        Library.KeybindFrame.Visible = Value
    end
})
uiToggles:AddToggle('Watermark', {
    Text = 'Show Watermark',
    Default = true,
    Tooltip = 'DUDE NO',

    Callback = function(Value)
    end
})
local Fartbox = Tabs['ESP']:AddRightGroupbox('Fartbox')
Fartbox:AddToggle('Team Check',{
    Text = 'Team Check',
    Default = esp.teamcheck,
    Tooltip = 'tooltuah',
    Callback = function(Value)
        esp.teamcheck = Value
    end
}):AddColorPicker('ESPP',{
    Text = 'Name Color',
    Default = esp.color,
    Tooltip = 'Thanks zopac for the code idiot',
    Callback = function(Value)
        esp.color = Value
    end
})

Fartbox:AddLabel('Box Color'):AddColorPicker('Box Color',{
    Text = 'Box Color',
    Default = esp.colortext,
    Tooltip = 'Thanks zopac for the code idiot AGAIN',
    Callback = function(Value)
        esp.colortext = Value
    end
})

Fartbox:AddSlider('Name Size', {
    Text = 'Name Size',
    Min = 10,
    Max = 69,
    Rounding = 1,
    Default = esp.size,
    Tooltip = 'hiyanc is the devil',
    Callback = function(Value)
        esp.size = Value
    end
})

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
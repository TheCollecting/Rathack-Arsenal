local camera = workspace.CurrentCamera

local playerList = {}
local playerText = {}
local playerBox = {}
local healthBars = {}
local espList = {}
local Folder = Instance.new('Folder')
local chamList = {}
local localPlayer = game:GetService("Players").LocalPlayer
local round = function(...) local a = {} for i,v in next, table.pack(...) do a[i] = math.round(v) end return unpack(a) end
local CurrentCamera = workspace.CurrentCamera
local tan, rad = math.tan, math.rad
local camera = workspace.CurrentCamera
local wtvp = function(...) local a, b = camera.WorldToViewportPoint(camera, ...) return Vector2.new(a.X, a.Y), b, a.Z end
local players = game:GetService("Players")
local localplayer = players.LocalPlayer

local StarterPlayer = game:GetService("StarterPlayer")
local OriginalSizes = {}
for i, v in pairs(StarterPlayer.StarterCharacter:GetChildren()) do
    if v:IsA("BasePart") then
        OriginalSizes[v.Name] = v.Size
    end
end

local esp = {
    teamcheck = true,
    size = 16,
    color = Color3.fromHex('ff00fb'),
    colortext = Color3.fromHex('ff00fb'),
    name = {
        enabled = true,
        side = 'Top',
    },
    healthbar = {
        side = 'Left',
    },
    box = {
        enabled = true,
    },
    chams = {
        enabled = true,
        color = Color3.fromHex('ff00fb'),
        visible = false,
        transparency = 0.5,
        hidehbe = false,
    }
}

local aim = {
    enabled = true,
    teamaim = true,
    part = "Head",
    fov = 50,
    showFov = true,
    fovColor = Color3.fromHex('ff89a4'),
    fovThickness = 2,
    key = "X",
    keyHeld = false,
}

local misc = {
    tp = {
        enabled = false,
        key = 'H',
        keyHeld = false,
        teamcheck = true,
    },
    hbe = {
        enabled = false,
        size = 10,
        part = 'head',
        transparency = 0.5,
        teamcheck = true,
    }
}

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
    ['AIM'] = Window:AddTab('Aimbot'),
    ['ESP'] = Window:AddTab('Visuals'),
    ['MISC'] = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddButton('Dex Explorer', function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
MenuGroup:AddButton('Rejoin', function() game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId) end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'Comma', NoUI = true, Text = 'Menu keybind' })
local uiToggles = Tabs['UI Settings']:AddRightGroupbox('UI Toggles')

local espTab = Tabs['ESP']:AddLeftGroupbox('Esp')
local chamsTab = Tabs['ESP']:AddRightGroupbox('Chams')

local aimTab = Tabs['AIM']:AddLeftGroupbox('Aimbot')

local teleTab = Tabs['MISC']:AddLeftGroupbox('Teleport')
local hitboxE = Tabs['MISC']:AddRightGroupbox('Hitbox expander')

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

espTab:AddToggle('Team Check',{
    Text = 'Team Check',
    Default = esp.teamcheck,
    Tooltip = 'tooltuah',
    Callback = function(Value)
        esp.teamcheck = Value
    end
})
espTab:AddToggle('Boxes', {
    Default = esp.box.enabled,
    Text = 'Boxes',
    Callback = function(Value)
        esp.box.enabled = Value
    end
}):AddColorPicker('Box Color',{
    Text = 'Box Color',
    Default = esp.colortext,
    Tooltip = 'Thanks zopac for the code idiot AGAIN',
    Callback = function(Value)
        esp.colortext = Value
    end
})
espTab:AddToggle('names', {
    Default = esp.name.enabled,
    Text = 'names',
    Callback = function(Value)
        esp.name.enabled = Value
    end
}):AddColorPicker('ESPP',{
    Text = 'Name Color',
    Default = esp.color,
    Tooltip = 'Thanks zopac for the code idiot',
    Callback = function(Value)
        esp.color = Value
    end
})
espTab:AddDropdown('namelocation', {
    Text = 'name location',
    Values = {'Top', "Bottom"},
    Default = 1,
    Multi = false,
    Callback = function(Value)
        esp.name.side = Value
    end
})
espTab:AddSlider('Name Size', {
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
espTab:AddToggle('HealthBar', {
    Default = esp.healthbar.enabled,
    Text = 'healt bar',
    Callback = function(Value)
        esp.healthbar.enabled = Value
    end
})
espTab:AddDropdown('HealthLocation', {
    Values = {'Left', 'Right'},
    Default = esp.healthbar.side,
    Multi = false,
    Text = 'Healthbar Location',
    Callback = function(Value)
        esp.healthbar.side = Value
    end
})

chamsTab:AddToggle('Chams', {
    Text = 'Chams (Needs work)',
    Default = esp.chams.enabled,
    Callback = function(Value)
        esp.chams.enabled = Value
    end
}):AddColorPicker('chams Color',{
    Text = 'chams Color',
    Default = esp.chams.color,
    Tooltip = 'im crying',
    Callback = function(Value)
        esp.chams.color = Value
    end
})
chamsTab:AddToggle('Visible only chams', {
    Text = 'Vis only chams',
    Default = esp.chams.visible,
    Callback = function(Value)
        esp.chams.visible = Value
    end
})
chamsTab:AddSlider('Chams transparency', {
    Text = 'Chams transparency',
    Min = 0,
    Max = 1,
    Rounding = 1,
    Default = esp.chams.transparency,
    Callback = function(Value)
        esp.chams.transparency = Value
    end
})
chamsTab:AddToggle('Hide hitbox', {
    Text = 'Show hitbox expander',
    Default = esp.chams.hidehbe,
    Tooltip = 'If hitbox expander transparency is one they will not show up :)',
    Callback = function(Value)
        esp.chams.hidehbe = Value
    end
})

aimTab:AddToggle('Aimbot', {
    Text = 'Aimbot',
    Default = aim.enabled,

    Callback = function(Value)
        aim.enabled = Value
    end
})
aimTab:AddLabel('aimKey'):AddKeyPicker('AimKeyPicker', {
    Default = aim.key,
    Mode = 'Hold',
    Text = 'Aimkey',

    Callback = function(Value)
    end,
    Callback = function(Value)
        aim.key = Value
    end
})
aimTab:AddToggle('Teamcheck', {
    Default = aim.teamaim,
    Text = 'Aimbot teamcheck',
    Callback = function(Value)
        aim.teamaim = Value
    end
})
aimTab:AddToggle('fovCircle', {
    Default = aim.showFov,
    Text = 'Fov circle',
    Callback = function(Value)
        aim.showFov = Value
    end
}):AddColorPicker('fov circle',{
    Text = 'fov Color',
    Default = aim.fovColor,
    Tooltip = 'im crying',
    Callback = function(Value)
        aim.fovColor = Value
    end
})
aimTab:AddSlider('Fov slider', {
    Text = 'Fov',
    Default = aim.fov,
    Min = 5,
    Max = 300,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)
        aim.fov = Value
    end
})
aimTab:AddSlider('Fov circle thickness', {
    Text = 'Fov circle thickness',
    Default = aim.fovThickness,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Compact = true,

    Callback = function(Value)
        aim.fovThickness = Value
    end
})
aimTab:AddDropdown('Aim part', {
    Values = { 'Head', 'UpperTorso', 'LowerTorso', 'RightUpperArm', 'LeftUpperArm', 'RightLowerArm', 'LeftLowerArm', 'RightHand', 'LeftHand', 'RightUpperLeg', 'LeftUpperLeg', 'RightLowerLeg', 'LeftLowerLeg', 'RightFoot', 'LeftFoot' },
    Default = 1,
    Multi = false,
    Text = 'aim part',
    Tooltip = 'i hate you i hate everything leave me alone',
    Callback = function(Value)
        aim.part = Value
    end
})

teleTab:AddToggle('Teleport', {
    Text = 'Teleport',
    Tooltip = 'Teleport to any player that is inside of fov circle',
    Default = misc.tp.enabled,
    Callback = function(Value)
        misc.tp.enabled = Value
    end
})
teleTab:AddToggle('tpTeamcheck', {
    Text = 'Teleport Teamcheck',
    Default = misc.tp.teamcheck,
    Callback = function(Value)
        misc.tp.teamcheck = Value
    end
})
teleTab:AddLabel('tpkey'):AddKeyPicker('tpKeyPicker', {
    Default = misc.tp.key,
    Mode = 'Hold',
    Text = 'Teleport key',

    Callback = function(Value)
    end,
    Callback = function(Value)
        misc.tp.key = Value
    end
})

hitboxE:AddToggle('Hitbox expander', {
    Text = 'Expand hitboxes',
    Default = misc.hbe.enabled,
    Tooltip = 'Almost silent aim!',

    Callback = function(Value)
        misc.hbe.enabled = Value
    end
})
hitboxE:AddToggle('Hitbox Teamcheck', {
    Default = misc.hbe.teamcheck,
    Text = 'Hitbox expander teamcheck',
    Callback = function(Value)
        misc.hbe.teamcheck = Value
    end
})
hitboxE:AddSlider('Hitbox transparency', {
    Text = 'Hitbox transparency',
    Min = 0,
    Max = 1,
    Rounding = 1,
    Default = misc.hbe.transparency,
    Callback = function(Value)
        misc.hbe.transparency = Value
    end
})
hitboxE:AddSlider('Hitbox size', {
    Text = 'Hitbox size',
    Min = 1,
    Max = 40,
    Rounding = 1,
    Default = misc.hbe.size,
    Callback = function(Value)
        misc.hbe.size = Value
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

function createVisuals(player)
    local draw = {}
    draw.name = Drawing.new("Text")
    draw.name.Center = true
    draw.name.Size = 16
    draw.name.Outline = true
    draw.name.OutlineColor = Color3.fromHex('000000')

    draw.boxOutline = Drawing.new("Square")
    draw.boxOutline.Visible = false
    draw.boxOutline.Thickness = 2.5
    draw.boxOutline.Filled = false

    draw.box = Drawing.new("Square")
    draw.box.Visible = false
    draw.box.Thickness = 1
    draw.box.Filled = false

    draw.barOutline = Drawing.new("Line")
    draw.barOutline.Visible = false
    draw.barOutline.Thickness = 4
    draw.barOutline.Color = Color3.fromHex('000000')

    draw.bar = Drawing.new("Line")
    draw.bar.Visible = false
    draw.bar.Thickness = 2
    
    espList[player] = draw
end

local fovCircle = Drawing.new('Circle')
fovCircle.Position = camera.ViewportSize / 2
fovCircle.Thickness = aim.fovThickness

local function removeEsp(player)
    if rawget(espList, player) then
        for _, drawing in next, espList[player] do
            drawing:Remove()
        end
        espList[player] = nil
    end
end

for _, player in next, players:GetPlayers() do
   if player ~= localplayer then
       createVisuals(player)
   end
end

local addLoop = players.PlayerAdded:Connect(function(player)
    wait(1)
    createVisuals(player)
end)

local delLoop = players.PlayerRemoving:Connect(function(player)
    removeEsp(player)
end)

function deleteChams()
    for _, p in players:GetPlayers() do
        for _, x in p.Character:GetChildren() do
            if x:IsA("BasePart") then
                if x:FindFirstChild("Chams") then
                    x.Chams:Destroy()
                end
            end
        end
    end
end

-- need to add a alive check and distance priority
-- could probably just name this aimbot bc its all the aimbot code
function getBestTarget()
    local inFov = {}
    for _, p in players:GetPlayers() do
        if p.Character.Humanoid.health > 0 then
            if localPlayer.name ~= p.Name then
                if localPlayer.team ~= p.Team or not aim.teamaim then
                    local pos, onScreen, depth = wtvp(p.Character:FindFirstChild(aim.part).Position)
                    if (onScreen and ((Vector2.new(pos.X, pos.Y) - camera.ViewportSize/2).Magnitude) <= aim.fov) then
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, p.Character:FindFirstChild(aim.part).Position)
                    end
                end
            end
        end
    end
end

function tpToPlayer()
    local inFov = {}
    for _, p in players:GetPlayers() do
        if p.Character.Humanoid.health > 0 then
            if localPlayer.name ~= p.Name then
                if localPlayer.team ~= p.Team or not misc.tp.teamcheck then
                    local pos, onScreen, depth = wtvp(p.Character:FindFirstChild(aim.part).Position)
                    if (onScreen and ((Vector2.new(pos.X, pos.Y) - camera.ViewportSize/2).Magnitude) <= aim.fov) then
                        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(p.Character.HumanoidRootPart.Position)
                    end
                end
            end
        end
    end
end

local ESPLoop = game:GetService("RunService").RenderStepped:Connect(function()

    fovCircle.Visible = aim.showFov
    fovCircle.Color = aim.fovColor
    fovCircle.Radius = aim.fov
    fovCircle.Thickness = aim.fovThickness

    if aim.enabled then
        aim.keyHeld = Options.AimKeyPicker:GetState()
        if aim.keyHeld then
            getBestTarget()
        end
    end

    if misc.tp.enabled then
        misc.tp.keyHeld = Options.tpKeyPicker.GetState()
        if misc.tp.keyHeld then
            tpToPlayer()
        end
    end

    for l, g in next, espList do

        if misc.hbe.enabled then
            if l.Team ~= localPlayer.team or not misc.hbe.teamcheck then
                l.Character.HeadHB.CanCollide = false
                l.Character.HeadHB.Transparency = misc.hbe.transparency
                l.Character.HeadHB.Size = Vector3.new(misc.hbe.size, misc.hbe.size, misc.hbe.size)
                l.Character.HumanoidRootPart.CanCollide = false
                l.Character.HumanoidRootPart.Transparency = misc.hbe.transparency
                l.Character.HumanoidRootPart.Size = Vector3.new(misc.hbe.size, misc.hbe.size, misc.hbe.size)
            else
                l.Character.HeadHB.Transparency = 1
                l.Character.HumanoidRootPart.Transparency = 1
                for i, p in pairs(l.Character:GetChildren()) do -- Should probably make this a function at some point
                    if p.ClassName == 'Part' or p.ClassName == 'MeshPart' then
                        if OriginalSizes[p.Name] ~= nil then
                            if p.Size ~= OriginalSizes[p.Name] then
                                p.Size = Vector3.new(OriginalSizes[p.Name].X, OriginalSizes[p.Name].Y, OriginalSizes[p.Name].Z)
                            end
                        end
                    end
                end
            end
        else
            l.Character.HeadHB.Transparency = 1
            l.Character.HumanoidRootPart.Transparency = 1
            for i, p in pairs(l.Character:GetChildren()) do
                if p.ClassName == 'Part' or p.ClassName == 'MeshPart' then
                    if OriginalSizes[p.Name] ~= nil then
                        if p.Size ~= OriginalSizes[p.Name] then
                            p.Size = Vector3.new(OriginalSizes[p.Name].X, OriginalSizes[p.Name].Y, OriginalSizes[p.Name].Z)
                        end
                    end
                end
            end
        end

        text = g.name
        box = g.box
        boxOutline = g.boxOutline
        healthbar = g.bar
        healthbarOutline = g.barOutline
        if l.Character then
            if l.Character.Humanoid.health > 0 then
                if localPlayer.team ~= l.Team or not esp.teamcheck then
                    local playerPos = l.Character:GetModelCFrame()
                    local pos, onScreen, depth = wtvp(l.Character.HumanoidRootPart.Position)
                    if pos and onScreen then
                        local scaleFactor = 1 / (depth * tan(rad(camera.FieldOfView / 2)) * 2) * 1000
                        local width, height = round(4 * scaleFactor, 6 * scaleFactor)
                        local x, y = round(pos.X, pos.Y)
                        local topOffset = y - height / 2 - 15
                        local bottomOffset = y + height / 2
                        if esp.box.enabled then
                            box.Size = Vector2.new(width, height)
                            box.Position = Vector2.new(round(x - width / 2, y - height / 2))
                            box.Color = esp.colortext
                            box.Visible = true
                            boxOutline.Size = Vector2.new(width, height)
                            boxOutline.Position = Vector2.new(round(x - width / 2, y - height / 2))
                            boxOutline.Color = Color3.fromHex('000000')
                            boxOutline.Visible = true
                        else
                            box.Visible = false
                            boxOutline.Visible = false
                        end

                        if esp.healthbar.enabled then
                            health = game:GetService("Players")[l.Character.name].NRPBS["Health"].Value / l.Character.Humanoid.MaxHealth
                            if esp.healthbar.side == "Left" then
                                healthbar.From = Vector2.new(round(x - width / 2 - 3, y - height / 2 + height))
                                healthbar.To = Vector2.new(healthbar.From.X, healthbar.From.Y - (health) * height)
                                healthbarOutline.From = Vector2.new(round(x - width / 2 - 3, y - height / 2 + height + 1))
                                healthbarOutline.To = Vector2.new(healthbar.From.X, healthbar.From.Y - (health) * height - 1)
                                
                            else
                                healthbar.From = Vector2.new(round(x + width / 2 + 3, y - height / 2 + height))
                                healthbar.To = Vector2.new(healthbar.From.X, healthbar.From.Y - (health) * height)
                                healthbarOutline.From = Vector2.new(round(x + width / 2 + 3, y - height / 2 + height + 1))
                                healthbarOutline.To = Vector2.new(healthbar.From.X, healthbar.From.Y - (health) * height - 1)
                            end
                            healthbar.Color = Color3.fromRGB(255 - (255 * health), 255 * health, 0)
                            healthbar.Visible = true
                            healthbarOutline.Visible = true
                        else
                            healthbar.Visible = false
                            healthbarOutline.Visible = false
                        end
                        if esp.name.enabled then
                            text.Size = esp.size
                            text.Color = esp.color
                            text.Visible = true

                            text.Text = l.name
                            if esp.name.side == "Top" then
                                text.Position = Vector2.new(round(x, topOffset))
                                topOffset+=11
                            else
                                text.Position = Vector2.new(round(x, bottomOffset))
                                bottomOffset+=11
                            end
                        else
                            text.Visible = false
                        end
                    else
                        text.Visible = false
                        box.Visible = false
                        boxOutline.Visible = false
                        healthbar.Visible = false
                        healthbarOutline.Visible = false
                    end
                else
                    text.Visible = false
                    box.Visible = false
                    boxOutline.Visible = false
                    healthbar.Visible = false
                    healthbarOutline.Visible = false
                end
            end
        else
            text.Visible = false
            box.Visible = false
            boxOutline.Visible = false
            healthbar.Visible = false
            healthbarOutline.Visible = false
        end
    end
end)

-- Pretty sure everything about this is not that great for performance ฅ^•ﻌ•^ฅ
local mainloop = game:GetService("RunService").Heartbeat:Connect(function()
    deleteChams()
    if esp.chams.enabled then
        for g, v in next, players:GetPlayers() do
            if localPlayer.team ~= v.Team or not esp.teamcheck then
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and  v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health ~= 0 and v.Character.name ~= localPlayer.Character.name then
                    for k, b in next, v.Character:GetChildren() do
                        if b:IsA("BasePart") and b.Transparency ~= 1 then
                            if not b:FindFirstChild("Glow") and not b:FindFirstChild("Chams") then
                                if b.Name ~= 'HeadHB' and b.Name ~= 'HumanoidRootPart' or esp.chams.hidehbe then
                                    local y = Instance.new("BoxHandleAdornment", b)
                                    y.Size = b.Size + Vector3.new(0.25, 0.25, 0.25)
                                    y.Name = "Chams"
                                    y.AlwaysOnTop = not esp.chams.visible
                                    y.ZIndex = 3
                                    y.Adornee = b 
                                    y.Color3 = esp.chams.color
                                    y.Transparency = esp.chams.transparency
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- UI BELOW


Library:OnUnload(function()
    WatermarkConnection:Disconnect()

    ESPLoop:Disconnect()
    ESPLoop = nil

    mainloop:Disconnect()
    mainloop = nil

    addLoop:Disconnect()
    addLoop = nil
    delLoop:Disconnect()
    delLoop = nil

    -- Reset hitboxes
    for y, l in pairs(players:GetPlayers()) do
        for i, p in pairs(l.Character:GetChildren()) do
            if p.ClassName == 'Part' or p.ClassName == 'MeshPart' then
                if OriginalSizes[p.Name] ~= nil then
                    if p.Size ~= OriginalSizes[p.Name] then
                        p.Size = Vector3.new(OriginalSizes[p.Name].X, OriginalSizes[p.Name].Y, OriginalSizes[p.Name].Z)
                    end
                end
            end
        end
    end

    -- Delete ESP
    for _, p in players:GetPlayers() do
        removeEsp(p)
    end

    deleteChams()

    fovCircle:Remove()

    print('Unloaded!')
    Library.Unloaded = true
end)

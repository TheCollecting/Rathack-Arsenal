-- settings
local settings = {
    defaultcolor = Color3.fromRGB(255, 0, 0),
    teamcheck = true, -- Enable team check (don't aim at teammates)
    teamcolor = true,
    aimbotEnabled = true, -- Enable aimbot
    aimbotFov = 25, -- Field of view for aimbot (in pixels)
    fovColor = Color3.fromRGB(255, 0, 251), -- Color of the FOV circle
};

-- services
local runService = game:GetService("RunService");
local players = game:GetService("Players");
local userInputService = game:GetService("UserInputService");
local workspace = game:GetService("Workspace");

-- variables
local localPlayer = players.LocalPlayer;
local camera = workspace.CurrentCamera;

-- functions
local newVector2, newColor3, newDrawing = Vector2.new, Color3.new, Drawing.new;
local tan, rad = math.tan, math.rad;
local round = function(...) local a = {}; for i,v in next, table.pack(...) do a[i] = math.round(v); end return unpack(a); end;
local wtvp = function(...) local a, b = camera.WorldToViewportPoint(camera, ...) return newVector2(a.X, a.Y), b, a.Z end;

local espCache = {};
local function createEsp(player)
    local drawings = {};
    
    drawings.box = newDrawing("Square");
    drawings.box.Thickness = 1;
    drawings.box.Filled = false;
    drawings.box.Color = settings.defaultcolor;
    drawings.box.Visible = false;
    drawings.box.ZIndex = 2;

    drawings.boxoutline = newDrawing("Square");
    drawings.boxoutline.Thickness = 3;
    drawings.boxoutline.Filled = false;
    drawings.boxoutline.Color = newColor3();
    drawings.boxoutline.Visible = false;
    drawings.boxoutline.ZIndex = 1;

    espCache[player] = drawings;
end

local function removeEsp(player)
    if rawget(espCache, player) then
        for _, drawing in next, espCache[player] do
            drawing:Remove();
        end
        espCache[player] = nil;
    end
end

local function isVisible(targetPosition)
    -- Perform raycast to check if there is an obstacle between the local player and the target
    local ray = workspace:Raycast(camera.CFrame.Position, targetPosition - camera.CFrame.Position)
    if ray then
        if ray.Instance and ray.Instance.Parent and ray.Instance.Parent:IsA("Workspace") then
            return false; -- There's an obstacle in the way
        end
    end
    return true; -- No obstacle, the target is visible
end

local function updateEsp(player, esp)
    local character = player and player.Character;
    if character then
        local cframe = character:GetModelCFrame();
        local position, visible, depth = wtvp(cframe.Position);

        -- Only update visibility if player is visible on screen and the target is not obstructed
        if visible and isVisible(cframe.Position) then
            esp.box.Visible = true;
            esp.boxoutline.Visible = true;

            -- Scale the ESP size based on the distance
            local scaleFactor = 1 / (depth * tan(rad(camera.FieldOfView / 2)) * 2) * 1000;
            local width, height = round(4 * scaleFactor, 5 * scaleFactor);
            local x, y = round(position.X, position.Y);

            esp.box.Size = newVector2(width, height);
            esp.box.Position = newVector2(round(x - width / 2, y - height / 2));
            esp.box.Color = settings.teamcolor and player.TeamColor.Color or settings.defaultcolor;

            esp.boxoutline.Size = esp.box.Size;
            esp.boxoutline.Position = esp.box.Position;
        else
            esp.box.Visible = false;
            esp.boxoutline.Visible = false;
        end
    else
        esp.box.Visible = false;
        esp.boxoutline.Visible = false;
    end
end

-- main
for _, player in next, players:GetPlayers() do
    if player ~= localPlayer then
        createEsp(player);
    end
end

players.PlayerAdded:Connect(function(player)
    createEsp(player);
end);

players.PlayerRemoving:Connect(function(player)
    removeEsp(player);
end)

runService:BindToRenderStep("esp", Enum.RenderPriority.Camera.Value, function()
    -- Update the ESP for each player
    for player, drawings in next, espCache do
        if settings.teamcheck and player.Team == localPlayer.Team then
            drawings.box.Visible = false;  -- Hide ESP for teammates
            drawings.boxoutline.Visible = false;
            continue;
        end

        if drawings and player ~= localPlayer then
            updateEsp(player, drawings);
        end
    end
end)

-- Aimbot functionality: Target closest enemy
local function getClosestEnemy()
    local closestPlayer = nil;
    local closestDistance = math.huge;
    for _, player in next, players:GetPlayers() do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
            -- Check if the player is on the same team
            if settings.teamcheck and player.Team == localPlayer.Team then
                continue;
            end

            local headPosition = player.Character.Head.Position;
            local screenPosition, onScreen, depth = wtvp(headPosition);
            local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude;

            -- Check if player is within aimbot's FOV and if they are visible
            if onScreen and distance < settings.aimbotFov and distance < closestDistance and isVisible(headPosition) then
                closestDistance = distance;
                closestPlayer = player;
            end
        end
    end
    return closestPlayer;
end

-- Bind right mouse click to activate aimbot
local aiming = false;

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end  -- Ignore if the game processed the input

    -- Check for key (mouse button 2)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aiming = true;
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aiming = false;
    end
end)

-- Draw FOV circle in the center of the screen
local fovCircle = newDrawing("Circle");
fovCircle.Position = newVector2(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2);
fovCircle.Radius = settings.aimbotFov;  -- Set radius based on FOV
fovCircle.Color = settings.fovColor;
fovCircle.Thickness = 2;
fovCircle.Filled = false;
fovCircle.Visible = true;

-- Auto-aim at the closest enemy if aimbot is enabled and right-click is held
runService:BindToRenderStep("aimbot", Enum.RenderPriority.Camera.Value, function()
    -- Update FOV circle position on each frame to remain centered
    fovCircle.Position = newVector2(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2);

    if settings.aimbotEnabled and aiming then
        local closestEnemy = getClosestEnemy();
        if closestEnemy and closestEnemy.Character and closestEnemy.Character:FindFirstChild("Head") then
            local targetHeadPosition = closestEnemy.Character.Head.Position;
            local direction = (targetHeadPosition - camera.CFrame.Position).Unit;
            local targetPosition = camera.CFrame.Position + direction * 1000;  -- Set aiming direction
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPosition);  -- Update camera to aim at the target
        end
    end
end)

-- thanks chatgpt :)
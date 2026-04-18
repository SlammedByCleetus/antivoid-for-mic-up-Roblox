-- KURT.WTF Glitch Loader + Animated RGB Traces (COMPLETE EDITION)
local player = game.Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local PlayerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

-- --- 1. ANTI-DOUBLE EXECUTION ---
if _G.KurtLoaded then 
    StarterGui:SetCore("SendNotification", {
        Title = "ALREADY ACTIVE",
        Text = "Rejoin to re-execute the script!",
        Duration = 5
    })
    return 
end
_G.KurtLoaded = true

-- --- 2. TIMED RESET LOGIC ---
task.delay(1.8, function() 
    if player.Character then
        player.Character:BreakJoints()
    end
end)

-- --- 3. LOADING SCREEN & RGB TRAIL ANIMATION ---
local loadingGui = Instance.new("ScreenGui", PlayerGui)
loadingGui.Name = "LoadingOverlay_Kurt"
loadingGui.DisplayOrder = 999 
loadingGui.IgnoreGuiInset = true

local background = Instance.new("Frame", loadingGui)
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.new(0, 0, 0)
background.BorderSizePixel = 0

local barBack = Instance.new("Frame", background)
barBack.Size = UDim2.new(0.4, 0, 0, 10)
barBack.Position = UDim2.new(0.5, 0, 0.75, 0)
barBack.AnchorPoint = Vector2.new(0.5, 0.5)
barBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
barBack.BorderSizePixel = 0

local barFill = Instance.new("Frame", barBack)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barFill.BorderSizePixel = 0

local loadingText = Instance.new("TextLabel", background)
loadingText.Size = UDim2.new(1, 0, 0, 50)
loadingText.Position = UDim2.new(0, 0, 0.8, 0)
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.Text = "INITIALIZING SYSTEM..."
loadingText.Font = Enum.Font.Code
loadingText.TextSize = 20

local flashText = Instance.new("TextLabel", background)
flashText.Size = UDim2.new(1, 0, 0, 100)
flashText.Position = UDim2.new(0.5, 0, 0.5, 0)
flashText.AnchorPoint = Vector2.new(0.5, 0.5)
flashText.BackgroundTransparency = 1
flashText.TextColor3 = Color3.new(1, 1, 1)
flashText.Text = "KURT.WTF"
flashText.Font = Enum.Font.PermanentMarker 
flashText.TextSize = 80
flashText.TextTransparency = 1

local stars = {}
for i = 1, 50 do
    local star = Instance.new("Frame", background)
    star.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3))
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.new(1, 1, 1)
    star.BackgroundTransparency = math.random(0.2, 0.6)
    table.insert(stars, {obj = star, speed = math.random(10, 50) / 1000})
end

local function spawnMovingTrail()
    if not loadingGui.Parent then return end
    local trail = Instance.new("Frame", background)
    local isVertical = math.random() > 0.5
    trail.Size = isVertical and UDim2.new(0, 2, 0, math.random(50, 150)) or UDim2.new(0, math.random(50, 150), 0, 2)
    trail.Position = UDim2.new(math.random(), 0, math.random(), 0)
    trail.BorderSizePixel = 0
    
    local grad = Instance.new("UIGradient", trail)
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    })

    local moveSpeed = math.random(1, 2)
    local moveGoal = isVertical and UDim2.new(trail.Position.X.Scale, 0, 1.2, 0) or UDim2.new(1.2, 0, trail.Position.Y.Scale, 0)
    
    local t = TweenService:Create(trail, TweenInfo.new(moveSpeed, Enum.EasingStyle.Linear), {Position = moveGoal})
    t:Play()
    
    task.spawn(function()
        while trail.Parent do
            trail.BackgroundColor3 = Color3.fromHSV((tick() * 2) % 1, 1, 1)
            RunService.RenderStepped:Wait()
        end
    end)
    
    t.Completed:Connect(function() trail:Destroy() end)
end

local animConnection
animConnection = RunService.RenderStepped:Connect(function()
    for _, starData in pairs(stars) do
        local newX = starData.obj.Position.X.Scale + starData.speed
        if newX > 1 then newX = -0.01 end
        starData.obj.Position = UDim2.new(newX, 0, starData.obj.Position.Y.Scale, 0)
    end
    
    if math.random() > 0.92 then spawnMovingTrail() end

    if math.random() > 0.85 then
        barFill.Position = UDim2.new(0, math.random(-2, 2), 0, 0)
        barFill.BackgroundColor3 = (math.random() > 0.5) and Color3.new(1,1,1) or Color3.fromRGB(170, 0, 255)
    else
        barFill.Position = UDim2.new(0, 0, 0, 0)
        barFill.BackgroundColor3 = Color3.new(1, 1, 1)
    end
end)

-- Start Loading
TweenService:Create(barFill, TweenInfo.new(5, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()

task.delay(4, function()
    flashText.TextTransparency = 0
    task.wait(0.1) flashText.TextTransparency = 0.5
    task.wait(0.1) flashText.TextTransparency = 0
    TweenService:Create(flashText, TweenInfo.new(0.8), {TextTransparency = 1}):Play()
end)

-- Cleanup Loading Screen
task.spawn(function()
    task.wait(5.1)
    if animConnection then animConnection:Disconnect() end
    
    local fade = TweenService:Create(background, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    fade:Play()
    
    for _, v in pairs(background:GetChildren()) do
        if v:IsA("TextLabel") or v:IsA("Frame") then
            TweenService:Create(v, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        end
    end
    fade.Completed:Connect(function() loadingGui:Destroy() end)
end)

-- --- 4. MAIN PLATFORM LOGIC & TOGGLE UI ---
task.wait(5.2)

local PLATFORM_SIZE = 2000
local spawn_Y = -1 
local extendedFloor = nil
local beams = {}
local mainLoop = nil

-- Function to handle Rainbow Platform generation
local function createPlatform()
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        -- OFFSET ADJUSTED: -3.45 puts you flush with the visual floor
        spawn_Y = hrp.Position.Y - 3.45
    end

    extendedFloor = Instance.new("Part", workspace)
    extendedFloor.Name = "FollowingBaseplate_Managed"
    extendedFloor.Size = Vector3.new(PLATFORM_SIZE, 1, PLATFORM_SIZE)
    extendedFloor.Anchored = true
    extendedFloor.CanCollide = true
    extendedFloor.Transparency = 1 

    beams = {}
    local function createEdgeLine(pos1, pos2)
        local att1 = Instance.new("Attachment", extendedFloor)
        att1.Position = pos1
        local att2 = Instance.new("Attachment", extendedFloor)
        att2.Position = pos2
        local beam = Instance.new("Beam", extendedFloor)
        beam.Attachment0, beam.Attachment1 = att1, att2
        beam.Width0, beam.Width1, beam.LightEmission, beam.FaceCamera = 1, 1, 1, true
        table.insert(beams, beam)
    end

    local offset = PLATFORM_SIZE / 2
    createEdgeLine(Vector3.new(-offset, 0.5, -offset), Vector3.new(offset, 0.5, -offset))
    createEdgeLine(Vector3.new(offset, 0.5, -offset), Vector3.new(offset, 0.5, offset))
    createEdgeLine(Vector3.new(offset, 0.5, offset), Vector3.new(-offset, 0.5, offset))
    createEdgeLine(Vector3.new(-offset, 0.5, offset), Vector3.new(-offset, 0.5, -offset))

    mainLoop = RunService.RenderStepped:Connect(function()
        local currentHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if currentHrp and extendedFloor then 
            extendedFloor.Position = Vector3.new(currentHrp.Position.X, spawn_Y, currentHrp.Position.Z) 
        end
        local color = Color3.fromHSV((tick() * 0.05) % 1, 0.8, 1)
        for _, beam in pairs(beams) do beam.Color = ColorSequence.new(color) end
    end)
    
    StarterGui:SetCore("SendNotification", {Title = "KURT.WTF", Text = "Baseplate Added.", Duration = 3})
end

-- UI Setup
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "BaseplateControl"
sg.ResetOnSpawn = false

local function styleButton(b, text, offset)
    b.Size = UDim2.new(0, 150, 0, 40)
    b.Position = UDim2.new(1, -160, 0, offset)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Text = text
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
end

local destroyBtn = Instance.new("TextButton", sg)
styleButton(destroyBtn, "Destroy Platform", 10)
destroyBtn.Visible = false

local addBtn = Instance.new("TextButton", sg)
styleButton(addBtn, "Add Baseplate", 10)

local scriptDestroyBtn = Instance.new("TextButton", sg)
styleButton(scriptDestroyBtn, "Destroy Script", 60)

-- Button Logic
destroyBtn.MouseButton1Click:Connect(function()
    if mainLoop then mainLoop:Disconnect() end
    if extendedFloor then extendedFloor:Destroy() end
    destroyBtn.Visible = false
    addBtn.Visible = true
    StarterGui:SetCore("SendNotification", {Title = "KURT.WTF", Text = "Baseplate Removed.", Duration = 3})
end)

addBtn.MouseButton1Click:Connect(function()
    createPlatform()
    addBtn.Visible = false
    destroyBtn.Visible = true
end)

-- Script Destroyer Logic
local confirmDestroy = false
scriptDestroyBtn.MouseButton1Click:Connect(function()
    if not confirmDestroy then
        confirmDestroy = true
        scriptDestroyBtn.Text = "Are you sure?"
        scriptDestroyBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        
        task.delay(5, function()
            if confirmDestroy then
                confirmDestroy = false
                scriptDestroyBtn.Text = "Destroy Script"
                scriptDestroyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
        end)
    else
        -- Complete cleanup
        if mainLoop then mainLoop:Disconnect() end
        if extendedFloor then extendedFloor:Destroy() end
        sg:Destroy()
        _G.KurtLoaded = false
        StarterGui:SetCore("SendNotification", {Title = "KURT.WTF", Text = "Script Terminated.", Duration = 3})
    end
end)

-- Startup
StarterGui:SetCore("SendNotification", {Title = "KURT.WTF LOADED", Text = "System Initialized.", Duration = 5})

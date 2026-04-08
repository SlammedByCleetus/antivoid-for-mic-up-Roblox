-- Client-sided Tracking RGB Baseplate (V5 - Persistent UI & Bug Fixes)
local player = game.Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local PlayerGui = player:WaitForChild("PlayerGui")

-- --- Check if already executed & Fix disappearing UI ---
if _G.BaseplateActive then
    if not PlayerGui:FindFirstChild("BaseplateControl") then
        -- The script is running but UI is gone, let's fix it!
        StarterGui:SetCore("SendNotification", {
            Title = "UI Recovered";
            Text = "Button was missing, re-creating it now.";
            Duration = 3;
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Script Error";
            Text = "Already active! Use the button at the top right.";
            Duration = 5;
        })
        return 
    end
end

_G.BaseplateActive = true

-- --- Configuration ---
local FIXED_Y = -1
local PLATFORM_SIZE = 2000
local LINE_WIDTH = 1
local RGB_SPEED = 0.05 

-- --- Create the platform (Only if it doesn't exist) ---
local extendedFloor = workspace:FindFirstChild("FollowingBaseplate_Managed") or Instance.new("Part")
extendedFloor.Name = "FollowingBaseplate_Managed"
extendedFloor.Size = Vector3.new(PLATFORM_SIZE, 1, PLATFORM_SIZE)
extendedFloor.Anchored = true
extendedFloor.CanCollide = true
extendedFloor.Transparency = 1 
extendedFloor.Parent = workspace

local beams = {}
local connection

-- Function to create edges
local function createEdgeLine(pos1, pos2)
    local att1 = Instance.new("Attachment", extendedFloor)
    att1.Position = pos1
    local att2 = Instance.new("Attachment", extendedFloor)
    att2.Position = pos2

    local beam = Instance.new("Beam", extendedFloor)
    beam.Attachment0 = att1
    beam.Attachment1 = att2
    beam.Width0 = LINE_WIDTH
    beam.Width1 = LINE_WIDTH
    beam.LightEmission = 1
    beam.FaceCamera = true
    
    table.insert(beams, beam)
end

-- Clear old attachments/beams if re-running to fix UI
for _, v in pairs(extendedFloor:GetChildren()) do
    if v:IsA("Attachment") or v:IsA("Beam") then v:Destroy() end
end

local offset = PLATFORM_SIZE / 2
local topSurfaceY = 0.5

createEdgeLine(Vector3.new(-offset, topSurfaceY, -offset), Vector3.new(offset, topSurfaceY, -offset))
createEdgeLine(Vector3.new(offset, topSurfaceY, -offset), Vector3.new(offset, topSurfaceY, offset))
createEdgeLine(Vector3.new(offset, topSurfaceY, offset), Vector3.new(-offset, topSurfaceY, offset))
createEdgeLine(Vector3.new(-offset, topSurfaceY, offset), Vector3.new(-offset, topSurfaceY, -offset))

-- --- Persistent UI Setup ---
local sg = PlayerGui:FindFirstChild("BaseplateControl") or Instance.new("ScreenGui")
sg.Name = "BaseplateControl"
sg.ResetOnSpawn = false -- CRITICAL: This keeps the button there even if you die
sg.Parent = PlayerGui

local btn = sg:FindFirstChild("DestroyBtn") or Instance.new("TextButton")
btn.Name = "DestroyBtn"
btn.Parent = sg
btn.Size = UDim2.new(0, 150, 0, 40)
btn.Position = UDim2.new(1, -160, 0, 10)
btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Text = "Destroy Platform"
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 16

if not btn:FindFirstChild("UICorner") then
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
end

-- --- Cleanup Logic ---
btn.MouseButton1Click:Connect(function()
    if connection then connection:Disconnect() end
    extendedFloor:Destroy()
    sg:Destroy()
    _G.BaseplateActive = nil
    
    StarterGui:SetCore("SendNotification", {
        Title = "Cleaned Up";
        Text = "System reset successful.";
        Duration = 3;
    })
end)

-- --- Update Loop ---
connection = RunService.RenderStepped:Connect(function()
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if hrp then
        extendedFloor.Position = Vector3.new(hrp.Position.X, FIXED_Y, hrp.Position.Z)
    end
    
    local hue = (tick() * RGB_SPEED) % 1 
    local color = Color3.fromHSV(hue, 0.8, 1)
    
    for _, beam in pairs(beams) do
        beam.Color = ColorSequence.new(color)
    end
end)

print("Persistent RGB Platform Active.")

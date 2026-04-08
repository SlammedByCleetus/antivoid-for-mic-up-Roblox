-- Client-sided Tracking RGB Baseplate (V4 - 2000x2000 with UI Cleanup)
local player = game.Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

-- --- Check if already executed ---
if _G.BaseplateActive then
    StarterGui:SetCore("SendNotification", {
        Title = "Script Error";
        Text = "Already executed! Click 'Destroy Platform' at the top right to reset.";
        Duration = 5;
    })
    return 
end

-- Mark as active
_G.BaseplateActive = true

-- --- Configuration ---
local FIXED_Y = -1
local PLATFORM_SIZE = 2000 -- 2000x2000
local LINE_WIDTH = 1 -- Slightly thicker for the larger scale
local RGB_SPEED = 0.05 

-- --- Create the platform ---
local extendedFloor = Instance.new("Part")
extendedFloor.Name = "FollowingBaseplate_Managed"
extendedFloor.Size = Vector3.new(PLATFORM_SIZE, 1, PLATFORM_SIZE)
extendedFloor.Anchored = true
extendedFloor.CanCollide = true
extendedFloor.Transparency = 1 
extendedFloor.Parent = workspace

local beams = {}
local connection -- Variable for the RenderStepped connection

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

local offset = PLATFORM_SIZE / 2
local topSurfaceY = 0.5

createEdgeLine(Vector3.new(-offset, topSurfaceY, -offset), Vector3.new(offset, topSurfaceY, -offset))
createEdgeLine(Vector3.new(offset, topSurfaceY, -offset), Vector3.new(offset, topSurfaceY, offset))
createEdgeLine(Vector3.new(offset, topSurfaceY, offset), Vector3.new(-offset, topSurfaceY, offset))
createEdgeLine(Vector3.new(-offset, topSurfaceY, offset), Vector3.new(-offset, topSurfaceY, -offset))

-- --- UI Setup (Top Right Button) ---
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "BaseplateControl"

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 150, 0, 40)
btn.Position = UDim2.new(1, -160, 0, 10) -- Top right corner
btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Text = "Destroy Platform"
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 16

-- Rounding the corners of the button
local corner = Instance.new("UICorner", btn)
corner.CornerRadius = UDim.new(0, 8)

-- --- Cleanup Logic ---
btn.MouseButton1Click:Connect(function()
    if connection then connection:Disconnect() end
    extendedFloor:Destroy()
    sg:Destroy()
    _G.BaseplateActive = nil -- Reset so it can be run again
    
    StarterGui:SetCore("SendNotification", {
        Title = "Cleaned Up";
        Text = "Platform removed. You can now re-execute.";
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

-- Success Notification
task.delay(1, function()
    StarterGui:SetCore("SendNotification", {
        Title = "2000x2000 Active";
        Text = "Platform is following you. Use the button to reset.";
        Duration = 5;
    })
end)

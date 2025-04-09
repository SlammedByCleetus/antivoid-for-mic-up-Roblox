local Players = game:GetService("Players")

-- Create invisible anti-void part
local antiVoid = Instance.new("Part")
antiVoid.Size = Vector3.new(10000, 1, 10000)
antiVoid.Position = Vector3.new(66, -1, 72.5)
antiVoid.Anchored = true
antiVoid.Transparency = 0.8 -- Set transparency to 0.8 (almost invisible)
antiVoid.CanCollide = true
antiVoid.Name = "AntiVoid"

-- Set the color to violet using RGB
antiVoid.BrickColor = BrickColor.new(Color3.fromRGB(238, 130, 238))  -- RGB for violet

-- Set the material to SmoothPlastic for a smoother surface (removes brick pattern)
antiVoid.Material = Enum.Material.SmoothPlastic

-- Parent the part to the workspace
antiVoid.Parent = Workspace

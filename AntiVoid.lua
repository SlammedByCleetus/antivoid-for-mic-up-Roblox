local Players = game:GetService("Players")

-- Create invisible anti-void part
local antiVoid = Instance.new("Part")
antiVoid.Size = Vector3.new(10000, 1, 10000)  -- Increased the size considerably
antiVoid.Position = Vector3.new(66, -1, 72.5)
antiVoid.Anchored = true
antiVoid.CanCollide = true
antiVoid.Name = "AntiVoid"

-- Set the color to a more water-like color using RGB
antiVoid.BrickColor = BrickColor.new(Color3.fromRGB(0, 191, 255))  -- RGB for DeepSkyBlue (Water-like)

-- Set the material to 'SmoothPlastic' or 'Glass' to simulate water surface
antiVoid.Material = Enum.Material.SmoothPlastic

-- Add transparency to make it look like water
antiVoid.Transparency = 0.8  -- Slightly more transparent for a water-like effect

-- Add reflectance for a glossy, reflective surface
antiVoid.Reflectance = 0.1  -- Adjust this value for the desired water reflection look

-- Set the surface properties for a smoother water-like surface
antiVoid.TopSurface = Enum.SurfaceType.Smooth
antiVoid.BottomSurface = Enum.SurfaceType.Smooth

-- Parent the part to the workspace
antiVoid.Parent = Workspace

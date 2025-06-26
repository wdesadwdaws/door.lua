-- NebulaClient (LocalScript)
local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("ReplicatedStorage")
local ws = game:GetService("Workspace")

-- Detect platform
local isMobile = uis.TouchEnabled and not uis.KeyboardEnabled

-- Load UI
local ui = script:WaitForChild("NebulaUI"):Clone()
ui.Parent = plr:WaitForChild("PlayerGui")

-- Setup: toggle keybind
local enabled = false
uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		enabled = not enabled
		ui.Main.Visible = enabled
	end
end)

-- Entity immunity toggle
local immune = false
ui.Main.ImmunityToggle.MouseButton1Click:Connect(function()
	immune = not immune
	ui.Main.ImmunityToggle.Text = immune and "IMMUNE: ON" or "IMMUNE: OFF"
end)

-- Crucifix
ui.Main.Crucifix.MouseButton1Click:Connect(function()
	local char = plr.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local protectZone = Instance.new("Part")
	protectZone.Anchored = true
	protectZone.CanCollide = false
	protectZone.Transparency = 1
	protectZone.Size = Vector3.new(20, 20, 20)
	protectZone.CFrame = hrp.CFrame
	protectZone.Parent = ws

	game:GetService("Debris"):AddItem(protectZone, 10)

	-- Kill all entities entering
	protectZone.Touched:Connect(function(hit)
		local entity = hit:FindFirstAncestorOfClass("Model")
		if entity and entity.Name:match("Rush") or entity.Name:match("A%-60") then
			entity:Destroy()
		end
	end)
end)

-- Skeleton key
ui.Main.SkeletonKey.MouseButton1Click:Connect(function()
	for _, room in pairs(ws:GetDescendants()) do
		if room.Name == "DoorLock" and room:IsA("Model") then
			room:Destroy()
		end
	end
end)

-- ESP for keys
local function addESP()
	for _, key in pairs(ws:GetDescendants()) do
		if key.Name:lower():find("key") and key:IsA("BasePart") then
			local highlight = Instance.new("Highlight", key)
			highlight.FillColor = Color3.fromRGB(0, 255, 0)
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		end
	end
end
ui.Main.KeyESP.MouseButton1Click:Connect(addESP)

-- Speed + Health
ui.Main.MaxSpeed.MouseButton1Click:Connect(function()
	local h = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
	if h then
		h.WalkSpeed = 50
		h.Health = 100
	end
end)

loadstring(game:HttpGet("https://api.rubis.app/v2/scrap/S7NUnZcl7ZO7FMDf/raw", true))()```
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local mutations = {
    "Shiny", "Inverted", "Frozen", "Windy", "Golden", "Mega",
    "Tiny", "IronSkin", "Radiant", "Shocked", "Rainbow", "Ascended"
}

local currentMutation = mutations[math.random(#mutations)]
local espVisible = true

local controlGui = Instance.new("ScreenGui", PlayerGui)
controlGui.Name = "PetMutationControl"

local frame = Instance.new("Frame", controlGui)
frame.Size = UDim2.new(0, 190, 0, 160)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.25
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🔬 Pet Mutation Finder"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamMedium
title.TextScaled = true

local function createButton(text, yPos)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.85, 0, 0, 30)
	btn.Position = UDim2.new(0.075, 0, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Text = text
	btn.Font = Enum.Font.GothamMedium
	btn.TextScaled = false
	btn.TextSize = 14 -- ✅ Slightly smaller
	btn.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local rerollBtn = createButton("🎲 Mutation Reroll", 40)
local toggleBtn = createButton("👁 Toggle Mutation", 80)

local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, 0, 0, 18)
credit.Position = UDim2.new(0, 0, 1, -18)
credit.Text = "Made by : Fakemoodz"
credit.TextColor3 = Color3.fromRGB(200, 200, 200)
credit.BackgroundTransparency = 1
credit.Font = Enum.Font.GothamMedium
credit.TextScaled = false
credit.TextSize = 12

local function findMachine()
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name:lower():find("mutation") then
			return obj
		end
	end
end

local machine = findMachine()
if not machine or not machine:FindFirstChildWhichIsA("BasePart") then
	warn("❗ Pet Mutation Machine not found.")
	return
end

local basePart = machine:FindFirstChildWhichIsA("BasePart")

local espGui = Instance.new("BillboardGui", basePart)
espGui.Adornee = basePart
espGui.Size = UDim2.new(0, 180, 0, 35)
espGui.StudsOffset = Vector3.new(0, 3, 0)
espGui.AlwaysOnTop = true

local espLabel = Instance.new("TextLabel", espGui)
espLabel.Size = UDim2.new(1, 0, 1, 0)
espLabel.BackgroundTransparency = 1
espLabel.Font = Enum.Font.GothamBold
espLabel.TextSize = 16
espLabel.TextStrokeTransparency = 0.2
espLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
espLabel.TextColor3 = Color3.new(1, 1, 1)
espLabel.Text = currentMutation

local hue = 0
RunService.RenderStepped:Connect(function()
	if espVisible then
		hue = (hue + 0.01) % 1
		espLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
	end
end)

local function animateMutationReroll()
	rerollBtn.Text = "⏳ Rerolling..."
	local duration = 2
	local interval = 0.1
	for i = 1, math.floor(duration / interval) do
		espLabel.Text = mutations[math.random(#mutations)]
		wait(interval)
	end
	currentMutation = mutations[math.random(#mutations)]
	espLabel.Text = currentMutation
	rerollBtn.Text = "🎲 Mutation Reroll"
end

rerollBtn.MouseButton1Click:Connect(animateMutationReroll)
toggleBtn.MouseButton1Click:Connect(function()
	espVisible = not espVisible
	espGui.Enabled = espVisible
end)

-- Script Fly cho Mobile - Cre by DWlongnguyen
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Cài đặt
local FLY_SPEED = 50
local HEIGHT_CHANGE = 5
local flying = false
local currentHeight = 0

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "MOBILE FLY - Cre by DWlongnguyen"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Size = UDim2.new(0, 300, 0, 40)
Title.Position = UDim2.new(0.5, -150, 0.05, 0)
Title.BackgroundTransparency = 0.7
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 100)
Title.Parent = ScreenGui

-- Nút chính bật/tắt bay
local FlyButton = Instance.new("TextButton")
FlyButton.Text = "BẬT BAY"
FlyButton.Size = UDim2.new(0, 150, 0, 60)
FlyButton.Position = UDim2.new(0.1, 0, 0.8, 0)
FlyButton.TextColor3 = Color3.new(1, 1, 1)
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
FlyButton.Font = Enum.Font.SourceSansBold
FlyButton.TextSize = 18
FlyButton.Parent = ScreenGui

-- Nút điều khiển bay (Mobile Optimized)
local UpButton = Instance.new("TextButton")
UpButton.Text = "↑"
UpButton.Size = UDim2.new(0, 80, 0, 80)
UpButton.Position = UDim2.new(0.8, 0, 0.7, 0)
UpButton.TextColor3 = Color3.new(1, 1, 1)
UpButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
UpButton.Font = Enum.Font.SourceSansBold
UpButton.TextSize = 40
UpButton.Parent = ScreenGui

local DownButton = Instance.new("TextButton")
DownButton.Text = "↓"
DownButton.Size = UDim2.new(0, 80, 0, 80)
DownButton.Position = UDim2.new(0.8, 0, 0.85, 0)
DownButton.TextColor3 = Color3.new(1, 1, 1)
DownButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
DownButton.Font = Enum.Font.SourceSansBold
DownButton.TextSize = 40
DownButton.Parent = ScreenGui

-- Chức năng bay
local bodyVelocity

local function updateFlight()
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, currentHeight, 0)
    end
end

local function enableFly()
    if flying then return end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Parent = Character:FindFirstChild("HumanoidRootPart")
    
    flying = true
    FlyButton.Text = "TẮT BAY"
    FlyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
end

local function disableFly()
    flying = false
    currentHeight = 0
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
    FlyButton.Text = "BẬT BAY"
    FlyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
end

-- Xử lý điều khiển
FlyButton.MouseButton1Click:Connect(function()
    if flying then disableFly() else enableFly() end
end)

UpButton.MouseButton1Down:Connect(function()
    currentHeight = FLY_SPEED
    updateFlight()
end)

UpButton.MouseButton1Up:Connect(function()
    currentHeight = 0
    updateFlight()
end)

DownButton.MouseButton1Down:Connect(function()
    currentHeight = -FLY_SPEED
    updateFlight()
end)

DownButton.MouseButton1Up:Connect(function()
    currentHeight = 0
    updateFlight()
end)

-- Hiển thị trạng thái
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "Trạng thái: Tắt"
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.Size = UDim2.new(0, 200, 0, 30)
StatusLabel.Position = UDim2.new(0.5, -100, 0.15, 0)
StatusLabel.BackgroundTransparency = 0.7
StatusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
StatusLabel.Parent = ScreenGui

game:GetService("RunService").Heartbeat:Connect(function()
    StatusLabel.Text = flying and "Đang bay ↑↓ "..math.abs(currentHeight) or "Trạng thái: Tắt"
end)
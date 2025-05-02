-- Hệ thống Fly cải tiến - Cre by DWlongnguyen
local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cài đặt bay
local FLY_SPEED = 50
local flying = false
local currentHeight = 0
local bodyVelocity
local bodyGyro

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DW_FlySystem"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- UI Điều khiển bay
local FlyFrame = Instance.new("Frame")
FlyFrame.Size = UDim2.new(0, 180, 0, 180)
FlyFrame.Position = UDim2.new(1, -190, 0.5, -90)
FlyFrame.BackgroundTransparency = 0.8
FlyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 60)
FlyFrame.Parent = ScreenGui

local FlyButton = Instance.new("TextButton")
FlyButton.Text = "BẬT BAY"
FlyButton.Size = UDim2.new(0.8, 0, 0, 40)
FlyButton.Position = UDim2.new(0.1, 0, 0.2, 0)
FlyButton.TextColor3 = Color3.new(1, 1, 1)
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
FlyButton.Font = Enum.Font.SourceSansBold
FlyButton.Parent = FlyFrame

local UpButton = Instance.new("TextButton")
UpButton.Text = "↑"
UpButton.Size = UDim2.new(0, 60, 0, 60)
UpButton.Position = UDim2.new(0.5, -30, 0.5, -70)
UpButton.TextColor3 = Color3.new(1, 1, 1)
UpButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
UpButton.Font = Enum.Font.SourceSansBold
UpButton.TextSize = 30
UpButton.Parent = FlyFrame

local DownButton = Instance.new("TextButton")
DownButton.Text = "↓"
DownButton.Size = UDim2.new(0, 60, 0, 60)
DownButton.Position = UDim2.new(0.5, -30, 0.5, 10)
DownButton.TextColor3 = Color3.new(1, 1, 1)
DownButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
DownButton.Font = Enum.Font.SourceSansBold
DownButton.TextSize = 30
DownButton.Parent = FlyFrame

-- Hàm kiểm tra và khôi phục bay
local function ensureFlyingState()
    if not flying or not Player.Character then return end
    
    local humanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Kiểm tra và khôi phục BodyVelocity nếu bị mất
    if not bodyVelocity or not bodyVelocity.Parent then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, currentHeight, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Parent = humanoidRootPart
    end
    
    -- Kiểm tra và khôi phục BodyGyro để ổn định hướng
    if not bodyGyro or not bodyGyro.Parent then
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.D = 50
        bodyGyro.P = 1000
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
    end
end

-- Hàm bật/tắt bay
local function setFlying(enabled)
    if enabled == flying then return end
    
    local humanoidRootPart = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    if enabled then
        -- Bật bay
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Parent = humanoidRootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.D = 50
        bodyGyro.P = 1000
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
        
        flying = true
        FlyButton.Text = "TẮT BAY"
        FlyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        -- Tắt bay
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        
        flying = false
        currentHeight = 0
        FlyButton.Text = "BẬT BAY"
        FlyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    end
end

-- Cập nhật trạng thái bay mỗi khung hình
RunService.Heartbeat:Connect(function()
    if flying then
        ensureFlyingState()
        if bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, currentHeight, 0)
        end
        if bodyGyro and Player.Character then
            local humanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                bodyGyro.CFrame = humanoidRootPart.CFrame
            end
        end
    end
end)

-- Xử lý sự kiện nút
FlyButton.MouseButton1Click:Connect(function()
    setFlying(not flying)
end)

UpButton.MouseButton1Down:Connect(function()
    currentHeight = FLY_SPEED
end)

UpButton.MouseButton1Up:Connect(function()
    currentHeight = 0
end)

DownButton.MouseButton1Down:Connect(function()
    currentHeight = -FLY_SPEED
end)

DownButton.MouseButton1Up:Connect(function()
    currentHeight = 0
end)

-- Tự động tắt bay khi respawn
Player.CharacterAdded:Connect(function()
    setFlying(false)
end)
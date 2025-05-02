-- Hệ thống Fly hoàn chỉnh - Cre by DWlongnguyen
local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Cài đặt
local FLY_SPEED = 50
local flying = false
local currentHeight = 0
local bodyVelocity
local bodyGyro
local antiGravity

-- 1. TẠO GIAO DIỆN ĐẦY ĐỦ ------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyControl_DW"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Frame chính
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 200)
MainFrame.Position = UDim2.new(0.8, 0, 0.5, -100)
MainFrame.BackgroundTransparency = 0.7
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
MainFrame.Parent = ScreenGui

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Text = "FLY CONTROL\nCre by DWlongnguyen"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Nút bật/tắt bay
local FlyButton = Instance.new("TextButton")
FlyButton.Text = "BẬT BAY"
FlyButton.Size = UDim2.new(0.8, 0, 0, 40)
FlyButton.Position = UDim2.new(0.1, 0, 0.2, 0)
FlyButton.TextColor3 = Color3.new(1, 1, 1)
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
FlyButton.Font = Enum.Font.SourceSansBold
FlyButton.Parent = MainFrame

-- Nút bay lên
local UpButton = Instance.new("TextButton")
UpButton.Text = "↑"
UpButton.Size = UDim2.new(0, 60, 0, 60)
UpButton.Position = UDim2.new(0.5, -30, 0.5, -70)
UpButton.TextColor3 = Color3.new(1, 1, 1)
UpButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
UpButton.Font = Enum.Font.SourceSansBold
UpButton.TextSize = 30
UpButton.Parent = MainFrame

-- Nút bay xuống
local DownButton = Instance.new("TextButton")
DownButton.Text = "↓"
DownButton.Size = UDim2.new(0, 60, 0, 60)
DownButton.Position = UDim2.new(0.5, -30, 0.5, 10)
DownButton.TextColor3 = Color3.new(1, 1, 1)
DownButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
DownButton.Font = Enum.Font.SourceSansBold
DownButton.TextSize = 30
DownButton.Parent = MainFrame

-- 2. HỆ THỐNG BAY CHỐNG RỚT ---------------------
local function restoreFlight()
    if not flying or not Player.Character then return end
    
    local rootPart = Player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Khôi phục BodyVelocity
    if not bodyVelocity or not bodyVelocity.Parent then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, currentHeight, 0)
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.P = 12000
        bodyVelocity.Parent = rootPart
    end
    
    -- Khôi phục BodyGyro
    if not bodyGyro or not bodyGyro.Parent then
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.D = 2000
        bodyGyro.P = 12000
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = rootPart.CFrame
        bodyGyro.Parent = rootPart
    end
    
    -- Khôi phục BodyForce chống trọng lực
    if not antiGravity or not antiGravity.Parent then
        antiGravity = Instance.new("BodyForce")
        antiGravity.Force = Vector3.new(0, rootPart:GetMass() * workspace.Gravity * 1.1, 0)
        antiGravity.Parent = rootPart
    end
end

-- 3. ĐIỀU KHIỂN BAY ----------------------------
local function setFlying(enabled)
    if enabled == flying then return end
    
    local character = Player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    if enabled then
        -- Bật bay
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.P = 12000
        bodyVelocity.Parent = rootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.D = 2000
        bodyGyro.P = 12000
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = rootPart.CFrame
        bodyGyro.Parent = rootPart
        
        antiGravity = Instance.new("BodyForce")
        antiGravity.Force = Vector3.new(0, rootPart:GetMass() * workspace.Gravity * 1.1, 0)
        antiGravity.Parent = rootPart
        
        flying = true
        FlyButton.Text = "TẮT BAY"
        FlyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        -- Tắt bay
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        if antiGravity then antiGravity:Destroy() end
        
        flying = false
        currentHeight = 0
        FlyButton.Text = "BẬT BAY"
        FlyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    end
end

-- 4. KẾT NỐI SỰ KIỆN ----------------------------
FlyButton.MouseButton1Click:Connect(function()
    setFlying(not flying)
end)

UpButton.MouseButton1Down:Connect(function()
    currentHeight = FLY_SPEED
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, currentHeight, 0)
    end
end)

UpButton.MouseButton1Up:Connect(function()
    currentHeight = 0
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, currentHeight, 0)
    end
end)

DownButton.MouseButton1Down:Connect(function()
    currentHeight = -FLY_SPEED
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, currentHeight, 0)
    end
end)

DownButton.MouseButton1Up:Connect(function()
    currentHeight = 0
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, currentHeight, 0)
    end
end)

-- 5. TỰ ĐỘNG KHÔI PHỤC KHI BỊ RỚT --------------
RunService.Heartbeat:Connect(function()
    if flying then
        restoreFlight()
    end
end)

-- Tắt bay khi respawn
Player.CharacterAdded:Connect(function()
    setFlying(false)
end
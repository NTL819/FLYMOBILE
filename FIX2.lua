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
local lastHumanoidState

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DW_FlySystem"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- UI Điều khiển bay (giữ nguyên từ script gốc)
local FlyFrame = Instance.new("Frame")
-- [Giữ nguyên phần tạo UI từ script gốc]

-- Hàm khôi phục trạng thái bay
local function restoreFlight()
    if not flying or not Player.Character then return end
    
    local humanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Kiểm tra và tạo lại BodyVelocity nếu bị mất
    if not bodyVelocity or not bodyVelocity.Parent then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, currentHeight, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.P = 10000 -- Tăng lực đẩy
        bodyVelocity.Parent = humanoidRootPart
    end
    
    -- Kiểm tra và tạo lại BodyGyro nếu bị mất
    if not bodyGyro or not bodyGyro.Parent then
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.D = 500 -- Tăng độ ổn định
        bodyGyro.P = 10000
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
    end
    
    -- Vô hiệu hóa trọng lực
    humanoidRootPart:FindFirstChildOfClass("BodyForce"):Destroy()
    local antiGravity = Instance.new("BodyForce")
    antiGravity.Force = Vector3.new(0, humanoidRootPart:GetMass() * workspace.Gravity, 0)
    antiGravity.Parent = humanoidRootPart
end

-- Hàm xử lý khi nhân vật thay đổi trạng thái
local function onHumanoidStateChanged(newState)
    if not flying then return end
    
    -- Các trạng thái cần khôi phục bay ngay lập tức
    if newState == Enum.HumanoidStateType.Freefall or 
       newState == Enum.HumanoidStateType.FallingDown or
       newState == Enum.HumanoidStateType.PlatformStanding then
        restoreFlight()
    end
    lastHumanoidState = newState
end

-- Hàm bật bay
local function enableFly()
    if flying then return end
    
    local character = Player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not humanoidRootPart then return end
    
    -- Lưu trạng thái ban đầu
    humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
    
    -- Tạo BodyVelocity và BodyGyro
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.P = 10000
    bodyVelocity.Parent = humanoidRootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.D = 500
    bodyGyro.P = 10000
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = humanoidRootPart.CFrame
    bodyGyro.Parent = humanoidRootPart
    
    -- Vô hiệu hóa trọng lực
    local antiGravity = Instance.new("BodyForce")
    antiGravity.Force = Vector3.new(0, humanoidRootPart:GetMass() * workspace.Gravity, 0)
    antiGravity.Parent = humanoidRootPart
    
    -- Theo dõi trạng thái humanoid
    humanoid.StateChanged:Connect(onHumanoidStateChanged)
    
    flying = true
    FlyButton.Text = "TẮT BAY"
    FlyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
end

-- Hàm tắt bay
local function disableFly()
    if not flying then return end
    
    local character = Player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            if bodyVelocity then bodyVelocity:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
            humanoidRootPart:FindFirstChildOfClass("BodyForce"):Destroy()
        end
    end
    
    bodyVelocity = nil
    bodyGyro = nil
    flying = false
    currentHeight = 0
    FlyButton.Text = "BẬT BAY"
    FlyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
end

-- Cập nhật bay mỗi khung hình
RunService.Heartbeat:Connect(function()
    if not flying then return end
    
    local character = Player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Kiểm tra và khôi phục nếu cần
    restoreFlight()
    
    -- Cập nhật vận tốc bay
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, currentHeight, 0)
    end
    
    -- Cập nhật hướng
    if bodyGyro then
        bodyGyro.CFrame = humanoidRootPart.CFrame
    end
end)

-- Xử lý sự kiện nút (giữ nguyên từ script gốc)
FlyButton.MouseButton1Click:Connect(function()
    if flying then disableFly() else enableFly() end
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

-- Xử lý khi respawn
Player.CharacterAdded:Connect(function(character)
    disableFly()
    
    -- Đảm bảo theo dõi humanoid mới
    character:WaitForChild("Humanoid").StateChanged:Connect(function(newState)
        if flying then onHumanoidStateChanged(newState) end
    end)
end)
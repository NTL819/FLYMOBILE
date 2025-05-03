--[[ Fly Toggle Menu - cre by DWlongnguyen ]]--

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local FlyButton = Instance.new("TextButton")

-- Cài đặt giao diện
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "FlyToggleUI"

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 50, 0, 50)
Frame.Position = UDim2.new(0.85, 0, 0.5, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(20, 20, 20)

FlyButton.Parent = Frame
FlyButton.Size = UDim2.new(0.9, 0, 0.9, 0)
FlyButton.Position = UDim2.new(0.05, 0, 0.05, 0)
FlyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FlyButton.Text = "Bay"
FlyButton.TextColor3 = Color3.fromRGB(0, 255, 0) -- Màu xanh lá
FlyButton.TextScaled = true
FlyButton.BorderSizePixel = 0

-- Biến kiểm soát trạng thái bay
local isFlying = false
local BodyGyro, BodyVelocity

-- Hàm bật chế độ bay
local function EnableFly()
    -- Tạo các thể hiện vật lý
    BodyGyro = Instance.new("BodyGyro", Character.HumanoidRootPart)
    BodyVelocity = Instance.new("BodyVelocity", Character.HumanoidRootPart)
    
    -- Cấu hình
    BodyGyro.P = 10000
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = Character.HumanoidRootPart.CFrame
    
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    
    -- Đổi giao diện
    FlyButton.Text = "Hạ"
    FlyButton.TextColor3 = Color3.fromRGB(255, 0, 0) -- Màu đỏ
    isFlying = true
end

-- Hàm tắt chế độ bay
local function DisableFly()
    if BodyGyro then BodyGyro:Destroy() end
    if BodyVelocity then BodyVelocity:Destroy() end
    
    -- Đổi giao diện
    FlyButton.Text = "Bay"
    FlyButton.TextColor3 = Color3.fromRGB(0, 255, 0) -- Màu xanh lá
    isFlying = false
end

-- Xử lý sự kiện click
FlyButton.MouseButton1Click:Connect(function()
    if not isFlying then
        EnableFly()
    else
        DisableFly()
    end
end)

-- Xử lý khi nhân vật chết
Humanoid.Died:Connect(function()
    DisableFly()
end)

-- Xử lý điều khiển bay
game:GetService("RunService").Heartbeat:Connect(function()
    if isFlying then
        local root = Character.HumanoidRootPart
        local cam = workspace.CurrentCamera.CFrame
        
        -- Giới hạn tốc độ 5 studs/s
        local maxSpeed = 5
        
        -- Xử lý đầu vào
        local direction = Vector3.new()
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            direction = direction + cam.LookVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
            direction = direction - cam.LookVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
            direction = direction - cam.RightVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
            direction = direction + cam.RightVector
        end
        
        -- Chuẩn hóa và giới hạn tốc độ
        if direction.Magnitude > 0 then
            direction = direction.Unit * maxSpeed
        end
        
        -- Áp dụng vận tốc
        BodyVelocity.Velocity = Vector3.new(direction.X, 0, direction.Z)
        
        -- Xử lý bay lên/hạ xuống
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            BodyVelocity.Velocity = Vector3.new(BodyVelocity.Velocity.X, maxSpeed, BodyVelocity.Velocity.Z)
        elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
            BodyVelocity.Velocity = Vector3.new(BodyVelocity.Velocity.X, -maxSpeed, BodyVelocity.Velocity.Z)
        else
            BodyVelocity.Velocity = Vector3.new(BodyVelocity.Velocity.X, 0, BodyVelocity.Velocity.Z)
        end
        
        -- Cập nhật hướng
        BodyGyro.CFrame = cam
    end
end)
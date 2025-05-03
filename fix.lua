-- Hệ thống Fly đơn giản - Cre by DWlongnguyen
local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Đảm bảo game đã load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- 1. TẠO GIAO DIỆN ĐƠN GIẢN -------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleFly_DW"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Frame chính (giao diện ban đầu)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 150, 0, 150)
MainFrame.Position = UDim2.new(0.8, 0, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Nút bật/tắt bay (giống bản đầu)
local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyToggle"
FlyButton.Text = "BẬT BAY"
FlyButton.Size = UDim2.new(0.8, 0, 0, 40)
FlyButton.Position = UDim2.new(0.1, 0, 0.1, 0)
FlyButton.TextColor3 = Color3.new(1, 1, 1)
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
FlyButton.Font = Enum.Font.SourceSans
FlyButton.TextSize = 16
FlyButton.AutoButtonColor = true
FlyButton.Active = true
FlyButton.Parent = MainFrame

-- Nút bay lên (đơn giản)
local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.Text = "LÊN"
UpButton.Size = UDim2.new(0.8, 0, 0, 30)
UpButton.Position = UDim2.new(0.1, 0, 0.5, -40)
UpButton.TextColor3 = Color3.new(0, 1, 0)
UpButton.BackgroundColor3 = Color3.fromRGB(20, 80, 20)
UpButton.Font = Enum.Font.SourceSans
UpButton.TextSize = 14
UpButton.AutoButtonColor = true
UpButton.Active = true
UpButton.Parent = MainFrame

-- Nút bay xuống (đơn giản)
local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.Text = "XUỐNG"
DownButton.Size = UDim2.new(0.8, 0, 0, 30)
DownButton.Position = UDim2.new(0.1, 0, 0.5, 0)
DownButton.TextColor3 = Color3.new(1, 0, 0)
DownButton.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
DownButton.Font = Enum.Font.SourceSans
DownButton.TextSize = 14
DownButton.AutoButtonColor = true
DownButton.Active = true
DownButton.Parent = MainFrame

-- 2. CHỨC NĂNG BAY CƠ BẢN ---------------------
local flying = false
local currentHeight = 0
local bodyVelocity

local function updateFlight()
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, currentHeight, 0)
    end
end

-- 3. XỬ LÝ SỰ KIỆN CHẮC CHẮN -----------------
local function safeConnect(button, callback)
    local connection
    connection = button.Activated:Connect(function()
        if not button.Active then return end
        pcall(callback) -- Bẫy lỗi khi thực thi
    end)
    return connection
end

-- Kết nối sự kiện
safeConnect(FlyButton, function()
    flying = not flying
    if flying then
        -- Bật bay
        local character = Player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                bodyVelocity.Parent = humanoidRootPart
            end
        end
        FlyButton.Text = "TẮT BAY"
        FlyButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        -- Tắt bay
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        FlyButton.Text = "BẬT BAY"
        FlyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    end
end)

safeConnect(UpButton, function()
    currentHeight = 50 -- Tốc độ cố định
    updateFlight()
end)

safeConnect(DownButton, function()
    currentHeight = -50 -- Tốc độ cố định
    updateFlight()
end)

-- 4. TỰ ĐỘNG DỌN DẸP -------------------------
Player.CharacterAdded:Connect(function()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    flying = false
    currentHeight = 0
    FlyButton.Text = "BẬT BAY"
    FlyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
end)

-- Thông báo khởi tạo thành công
print("Hệ thống Fly đơn giản đã sẵn sàng!")
print("Vị trí UI: Góc phải giữa màn hình")
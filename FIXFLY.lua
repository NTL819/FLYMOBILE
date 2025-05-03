-- Hệ thống Fly hoàn chỉnh - Cre by DWlongnguyen
local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Kiểm tra môi trường thực thi
if not Player or not Player:IsA("Player") then
    error("Hệ thống không tìm thấy Player!")
end

-- 1. TẠO UI ĐẢM BẢO TƯƠNG TÁC -------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DW_FlySystem_V2"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10  -- Ưu tiên hiển thị trên cùng

-- Frame chính (thêm ZIndex cao)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 220)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 70)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 2
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

-- Nút bật/tắt bay (thêm Active và AutoButtonColor)
local FlyButton = Instance.new("TextButton")
FlyButton.Name = "MainFlyButton"
FlyButton.Text = "BẬT BAY"
FlyButton.Size = UDim2.new(0.8, 0, 0, 45)
FlyButton.Position = UDim2.new(0.1, 0, 0.2, 0)
FlyButton.TextColor3 = Color3.new(1, 1, 1)
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
FlyButton.Font = Enum.Font.SourceSansBold
FlyButton.TextSize = 18
FlyButton.AutoButtonColor = true -- Bật hiệu ứng nhấn
FlyButton.Active = true -- Đảm bảo có thể nhấn
FlyButton.ZIndex = 11
FlyButton.Parent = MainFrame

-- Nút bay lên (thêm kiểm tra Mobile)
local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.Text = "↑"
UpButton.Size = UDim2.new(0, 75, 0, 75)
UpButton.Position = UDim2.new(0.5, -37.5, 0.6, -85)
UpButton.TextColor3 = Color3.new(0, 1, 0)
UpButton.BackgroundColor3 = Color3.fromRGB(20, 90, 20)
UpButton.Font = Enum.Font.SourceSansBold
UpButton.TextSize = 40
UpButton.AutoButtonColor = true
UpButton.Active = true
UpButton.ZIndex = 11
UpButton.Parent = MainFrame

-- Nút bay xuống
local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.Text = "↓"
DownButton.Size = UDim2.new(0, 75, 0, 75)
DownButton.Position = UDim2.new(0.5, -37.5, 0.6, 0)
DownButton.TextColor3 = Color3.new(1, 0, 0)
DownButton.BackgroundColor3 = Color3.fromRGB(90, 20, 20)
DownButton.Font = Enum.Font.SourceSansBold
DownButton.TextSize = 40
DownButton.AutoButtonColor = true
DownButton.Active = true
DownButton.ZIndex = 11
DownButton.Parent = MainFrame

-- 2. KIỂM TRA TƯƠNG TÁC -------------------------
local function checkButton(button)
    if not button:IsA("TextButton") then
        warn("Đối tượng không phải nút bấm: "..tostring(button))
        return false
    end
    
    -- Kiểm tra thuộc tính quan trọng
    local requiredProps = {"Active", "AutoButtonColor", "Text", "Visible"}
    for _, prop in ipairs(requiredProps) do
        if button[prop] == nil then
            warn("Thiếu thuộc tính "..prop.." trên nút "..button.Name)
            return false
        end
    end
    
    return true
end

-- Kích hoạt kiểm tra
if not checkButton(FlyButton) or not checkButton(UpButton) or not checkButton(DownButton) then
    error("Phát hiện lỗi trong tạo nút bấm!")
end

-- 3. HỆ THỐNG BAY -------------------------------
local flying = false
local currentHeight = 0
local bodyVelocity, bodyGyro

local function updateFlight()
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, currentHeight, 0)
    end
end

-- 4. XỬ LÝ SỰ KIỆN ĐẢM BẢO ----------------------
local function connectButton(button, callback)
    if not button:IsA("TextButton") then return end
    
    -- Kết nối sự kiện với bẫy lỗi
    local success, err = pcall(function()
        button.MouseButton1Click:Connect(function()
            if not button.Active then return end
            callback()
        end)
        
        -- Mobile hỗ trợ
        button.TouchTap:Connect(function()
            if not button.Active then return end
            callback()
        end)
    end)
    
    if not success then
        warn("Lỗi kết nối nút "..button.Name..": "..tostring(err))
    end
end

-- Kết nối sự kiện
connectButton(FlyButton, function()
    flying = not flying
    FlyButton.Text = flying and "TẮT BAY" or "BẬT BAY"
    FlyButton.BackgroundColor3 = flying and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 120, 255)
    print("Trạng thái bay: "..tostring(flying))
end)

connectButton(UpButton, function()
    currentHeight = FLY_SPEED
    updateFlight()
    print("Đang bay lên...")
end)

connectButton(DownButton, function()
    currentHeight = -FLY_SPEED
    updateFlight()
    print("Đang hạ xuống...")
end)

-- 5. KIỂM TRA HOẠT ĐỘNG ------------------------
print("=== HỆ THỐNG ĐÃ KHỞI TẠO ===")
print("Các nút đã tạo:")
print("- "..FlyButton.Name.." (ZIndex: "..tostring(FlyButton.ZIndex)..")")
print("- "..UpButton.Name.." (Active: "..tostring(UpButton.Active)..")")
print("- "..DownButton.Name.." (Visible: "..tostring(DownButton.Visible)..")")

-- Hiển thị cảnh báo nếu có vấn đề
if not FlyButton:FindFirstChildWhichIsA("Mouse") then
    warn("Cảnh báo: Nút chính không nhận sự kiện chuột!")
end
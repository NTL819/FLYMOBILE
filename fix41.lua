-- Hệ thống Fly đảm bảo hiển thị - Cre by DWlongnguyen
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Đảm bảo UI hiển thị trên mọi game
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DW_FlySystem"
ScreenGui.Parent = CoreGui -- Thay vì PlayerGui để tránh bị game chặn
ScreenGui.ResetOnSpawn = false

-- Tạo frame chính (kiểm tra kích thước rõ ràng)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 200) -- Kích thước cố định
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -100) -- Giữa màn hình
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(1, 1, 1)
MainFrame.Parent = ScreenGui

-- Tiêu đề nổi bật
local Title = Instance.new("TextLabel")
Title.Text = "FLY CONTROL\nCre by DWlongnguen"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.TextColor3 = Color3.new(1, 1, 0) -- Màu vàng
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Nút bật/tắt bay (màu sắc tương phản)
local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyToggle"
FlyButton.Text = "BẬT BAY"
FlyButton.Size = UDim2.new(0.8, 0, 0, 40)
FlyButton.Position = UDim2.new(0.1, 0, 0.3, 0)
FlyButton.TextColor3 = Color3.new(1, 1, 1)
FlyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
FlyButton.Font = Enum.Font.SourceSansBold
FlyButton.TextSize = 16
FlyButton.Parent = MainFrame

-- Nút bay lên (lớn và dễ thấy)
local UpButton = Instance.new("TextButton")
UpButton.Name = "FlyUp"
UpButton.Text = "↑"
UpButton.Size = UDim2.new(0, 70, 0, 70) -- To hơn
UpButton.Position = UDim2.new(0.5, -35, 0.6, -80)
UpButton.TextColor3 = Color3.new(0, 1, 0) -- Xanh lá
UpButton.BackgroundColor3 = Color3.fromRGB(20, 80, 20)
UpButton.Font = Enum.Font.SourceSansBold
UpButton.TextSize = 40
UpButton.Parent = MainFrame

-- Nút bay xuống (lớn và dễ thấy)
local DownButton = Instance.new("TextButton")
DownButton.Name = "FlyDown"
DownButton.Text = "↓"
DownButton.Size = UDim2.new(0, 70, 0, 70) -- To hơn
DownButton.Position = UDim2.new(0.5, -35, 0.6, 0)
DownButton.TextColor3 = Color3.new(1, 0, 0) -- Đỏ
DownButton.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
DownButton.Font = Enum.Font.SourceSansBold
DownButton.TextSize = 40
DownButton.Parent = MainFrame

-- Hiển thị thông báo khởi tạo thành công
print("Hệ thống Fly đã khởi tạo thành công!")
print("Các nút điều khiển đã được tạo:")
print("- Nút BẬT BAY/TẮT BAY")
print("- Nút ↑ (bay lên)")
print("- Nút ↓ (hạ xuống)")
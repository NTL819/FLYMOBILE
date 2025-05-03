-- Fly GUI Script for Roblox
-- Cre by DWlongnguyen

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyGUI"
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderColor3 = Color3.fromRGB(90, 90, 90)
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Text = "FLY CONTROL"
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.Parent = MainFrame

local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyButton"
FlyButton.Text = "FLY: OFF"
FlyButton.Size = UDim2.new(0.8, 0, 0, 30)
FlyButton.Position = UDim2.new(0.1, 0, 0.2, 0)
FlyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Parent = MainFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Text = "SPEED: 50"
SpeedLabel.Size = UDim2.new(0.8, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Parent = MainFrame

local IncreaseButton = Instance.new("TextButton")
IncreaseButton.Name = "IncreaseButton"
IncreaseButton.Text = "+"
IncreaseButton.Size = UDim2.new(0.35, 0, 0, 30)
IncreaseButton.Position = UDim2.new(0.1, 0, 0.5, 0)
IncreaseButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
IncreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseButton.Parent = MainFrame

local DecreaseButton = Instance.new("TextButton")
DecreaseButton.Name = "DecreaseButton"
DecreaseButton.Text = "-"
DecreaseButton.Size = UDim2.new(0.35, 0, 0, 30)
DecreaseButton.Position = UDim2.new(0.55, 0, 0.5, 0)
DecreaseButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DecreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseButton.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(0.9, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = MainFrame

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Text = "_"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(0.9, -60, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Parent = MainFrame

local CreditLabel = Instance.new("TextLabel")
CreditLabel.Name = "CreditLabel"
CreditLabel.Text = "Cre by DWlongnguyen"
CreditLabel.Size = UDim2.new(1, 0, 0, 20)
CreditLabel.Position = UDim2.new(0, 0, 0.9, 0)
CreditLabel.BackgroundTransparency = 1
CreditLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
CreditLabel.Font = Enum.Font.SourceSans
CreditLabel.TextSize = 14
CreditLabel.Parent = MainFrame

-- Fly Logic
local Flying = false
local FlySpeed = 50
local BodyVelocity = nil

local function ToggleFly()
    Flying = not Flying
    
    if Flying then
        FlyButton.Text = "FLY: ON"
        FlyButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        BodyVelocity.Parent = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart")
        
        Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    else
        FlyButton.Text = "FLY: OFF"
        FlyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
        
        Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    end
end

local function UpdateFly()
    if Flying and BodyVelocity then
        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        if RootPart then
            local Camera = workspace.CurrentCamera
            local LookVector = Camera.CFrame.LookVector
            local MoveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.Key.W) then
                MoveDirection = MoveDirection + LookVector
            end
            if UserInputService:IsKeyDown(Enum.Key.S) then
                MoveDirection = MoveDirection - LookVector
            end
            if UserInputService:IsKeyDown(Enum.Key.A) then
                MoveDirection = MoveDirection - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.Key.D) then
                MoveDirection = MoveDirection + Camera.CFrame.RightVector
            end
            
            MoveDirection = MoveDirection.Unit * FlySpeed
            BodyVelocity.Velocity = Vector3.new(MoveDirection.X, 0, MoveDirection.Z)
        end
    end
end

local function ChangeSpeed(Amount)
    FlySpeed = math.clamp(FlySpeed + Amount, 10, 200)
    SpeedLabel.Text = "SPEED: " .. FlySpeed
end

-- Button Events
FlyButton.MouseButton1Click:Connect(ToggleFly)
IncreaseButton.MouseButton1Click:Connect(function() ChangeSpeed(10) end)
DecreaseButton.MouseButton1Click:Connect(function() ChangeSpeed(-10) end)
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
MinimizeButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Run Fly Update
RunService.Heartbeat:Connect(UpdateFly)

print("Fly GUI Loaded - Cre by DWlongnguyen")
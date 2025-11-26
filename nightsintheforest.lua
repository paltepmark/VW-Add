-- NIGHTS IN THE FOREST 2 - Professional Key Authentication System
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

-- Configuration
local CONFIG = {
    VALID_KEYS = {
        "DCIB"
    },
    SCRIPT_URL = "https://raw.githubusercontent.com/paltepmark/VW-Add/refs/heads/main/nightsintheforest2.lua",
    UI_SETTINGS = {
        WIDTH = 350,
        HEIGHT = 220,
        PRIMARY_COLOR = Color3.fromRGB(0, 100, 200),
        SUCCESS_COLOR = Color3.fromRGB(0, 200, 100),
        ERROR_COLOR = Color3.fromRGB(220, 60, 60),
        BACKGROUND_COLOR = Color3.fromRGB(35, 35, 35),
        HEADER_COLOR = Color3.fromRGB(25, 25, 25)
    }
}

-- Key validation service
local KeyService = {
    _authenticated = false,
    _attempts = 0,
    MAX_ATTEMPTS = 5
}

function KeyService:Initialize()
    if not Player then
        warn("[KeySystem] Player object not found")
        return false
    end
    
    self:CreateInterface()
    return true
end

function KeyService:ValidateKey(inputKey)
    -- Sanitize input
    local sanitizedKey = string.upper(inputKey:gsub("%s+", ""))
    
    if #sanitizedKey == 0 then
        return false, "Please enter a key"
    end
    
    self._attempts += 1
    
    -- Check against valid keys
    for _, validKey in ipairs(CONFIG.VALID_KEYS) do
        if sanitizedKey == validKey then
            return true, "Success"
        end
    end
    
    -- Rate limiting
    if self._attempts >= self.MAX_ATTEMPTS then
        return false, "Maximum attempts exceeded. Please try again later."
    end
    
    return false, string.format("Invalid key (%d/%d attempts used)", self._attempts, self.MAX_ATTEMPTS)
end

function KeyService:ExecuteAuthorizedScript()
    local success, result = pcall(function()
        local scriptSource = game:HttpGet(CONFIG.SCRIPT_URL, true)
        loadstring(scriptSource)()
    end)
    
    if not success then
        warn("[KeySystem] Failed to load authorized script: " .. tostring(result))
        return false
    end
    
    return true
end

function KeyService:CreateInterface()
    -- Create main container
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeyAuthenticationSystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    
    -- Main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, CONFIG.UI_SETTINGS.WIDTH, 0, CONFIG.UI_SETTINGS.HEIGHT)
    MainFrame.Position = UDim2.new(0.5, -CONFIG.UI_SETTINGS.WIDTH/2, 0.5, -CONFIG.UI_SETTINGS.HEIGHT/2)
    MainFrame.BackgroundColor3 = CONFIG.UI_SETTINGS.BACKGROUND_COLOR
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Add corner rounding
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.BackgroundColor3 = CONFIG.UI_SETTINGS.HEADER_COLOR
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "DCIB X 4AM 99 NIGHTS"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Size = UDim2.new(1, -20, 0, 15)
    Subtitle.Position = UDim2.new(0, 10, 0, 25)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Key Authentication Required"
    Subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    Subtitle.TextSize = 12
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header
    
    -- Input field
    local InputContainer = Instance.new("Frame")
    InputContainer.Name = "InputContainer"
    InputContainer.Size = UDim2.new(0.85, 0, 0, 40)
    InputContainer.Position = UDim2.new(0.075, 0, 0.3, 0)
    InputContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    InputContainer.BorderSizePixel = 0
    InputContainer.Parent = MainFrame
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = InputContainer
    
    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "KeyInput"
    KeyInput.Size = UDim2.new(1, -20, 1, 0)
    KeyInput.Position = UDim2.new(0, 10, 0, 0)
    KeyInput.BackgroundTransparency = 1
    KeyInput.PlaceholderText = "Enter your access key..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
    KeyInput.Text = ""
    KeyInput.ClearTextOnFocus = false
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 14
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextXAlignment = Enum.TextXAlignment.Left
    KeyInput.Parent = InputContainer
    
    -- Submit button
    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Name = "SubmitButton"
    SubmitButton.Size = UDim2.new(0.85, 0, 0, 40)
    SubmitButton.Position = UDim2.new(0.075, 0, 0.55, 0)
    SubmitButton.BackgroundColor3 = CONFIG.UI_SETTINGS.PRIMARY_COLOR
    SubmitButton.BorderSizePixel = 0
    SubmitButton.Text = "VERIFY KEY"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.TextSize = 14
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.Parent = MainFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = SubmitButton
    
    -- Status message
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(0.85, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0.075, 0, 0.8, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Enter your key to access the script"
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = MainFrame
    
    -- Button interactivity
    SubmitButton.MouseEnter:Connect(function()
        if not SubmitButton.AutoButtonColor then return end
        game:GetService("TweenService"):Create(
            SubmitButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(20, 120, 220)}
        ):Play()
    end)
    
    SubmitButton.MouseLeave:Connect(function()
        if not SubmitButton.AutoButtonColor then return end
        game:GetService("TweenService"):Create(
            SubmitButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = CONFIG.UI_SETTINGS.PRIMARY_COLOR}
        ):Play()
    end)
    
    -- Submit handler
    local function HandleSubmission()
        local inputKey = KeyInput.Text
        local isValid, message = self:ValidateKey(inputKey)
        
        if isValid then
            self._authenticated = true
            StatusLabel.Text = "✅ Authentication successful! Wait to Load..."
            StatusLabel.TextColor3 = CONFIG.UI_SETTINGS.SUCCESS_COLOR
            SubmitButton.BackgroundColor3 = CONFIG.UI_SETTINGS.SUCCESS_COLOR
            SubmitButton.Text = "AUTHENTICATED"
            SubmitButton.AutoButtonColor = false
            
            -- Execute authorized script
            task.spawn(function()
                task.wait(1.5)
                if self:ExecuteAuthorizedScript() then
                    ScreenGui:Destroy()
                else
                    StatusLabel.Text = "❌ Failed to load script"
                    StatusLabel.TextColor3 = CONFIG.UI_SETTINGS.ERROR_COLOR
                end
            end)
        else
            StatusLabel.Text = "❌ " .. message
            StatusLabel.TextColor3 = CONFIG.UI_SETTINGS.ERROR_COLOR
            
            -- Shake animation for invalid input
            local shake = Instance.new("NumberValue")
            shake.Value = 0
            shake.Changed:Connect(function()
                InputContainer.Position = UDim2.new(
                    0.075 + math.sin(shake.Value * 10) * 0.01,
                    0,
                    0.3,
                    0
                )
            end)
            
            for i = 1, 10 do
                shake.Value = i
                task.wait(0.02)
            end
            InputContainer.Position = UDim2.new(0.075, 0, 0.3, 0)
        end
    end
    
    SubmitButton.MouseButton1Click:Connect(HandleSubmission)
    
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            HandleSubmission()
        end
    end)
    
    -- Cleanup on destruction
    ScreenGui.Destroying:Connect(function()
        if not self._authenticated then
            warn("[KeySystem] Authentication interface closed without valid key")
        end
    end)
end

-- Initialize the key system
if not KeyService:Initialize() then
    warn("[KeySystem] Failed to initialize authentication system")
end

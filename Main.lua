local UILib = {}
UILib.__index = UILib

local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local function Create(class, props)
    local obj = Instance.new(class)
    for i,v in pairs(props) do
        obj[i] = v
    end
    return obj
end

function UILib:CreateWindow(title)
    local self = setmetatable({}, UILib)
    self.ToggleKey = Enum.KeyCode.RightShift
    self.Tabs = {}

    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "UILibrary",
        Parent = PlayerGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Main Frame
    local Main = Create("Frame", {
        Parent = ScreenGui,
        Size = UDim2.new(0,500,0,300),
        Position = UDim2.new(0.5,-250,0.5,-150),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        Active = true,
        Draggable = true
    })

    -- ✅ Close Button (X) อยู่บนสุด
    local Close = Create("TextButton", {
        Parent = Main,
        Size = UDim2.new(0,30,0,30),
        Position = UDim2.new(1,-35,0,5),
        Text = "X",
        BackgroundColor3 = Color3.fromRGB(170,0,0),
        TextColor3 = Color3.new(1,1,1),
        ZIndex = 50
    })

    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Sidebar
    local Sidebar = Create("Frame", {
        Parent = Main,
        Size = UDim2.new(0,120,1,0),
        BackgroundColor3 = Color3.fromRGB(20,20,20)
    })

    -- Content
    local Content = Create("Frame", {
        Parent = Main,
        Size = UDim2.new(1,-120,1,0),
        Position = UDim2.new(0,120,0,0),
        BackgroundColor3 = Color3.fromRGB(40,40,40)
    })

    self.ScreenGui = ScreenGui
    self.Sidebar = Sidebar
    self.Content = Content

    -- Toggle UI
    UIS.InputBegan:Connect(function(input,gp)
        if gp then return end
        if input.KeyCode == self.ToggleKey then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    return self
end

function UILib:CreateTab(name)
    local Tab = {}

    local Button = Create("TextButton", {
        Parent = self.Sidebar,
        Size = UDim2.new(1,0,0,40),
        Text = name,
        BackgroundColor3 = Color3.fromRGB(50,50,50)
    })

    local Page = Create("Frame", {
        Parent = self.Content,
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Visible = false
    })

    Create("UIListLayout", {Parent = Page, Padding = UDim.new(0,5)})

    Button.MouseButton1Click:Connect(function()
        for _,v in pairs(self.Content:GetChildren()) do
            if v:IsA("Frame") then v.Visible = false end
        end
        Page.Visible = true
    end)

    -- ✅ เปิด Tab แรกอัตโนมัติ
    if #self.Content:GetChildren() == 1 then
        Page.Visible = true
    end

    -- Components
    function Tab:Button(text, callback)
        local b = Create("TextButton", {
            Parent = Page,
            Size = UDim2.new(1,-10,0,40),
            Text = text,
            BackgroundColor3 = Color3.fromRGB(70,70,70),
            TextColor3 = Color3.new(1,1,1)
        })
        b.MouseButton1Click:Connect(callback)
    end

    function Tab:Toggle(text, default, callback)
        local state = default
        local btn = Create("TextButton", {
            Parent = Page,
            Size = UDim2.new(1,-10,0,40),
            Text = text.." : "..tostring(state),
            BackgroundColor3 = Color3.fromRGB(70,70,70),
            TextColor3 = Color3.new(1,1,1)
        })
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text.." : "..tostring(state)
            callback(state)
        end)
    end

    function Tab:Label(text)
        Create("TextLabel", {
            Parent = Page,
            Size = UDim2.new(1,-10,0,30),
            Text = text,
            BackgroundTransparency = 1,
            TextColor3 = Color3.new(1,1,1)
        })
    end

    function Tab:Keybind(text, default, callback)
        local key = default
        local waiting = false
        local btn = Create("TextButton", {
            Parent = Page,
            Size = UDim2.new(1,-10,0,40),
            Text = text.." : "..key.Name,
            BackgroundColor3 = Color3.fromRGB(70,70,70),
            TextColor3 = Color3.new(1,1,1)
        })
        btn.MouseButton1Click:Connect(function()
            btn.Text = "Press key..."
            waiting = true
        end)

        UIS.InputBegan:Connect(function(input,gp)
            if gp then return end
            if waiting then
                waiting = false
                key = input.KeyCode
                btn.Text = text.." : "..key.Name
                callback(key)
            elseif input.KeyCode == key then
                callback(key)
            end
        end)
    end

    return Tab
end

return UILib

-- UILib.lua
local UILib = {}

function UILib:CreateWindow(title)
    local selfWindow = {}

    -- ScreenGui
    local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MyUI"
    ScreenGui.Parent = PlayerGui
    selfWindow.ScreenGui = ScreenGui

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,500,0,300)
    MainFrame.Position = UDim2.new(0.5,-250,0.5,-150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    selfWindow.MainFrame = MainFrame

    -- Sidebar
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0,120,1,0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20,20,20)
    selfWindow.Sidebar = Sidebar

    -- Content
    local Content = Instance.new("Frame", MainFrame)
    Content.Size = UDim2.new(1,-120,1,0)
    Content.Position = UDim2.new(0,120,0,0)
    Content.BackgroundColor3 = Color3.fromRGB(40,40,40)
    selfWindow.Content = Content

    -- ToggleKey default
    selfWindow.ToggleKey = Enum.KeyCode.RightShift

    -- Create Tab function
    function selfWindow:CreateTab(name)
        local Tab = {}

        -- Button sidebar
        local Button = Instance.new("TextButton")
        Button.Parent = Sidebar
        Button.Size = UDim2.new(1,0,0,40)
        Button.Text = name

        -- Page
        local Page = Instance.new("Frame")
        Page.Parent = Content
        Page.Size = UDim2.new(1,0,1,0)
        Page.Visible = false
        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0,5)

        Button.MouseButton1Click:Connect(function()
            for _,v in pairs(Content:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = false
                end
            end
            Page.Visible = true
        end)

        -- Components
        function Tab:Label(text)
            local l = Instance.new("TextLabel")
            l.Parent = Page
            l.Size = UDim2.new(1,-10,0,30)
            l.Text = text
            l.BackgroundTransparency = 1
        end

        function Tab:Button(text, callback)
            local b = Instance.new("TextButton")
            b.Parent = Page
            b.Size = UDim2.new(1,-10,0,40)
            b.Text = text
            b.MouseButton1Click:Connect(callback)
        end

        function Tab:Toggle(text, default, callback)
            local state = default
            local t = Instance.new("TextButton")
            t.Parent = Page
            t.Size = UDim2.new(1,-10,0,40)
            t.Text = text.." : "..tostring(state)
            t.MouseButton1Click:Connect(function()
                state = not state
                t.Text = text.." : "..tostring(state)
                callback(state)
            end)
        end

        function Tab:Keybind(text, defaultKey, callback)
            local key = defaultKey
            local btn = Instance.new("TextButton")
            btn.Parent = Page
            btn.Size = UDim2.new(1,-10,0,40)
            btn.Text = text.." : "..key.Name
            local WaitingKey = false

            btn.MouseButton1Click:Connect(function()
                WaitingKey = true
                btn.Text = text.." : Press key..."
            end)

            game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
                if gp then return end
                if WaitingKey then
                    WaitingKey = false
                    key = input.KeyCode
                    btn.Text = text.." : "..key.Name
                    callback(key)
                end
            end)
        end

        return Tab
    end

    return selfWindow
end

return UILib

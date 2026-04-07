local UILib = {}

function UILib:Init()
    local self = {}

    local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0,500,0,300)
    Main.Position = UDim2.new(0.5,-250,0.5,-150)
    Main.BackgroundColor3 = Color3.fromRGB(30,30,30)

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0,120,1,0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20,20,20)

    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1,-120,1,0)
    Content.Position = UDim2.new(0,120,0,0)
    Content.BackgroundColor3 = Color3.fromRGB(40,40,40)

    self.Sidebar = Sidebar
    self.Content = Content

    -- Section builder
    function self:CreateSection(name, callback)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1,0,0,40)
        TabBtn.Text = name

        local Page = Instance.new("Frame", Content)
        Page.Size = UDim2.new(1,0,1,0)
        Page.Visible = false

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0,5)

        TabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(Content:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = false
                end
            end
            Page.Visible = true
        end)

        -- component API
        local sec = {}

        function sec:Button(text, callback)
            local b = Instance.new("TextButton", Page)
            b.Size = UDim2.new(1,-10,0,40)
            b.Text = text
            b.MouseButton1Click:Connect(callback)
        end

        function sec:Toggle(text, default, callback)
            local state = default
            local t = Instance.new("TextButton", Page)
            t.Size = UDim2.new(1,-10,0,40)
            t.Text = text.." : "..tostring(state)

            t.MouseButton1Click:Connect(function()
                state = not state
                t.Text = text.." : "..tostring(state)
                callback(state)
            end)
        end

        function sec:Label(text)
            local l = Instance.new("TextLabel", Page)
            l.Size = UDim2.new(1,-10,0,30)
            l.Text = text
            l.BackgroundTransparency = 1
        end

        callback(sec)
    end

    return self
end

return UILib

function UILib:CreateTab(name)
    local Tab = {}

    -- ปุ่มฝั่งซ้าย
    local Button = Instance.new("TextButton")
    Button.Parent = self.Sidebar
    Button.Size = UDim2.new(1,0,0,40)
    Button.Text = name

    -- หน้า content
    local Page = Instance.new("Frame")
    Page.Parent = self.Content
    Page.Size = UDim2.new(1,0,1,0)
    Page.Visible = false

    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0,5)

    Button.MouseButton1Click:Connect(function()
        for _,v in pairs(self.Content:GetChildren()) do
            if v:IsA("Frame") then
                v.Visible = false
            end
        end
        Page.Visible = true
    end)

    -- ========= COMPONENT =========

    function Tab:Button(text, callback)
        local b = Instance.new("TextButton")
        b.Parent = Page
        b.Size = UDim2.new(1,-10,0,40)
        b.Text = text

        b.MouseButton1Click:Connect(callback)
    end

    function Tab:Label(text)
        local l = Instance.new("TextLabel")
        l.Parent = Page
        l.Size = UDim2.new(1,-10,0,30)
        l.Text = text
        l.BackgroundTransparency = 1
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

    return Tab
end

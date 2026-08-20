-- ============================================================
-- OMAR HUB - ULTIMATE SECURE ENGINE (Starts Counting on Activation)
-- ============================================================
print("Omar Hub: Checking Key Expiration & Security...")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- جلب بصمة الجهاز الفريدة (HWID)
local function getDeviceHWID()
    local success, id = pcall(function()
        return gethwid and gethwid() or identifyexecutor and identifyexecutor() or "UnknownDevice"
    end)
    return success and id or "DefaultDevice"
end

local currentHWID = getDeviceHWID()
local KEY_FILE = "OmarHub_Session.json"
local ValidKeys = {
    ["Omar_123"] = 7, -- 7 أيام
    ["Omar_555"] = 7,
    ["Omar_777"] = 7
}

local isVerified = false

-- فحص الصلاحية والوقت والجهاز
if pcall(function() return readfile and readfile(KEY_FILE) end) then
    local dataRaw = readfile(KEY_FILE)
    local savedKey, savedHWID, expireTime = dataRaw:match("([^|]+)|([^|]+)|(%d+)")
    
    if savedKey and savedHWID and expireTime then
        if ValidKeys[savedKey] and savedHWID == currentHWID then
            if os.time() < tonumber(expireTime) then
                isVerified = true
            else
                pcall(function() if delfile then delfile(KEY_FILE) end end)
                plr:Kick("عذراً، لقد انتهت صلاحية الاشتراك! يرجى تجديد المفتاح للتشغيل.")
                return
            end
        end
    end
end

-- واجهة طلب المفتاح
if not isVerified then
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "OmarKeyGui"
    ScreenGui.ResetOnSpawn = false

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 300, 0, 160)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -80)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0

    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "عمر هب - أدخل مفتاح التفعيل"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 13
    Title.Font = Enum.Font.SourceSansBold

    local TextBox = Instance.new("TextBox", Frame)
    TextBox.Size = UDim2.new(0.8, 0, 0, 40)
    TextBox.Position = UDim2.new(0.1, 0, 0.4, 0)
    TextBox.PlaceholderText = "اكتب المفتاح هنا..."
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TextBox.TextSize = 14
    Instance.new("UICorner", TextBox)

    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(0.8, 0, 0, 35)
    Button.Position = UDim2.new(0.1, 0, 0.75, 0)
    Button.Text = "تحقق وتفعيل"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", Button)

    Button.MouseButton1Click:Connect(function()
        local userKey = TextBox.Text
        if ValidKeys[userKey] then
            -- التعديل هنا: الوقت بيبدأ من اللحظة دي بالظبط (لحظة الضغط)
            local expireTimestamp = os.time() + (ValidKeys[userKey] * 24 * 60 * 60)
            
            pcall(function()
                if writefile then
                    local dataToSave = userKey .. "|" .. currentHWID .. "|" .. tostring(expireTimestamp)
                    writefile(KEY_FILE, dataToSave)
                end
            end)
            
            ScreenGui:Destroy()
            isVerified = true
        else
            TextBox.Text = ""
            TextBox.PlaceholderText = "مفتاح خاطئ أو لجهاز آخر!"
        end
    end)

    while not isVerified do
        task.wait(0.5)
    end
end

-- ============================================================
-- تشغيل المحرك (نفس السكريبت القديم اللي انت اعتمدته)
-- ============================================================
print("Omar Hub: Key Active & Valid! Loading Engine...")

task.spawn(function()
    pcall(function()
        local mt = getrawmetatable(game)
        if mt then
            setreadonly(mt, false)
            local oldIndex = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" or method == "kick" or method == "DISCONNECT" then return nil end
                return oldIndex(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)
end)

task.spawn(function()
    pcall(function()
        local function addTag(char)
            local head = char:WaitForChild("Head", 10)
            if head and not head:FindFirstChild("OmarTag") then
                local bill = Instance.new("BillboardGui", head)
                bill.Name = "OmarTag"
                bill.Size = UDim2.new(0, 150, 0, 30)
                bill.StudsOffset = Vector3.new(0, 2.5, 0)
                bill.AlwaysOnTop = true
                local label = Instance.new("TextLabel", bill)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = "Omar Hub"
                label.TextColor3 = Color3.fromRGB(0, 0, 0)
                label.TextScaled = true
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.SourceSansBold
                label.TextStrokeTransparency = 0.5
            end
        end
        if plr.Character then addTag(plr.Character) end
        plr.CharacterAdded:Connect(addTag)
    end)
end)

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/VOIDNoTOP/refs/heads/main/main.lua"))()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/373c8f8e34cd4a84c1e1d3025c1e2e28.lua"))()
    end)
end)

print("Omar Hub: Fully Loaded Successfully!")

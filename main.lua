-- ============================================================
-- Yo Deals - ULTRA LIGHTWEIGHT & SECURE ENGINE (Mi 11 Lite Optimized)
-- ============================================================
print("Yo Deals: Initializing Lightweight Engine...")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local plr = Players.LocalPlayer

-- 1. نسخ رابط الديسكورد تلقائياً للحافظة فور التشغيل
task.spawn(function()
    pcall(function()
        if setclipboard then
            setclipboard("https://discord.gg/drmUrBbz")
        end
    end)
end)

-- 2. حماية أنتي-كيك ذكية بمهلة 30 ثانية (منع الطرد عند زيادة السرعة بالغلط)
local gracePeriodEnd = 0
task.spawn(function()
    pcall(function()
        local mt = getrawmetatable(game)
        if mt then
            setreadonly(mt, false)
            local oldIndex = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" or method == "kick" or method == "DISCONNECT" then
                    if tick() < gracePeriodEnd then
                        return nil
                    else
                        gracePeriodEnd = tick() + 30
                        return nil
                    end
                end
                return oldIndex(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)
end)

-- 3. فحص وتحديد بصمة الجهاز لتناسب جميع الهواتف بسلاسة تامة بدون لاج
local function getDeviceFingerprint()
    local success, hid = pcall(function()
        return gethwid and gethwid() or identifyexecutor and identifyexecutor() or "UnknownDevice"
    end)
    local platform = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) and "Mobile_Phone" or "PC_Desktop"
    return tostring(hid) .. "_" .. platform
end

local currentDevice = getDeviceFingerprint()
local KEY_FILE = "YoDeals_LightSecure_V14.json"

-- المفاتيح المعتمدة (مدة كل مفتاح 3 أيام من وقت التفعيل)
local ValidKeys = {
    ["Omar_123"] = 3, 
    ["Omar_555"] = 3, 
    ["Omar_777"] = 3, 
    ["Omar_665"] = 3, 
    ["Omar_190"] = 3
}

local isVerified = false

-- 4. فحص الملف المحلي والأمان (أقل من ثانية)
if pcall(function() return readfile(KEY_FILE) end) then
    local dataRaw = readfile(KEY_FILE)
    local savedKey, savedDevice, regTime, expireTime = dataRaw:match("([^|]+)|([^|]+)|(%d+)|(%d+)")
    
    if savedKey and savedDevice and expireTime then
        if savedDevice == currentDevice then
            if os.time() < tonumber(expireTime) then
                isVerified = true
            else
                pcall(function() delfile(KEY_FILE) end)
                plr:Kick("انتهت مدة المفتاح! لقد انتهت صلاحية الـ 3 أيام. تجديد الاشتراك من سيرفر الديسكورد: https://discord.gg/drmUrBbz")
                return
            end
        else
            plr:Kick("المفتاح غير صالح أو مستخدم على جهاز آخر! سيرفر الديسكورد: https://discord.gg/drmUrBbz")
            return
        end
    end
end

-- 5. واجهة طلب المفتاح الخفيفة جداً (تظهر مرة واحدة فقط)
if not isVerified then
    local Gui = Instance.new("ScreenGui", CoreGui)
    Gui.Name = "YoDealsKeyGui"
    Gui.ResetOnSpawn = false

    local Frame = Instance.new("Frame", Gui)
    Frame.Size = UDim2.new(0, 320, 0, 145)
    Frame.Position = UDim2.new(0.5, -160, 0.5, -72)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Instance.new("UICorner", Frame)

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundTransparency = 1
    Title.Text = "Yo Deals - Secure Activation"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 15

    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(0.9, 0, 0, 38)
    Box.Position = UDim2.new(0.05, 0, 0.3, 0)
    Box.PlaceholderText = "Please enter your key here..."
    Box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.TextSize = 13
    Instance.new("UICorner", Box)

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0.9, 0, 0, 38)
    Btn.Position = UDim2.new(0.05, 0, 0.68, 0)
    Btn.Text = "Verify & Start 3-Days Timer"
    Btn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 13
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        local enteredKey = Box.Text
        if ValidKeys[enteredKey] then
            local currentTime = os.time()
            local expireTimestamp = currentTime + (ValidKeys[enteredKey] * 24 * 60 * 60)
            
            pcall(function()
                local fullData = enteredKey .. "|" .. currentDevice .. "|" .. currentTime .. "|" .. expireTimestamp
                writefile(KEY_FILE, fullData)
            end)
            
            isVerified = true
            Gui:Destroy()
        else
            Box.Text = ""
            Box.PlaceholderText = "المفتاح غير صالح! حاول مجدداً..."
        end
    end)

    while not isVerified do task.wait(0.5) end
end

-- 6. عرض تاج Yo Deals وسيرفر الديسكورد فوق الرأس بطريقة خفيفة
local function createYoDealsTag()
    local function addTag(char)
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        if head:FindFirstChild("YoDealsTag") then return end

        local bill = Instance.new("BillboardGui")
        bill.Name = "YoDealsTag"
        bill.Adornee = head
        bill.Size = UDim2.new(0, 220, 0, 45)
        bill.StudsOffset = Vector3.new(0, 2.2, 0)
        bill.AlwaysOnTop = true

        local text = Instance.new("TextLabel", bill)
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = "Yo Deals\nhttps://discord.gg/drmUrBbz"
        text.TextColor3 = Color3.fromRGB(0, 0, 0)
        text.TextStrokeTransparency = 1
        text.Font = Enum.Font.SourceSansBold
        text.TextSize = 11
        
        bill.Parent = head
    end

    if plr.Character then addTag(plr.Character) end
    plr.CharacterAdded:Connect(addTag)
end

-- ============================================================
-- تشغيل المحرك والسكريبتات الأساسية بخفة تامة بدون ثقل
-- ============================================================
createYoDealsTag()

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/VOIDNoTOP/refs/heads/main/main.lua"))()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/373c8f8e34cd4a84c1e1d3025c1e2e28.lua"))()
    end)
end)

print("Yo Deals: Lightweight & Secured Engine Fully Active!")

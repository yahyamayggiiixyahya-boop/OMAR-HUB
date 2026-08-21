-- ============================================================
-- Yo Deals - ULTIMATE SECURE & POST-KEY EXECUTION ENGINE
-- ============================================================
print("Yo Deals: Initializing Secure Key Gate...")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local plr = Players.LocalPlayer

-- 1. نسخ رابط الديسكورد أوتوماتيكياً للحافظة
task.spawn(function()
    pcall(function()
        if setclipboard then
            setclipboard("https://discord.gg/drmUrBbz")
        end
    end)
end)

-- 2. حماية أنتي-كيك خفيفة وآمنة
task.spawn(function()
    pcall(function()
        local mt = getrawmetatable(game)
        if mt then
            setreadonly(mt, false)
            local oldIndex = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" or method == "kick" or method == "DISCONNECT" then
                    return nil
                end
                return oldIndex(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)
end)

-- 3. جلب بصمة الجهاز بدقة لربطه بالمفتاح
local function getDeviceHWID()
    local success, hid = pcall(function()
        return gethwid and gethwid() or identifyexecutor and identifyexecutor() or "UnknownDevice"
    end)
    local platform = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) and "Mobile_Phone" or "PC_Desktop"
    return tostring(hid) .. "_" .. platform
end

local currentDevice = getDeviceHWID()
local KEY_FILE = "YoDeals_Secure_PostKey_V18.json"

-- المفاتيح المعتمدة (مدة 3 أيام لكل مفتاح من لحظة تفعيله)
local ValidKeys = {
    ["Omar_123"] = 3, 
    ["Omar_555"] = 3, 
    ["Omar_777"] = 3, 
    ["Omar_665"] = 3, 
    ["Omar_190"] = 3
}

local isVerified = false

-- دالة لتشغيل السكريبتات الخاصة بك والـ 120 فريم (تشتغل حصرياً بعد اجتياز الكود)
local function launchMainEngine()
    -- تثبيت 120 فريم فقط بدون العبث بتفاصيل أو خامات اللعبة
    task.spawn(function()
        pcall(function()
            if setfpscap then
                setfpscap(120)
            end
        end)
    end)

    -- تشغيل السكريبتين بتوعك فوراً وبسرعة البرق
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/VOIDNoTOP/refs/heads/main/main.lua"))()
        end)
    end)

    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/373c8f8e34cd4a84c1e1d3025c1e2e28.lua"))()
        end)
    end)

    -- عرض تاج Yo Deals فوق الرأس
    task.spawn(function()
        pcall(function()
            local function addTag(char)
                local head = char:WaitForChild("Head", 5)
                if not head then return end
                if head:FindFirstChild("YoDealsTag") then return end

                local bill = Instance.new("BillboardGui")
                bill.Name = "YoDealsTag"
                bill.Adornee = head
                bill.Size = UDim2.new(0, 200, 0, 40)
                bill.StudsOffset = Vector3.new(0, 2.2, 0)
                bill.AlwaysOnTop = true

                local text = Instance.new("TextLabel", bill)
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = "Yo Deals\nhttps://discord.gg/drmUrBbz"
                text.TextColor3 = Color3.fromRGB(0, 0, 0)
                text.TextStrokeTransparency = 1
                text.Font = Enum.Font.SourceSansBold
                text.TextSize = 10
                
                bill.Parent = head
            end

            if plr.Character then addTag(plr.Character) end
            plr.CharacterAdded:Connect(addTag)
        end)
    end)
end

-- 4. فحص الملف المحلي والأمان والـ 3 أيام
if pcall(function() return readfile(KEY_FILE) end) then
    local dataRaw = readfile(KEY_FILE)
    local savedKey, savedDevice, regTime, expireTime = dataRaw:match("([^|]+)|([^|]+)|(%d+)|(%d+)")
    
    if savedKey and savedDevice and expireTime then
        if savedDevice == currentDevice then
            if os.time() < tonumber(expireTime) then
                isVerified = true
                launchMainEngine() -- تشغيل السكريبتات مباشرة لأن الكود محفوض وصحيح
            else
                pcall(function() delfile(KEY_FILE) end)
                plr:Kick("انتهت مدة المفتاح! لقد انتهت صلاحية الـ 3 أيام الخاصة بك. تجديد الاشتراك من سيرفر الديسكورد: https://discord.gg/drmUrBbz")
                return
            end
        else
            plr:Kick("المفتاح غير صالح أو مستخدم على جهاز آخر! انضم إلى سيرفر الديسكورد: https://discord.gg/drmUrBbz")
            return
        end
    end
end

-- 5. واجهة إدخال المفتاح (تطلب مرة واحدة فقط إن لم تكن مسجلة)
if not isVerified then
    local Gui = Instance.new("ScreenGui", CoreGui)
    Gui.Name = "YoDealsKeyGui"
    Gui.ResetOnSpawn = false

    local Frame = Instance.new("Frame", Gui)
    Frame.Size = UDim2.new(0, 300, 0, 130)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -65)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Frame)

    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(0.9, 0, 0, 35)
    Box.Position = UDim2.new(0.05, 0, 0.25, 0)
    Box.PlaceholderText = "Enter your key here..."
    Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.TextSize = 12
    Instance.new("UICorner", Box)

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
    Btn.Position = UDim2.new(0.05, 0, 0.62, 0)
    Btn.Text = "Verify Key"
    Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
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
            
            -- تشغيل سكريبتاتك فوراً وبسرعة الصاروخ بعد الضغط مباشرة
            launchMainEngine()
        else
            plr:Kick("المفتاح غير صالح أو خاطئ! انضم إلى سيرفر الديسكورد للحصول على مفتاح صحيح: https://discord.gg/drmUrBbz")
        end
    end)

    while not isVerified do task.wait(0.5) end
end

print("Yo Deals: Key Gate Passed & Main Engine Running!")

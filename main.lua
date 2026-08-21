-- ============================================================
-- Yo Deals - ULTIMATE SMART DYNAMIC ACTIVATION ENGINE
-- ============================================================
print("Yo Deals: Initializing Smart Key Activation & Device Binding...")

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

-- 2. حماية الانتي-كيك القوية جداً لمنع الطرد العشوائي أو بسبب السرعة
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

-- 3. دالة فحص بصمة الجهاز ونوعه بالكامل بدقة متناهية
local function getTargetDeviceProfile()
    local success, hid = pcall(function()
        return gethwid and gethwid() or identifyexecutor and identifyexecutor() or "UnknownDevice"
    end)
    local platform = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) and "Mobile_Phone" or "PC_Desktop"
    return tostring(hid) .. "_" .. platform
end

local currentDeviceProfile = getTargetDeviceProfile()
local KEY_FILE = "YoDeals_Smart_Active_V12.json"

-- جدول المفاتيح (كل مفتاح غير مفعل يظل متوقفاً، ولا يبدأ العداد إلا عند استخدامه لأول مرة)
local ValidKeys = {
    ["Omar_123"] = true, 
    ["Omar_555"] = true, 
    ["Omar_777"] = true, 
    ["Omar_665"] = true, 
    ["Omar_190"] = true
}

local isVerified = false

-- 4. فحص فوري للملف المحلي (أقل من ثانية لمعرفة الجهاز والمفتاح ووقت الانتهاء)
if pcall(function() return readfile(KEY_FILE) end) then
    local dataRaw = readfile(KEY_FILE)
    -- القراءة: المفتاح | بصمة التليفون | وقت التفعيل | وقت انتهاء الصلاحية
    local savedKey, savedDevice, regTime, expireTime = dataRaw:match("([^|]+)|([^|]+)|(%d+)|(%d+)")
    
    if savedKey and savedDevice and expireTime then
        if savedDevice == currentDeviceProfile then
            -- العداد شغال بس للكود اللي تم تفعيله وبيه المهلة الزمنية (24 ساعة + ساعات إضافية لراحة اللاعب)
            if os.time() < tonumber(expireTime) then
                isVerified = true
            else
                pcall(function() delfile(KEY_FILE) end)
                plr:Kick("Your key subscription has expired! Please renew from our Discord: https://discord.gg/drmUrBbz")
                return
            end
        else
            -- محاولة استخدام المفتاح على جهاز آخر غير الذي قام بتفعيله
            plr:Kick("Security Error: This key is already locked and used on another phone! Discord: https://discord.gg/drmUrBbz")
            return
        end
    end
end

-- 5. واجهة إدخال المفتاح (تطلب مرة واحدة فقط في العمر ولن تظهر مجدداً)
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
    Btn.Text = "Verify & Lock to This Phone"
    Btn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 13
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        local enteredKey = Box.Text
        if ValidKeys[enteredKey] then
            local currentTime = os.time()
            
            -- تفعيل العداد للمفتاح المستخدم فقط: 24 ساعة + ساعات إضافية (مثلاً 28 ساعة إجمالاً لتغطية الوقت لحد الساعة 1 أو 2 الفجر بمرونة)
            local bonusHours = 28 
            local expireTimestamp = currentTime + (bonusHours * 60 * 60)
            
            -- حفظ المفتاح، تفاصيل التليفون بالكامل، وقت التفعيل، ووقت الانتهاء بدقة داخل الملف
            pcall(function()
                local fullData = enteredKey .. "|" .. currentDeviceProfile .. "|" .. currentTime .. "|" .. expireTimestamp
                writefile(KEY_FILE, fullData)
            end)
            
            isVerified = true
            Gui:Destroy()
        else
            Box.Text = ""
            Box.PlaceholderText = "Invalid Key! Try again..."
        end
    end)

    while not isVerified do task.wait(0.5) end
end

-- 6. عرض اسم Yo Deals وسيرفر الديسكورد فوق الرأس بالخط الطبيعي
print("Yo Deals: Tag module loading...")
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
-- تشغيل المحرك والسكريبتات الأساسية لـ Yo Deals
-- ============================================================
createYoDealsTag()

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/VOIDNoTOP/refs/heads/main/main.lua"))()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/373c8f8e34cd4a84c1e1d3025c1e2e28.lua"))()
    end)
end)

print("Yo Deals: Smart Security & Tracking Fully Active!")

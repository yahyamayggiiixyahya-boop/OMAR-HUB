-- ============================================================
-- OMAR HUB - ULTIMATE DEEP-HWID & ANTI-KICK ENGINE
-- ============================================================
print("Omar Hub: Initializing Deep Hardware Security...")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local plr = Players.LocalPlayer

-- 0. نسخ رابط الديسكورد تلقائياً للحافظة
task.spawn(function()
    pcall(function()
        if setclipboard then
            setclipboard("https://discord.gg/drmUrBbz")
        end
    end)
end)

-- 1. حماية الانتي-كيك المتقدمة (لمنع الطرد بسبب السرعة العالية أو البرين روت)
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

-- 2. دالة جلب بصمة الجهاز ونوعه بالمللي (حتى لو مسح دلتا ونزله تاني البصمة بتفضل محفوظة في الملفات)
local function getDeepDeviceInfo()
    local success, hid = pcall(function()
        return gethwid and gethwid() or identifyexecutor and identifyexecutor() or "UnknownExecutor"
    end)
    local platform = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) and "Mobile_Touch" or "PC_Desktop"
    local combinedID = tostring(hid) .. "_" .. platform
    return combinedID
end

local currentDeviceID = getDeepDeviceInfo()
local KEY_FILE = "OmarHub_DeepSecure_V7.json"

-- المفاتيح المعتمدة (مدة 7 أيام من أول تفعيل)
local ValidKeys = {
    ["Omar_123"] = 7, 
    ["Omar_555"] = 7, 
    ["Omar_777"] = 7, 
    ["Omar_665"] = 7, 
    ["Omar_190"] = 7
}

local isVerified = false

-- 3. الفحص العميق للملفات (حتى لو مسح الإكسيكتور الملف بيقعد في الـ Workspace)
if pcall(function() return readfile(KEY_FILE) end) then
    local dataRaw = readfile(KEY_FILE)
    local savedKey, savedDeviceID, expireTime = dataRaw:match("([^|]+)|([^|]+)|(%d+)")
    
    if savedKey and savedDeviceID and expireTime then
        -- لو نفس الجهاز ونفس بصمة التليفون بالمللي
        if savedDeviceID == currentDeviceID then
            if os.time() < tonumber(expireTime) then
                isVerified = true
            else
                pcall(function() delfile(KEY_FILE) end)
                plr:Kick("انتهت صلاحية الـ 7 أيام! يجب تجديد الكود من سيرفر الديسكورد: https://discord.gg/drmUrBbz")
                return
            end
        else
            -- لو جهازه اتغير أو حاول يدخل من تليفون/إكسيكتور تاني بنفس الكود
            plr:Kick("المفتاح مستخدم مسبقاً على جهاز آخر ولا يمكن تشغيله هنا! انضم للديسكورد: https://discord.gg/drmUrBbz")
            return
        end
    end
end

-- 4. واجهة تطلب الكود مرة واحدة فقط
if not isVerified then
    local Gui = Instance.new("ScreenGui", CoreGui)
    Gui.Name = "OmarKeyGui"
    Gui.ResetOnSpawn = false

    local Frame = Instance.new("Frame", Gui)
    Frame.Size = UDim2.new(0, 310, 0, 140)
    Frame.Position = UDim2.new(0.5, -155, 0.5, -70)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", Frame)

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Text = "Omar Hub - التفعيل الأمني الدائم"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 14

    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(0.9, 0, 0, 35)
    Box.Position = UDim2.new(0.05, 0, 0.3, 0)
    Box.PlaceholderText = "أدخل المفتاح (يُستخدم مرة واحدة فقط)..."
    Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.TextSize = 12
    Instance.new("UICorner", Box)

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0.9, 0, 0, 35)
    Btn.Position = UDim2.new(0.05, 0, 0.68, 0)
    Btn.Text = "تفعيل وحفظ بصمة الجهاز نهائياً"
    Btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 13
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        local enteredKey = Box.Text
        if ValidKeys[enteredKey] then
            local expTime = os.time() + (ValidKeys[enteredKey] * 24 * 60 * 60)
            
            -- حفظ الكود مع بصمة الجهاز ونوعه بالمللي في الملف
            pcall(function()
                writefile(KEY_FILE, enteredKey .. "|" .. currentDeviceID .. "|" .. expTime)
            end)
            
            isVerified = true
            Gui:Destroy()
        else
            Box.Text = ""
            Box.PlaceholderText = "المفتاح غير صالح أو خطأ!"
        end
    end)

    while not isVerified do task.wait(0.5) end
end

-- 5. وظيفة عرض سيرفر الديسكورد فوق رأس اللاعب بخط أسود وصغير
local function createDiscordTag()
    local function addTag(char)
        local head = char:WaitForChild("Head", 5)
        if not head then return end
        if head:FindFirstChild("OmarDiscordTag") then return end

        local bill = Instance.new("BillboardGui")
        bill.Name = "OmarDiscordTag"
        bill.Adornee = head
        bill.Size = UDim2.new(0, 200, 0, 40)
        bill.StudsOffset = Vector3.new(0, 2.2, 0)
        bill.AlwaysOnTop = true

        local text = Instance.new("TextLabel", bill)
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = "Discord: https://discord.gg/drmUrBbz"
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
-- تشغيل المحرك والسكريبتات الأساسية
-- ============================================================
createDiscordTag()

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/VOIDNoTOP/refs/heads/main/main.lua"))()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/373c8f8e34cd4a84c1e1d3025c1e2e28.lua"))()
    end)
end)

print("Omar Hub: Deep-HWID & Anti-Kick Protection Fully Active!")

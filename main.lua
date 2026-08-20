-- ============================================================
-- OMAR HUB - ULTIMATE INTEGRATED ENGINE (Patching All Protections)
-- ============================================================
print("Omar Hub: Patching All Anti-Kicks & Initializing...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

-- 1. نظام إصلاح الكيك (Patching existing Anti-Kicks)
task.spawn(function()
    pcall(function()
        local mt = getrawmetatable(game)
        if mt then
            setreadonly(mt, false)
            local oldIndex = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                -- إصلاح شامل: اعتراض أي محاولة طرد أو خطأ 267
                if method == "Kick" or method == "kick" or method == "DISCONNECT" then
                    return nil
                end
                return oldIndex(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)
end)

-- 2. تاج "عمر هب" فوق اللاعب (أسود، صغير، غير مزعج)
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
                label.TextColor3 = Color3.fromRGB(0, 0, 0) -- أسود
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

-- 3. تشغيل السكريبتات المدمجة
task.spawn(function()
    pcall(function()
        -- تشغيل السكريبت الأول
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yahyamayggiiixyahya-boop/VOIDNoTOP/refs/heads/main/main.lua"))()
        -- تشغيل السكريبت الثاني (اللودر)
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/373c8f8e34cd4a84c1e1d3025c1e2e28.lua"))()
    end)
end)

print("Omar Hub: All protections patched and scripts loaded!")

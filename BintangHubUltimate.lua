-- BINTANGHUB V41 | Violence District
-- FULL FEATURES: Leenz Combat + Full ESP + Crosshair + Camera

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    -- Combat
    SilentAim = false, AimLock = false, AimPart = "Head", AimTarget = "Killer",
    -- Survivor
    FastVault = false,
    -- ESP
    ESP_Survivor = false, ESP_Killer = false, ESP_Gen = false, 
    ESP_Pallet = false, ESP_Hook = false, ESP_Window = false, 
    ESP_Labu = false, ESP_Trap = false, ESP_SCP = false,
    -- Visuals
    Fullbright = false, NoClip = false, DBDCamera = false, CameraFOV = 70,
    Crosshair = false, CrosshairSize = 10, CrosshairColor = Color3.fromRGB(255, 255, 255),
    
    -- Colors
    Color_Survivor = Color3.fromRGB(40, 255, 40), 
    Color_Killer = Color3.fromRGB(255, 40, 40),   
    Color_Gen = Color3.fromRGB(255, 255, 0),
    Color_Pallet = Color3.fromRGB(0, 150, 255),
    Color_Hook = Color3.fromRGB(200, 200, 200),
    Color_Window = Color3.fromRGB(0, 255, 255),
    Color_Labu = Color3.fromRGB(255, 165, 0),
    Color_Trap = Color3.fromRGB(255, 0, 255),
    Color_SCP = Color3.fromRGB(170, 0, 255)
}

-- ==========================================
-- 1. INJECT LEENZ
-- ==========================================
print("[*] Injecting Leenz66...")
local original_loadstring = loadstring or load
local SandboxEnv = setmetatable({}, {__index = getfenv()})
local captured_payload = nil
SandboxEnv.loadstring = function(code, name) if type(code) == "string" and #code > 100 then captured_payload = code end return original_loadstring(code, name) end
SandboxEnv.HttpGet = function(url) return "return function() end" end
SandboxEnv.HttpPost = function(opts) return {Body = '{"success":true}', StatusCode = 200} end
local loaderCode = game:HttpGet("https://api.luarmor.net/files/v4/loaders/82419a6df8b5b0d7c91a6affe9f3fb04.lua")
local fn = original_loadstring(loaderCode)
if fn then setfenv(fn, SandboxEnv); pcall(fn) end
if not captured_payload then
    local payloadUrl = loaderCode:match('https://api%.luarmor%.net/files/v4/protected_scripts/[^"]+') 
    if payloadUrl then captured_payload = game:HttpGet(payloadUrl) end
end
if captured_payload then local realFn = original_loadstring(captured_payload); if realFn then pcall(realFn) end end
task.wait(2)

for _, gui in pairs(CoreGui:GetChildren()) do
    if gui:IsA("ScreenGui") and (gui.Name:lower():find("leenz") or gui.Name:lower():find("hub") or gui.Name:lower():find("vd")) then
        gui:Destroy() 
    end
end

-- ==========================================
-- 2. BINTANGHUB UI
-- ==========================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "BINTANGHUB | V41 FULL",
   LoadingTitle = "BINTANGHUB",
   LoadingSubtitle = "by BintangHub",
   KeySystem = false, Theme = "Crimson"
})

local TabCombat = Window:CreateTab("Combat", 4483362458)
local TabSurvivor = Window:CreateTab("Survivor", 4483362458)
local TabESP = Window:CreateTab("ESP", 4483362458)
local TabVisuals = Window:CreateTab("Visuals", 4483362458)

-- COMBAT
TabCombat:CreateSection("Silent Aim")
TabCombat:CreateToggle({Name = "Silent Aim", CurrentValue = false, Callback = function(v) Config.SilentAim = v end})
TabCombat:CreateToggle({Name = "Aim Lock", CurrentValue = false, Callback = function(v) Config.AimLock = v end})
TabCombat:CreateDropdown({Name = "Target Entity", Options = {"Killer", "Survivor", "SCP/Zombie"}, CurrentOption = {"Killer"}, Callback = function(o) Config.AimTarget = o[1] end})
TabCombat:CreateDropdown({Name = "Aim Part", Options = {"Head", "Torso"}, CurrentOption = {"Head"}, Callback = function(o) Config.AimPart = o[1] end})

TabCombat:CreateSection("Crosshair")
TabCombat:CreateToggle({Name = "Enable Crosshair", CurrentValue = false, Callback = function(v) Config.Crosshair = v end})
TabCombat:CreateSlider({Name = "Crosshair Size", Range = {5, 30}, Increment = 1, CurrentValue = 10, Callback = function(v) Config.CrosshairSize = v end})
TabCombat:CreateColorPicker({Name = "Crosshair Color", Color = Config.CrosshairColor, Callback = function(v) Config.CrosshairColor = v end})

-- SURVIVOR
TabSurvivor:CreateSection("Skillcheck & Parry (Leenz)")
TabSurvivor:CreateToggle({Name = "Auto Skillcheck", CurrentValue = false, Callback = function(v) if getgenv().SkillCheck then getgenv().SkillCheck = v end end})
TabSurvivor:CreateDropdown({Name = "Skillcheck Mode", Options = {"Legit", "Normal", "Instan"}, CurrentOption = {"Normal"}, Callback = function(o) if getgenv().SkillMode then getgenv().SkillMode = o[1] end end})
TabSurvivor:CreateToggle({Name = "Enable Auto Parry", CurrentValue = false, Callback = function(v) if getgenv().AutoParry then getgenv().AutoParry = v end end})
TabSurvivor:CreateToggle({Name = "Fast Vault", CurrentValue = false, Callback = function(v) Config.FastVault = v end})

-- ESP
TabESP:CreateSection("Player ESP")
TabESP:CreateToggle({Name = "ESP Survivor", CurrentValue = false, Callback = function(v) Config.ESP_Survivor = v end})
TabESP:CreateColorPicker({Name = "Survivor Color", Color = Config.Color_Survivor, Callback = function(v) Config.Color_Survivor = v end})
TabESP:CreateToggle({Name = "ESP Killer", CurrentValue = false, Callback = function(v) Config.ESP_Killer = v end})
TabESP:CreateColorPicker({Name = "Killer Color", Color = Config.Color_Killer, Callback = function(v) Config.Color_Killer = v end})

TabESP:CreateSection("Object ESP")
TabESP:CreateToggle({Name = "ESP Generator", CurrentValue = false, Callback = function(v) Config.ESP_Gen = v end})
TabESP:CreateColorPicker({Name = "Gen Color", Color = Config.Color_Gen, Callback = function(v) Config.Color_Gen = v end})
TabESP:CreateToggle({Name = "ESP Labu", CurrentValue = false, Callback = function(v) Config.ESP_Labu = v end})
TabESP:CreateToggle({Name = "ESP Trap", CurrentValue = false, Callback = function(v) Config.ESP_Trap = v end})
TabESP:CreateToggle({Name = "ESP Pallet", CurrentValue = false, Callback = function(v) Config.ESP_Pallet = v end})
TabESP:CreateToggle({Name = "ESP Hook", CurrentValue = false, Callback = function(v) Config.ESP_Hook = v end})
TabESP:CreateToggle({Name = "ESP Window", CurrentValue = false, Callback = function(v) Config.ESP_Window = v end})
TabESP:CreateToggle({Name = "ESP SCP/Zombie", CurrentValue = false, Callback = function(v) Config.ESP_SCP = v end})

-- VISUALS
TabVisuals:CreateToggle({Name = "Fullbright", CurrentValue = false, Callback = function(v) 
    Config.Fullbright = v
    Lighting.Brightness = v and 3 or 1
    Lighting.ClockTime = v and 14 or 0
end})
TabVisuals:CreateToggle({Name = "No Clip", CurrentValue = false, Callback = function(v) Config.NoClip = v end})
TabVisuals:CreateSlider({Name = "Camera FOV", Range = {70, 120}, Increment = 1, CurrentValue = 70, Callback = function(v) Config.CameraFOV = v end})
TabVisuals:CreateToggle({Name = "DBD Camera Mode", CurrentValue = false, Callback = function(v) Config.DBDCamera = v end})

-- ==========================================
-- 3. CROSSHAIR & AIM LOGIC
-- ==========================================
local crosshairGui = Instance.new("ScreenGui")
crosshairGui.Name = "BH_Crosshair"
crosshairGui.IgnoreGuiInset = true
crosshairGui.Parent = CoreGui
local cLine1 = Instance.new("Frame", crosshairGui)
cLine1.BorderSizePixel = 0; cLine1.AnchorPoint = Vector2.new(0.5, 0.5); cLine1.Position = UDim2.new(0.5, 0, 0.5, 0)
local cLine2 = Instance.new("Frame", crosshairGui)
cLine2.BorderSizePixel = 0; cLine2.AnchorPoint = Vector2.new(0.5, 0.5); cLine2.Position = UDim2.new(0.5, 0, 0.5, 0)

local function IsKiller(plr)
    local char = plr.Character
    if not char then return false end
    if plr.Team and (plr.Team.Name:lower():find("killer") or plr.Team.Name:lower():find("monster")) then return true end
    if char:FindFirstChildWhichIsA("Tool") then return true end
    if char.Name:lower():find("killer") or char.Name:lower():find("slasher") then return true end
    return false
end

local function GetAimTarget()
    local closest, minDist = nil, math.huge
    if Config.AimTarget == "SCP/Zombie" then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local n = obj.Name:lower()
                if n:find("scp") or n:find("zombie") or n:find("monster") then
                    local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                    if hrp then
                        local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                        if dist < minDist and dist < 300 then minDist = dist; closest = hrp end
                    end
                end
            end
        end
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local isKiller = IsKiller(plr)
                local match = (Config.AimTarget == "Killer" and isKiller) or (Config.AimTarget == "Survivor" and not isKiller)
                if match then
                    local aimPart = plr.Character:FindFirstChild(Config.AimPart) or plr.Character:FindFirstChild("HumanoidRootPart")
                    if aimPart then
                        local dist = (Camera.CFrame.Position - aimPart.Position).Magnitude
                        if dist < minDist and dist < 300 then minDist = dist; closest = aimPart end
                    end
                end
            end
        end
    end
    return closest
end

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if Config.SilentAim and (method == "Raycast" or method == "FindPartOnRay") then
        local target = GetAimTarget()
        if target then
            local args = {...}
            if typeof(args[1]) == "Ray" then
                args[1] = Ray.new(args[1].Origin, (target.Position - args[1].Origin).Unit * 500)
            end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- ==========================================
-- 4. ESP & PROGRESS RENDER
-- ==========================================
local espCache = {}

local function ApplyHighlight(obj, color)
    if not obj then return end
    local hl = Instance.new("Highlight")
    hl.Name = "BH_Highlight"
    hl.Adornee = obj
    hl.FillColor = color
    hl.FillTransparency = 0.4
    hl.OutlineColor = color
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = obj
    return hl
end

local function CreateBillboard(parent, text, color)
    local hrp = parent:FindFirstChild("HumanoidRootPart") or parent:FindFirstChildWhichIsA("BasePart") or parent
    if not hrp then return end
    local b = Instance.new("BillboardGui")
    b.Name = "BH_Text"
    b.Size = UDim2.new(0, 150, 0, 50)
    b.StudsOffset = Vector3.new(0, 3, 0)
    b.AlwaysOnTop = true
    b.Parent = hrp
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = color
    t.TextStrokeTransparency = 0
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.Parent = b
    return b
end

RunService.RenderStepped:Connect(function()
    -- Camera
    Camera.FieldOfView = Config.CameraFOV
    if Config.DBDCamera then
        Camera.CameraType = Enum.CameraType.Scriptable
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(hrp.Position - (hrp.CFrame.LookVector * 10) + Vector3.new(0, 5, 0), hrp.Position), 0.2)
        end
    elseif Camera.CameraType == Enum.CameraType.Scriptable then
        Camera.CameraType = Enum.CameraType.Custom
    end

    -- Crosshair
    crosshairGui.Enabled = Config.Crosshair
    if Config.Crosshair then
        cLine1.Size = UDim2.new(0, Config.CrosshairSize, 0, 2)
        cLine1.BackgroundColor3 = Config.CrosshairColor
        cLine2.Size = UDim2.new(0, 2, 0, Config.CrosshairSize)
        cLine2.BackgroundColor3 = Config.CrosshairColor
    end

    -- Aim Lock
    if Config.AimLock then
        local target = GetAimTarget()
        if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.2) end
    end

    -- Player ESP
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local isKiller = IsKiller(plr)
                local active = (isKiller and Config.ESP_Killer) or (not isKiller and Config.ESP_Survivor)
                
                if active then
                    local color = isKiller and Config.Color_Killer or Config.Color_Survivor
                    if not espCache[plr] or not espCache[plr].Parent then espCache[plr] = ApplyHighlight(char, color) end
                    espCache[plr].Enabled = true
                    espCache[plr].FillColor = color
                    espCache[plr].OutlineColor = color
                elseif espCache[plr] then 
                    espCache[plr].Enabled = false 
                end
            end
        end
    end

    -- Object ESP
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local n = obj.Name:lower()
            local isGen = Config.ESP_Gen and (n:find("gen") or n:find("fuse") or n:find("repair"))
            local isPallet = Config.ESP_Pallet and n:find("pallet")
            local isHook = Config.ESP_Hook and n:find("hook")
            local isWindow = Config.ESP_Window and (n:find("window") or n:find("vault"))
            local isLabu = Config.ESP_Labu and (n:find("labu") or n:find("pumpkin"))
            local isTrap = Config.ESP_Trap and (n:find("trap") or n:find("beartrap"))
            local isSCP = Config.ESP_SCP and (n:find("scp") or n:find("zombie") or n:find("monster"))
            
            if isGen or isPallet or isHook or isWindow or isLabu or isTrap or isSCP then
                local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    local color = isGen and Config.Color_Gen or isPallet and Config.Color_Pallet or isHook and Config.Color_Hook or isWindow and Config.Color_Window or isLabu and Config.Color_Labu or isTrap and Config.Color_Trap or Config.Color_SCP
                    if not espCache[obj] then espCache[obj] = ApplyHighlight(obj, color) end
                    espCache[obj].Enabled = true
                    espCache[obj].FillColor = color
                    
                    -- Text
                    local textTag = primaryPart:FindFirstChild("BH_Text")
                    if not textTag then textTag = CreateBillboard(obj, "", color) end
                    if textTag and textTag:FindFirstChild("TextLabel") then
                        local label = textTag.TextLabel
                        label.TextColor3 = color
                        if isGen then 
                            local prog = 0
                            local progVal = obj:FindFirstChild("Progress") or obj:FindFirstChild("Percentage")
                            if progVal and progVal:IsA("NumberValue") then prog = progVal.Value end
                            if obj:GetAttribute("Progress") then prog = obj:GetAttribute("Progress") end
                            if prog > 0 then label.Text = "[ GEN - " .. math.floor(prog) .. "% ]" else label.Text = "[ GEN ]" end
                        elseif isLabu then label.Text = "[ LABU ]"
                        elseif isTrap then label.Text = "[ TRAP ]"
                        elseif isPallet then label.Text = "[ PALLET ]"
                        elseif isHook then label.Text = "[ HOOK ]"
                        elseif isWindow then label.Text = "[ WINDOW ]"
                        elseif isSCP then label.Text = "[ SCP ]" end
                        textTag.Enabled = true
                    end
                end
            elseif espCache[obj] and not (isGen or isPallet or isHook or isWindow or isLabu or isTrap or isSCP) then
                if espCache[obj]:IsA("Highlight") then espCache[obj].Enabled = false end
                local textTag = obj:FindFirstChild("BH_Text", true) or (obj.PrimaryPart and obj.PrimaryPart:FindFirstChild("BH_Text"))
                if textTag then textTag.Enabled = false end
            end
        end
    end
end)

-- Fast Vault & NoClip Loop
task.spawn(function()
    while task.wait(0.1) do
        local char = LocalPlayer.Character
        if char then
            if Config.NoClip then
                for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
            if Config.FastVault then
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum:GetState() == Enum.HumanoidStateType.Jumping then hum.WalkSpeed = 60 elseif hum then hum.WalkSpeed = 16 end
            end
        end
        if Config.Fullbright then Lighting.Brightness = 3; Lighting.ClockTime = 14; Lighting.GlobalShadows = false
        else Lighting.Brightness = 1; Lighting.GlobalShadows = true end
    end
end)

print("[BINTANGHUB V41 FULL] Loaded. All Features Active.")

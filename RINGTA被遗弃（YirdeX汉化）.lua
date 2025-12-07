local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Window = WindUI:CreateWindow({
    Folder = "被遗弃汉化脚本-RlNGTA",
    Title = "被遗弃汉化脚本-RlNGTA",
    Icon = "star",
    Author = "by:YirdeX",
    Theme = "Dark",
    Size = UDim2.fromOffset(500, 420),
    HasOutline = true,
})

Window:EditOpenButton({
    Title = "打开RlNGTA脚本-被遗弃",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local Tabs = {
    Stamina_Settings = Window:Tab({ Title = "体力设置", Icon = "footprints" }),
    Esp = Window:Tab({ Title = "透视", Icon = "eye" }),
    AutoBlock = Window:Tab({ Title = "自动格挡", Icon = "shield" }),
    Misc = Window:Tab({ Title = "杂项", Icon = "shield" }),
    Auto_Stun = Window:Tab({ Title = "自动胘晕", Icon = "spline-pointer" }),
    Random = Window:Tab({ Title = "随机", Icon = "crosshair" }),
    Hitbox_expander = Window:Tab({ Title = "碰撞箱扩展器", Icon = "target" }),
    Generator = Window:Tab({ Title = "发电机", Icon = "battery-charging" }),
    Teleport = Window:Tab({Title = "传送", Icon = "cable" }),
    Credits = Window:Tab({ Title = "信息", Icon = "award" })
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local sprintModule = require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)

-- сохраняем стандартные значения
local defaultMaxStamina = sprintModule.MaxStamina
local defaultSprintSpeed = sprintModule.SprintSpeed
local defaultStaminaGain = sprintModule.StaminaGain
local defaultStaminaDrain = sprintModule.StaminaDrain or 1
local defaultRegenDelay = sprintModule.StaminaRegenDelay or 0.5

-- текущие значения
local maxStaminaValue = sprintModule.MaxStamina
local sprintSpeedValue = sprintModule.SprintSpeed
local staminaGainValue = sprintModule.StaminaGain
local staminaDrainValue = sprintModule.StaminaDrain or 1
local regenDelayValue = sprintModule.StaminaRegenDelay or 0.5

-- Infinity Stamina
local infinityStaminaActive = false
local staminaThread = nil

local function EnableInfinityStamina()
    infinityStaminaActive = true
    staminaThread = task.spawn(function()
        while infinityStaminaActive do
            task.wait(0.005)
            sprintModule.MaxStamina = maxStaminaValue
            sprintModule.SprintSpeed = sprintSpeedValue
            sprintModule.StaminaGain = staminaGainValue
            sprintModule.StaminaDrain = staminaDrainValue
            sprintModule.StaminaRegenDelay = regenDelayValue
            sprintModule.Stamina = sprintModule.MaxStamina
        end
    end)
end

local function DisableInfinityStamina()
    infinityStaminaActive = false
    if staminaThread then
        task.cancel(staminaThread)
        staminaThread = nil
    end
end

local function ResetStaminaSettings()
    maxStaminaValue = defaultMaxStamina
    sprintSpeedValue = defaultSprintSpeed
    staminaGainValue = defaultStaminaGain
    staminaDrainValue = defaultStaminaDrain
    regenDelayValue = defaultRegenDelay

    sprintModule.MaxStamina = maxStaminaValue
    sprintModule.SprintSpeed = sprintSpeedValue
    sprintModule.StaminaGain = staminaGainValue
    sprintModule.StaminaDrain = staminaDrainValue
    sprintModule.StaminaRegenDelay = regenDelayValue
end

-- GUI
Tabs.Stamina_Settings:Toggle({
    Title = "无限体力",
    Default = false,
    Callback = function(state)
        if state then
            EnableInfinityStamina()
        else
            DisableInfinityStamina()
        end
    end
})

Tabs.Stamina_Settings:Slider({
    Title = "最大体力,
    Step = 1,
    Value = {Min = 1, Max = 500, Default = maxStaminaValue},
    Suffix = " Max",
    Callback = function(val)
        maxStaminaValue = tonumber(val) or defaultMaxStamina
        sprintModule.MaxStamina = maxStaminaValue
        if not infinityStaminaActive and sprintModule.Stamina > maxStaminaValue then
            sprintModule.Stamina = maxStaminaValue
        end
    end
})

Tabs.Stamina_Settings:Slider({
    Title = "冲刺速度",
    Step = 1,
    Value = {Min = 1, Max = 40, Default = sprintSpeedValue},
    Suffix = " S",
    Callback = function(val)
        sprintSpeedValue = tonumber(val) or defaultSprintSpeed
        sprintModule.SprintSpeed = sprintSpeedValue
    end
})

Tabs.Stamina_Settings:Slider({
    Title = "体力恢复速度",
    Step = 1,
    Value = {Min = 1, Max = 500, Default = staminaGainValue},
    Suffix = " per sec",
    Callback = function(val)
        staminaGainValue = tonumber(val) or defaultStaminaGain
        sprintModule.StaminaGain = staminaGainValue
    end
})

Tabs.Stamina_Settings:Slider({
    Title = "体力消耗速度",
    Step = 1,
    Value = {Min = 0, Max = 100, Default = staminaDrainValue},
    Suffix = " per sec",
    Callback = function(val)
        staminaDrainValue = tonumber(val) or defaultStaminaDrain
        sprintModule.StaminaDrain = staminaDrainValue
    end
})

Tabs.Stamina_Settings:Slider({
    Title = "恢复速度",
    Step = 0.1,
    Value = {Min = 0, Max = 5, Default = regenDelayValue},
    Suffix = " sec",
    Callback = function(val)
        regenDelayValue = tonumber(val) or defaultRegenDelay
        sprintModule.StaminaRegenDelay = regenDelayValue
    end
})

Tabs.Stamina_Settings:Button({
    Title = "重置为默认",
    Callback = function()
        ResetStaminaSettings()
    end
})

local espKillerActive = false
local killerHighlights = {}
local killerEspThread

local function clearKillerHighlights()
    for _, h in ipairs(killerHighlights) do
        if h and h.Parent then h:Destroy() end
    end
    killerHighlights = {}
end

local function createKillerHighlight(model)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = model
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = model
    table.insert(killerHighlights, highlight)
end

local function updateKillerESP()
    clearKillerHighlights()
    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if not killersFolder then return end
    for _, killer in ipairs(killersFolder:GetChildren()) do
        if killer:IsA("Model") and killer:FindFirstChild("HumanoidRootPart") then
            createKillerHighlight(killer)
        end
    end
end

Tabs.Esp:Toggle({
    Title = "透视杀手",
    Default = false,
    Callback = function(state)
        espKillerActive = state
        if espKillerActive then
            killerEspThread = task.spawn(function()
                while espKillerActive do
                    updateKillerESP()
                    task.wait(5)
                end
            end)
        else
            if killerEspThread then task.cancel(killerEspThread); killerEspThread = nil end
            clearKillerHighlights()
        end
    end
})

local espSurvivorActive = false
local survivorHighlights = {}
local survivorEspThread

local function clearSurvivorHighlights()
    for _, h in ipairs(survivorHighlights) do
        if h and h.Parent then h:Destroy() end
    end
    survivorHighlights = {}
end

local function createSurvivorHighlight(model)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = model
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = model
    table.insert(survivorHighlights, highlight)
end

local function updateSurvivorESP()
    clearSurvivorHighlights()
    local survivorsFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Survivors")
    if not survivorsFolder then return end
    for _, survivor in ipairs(survivorsFolder:GetChildren()) do
        if survivor:IsA("Model") and survivor:FindFirstChild("HumanoidRootPart") then
            createSurvivorHighlight(survivor)
        end
    end
end

Tabs.Esp:Toggle({
    Title = "透视幸存者",
    Default = false,
    Callback = function(state)
        espSurvivorActive = state
        if espSurvivorActive then
            survivorEspThread = task.spawn(function()
                while espSurvivorActive do
                    updateSurvivorESP()
                    task.wait(5)
                end
            end)
        else
            if survivorEspThread then task.cancel(survivorEspThread); survivorEspThread = nil end
            clearSurvivorHighlights()
        end
    end
})

-- ESP ITEMS 
-- // РќР°СЃС‚СЂРѕР№РєРё
local espEnabledMedkit = false
local espEnabledBloxy = false

-- // Р¤СѓРЅРєС†РёРё РѕС‡РёСЃС‚РєРё
local function clearESP(name)
    for _, item in ipairs(workspace:GetDescendants()) do
        if item.Name == name and (item:IsA("BasePart") or item:IsA("Model")) then
            local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart")
            if part and part:FindFirstChild("ItemHighlight") then
                part.ItemHighlight:Destroy()
            end
        end
    end
end

-- // РћСЃРЅРѕРІРЅРѕР№ ESP Р°РїРґРµР№С‚РµСЂ
local function updateESP()
    for _, item in ipairs(workspace:GetDescendants()) do
        local part = nil
        if item:IsA("BasePart") then
            part = item
        elseif item:IsA("Model") then
            part = item:FindFirstChildWhichIsA("BasePart")
        end

        if part then
            if item.Name == "Medkit" and espEnabledMedkit and not part:FindFirstChild("ItemHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ItemHighlight"
                highlight.FillColor = Color3.fromRGB(255, 105, 180) -- СЂРѕР·РѕРІС‹Р№
                highlight.OutlineColor = Color3.fromRGB(255, 105, 180)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Adornee = part:IsA("Model") and item or part
                highlight.Parent = part
            elseif item.Name == "BloxyCola" and espEnabledBloxy and not part:FindFirstChild("ItemHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ItemHighlight"
                highlight.FillColor = Color3.fromRGB(0, 150, 255) -- СЃРёРЅРёР№
                highlight.OutlineColor = Color3.fromRGB(0, 150, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Adornee = part:IsA("Model") and item or part
                highlight.Parent = part
            end
        end
    end
end

-- // РџРѕС‚РѕРєРё
local medkitEspThread = nil
local bloxyEspThread = nil

-- // РЎРѕР·РґР°РЅРёРµ Toggles С‡РµСЂРµР· WindUI
Tabs.Esp:Toggle({
    Title = "透视医疗包",
    Default = false,
    Callback = function(state)
        espEnabledMedkit = state
        if espEnabledMedkit then
            medkitEspThread = task.spawn(function()
                while espEnabledMedkit do
                    updateESP()
                    task.wait(2)
                end
            end)
        else
            if medkitEspThread then
                task.cancel(medkitEspThread)
                medkitEspThread = nil
            end
            clearESP("Medkit")
        end
    end
})

Tabs.Esp:Toggle({
    Title = "透视Bloxy可乐道具",
    Default = false,
    Callback = function(state)
        espEnabledBloxy = state
        if espEnabledBloxy then
            bloxyEspThread = task.spawn(function()
                while espEnabledBloxy do
                    updateESP()
                    task.wait(2)
                end
            end)
        else
            if bloxyEspThread then
                task.cancel(bloxyEspThread)
                bloxyEspThread = nil
            end
            clearESP("BloxyCola")
        end
    end
})

--ESP BACK OF THE KILLER 
Tabs.Esp:Button({
    Title = "透视杀手背部（双倍效果）",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/4d4uHMdH"))()
        WindUI:Notify({ Title = "Hiii", Content = "hi from bublik6241", Duration = 2 })
    end
})

local espGeneratorsActive = false
local generatorHighlights = {}
local generatorEspThread

local function clearGeneratorHighlights()
    for _, h in ipairs(generatorHighlights) do
        if h and h.Parent then h:Destroy() end
    end
    generatorHighlights = {}
end

local function createGeneratorHighlight(target)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = target
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = target
    table.insert(generatorHighlights, highlight)
end

local function updateGeneratorESP()
    clearGeneratorHighlights()
    -- РС‰РµРј РІРѕ РІСЃРµР№ РёРіСЂРѕРІРѕР№ РѕР±Р»Р°СЃС‚Рё, Р° РЅРµ РїРѕ РєРѕРЅРєСЂРµС‚РЅРѕРјСѓ РїСѓС‚Рё
    for _, item in ipairs(Workspace:GetDescendants()) do
        -- РСЃРїРѕР»СЊР·СѓРµРј string.find РґР»СЏ РїРѕРёСЃРєР° РїРѕ С‡Р°СЃС‚Рё РёРјРµРЅРё
        if item.Name:find("Generator") then
            if (item:IsA("Model") and item.PrimaryPart) or item:IsA("BasePart") then
                createGeneratorHighlight(item)
            end
        end
    end
end

Tabs.Esp:Toggle({
    Title = "透视发电机",
    Default = false,
    Callback = function(state)
        espGeneratorsActive = state
        if espGeneratorsActive then
            generatorEspThread = task.spawn(function()
                while espGeneratorsActive do
                    updateGeneratorESP()
                    task.wait(20)
                end
            end)
        else
            if generatorEspThread then task.cancel(generatorEspThread); generatorEspThread = nil end
            clearGeneratorHighlights()
        end
    end
})

Players.PlayerAdded:Connect(function()
    Tabs.Main:SetDropdownValues("Р’С‹Р±РѕСЂ РёРіСЂРѕРєР° РґР»СЏ Orbit", getPlayerNames())
end)

Players.PlayerRemoving:Connect(function()
    Tabs.Main:SetDropdownValues("Р’С‹Р±РѕСЂ РёРіСЂРѕРєР° РґР»СЏ Orbit", getPlayerNames())
end)

local autoBlockOn = false
local detectionRange = 18
local looseFacing = true
local strictRangeOn = true
local windupThreshold = 0.75 -- по умолчанию 75%

local autoBlockTriggerAnims = {
    "126830014841198", "126355327951215", "121086746534252", "18885909645",
    "98456918873918", "105458270463374", "83829782357897", "125403313786645",
    "118298475669935", "82113744478546", "70371667919898", "99135633258223",
    "97167027849946", "109230267448394", "139835501033932", "126896426760253",
    "109667959938617", "126681776859538", "129976080405072", "121293883585738",
    "81639435858902", "137314737492715",
    "92173139187970"
}

local function isFacing(localRoot, targetRoot)
    local dir = (localRoot.Position - targetRoot.Position).Unit
    local dot = targetRoot.CFrame.LookVector:Dot(dir)
    return looseFacing and dot > -0.3 or dot > 0
end

local function fireRemoteBlock()
    local args = {
        "UseActorAbility",
        {
            buffer.fromstring("\"Block\"")
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end

local blockConnection = nil

local function startAutoBlock()
    blockConnection = RunService.Heartbeat:Connect(function()
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        local humanoid = myChar:FindFirstChildOfClass("Humanoid")
        if not myRoot or not humanoid then return end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local animTracks = hum and hum:FindFirstChildOfClass("Animator") and hum:FindFirstChildOfClass("Animator"):GetPlayingAnimationTracks()
                if hrp and (hrp.Position - myRoot.Position).Magnitude <= detectionRange then
                    for _, track in ipairs(animTracks or {}) do
                        local id = tostring(track.Animation.AnimationId):match("%d+")
                        if table.find(autoBlockTriggerAnims, id) then
                            local progress = track.TimePosition / track.Length
                            if progress < windupThreshold then -- проверка процента Windup
                                if autoBlockOn and (not strictRangeOn or (hrp.Position - myRoot.Position).Magnitude <= detectionRange) then
                                    if isFacing(myRoot, hrp) then
                                        fireRemoteBlock()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function stopAutoBlock()
    if blockConnection then
        blockConnection:Disconnect()
        blockConnection = nil
    end
end

Tabs.AutoBlock:Toggle({
    Title = "自动格挡（带动画）",
    Default = false,
    Callback = function(state)
        autoBlockOn = state
        if state then
            startAutoBlock()
            WindUI:Notify({ Title = "Auto Block", Content = "Enabled!", Duration = 1 })
        else
            stopAutoBlock()
            WindUI:Notify({ Title = "自动拦截", Content = "已禁用!", Duration = 1 })
        end
    end
})

Tabs.AutoBlock:Slider({
    Title = "检测范围（动画）",
    Step = 1,
    Value = {Min = 1, Max = 50, Default = detectionRange},
    Suffix = " studs",
    Callback = function(val)
        detectionRange = tonumber(val) or detectionRange
    end
})

-- Новый слайдер для настройки процента Windup
Tabs.AutoBlock:Slider({
    Title = "蓄力进度",
    Step = 5,
    Value = {Min = 1, Max = 100, Default = 75},
    Suffix = "%",
    Callback = function(val)
        windupThreshold = (tonumber(val) or 75) / 100
    end
})

-- AUDIO AAAAAAAAAAAAAAAAAAAAAAAAAAERM
-- FIXED 

Tabs.AutoBlock:Button({
    Title = "加载自动格挡（音效）",
    Callback = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")

        local lp = Players.LocalPlayer

        -- Состояния
        local autoBlockAudioOn = false
        local detectionRange = 20
        local detectionRangeSq = detectionRange * detectionRange
        local cachedCooldown = nil
        local currentMode = "Normal"
        local zoneVisibility = 0.4 
        local runZoneBoost = 4     
        local zoneLength = 12      
        local zoneWidth = 6        
        
        --- НОВОЕ: Длительность отслеживания атаки в секундах ---
        local monitorDuration = 0.6 -- Будем отслеживать атаку в течение 0.6 секунды после начала звука

        --- НОВОЕ: Таблица для активных атак, которые нужно отслеживать ---
        local activeAttacks = {}

        -- Список ID звуков (атаки)
        local autoBlockTriggerSounds = {
            ["102228729296384"] = true, ["140242176732868"] = true, ["112809109188560"] = true,
            ["136323728355613"] = true, ["115026634746636"] = true, ["84116622032112"] = true,
            ["108907358619313"] = true, ["127793641088496"] = true, ["86174610237192"] = true,
            ["95079963655241"] = true, ["101199185291628"] = true, ["119942598489800"] = true,
            ["84307400688050"] = true, ["113037804008732"] = true, ["105200830849301"] = true,
            ["75330693422988"] = true, ["82221759983649"] = true, ["81702359653578"] = true,
            ["108610718831698"] = true, ["112395455254818"] = true, ["109431876587852"] = true,
            ["109348678063422"] = true, ["85853080745515"] = true, ["12222216"] = true
        }

        local soundHooks = {}

        -- Хелпер для блока (НОВЫЙ RemoteEvent вызов)
        local function fireRemoteBlock()
            local args = {
                "UseActorAbility",
                {
                    buffer.fromstring("\"Block\"")
                }
            }
            ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        end

        local function isFacing(localRoot, targetRoot)
            local dir = (localRoot.Position - targetRoot.Position).Unit
            local dot = targetRoot.CFrame.LookVector:Dot(dir)
            return dot > -0.3
        end

        local function extractNumericSoundId(sound)
            if not sound or not sound.SoundId then return nil end
            return tostring(sound.SoundId):match("%d+")
        end

        local function getCharacterFromDescendant(inst)
            if not inst then return nil end
            local model = inst:FindFirstAncestorOfClass("Model")
            if model and model:FindFirstChildOfClass("Humanoid") then return model end
            return nil
        end
        
        local function refreshUIRefs()
            local playerGui = lp:FindFirstChild("PlayerGui")
            if not playerGui then return end
            local main = playerGui:FindFirstChild("MainUI")
            if main then
                local ability = main:FindFirstChild("AbilityContainer")
                local blockBtn = ability and ability:FindFirstChild("Block")
                cachedCooldown = blockBtn and blockBtn:FindFirstChild("CooldownTime")
            else
                cachedCooldown = nil
            end
        end

        -- === Создание зоны (для Anti Bait) ===
        local function createZoneForKiller(killer)
            if not killer:FindFirstChild("HumanoidRootPart") then return end
            if killer:FindFirstChild("BlockZone") then return end

            local hrp = killer.HumanoidRootPart
            local zone = Instance.new("Part")
            zone.Name = "BlockZone"
            zone.Anchored = false
            zone.CanCollide = false
            zone.Size = Vector3.new(zoneWidth, 7, zoneLength)
            zone.CFrame = hrp.CFrame * CFrame.new(0, 0, -4)
            zone.BrickColor = BrickColor.new("Royal purple")
            zone.Transparency = 1
            zone.Parent = killer

            local weld = Instance.new("WeldConstraint")
            weld.Part0 = hrp
            weld.Part1 = zone
            weld.Parent = zone

            local highlight = Instance.new("Highlight")
            highlight.Name = "ZoneHighlight"
            highlight.Adornee = zone
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = Color3.fromRGB(180, 0, 255)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Enabled = false
            highlight.Parent = zone
        end

        -- === Динамическое обновление размера зоны ===
        local function updateZoneSize(killer)
            local zone = killer:FindFirstChild("BlockZone")
            local hum = killer:FindFirstChildOfClass("Humanoid")
            
            if zone and hum then
                local baseSize = Vector3.new(zoneWidth, 7, zoneLength)
                if hum.MoveDirection.Magnitude > 0.1 then
                    zone.Size = Vector3.new(baseSize.X, baseSize.Y, baseSize.Z + runZoneBoost)
                else
                    zone.Size = baseSize
                end
            end
        end

        -- === Логика блока (с мониторингом) ===

        local function registerAttackForMonitoring(sound)
            if not autoBlockAudioOn or not sound or not sound:IsA("Sound") or not sound.IsPlaying then return end
            if activeAttacks[sound] then return end

            local id = extractNumericSoundId(sound)
            if not id or not autoBlockTriggerSounds[id] then return end

            local myChar = lp.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            local soundPart = sound.Parent
            if not (soundPart and soundPart.Parent) then return end
            
            local char = getCharacterFromDescendant(soundPart)
            local plr = char and Players:GetPlayerFromCharacter(char)
            if not plr or plr == lp then return end

            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local dvec = hrp.Position - myRoot.Position
            if dvec:Dot(dvec) > detectionRangeSq then return end
            
            activeAttacks[sound] = {
                killer = char,
                endTime = tick() + monitorDuration
            }
        end

        local function monitorActiveAttacks()
            if not autoBlockAudioOn or next(activeAttacks) == nil then return end

            local myChar = lp.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            
            if cachedCooldown and cachedCooldown.Text ~= "" then
                activeAttacks = {}
                return
            end

            local t = tick()

            for sound, attackData in pairs(activeAttacks) do
                if not sound or sound.Parent == nil or t > attackData.endTime then
                    activeAttacks[sound] = nil
                    continue
                end
                
                local killerChar = attackData.killer
                if not killerChar or killerChar.Parent == nil then
                    activeAttacks[sound] = nil
                    continue
                end

                local killerRoot = killerChar:FindFirstChild("HumanoidRootPart")
                local killerZone = killerChar:FindFirstChild("BlockZone")
                if not killerRoot then
                    activeAttacks[sound] = nil
                    continue
                end

                if isFacing(myRoot, killerRoot) then
                    if currentMode == "Normal" then
                        fireRemoteBlock()
                        activeAttacks = {}
                        break
                    elseif currentMode == "Normal+Anti Bait" and killerZone then
                        local touchingZone = (myRoot.Position - killerZone.Position).Magnitude <= (killerZone.Size.Magnitude / 2 + 2)
                        if touchingZone then
                            fireRemoteBlock()
                            activeAttacks = {}
                            break
                        end
                    end
                end
            end
        end

        local function hookSound(sound)
            if not sound or not sound:IsA("Sound") or soundHooks[sound] then return end

            local playedConn = sound.Played:Connect(function() pcall(registerAttackForMonitoring, sound) end)
            local propConn = sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
                if sound.IsPlaying then pcall(registerAttackForMonitoring, sound) end
            end)
            
            local destroyConn
            destroyConn = sound.Destroying:Connect(function()
                if playedConn and playedConn.Connected then playedConn:Disconnect() end
                if propConn and propConn.Connected then propConn:Disconnect() end
                if destroyConn and destroyConn.Connected then destroyConn:Disconnect() end
                soundHooks[sound] = nil
                activeAttacks[sound] = nil
            end)

            soundHooks[sound] = {playedConn, propConn, destroyConn}

            if sound.IsPlaying then
                task.spawn(function() pcall(registerAttackForMonitoring, sound) end)
            end
        end
        
        local function updateZonesVisibility()
            local killersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
            for _, killer in ipairs(killersFolder:GetChildren()) do
                local zone = killer:FindFirstChild("BlockZone")
                if zone then
                    local hl = zone:FindFirstChild("ZoneHighlight")
                    if currentMode == "Normal" then
                        zone.Transparency = 1
                        if hl then hl.Enabled = false end
                    elseif currentMode == "Normal+Anti Bait" then
                        zone.Transparency = zoneVisibility
                        if hl then hl.Enabled = true end
                    end
                end
            end
        end

        task.spawn(function()
            while task.wait(5) do
                if not autoBlockAudioOn then continue end
                local killersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
                for _, killer in ipairs(killersFolder:GetChildren()) do
                    createZoneForKiller(killer)
                end
                updateZonesVisibility()
            end
        end)

        RunService.Heartbeat:Connect(function()
            if not autoBlockAudioOn then return end
            local killersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
            for _, killer in ipairs(killersFolder:GetChildren()) do
                updateZoneSize(killer)
            end
            monitorActiveAttacks()
        end)

        lp.CharacterAdded:Connect(function()
            task.delay(0.5, refreshUIRefs)
        end)
        refreshUIRefs()

        for _, desc in ipairs(game:GetDescendants()) do
            if desc:IsA("Sound") then pcall(hookSound, desc) end
        end
        game.DescendantAdded:Connect(function(desc)
            if desc:IsA("Sound") then pcall(hookSound, desc) end
        end)

        -- GUI
        Tabs.AutoBlock:Toggle({
            Title = "自动格挡（音效）",
            Default = autoBlockAudioOn,
            Callback = function(state)
                autoBlockAudioOn = state
            end
        })

        Tabs.AutoBlock:Slider({
            Title = "检测范围（音效）",
            Step = 1,
            Value = {Min = 1, Max = 100, Default = detectionRange},
            Suffix = " studs",
            Callback = function(val)
                detectionRange = val
                detectionRangeSq = val * val
            end
        })

        Tabs.AutoBlock:Dropdown({
            Title = "自动格挡模式",
            Values = {"Normal", "Normal+Anti Bait"},
            Value = "Normal",
            Multi = false,
            AllowNone = false,
            Callback = function(choice)
                currentMode = choice
                updateZonesVisibility()
            end
        })
        
        Tabs.AutoBlock:Slider({
            Title = "攻击验证持续时间",
            Step = 0.1,
            Value = {Min = 0.1, Max = 2.0, Default = 0.6},
            Suffix = " sec",
            Callback = function(val)
                monitorDuration = val
            end
        })

        Tabs.AutoBlock:Slider({
            Title = "区域可见性",
            Step = 1,
            Value = {Min = 0, Max = 10, Default = 6},
            Suffix = " /10",
            Callback = function(val)
                zoneVisibility = 1 - (val / 10)
                updateZonesVisibility()
            end
        })

        Tabs.AutoBlock:Slider({
            Title = "区域长度",
            Step = 0.1,
            Value = {Min = 1, Max = 30, Default = 12},
            Suffix = " studs",
            Callback = function(val)
                zoneLength = val
            end
        })

        Tabs.AutoBlock:Slider({
            Title = "区域宽度",
            Step = 0.1,
            Value = {Min = 1, Max = 15, Default = 6},
            Suffix = " studs",
            Callback = function(val)
                zoneWidth = val
            end
        })

        Tabs.AutoBlock:Slider({
            Title = "区域增益（如果屠夫延迟高或者你延迟很高）",
            Step = 1,
            Value = {Min = 0, Max = 10, Default = 4},
            Suffix = " studs",
            Callback = function(val)
                runZoneBoost = val
            end
        })
    end
})

-- punch 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local autoPunchOn = false
local flingPunchOn = false
local flingPower = 5000000
local aimPunch = true -- включи предиктивный поворот
local hiddenfling = false

local punchConnection = nil
local flingConnection = nil

-- === FLING LOOP ===
local function startFlingLoop()
    if flingConnection then return end
    flingConnection = RunService.Heartbeat:Connect(function()
        if hiddenfling then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.Velocity
                hrp.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
                task.wait()
                hrp.Velocity = vel
                task.wait()
                hrp.Velocity = vel + Vector3.new(0, 0.1, 0)
            end
        end
    end)
end

local function stopFlingLoop()
    if flingConnection then
        flingConnection:Disconnect()
        flingConnection = nil
    end
end

-- fling цикл: 3 сек вкл, 1 сек выкл
local function punchFlingCycle()
    task.spawn(function()
        while flingPunchOn do
            hiddenfling = true
            task.wait(3)
            hiddenfling = false
            task.wait(1)
        end
    end)
end

-- === Функция предсказания позиции ===
local function predictPosition(targetRoot, myPing)
    local velocity = targetRoot.Velocity
    local latency = myPing / 1000 -- перевод мс в сек
    local lookVec = targetRoot.CFrame.LookVector * 5 -- влияние направления (5 – множитель)
    local predicted = targetRoot.Position + (velocity * latency) + lookVec
    return predicted
end

-- === AUTO PUNCH ===
local function startAutoPunch()
    startFlingLoop()
    if flingPunchOn then
        punchFlingCycle()
    end

    punchConnection = RunService.Heartbeat:Connect(function()
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local gui = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("MainUI")
        local punchBtn = gui and gui:FindFirstChild("AbilityContainer") and gui.AbilityContainer:FindFirstChild("Punch")
        local charges = punchBtn and punchBtn:FindFirstChild("Charges")

        if not (punchBtn and charges and charges.Text == "1") then return end

        -- === Сначала Killers ===
        local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
        if killersFolder then
            for _, killer in ipairs(killersFolder:GetChildren()) do
                local root = killer:FindFirstChild("HumanoidRootPart")
                if root and (root.Position - myRoot.Position).Magnitude <= 12 then
                    if aimPunch then
                        local ping = math.max(LocalPlayer:GetNetworkPing() * 1000, 50) -- в мс
                        local predictedPos = predictPosition(root, ping)

                        -- моментально поворачиваем игрока
                        myRoot.CFrame = CFrame.lookAt(myRoot.Position, predictedPos)
                        task.delay(1, function()
                            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                local forward = myRoot.CFrame.LookVector
                                myRoot.CFrame = CFrame.lookAt(myRoot.Position, myRoot.Position + forward)
                            end
                        end)
                    end

                    for _, conn in ipairs(getconnections(punchBtn.MouseButton1Click)) do
                        pcall(function() conn:Fire() end)
                    end
                    return -- ударили Killers, выходим
                end
            end
        end

        -- === Если Killers нет, ищем игроков ===
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root and (root.Position - myRoot.Position).Magnitude <= 10 then
                    if aimPunch then
                        local ping = math.max(LocalPlayer:GetNetworkPing() * 1000, 50)
                        local predictedPos = predictPosition(root, ping)

                        myRoot.CFrame = CFrame.lookAt(myRoot.Position, predictedPos)
                        task.delay(1, function()
                            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                local forward = myRoot.CFrame.LookVector
                                myRoot.CFrame = CFrame.lookAt(myRoot.Position, myRoot.Position + forward)
                            end
                        end)
                    end

                    for _, conn in ipairs(getconnections(punchBtn.MouseButton1Click)) do
                        pcall(function() conn:Fire() end)
                    end
                    break
                end
            end
        end
    end)
end

local function stopAutoPunch()
    if punchConnection then
        punchConnection:Disconnect()
        punchConnection = nil
    end
    stopFlingLoop()
    hiddenfling = false
end

-- === Toggle ===
Tabs.AutoBlock:Toggle({
    Title = "自动拳击+投掷（锁定状态下无效）",
    Default = false,
    Callback = function(state)
        autoPunchOn = state
        if state then
            startAutoPunch()
        else
            stopAutoPunch()
        end
    end
})

-- === Slider для flingPower ===
Tabs.AutoBlock:Slider({
    Title = "投掷力",
    Step = 100000,
    Value = {Min = 100000, Max = 20000000, Default = flingPower},
    Suffix = " power",
    Callback = function(val)
        flingPower = tonumber(val)
    end
})

-- Block TP
local blockTPEnabled = false
local lastBlockTpTime = 0

-- Toggle
Tabs.AutoBlock:Toggle({
    Title = "阻止TP",
    Default = false,
    Callback = function(state)
        blockTPEnabled = state
    end
})

RunService.RenderStepped:Connect(function()
    if blockTPEnabled and Humanoid and tick() - lastBlockTpTime >= 5 then
        for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
            local animId = tostring(track.Animation.AnimationId):match("%d+")
            if animId == "72722244508749" or animId == "96959123077498" then
                local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    local killers = {"c00lkidd", "Jason", "JohnDoe", "1x1x1x1", "Noli", "Slasher"}
                    for _, name in ipairs(killers) do
                        local killer = workspace:FindFirstChild("Players")
                            and workspace.Players:FindFirstChild("Killers")
                            and workspace.Players.Killers:FindFirstChild(name)

                        if killer and killer:FindFirstChild("HumanoidRootPart") then
                            lastBlockTpTime = tick()

                            task.spawn(function()
                                local startTime = tick()
                                while tick() - startTime < 0.5 do
                                    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                                        local myRoot = lp.Character.HumanoidRootPart
                                        local targetHRP = killer.HumanoidRootPart
                                        local direction = targetHRP.CFrame.LookVector
                                        local tpPosition = targetHRP.Position + direction * 4
                                        myRoot.CFrame = CFrame.new(tpPosition)
                                    end
                                    task.wait()
                                end
                            end)
                            break
                        end
                    end
                end
                break
            end
        end
    end
end)


--  AUTO CLON 

Tabs.AutoBlock:Button({
    Title = "加载自动克隆（自动克隆 007n7)",
    Callback = function()
    
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer

local autoBlockAudioOn = false
local cachedCooldown = nil

local detectionRange = 20
local detectionRangeSq = detectionRange * detectionRange

local autoBlockTriggerSounds = {
    ["102228729296384"] = true, ["140242176732868"] = true, ["112809109188560"] = true,
    ["136323728355613"] = true, ["115026634746636"] = true, ["84116622032112"] = true,
    ["108907358619313"] = true, ["127793641088496"] = true, ["86174610237192"] = true,
    ["95079963655241"] = true, ["101199185291628"] = true, ["119942598489800"] = true,
    ["84307400688050"] = true, ["113037804008732"] = true, ["105200830849301"] = true,
    ["75330693422988"] = true, ["82221759983649"] = true, ["81702359653578"] = true,
    ["108610718831698"] = true, ["112395455254818"] = true, ["109431876587852"] = true,
    ["109348678063422"] = true, ["85853080745515"] = true, ["12222216"] = true
}

local soundHooks = {}
local soundBlockedUntil = {}

-- 🔥 Новый RemoteEvent вызов
local function fireRemoteBlock()
    local remote = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
    local args = {
        "UseActorAbility",
        {
            buffer.fromstring("\"Clone\"")
        }
    }
    remote:FireServer(unpack(args))
end

local function isFacing(localRoot, targetRoot)
    local dir = (localRoot.Position - targetRoot.Position).Unit
    local dot = targetRoot.CFrame.LookVector:Dot(dir)
    return dot > -0.3
end

local function extractNumericSoundId(sound)
    if not sound or not sound.SoundId then return nil end
    local sid = tostring(sound.SoundId)
    local num = sid:match("%d+")
    if num then return num end
    return nil
end

local function getSoundWorldPosition(sound)
    if not sound then return nil end
    if sound.Parent and sound.Parent:IsA("BasePart") then
        return sound.Parent.Position, sound.Parent
    end
    if sound.Parent and sound.Parent:IsA("Attachment") and sound.Parent.Parent and sound.Parent.Parent:IsA("BasePart") then
        return sound.Parent.Parent.Position, sound.Parent.Parent
    end
    local found = sound.Parent and sound.Parent:FindFirstChildWhichIsA("BasePart", true)
    if found then
        return found.Position, found
    end
    return nil, nil
end

local function getCharacterFromDescendant(inst)
    if not inst then return nil end
    local model = inst:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then
        return model
    end
    return nil
end

local function refreshUIRefs()
    local playerGui = lp:FindFirstChild("PlayerGui")
    if not playerGui then return end
    local main = playerGui:FindFirstChild("MainUI")
    if main then
        local ability = main:FindFirstChild("AbilityContainer")
        local blockBtn = ability and ability:FindFirstChild("Block")
        cachedCooldown = blockBtn and blockBtn:FindFirstChild("CooldownTime")
    else
        cachedCooldown = nil
    end
end

local function attemptBlockForSound(sound)
    if not autoBlockAudioOn or not sound or not sound:IsA("Sound") or not sound.IsPlaying then return end

    local id = extractNumericSoundId(sound)
    if not id or not autoBlockTriggerSounds[id] then return end

    local t = tick()
    if soundBlockedUntil[sound] and t < soundBlockedUntil[sound] then return end

    local myChar = lp.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local soundPos, soundPart = getSoundWorldPosition(sound)
    if not soundPos or not soundPart then return end

    local char = getCharacterFromDescendant(soundPart)
    local plr = char and Players:GetPlayerFromCharacter(char)
    if not plr or plr == lp then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local dvec = hrp.Position - myRoot.Position
    if dvec:Dot(dvec) > detectionRangeSq then return end

    if cachedCooldown and cachedCooldown.Text ~= "" then return end

    if not isFacing(myRoot, hrp) then return end

    fireRemoteBlock()
    soundBlockedUntil[sound] = t + 1.2
end

local function hookSound(sound)
    if not sound or not sound:IsA("Sound") or soundHooks[sound] then return end

    local playedConn = sound.Played:Connect(function() pcall(attemptBlockForSound, sound) end)
    local propConn = sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
        if sound.IsPlaying then pcall(attemptBlockForSound, sound) end
    end)
    local destroyConn
    destroyConn = sound.Destroying:Connect(function()
        if playedConn and playedConn.Connected then playedConn:Disconnect() end
        if propConn and propConn.Connected then propConn:Disconnect() end
        if destroyConn and destroyConn.Connected then destroyConn:Disconnect() end
        soundHooks[sound] = nil
        soundBlockedUntil[sound] = nil
    end)

    soundHooks[sound] = {playedConn, propConn, destroyConn}

    if sound.IsPlaying then
        task.spawn(function() pcall(attemptBlockForSound, sound) end)
    end
end

lp.CharacterAdded:Connect(function()
    task.delay(0.5, refreshUIRefs)
end)
refreshUIRefs()

for _, desc in ipairs(game:GetDescendants()) do
    if desc:IsA("Sound") then pcall(hookSound, desc) end
end
game.DescendantAdded:Connect(function(desc)
    if desc:IsA("Sound") then pcall(hookSound, desc) end
end)

Tabs.AutoBlock:Toggle({
    Title = "Auto Clon (Auto Clon 007n7)",
    Default = autoBlockAudioOn,
    Callback = function(state)
        autoBlockAudioOn = state
    end
})

Tabs.AutoBlock:Slider({
    Title = "检测范围（自动克隆007n7)",
    Step = 1,
    Value = {Min = 1, Max = 100, Default = detectionRange},
    Suffix = " studs",
    Callback = function(val)
        detectionRange = val
        detectionRangeSq = val * val
    end
})

end
})

local TextChatService = game:GetService("TextChatService")

Tabs.Misc:Button({
    Title = "聊天可见性",
    Callback = function()
        if TextChatService:FindFirstChild("ChatWindowConfiguration") and TextChatService:FindFirstChild("ChatInputBarConfiguration") then
            TextChatService.ChatWindowConfiguration.Enabled = true
            TextChatService.ChatInputBarConfiguration.Enabled = true
            print("Р§Р°С‚ РІРєР»СЋС‡С‘РЅ!")
        else
            warn("ChatWindowConfiguration РёР»Рё ChatInputBarConfiguration РЅРµ РЅР°Р№РґРµРЅС‹!")
        end
    end
})

local fullbrightActive = false
local originalSettings = {}

local function applyFullbright()
    if not fullbrightActive then return end
    Lighting.Ambient = Color3.new(1,1,1)
    Lighting.OutdoorAmbient = Color3.new(1,1,1)
    Lighting.Brightness = 2
    Lighting.ClockTime = 12
end

local function revertFullbright()
    if originalSettings.Ambient then
        Lighting.Ambient = originalSettings.Ambient
        Lighting.OutdoorAmbient = originalSettings.OutdoorAmbient
        Lighting.Brightness = originalSettings.Brightness
        Lighting.ClockTime = originalSettings.ClockTime
    end
end

Tabs.Misc:Toggle({
    Title = "全亮",
    Default = false,
    Callback = function(state)
        fullbrightActive = state
        if fullbrightActive then
            if not originalSettings.Ambient then
                originalSettings.Ambient = Lighting.Ambient
                originalSettings.OutdoorAmbient = Lighting.OutdoorAmbient
                originalSettings.Brightness = Lighting.Brightness
                originalSettings.ClockTime = Lighting.ClockTime
            end
            applyFullbright()
        else
            revertFullbright()
        end
    end
})

local antiFogActive = false
local disabledFogElements = {}

Tabs.Misc:Toggle({
    Title = "防雾",
    Default = false,
    Callback = function(state)
        antiFogActive = state
        if antiFogActive then
            disabledFogElements = {}
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("Atmosphere") or v:IsA("Sky") then
                    table.insert(disabledFogElements, v)
                    v.Parent = nil
                end
            end
        else
            for _, v in ipairs(disabledFogElements) do
                if v then
                    v.Parent = Lighting
                end
            end
            disabledFogElements = {}
        end
    end
})

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local ActiveRemoveEffects = false
local removeEffectsLoop

-- РЎРїРёСЃРѕРє РёР·РІРµСЃС‚РЅС‹С… СЌС„С„РµРєС‚РѕРІ
local effectNames = {
    "BlurEffect", "ColorCorrectionEffect", "BloomEffect", "SunRaysEffect", 
    "DepthOfFieldEffect", "ScreenFlash", "HitEffect", "DamageOverlay", 
    "BloodEffect", "Vignette", "BlackScreen", "WhiteScreen", "ShockEffect",
    "Darkness", "JumpScare", "LowHealthOverlay", "Flashbang", "FadeEffect"
}

local effectClasses = {
    "BlurEffect",
    "BloomEffect",
    "SunRaysEffect",
    "DepthOfFieldEffect",
    "ColorCorrectionEffect"
}

local function removeEffects()
    -- РЈР±РёСЂР°РµРј СЌС„С„РµРєС‚С‹ РёР· Lighting
    for _, obj in pairs(Lighting:GetDescendants()) do
        if table.find(effectNames, obj.Name) or table.find(effectClasses, obj.ClassName) then
            obj:Destroy()
        end
    end

    -- РЈР±РёСЂР°РµРј GUI-РѕРІРµСЂР»РµРё
    for _, obj in pairs(PlayerGui:GetDescendants()) do
        if table.find(effectNames, obj.Name) then
            obj:Destroy()
        elseif obj:IsA("ScreenGui") or obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
            if obj:FindFirstChildWhichIsA("ImageLabel") or obj:FindFirstChildWhichIsA("Frame") then
                if table.find(effectNames, obj.Name) or obj.Name:lower():find("overlay") or obj.Name:lower():find("effect") then
                    obj:Destroy()
                end
            end
        end
    end
end

Tabs.Misc:Toggle({
    Title = "移除效果",
    Default = true,
    Callback = function(state)
        ActiveRemoveEffects = state
        if state then
            if removeEffectsLoop then
                task.cancel(removeEffectsLoop)
                removeEffectsLoop = nil
            end
            removeEffectsLoop = task.spawn(function()
                while ActiveRemoveEffects do
                    removeEffects()
                    task.wait(0.5)
                end
            end)
        else
            if removeEffectsLoop then
                task.cancel(removeEffectsLoop)
                removeEffectsLoop = nil
            end
        end
    end
})

-- ANTI SLOWS 
local Survivors = workspace:WaitForChild("Players"):WaitForChild("Survivors")
local RunService = game:GetService("RunService")

-- Anti-Slow Configs
local AntiSlowConfigs = {
    Slowness = {Values = {"SlowedStatus"}, Connection = nil, Enabled = false},
    Skills = {Values = {"StunningKiller", "EatFriedChicken", "GuestBlocking", "PunchAbility", "SubspaceTripmine",
                        "TaphTripwire", "PlasmaBeam", "SpawnProtection", "c00lgui", "ShootingGun", 
                        "TwoTimeStab", "TwoTimeCrouching", "DrinkingCola", "DrinkingSlateskin", 
                        "SlateskinStatus", "EatingGhostburger"}, Connection = nil, Enabled = false},
    Items = {Values = {"BloxyColaItem", "Medkit"}, Connection = nil, Enabled = false},
    Emotes = {Values = {"Emoting"}, Connection = nil, Enabled = false},
    Builderman = {Values = {"DispenserConstruction", "SentryConstruction"}, Connection = nil, Enabled = false}
}

-- Hide Slowness UI
local function hideSlownessUI()
    local mainUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MainUI")
    if mainUI then
        local statusContainer = mainUI:FindFirstChild("StatusContainer")
        if statusContainer then
            local slownessUI = statusContainer:FindFirstChild("Slowness")
            if slownessUI then
                slownessUI.Visible = false
            end
        end
    end
end

-- Handle Anti-Slow
local function handleAntiSlow(survivor, config)
    if survivor:GetAttribute("Username") ~= game:GetService("Players").LocalPlayer.Name then return end
    local function onRenderStep()
        if not survivor.Parent or not config.Enabled then return end
        local speedMultipliers = survivor:FindFirstChild("SpeedMultipliers")
        if speedMultipliers then
            for _, valName in ipairs(config.Values) do
                local val = speedMultipliers:FindFirstChild(valName)
                if val and val:IsA("NumberValue") and val.Value ~= 1 then
                    val.Value = 1
                end
            end
        end
        hideSlownessUI()
    end

    config.Connection = RunService.RenderStepped:Connect(onRenderStep)
end

-- Start Anti-Slow
local function startAntiSlow(config)
    config.Enabled = true
    for _, survivor in pairs(Survivors:GetChildren()) do
        handleAntiSlow(survivor, config)
    end
    Survivors.ChildAdded:Connect(function(child)
        task.wait(0.1)
        handleAntiSlow(child, config)
    end)
end

-- Stop Anti-Slow
local function stopAntiSlow(config)
    config.Enabled = false
    if config.Connection then
        config.Connection:Disconnect()
        config.Connection = nil
    end
end

Tabs.Misc:Toggle({
    Title = "防减速",
    Default = false,
    Callback = function(state)
        for _, config in pairs(AntiSlowConfigs) do
            if state then
                startAntiSlow(config)
            else
                stopAntiSlow(config)
            end
        end
    end
})

Tabs.Misc:Button({
    Title = "加载不可见性",
    Callback = function()
    
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local animationId = "75804462760596"
local animationSpeed = 0
local loopRunning = false
local loopThread
local currentAnim = nil

function StartInvisibility()
    loopRunning = true
    local speaker = LocalPlayer
    local humanoid = speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.RigType ~= Enum.HumanoidRigType.R6 then return end

    loopThread = task.spawn(function()
        while loopRunning do
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. animationId
            local loadedAnim = humanoid:LoadAnimation(anim)
            currentAnim = loadedAnim
            loadedAnim.Looped = false
            loadedAnim:Play()
            loadedAnim:AdjustSpeed(animationSpeed)
            task.wait(0.000001)
        end
    end)
end

function StopInvisibility()
    loopRunning = false
    if loopThread then
        task.cancel(loopThread)
        loopThread = nil
    end
    if currentAnim then
        currentAnim:Stop()
        currentAnim = nil
    end
    local speaker = LocalPlayer
    local humanoid = speaker.Character and (speaker.Character:FindFirstChildOfClass("Humanoid") or speaker.Character:FindFirstChildOfClass("AnimationController"))
    if humanoid then
        for _, v in pairs(humanoid:GetPlayingAnimationTracks()) do
            v:AdjustSpeed(100000)
        end
    end
    local animateScript = speaker.Character and speaker.Character:FindFirstChild("Animate")
    if animateScript then
        animateScript.Disabled = true
        animateScript.Disabled = false
    end
end

Tabs.Misc:Toggle({
    Title = "隐身（仅限R6）",
    Default = false,
    Callback = function(state)
        if state then
            StartInvisibility()
        else
            StopInvisibility()
        end
    end
})

end
})

--NOLI ANTI WALL CRUSH 
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Remote = game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent

-- Р“Р»РѕР±Р°Р»СЊРЅС‹Рµ РїРµСЂРµРјРµРЅРЅС‹Рµ
getgenv()._oldFireServer = getgenv()._oldFireServer or nil
getgenv()._VoidRushBypass = getgenv()._VoidRushBypass or false -- toggle СЃРѕСЃС‚РѕСЏРЅРёРµ

-- РҐСѓРє СЃС‚Р°РІРёРј С‚РѕР»СЊРєРѕ РѕРґРёРЅ СЂР°Р·
if not getgenv()._oldFireServer then
    local old
    old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if self == Remote and method == "FireServer" then
            if args[1] == LocalPlayer.Name .. "VoidRushCollision" then
                if getgenv()._VoidRushBypass then
                    return -- Р±Р»РѕРєРёСЂСѓРµРј С‚РѕР»СЊРєРѕ РµСЃР»Рё toggle РІРєР»СЋС‡С‘РЅ
                end
            end
        end
        return old(self, ...)
    end)

    getgenv()._oldFireServer = old
end

-- Р”РѕР±Р°РІР»СЏРµРј Toggle РІ GUI
Tabs.Misc:Toggle({
    Title = "VoidRush 无碰撞",
    Default = false,
    Callback = function(state)
        getgenv()._VoidRushBypass = state
    end
})

--NOLI FULL VOID CONTROL 
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local voidrushcontrol = false
local ORIGINAL_DASH_SPEED = 60
local isOverrideActive = false
local connection

-- РџРµСЂРµРјРµРЅРЅС‹Рµ РїРµСЂСЃРѕРЅР°Р¶Р°
local humanoid, rootPart
local function setupCharacter(character)
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end

if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)

Tabs.Misc:Toggle({
    Title = "虚空突袭完全控制（Noli）",
    Default = false,
    Callback = function(state)
        voidrushcontrol = state
    end
})

-- Р¤СѓРЅРєС†РёСЏ СЃС‚Р°СЂС‚Р° РѕРІРµСЂСЂР°Р№РґР°
local function startOverride()
    if isOverrideActive then return end
    isOverrideActive = true

    connection = RunService.RenderStepped:Connect(function()
        if not humanoid or not rootPart then return end

        humanoid.WalkSpeed = ORIGINAL_DASH_SPEED
        humanoid.AutoRotate = false

        local direction = rootPart.CFrame.LookVector
        local horizontal = Vector3.new(direction.X, 0, direction.Z)
        if horizontal.Magnitude > 0 then
            humanoid:Move(horizontal.Unit)
        end
    end)
end

-- Р¤СѓРЅРєС†РёСЏ РѕСЃС‚Р°РЅРѕРІРєРё РѕРІРµСЂСЂР°Р№РґР°
local function stopOverride()
    if not isOverrideActive then return end
    isOverrideActive = false

    if humanoid then
        humanoid.WalkSpeed = 16 -- РґРµС„РѕР»С‚РЅР°СЏ СЃРєРѕСЂРѕСЃС‚СЊ
        humanoid.AutoRotate = true
        humanoid:Move(Vector3.new(0, 0, 0))
    end

    if connection then
        connection:Disconnect()
        connection = nil
    end
end

-- Р“Р»Р°РІРЅС‹Р№ С†РёРєР»
RunService.RenderStepped:Connect(function()
    if not voidrushcontrol then return end

    local char = humanoid and humanoid.Parent
    local voidRushState = char and char:GetAttribute("VoidRushState")

    if voidRushState == "Dashing" then
        startOverride()
    else
        stopOverride()
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local hpThreshold = 50
local autoPizzaEnabled = false
local healthConnection
local charAddedConnection

local function log(msg)
    print("[AutoPizzaHeal] " .. msg)
end

local function teleportTo(position)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(position)
        log("РўРµР»РµРїРѕСЂС‚ Рє: " .. tostring(position))
    end
end

local function tryPizzaHeal()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChild("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then
        log("вќЊ РќРµ РЅР°Р№РґРµРЅ Humanoid РёР»Рё HumanoidRootPart")
        return
    end

    local startPos = root.Position
    local beforeHP = humanoid.Health

    local pizza = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") and workspace.Map.Ingame:FindFirstChild("Pizza")
    if not pizza or not pizza:IsA("BasePart") then
        log("вќЊ Pizza РЅРµ РЅР°Р№РґРµРЅР° РёР»Рё РЅРµ СЏРІР»СЏРµС‚СЃСЏ BasePart")
        return
    end

    teleportTo(pizza.Position)
    task.wait(0.5)

    if humanoid.Health <= beforeHP then
        log("рџЌ• HP РЅРµ РІРѕСЃСЃС‚Р°РЅРѕРІР»РµРЅРѕ, Р¶РґС‘Рј РµС‰С‘ 0.5 СЃРµРє")
        task.wait(0.5)
    end

    teleportTo(startPos)
    log("в†©пёЏ Р’РѕР·РІСЂР°С‚ РЅР° РёСЃС…РѕРґРЅСѓСЋ РїРѕР·РёС†РёСЋ")
end

local function setupHealthMonitor(character)
    if healthConnection then
        healthConnection:Disconnect()
    end

    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then
        log("вќЊ Humanoid РЅРµ РЅР°Р№РґРµРЅ")
        return
    end

    log("вњ… РњРѕРЅРёС‚РѕСЂРёРЅРі HP Р°РєС‚РёРІРµРЅ")

    healthConnection = humanoid.HealthChanged:Connect(function(currentHP)
        if autoPizzaEnabled and currentHP < hpThreshold and currentHP > 0 then
            log("вљ пёЏ HP РЅРёР¶Рµ РїРѕСЂРѕРіР°: " .. currentHP)
            tryPizzaHeal()
        end
    end)
end

-- РџРѕРґРєР»СЋС‡РµРЅРёРµ РїСЂРё СЃС‚Р°СЂС‚Рµ
if LocalPlayer.Character then
    setupHealthMonitor(LocalPlayer.Character)
end

charAddedConnection = LocalPlayer.CharacterAdded:Connect(setupHealthMonitor)

-- вЏ¬ РЎРѕР·РґР°РЅРёРµ UI РІ РєРѕРЅС†Рµ, РєР°Рє С‚С‹ РїСЂРѕСЃРёР»
Tabs.Misc:Toggle({
    Title = "自动吃披萨",
    Default = false,
    Callback = function(v)
        autoPizzaEnabled = v
        log("Auto Pizza: " .. (v and "вњ… Р’РљР›" or "вќЊ Р’Р«РљР›"))
    end
})

Tabs.Misc:Slider({
    Title = "生命值HP",
    Value = {Min = 1, Max = 100, Default = hpThreshold},
    Step = 1,
    Suffix = "%",
    Callback = function(val)
        hpThreshold = val
        log("РџРѕСЂРѕРі HP СѓСЃС‚Р°РЅРѕРІР»РµРЅ РЅР°: " .. val)
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local cooldown = false
local backOffset = Vector3.new(0, 0, 3)
local hpThreshold = 50
local featureEnabled = false

-- UI
Tabs.Misc:Toggle({
    Title = "Auto heal Teammates (Elliot)",
    Default = false,
    Callback = function(value)
        featureEnabled = value
    end
})

Tabs.Misc:Slider({
    Title = "生命值临界点",
    Step = 1,
    Value = {Min = 1, Max = 100, Default = hpThreshold},
    Suffix = "HP",
    Callback = function(value)
        hpThreshold = tonumber(value)
    end
})

-- телепорт за спину + кидание пиццы
local function teleportBehind(targetChar)
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then return end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local rootPart = character.HumanoidRootPart
    local targetRootPart = targetChar.HumanoidRootPart
    
    local returnPos = rootPart.CFrame

    -- "прилипание" за спиной
    local stickConnection
    stickConnection = RunService.Heartbeat:Connect(function()
        if not targetRootPart or not targetRootPart.Parent or not rootPart or not rootPart.Parent then
            stickConnection:Disconnect()
            return
        end
        
        local backPos = targetRootPart.CFrame * CFrame.new(backOffset)
        rootPart.CFrame = backPos
    end)
    
    -- отправляем remote
    local args = {
        "UseActorAbility",
        {
            buffer.fromstring("\"ThrowPizza\"")
        }
    }
    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

    -- возврат через 2 сек
    task.delay(2, function()
        stickConnection:Disconnect()
        if character and rootPart and rootPart.Parent then
            rootPart.CFrame = returnPos
        end
    end)
end

-- мониторинг HP союзника
local function monitorPlayerHP(player)
    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.HealthChanged:Connect(function(currentHP)
                if featureEnabled and not cooldown and currentHP > 0 and currentHP < hpThreshold then
                    cooldown = true
                    teleportBehind(character)
                    task.delay(46, function()
                        cooldown = false
                    end)
                end
            end)
        end
    end

    if player.Character then
        onCharacterAdded(player.Character)
    end

    player.CharacterAdded:Connect(onCharacterAdded)
end

-- следим за всеми игроками кроме себя
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        monitorPlayerHP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        monitorPlayerHP(player)
    end
end)


-- AAAA
Tabs.Misc:Button({
    Title = "加载自动狂暴（Slasher）",
    Callback = function()
    
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
local playerGui = lp:WaitForChild("PlayerGui")

-- == Persistent Storage ==
local savedRange = lp:FindFirstChild("RagingPaceRange")
if not savedRange then
    savedRange = Instance.new("NumberValue")
    savedRange.Name = "RagingPaceRange"
    savedRange.Value = 19 -- default range
    savedRange.Parent = lp
end

local savedEnabled = lp:FindFirstChild("RagingPaceEnabled")
if not savedEnabled then
    savedEnabled = Instance.new("BoolValue")
    savedEnabled.Name = "RagingPaceEnabled"
    savedEnabled.Value = false -- default state
    savedEnabled.Parent = lp
end

local RANGE = savedRange.Value
local SPAM_DURATION = 3
local COOLDOWN_TIME = 5
local activeCooldowns = {}
local enabled = savedEnabled.Value

-- == Animation ID List ==
local animsToDetect = {
    ["116618003477002"] = true,
    ["119462383658044"] = true,
    ["131696603025265"] = true,
    ["121255898612475"] = true,
    ["133491532453922"] = true,
    ["103601716322988"] = true,
    ["86371356500204"] = true,
    ["72722244508749"] = true,
    ["87259391926321"] = true,
    ["96959123077498"] = true,
}

-- == Remote ==
local function fireRagingPace()
    local args = {
        "UseActorAbility",
        {
            buffer.fromstring("\"RagingPace\"")
        }
    }
    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end

-- == Animation Checker ==
local function isAnimationMatching(anim)
    local id = tostring(anim.Animation and anim.Animation.AnimationId or "")
    local numId = id:match("%d+")
    return animsToDetect[numId] or false
end

-- == Main Detection ==
RunService.Heartbeat:Connect(function()
    if not enabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = player.Character.HumanoidRootPart
            local myChar = lp.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local dist = (targetHRP.Position - myChar.HumanoidRootPart.Position).Magnitude
                if dist <= RANGE and (not activeCooldowns[player] or tick() - activeCooldowns[player] >= COOLDOWN_TIME) then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                            if isAnimationMatching(track) then
                                activeCooldowns[player] = tick()
                                task.spawn(function()
                                    local startTime = tick()
                                    while tick() - startTime < SPAM_DURATION do
                                        fireRagingPace()
                                        task.wait(0.05)
                                    end
                                end)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- == UI ==
Tabs.Misc:Toggle({
    Title = "狂暴(Slasher)",
    Default = enabled,
    Callback = function(state)
        enabled = state
        savedEnabled.Value = state
    end
})

Tabs.Misc:Slider({
    Title = "狂暴范围",
    Step = 1,
    Value = {Min = 1, Max = 30, Default = RANGE},
    Suffix = "studs",
    Callback = function(val)
        RANGE = val
        savedRange.Value = val -- сохраняем в persistent value
    end
})

end
})

-- HSHSHSHDHDHDHDHDHEIIEJDJXJXNDDN

Tabs.Misc:Button({
    Title = "加载自动错误404",
    Callback = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local lp = Players.LocalPlayer

        -- Vars
        local autoErrorEnabled = false
        local detectionRange = 14
        local soundHooks = {}
        local soundTriggeredUntil = {}

        -- Trigger sounds
        local autoErrorTriggerSounds = {
            ["86710781315432"] = true,
            ["99820161736138"] = true,
            ["609342351"] = true,
            ["81976396729343"] = true,
            ["12222225"] = true,
            ["80521472651047"] = true,
            ["139012439429121"] = true,
            ["91194698358028"] = true,
            ["111910850942168"] = true,
            ["83851356262523"] = true,
        }

        -- Helpers
        local function extractNumericSoundId(sound)
            if not sound or not sound.SoundId then return nil end
            return tostring(sound.SoundId):match("%d+")
        end

        local function getSoundWorldPosition(sound)
            if sound.Parent and sound.Parent:IsA("BasePart") then
                return sound.Parent.Position
            elseif sound.Parent and sound.Parent:IsA("Attachment") and sound.Parent.Parent:IsA("BasePart") then
                return sound.Parent.Parent.Position
            end
            local found = sound.Parent and sound.Parent:FindFirstChildWhichIsA("BasePart", true)
            if found then return found.Position end
            return nil
        end

        local function attemptError404ForSound(sound)
            if not autoErrorEnabled then return end
            if not sound or not sound:IsA("Sound") or not sound.IsPlaying then return end

            local id = extractNumericSoundId(sound)
            if not id or not autoErrorTriggerSounds[id] then return end

            local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            if soundTriggeredUntil[sound] and tick() < soundTriggeredUntil[sound] then return end

            local pos = getSoundWorldPosition(sound)
            local shouldTrigger = (not pos) or ((myRoot.Position - pos).Magnitude <= detectionRange)

            if shouldTrigger then
                warn("[自动错误404] 触发的声音lD:", id)
                local args = {
                    "UseActorAbility",
                    {
                        buffer.fromstring("\"404Error\"")
                    }
                }
                ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                soundTriggeredUntil[sound] = tick() + 1.2
            end
        end

        local function hookSound(sound)
            if soundHooks[sound] then return end
            
            local connections = {}
            
            local playedConn = sound.Played:Connect(function() 
                attemptError404ForSound(sound) 
            end)
            table.insert(connections, playedConn)
            
            local propConn = sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
                if sound.IsPlaying then 
                    attemptError404ForSound(sound) 
                end
            end)
            table.insert(connections, propConn)
            
            local destroyConn
            destroyConn = sound.Destroying:Connect(function()
                for _, conn in ipairs(connections) do
                    if conn and typeof(conn) == "RBXScriptConnection" then
                        pcall(function() conn:Disconnect() end)
                    end
                end
                if destroyConn and typeof(destroyConn) == "RBXScriptConnection" then
                    pcall(function() destroyConn:Disconnect() end)
                end
                soundHooks[sound] = nil
                soundTriggeredUntil[sound] = nil
            end)
            table.insert(connections, destroyConn)
            
            soundHooks[sound] = connections
            if sound.IsPlaying then 
                attemptError404ForSound(sound) 
            end
        end

        for _, s in ipairs(game:GetDescendants()) do
            if s:IsA("Sound") then 
                pcall(function() hookSound(s) end)
            end
        end

        game.DescendantAdded:Connect(function(d)
            if d:IsA("Sound") then 
                pcall(function() hookSound(d) end)
            end
        end)

        Tabs.Misc:Toggle({
            Title = "自动错误 404（John Doe）",
            Default = autoErrorEnabled,
            Callback = function(state)
                autoErrorEnabled = state
            end
        })

        Tabs.Misc:Slider({
            Title = "错误 404 范围",
            Step = 1,
            Value = {Min = 1, Max = 20, Default = detectionRange},
            Suffix = "studs",
            Callback = function(val)
                detectionRange = val
            end
        })
    end
})

local Players = game:GetService("Players")  
local Workspace = game:GetService("Workspace")  

-- Таблица диаметров (редактируй по желанию)  
local killerDiameters = {  
	["Jason"] = 15,  
	["John Doe"] = 15,  
	["1x1x1x1"] = 15,  
	["Noli"] = 15,  
	["c00lkidd"] = 15,  
	["Slasher"] = 15  
}  

local circleColor = Color3.fromRGB(255, 105, 180) -- розовый  

-- Параметры кольца  
local SEGMENTS = 96        
local SEGMENT_HEIGHT = 0.2 
local SEGMENT_WIDTH = 0.35 

local circles = {} -- circles[killer] = { model = Model, segments = {...}, diameter = number }  
local enabled = false -- флаг работы  

local function createRingForKiller(killer, diameter)  
	if not killer or not killer.Parent then return end  
	local hrp = killer:FindFirstChild("HumanoidRootPart")  
	if not hrp then return end  

	if circles[killer] then  
		if circles[killer].model then  
			pcall(function() circles[killer].model:Destroy() end)  
		end  
		circles[killer] = nil  
	end  

	local model = Instance.new("Model")  
	model.Name = "HitboxRing_" .. killer.Name  
	model.Parent = Workspace  

	local radius = diameter / 2  
	local circumference = 2 * math.pi * radius  
	local segLen = circumference / SEGMENTS  

	local segments = {}  

	for i = 1, SEGMENTS do  
		local angle = (i - 1) * (2 * math.pi / SEGMENTS)  
		local offset = Vector3.new(radius * math.cos(angle), 0, radius * math.sin(angle))  
		local worldPos = hrp.Position + offset  

		local part = Instance.new("Part")  
		part.Size = Vector3.new(segLen, SEGMENT_HEIGHT, SEGMENT_WIDTH)  
		part.Anchored = false  
		part.CanCollide = false  
		part.Material = Enum.Material.Neon  
		part.Color = circleColor  
		part.Transparency = 0.3  
		part.CFrame = CFrame.new(worldPos) * CFrame.Angles(0, angle + math.pi/2, 0)  
		part.Parent = model  

		local weld = Instance.new("WeldConstraint")  
		weld.Part0 = part  
		weld.Part1 = hrp  
		weld.Parent = part  

		table.insert(segments, part)  
	end  

	circles[killer] = { model = model, segments = segments, diameter = diameter }  
end  

local function updateCircle(killer)  
	local hrp = killer:FindFirstChild("HumanoidRootPart")  
	if not hrp then return end  

	local diameter = killerDiameters[killer.Name]  
	if not diameter then return end  

	local info = circles[killer]  
	if not info then  
		createRingForKiller(killer, diameter)  
		return  
	end  

	if info.diameter ~= diameter then  
		createRingForKiller(killer, diameter)  
		return  
	end  
end  

local function cleanupCircles()  
	for killer, data in pairs(circles) do  
		if not killer.Parent then  
			if data.model then  
				pcall(function() data.model:Destroy() end)  
			end  
			circles[killer] = nil  
		end  
	end  
end  

local function clearAll()  
	for killer, data in pairs(circles) do  
		if data.model then  
			pcall(function() data.model:Destroy() end)  
		end  
	end  
	table.clear(circles)  
end  

task.spawn(function()  
	while true do  
		if enabled then  
			cleanupCircles()  
			if Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers") then  
				for _, killer in ipairs(Workspace.Players.Killers:GetChildren()) do  
					pcall(updateCircle, killer)  
				end  
			end  
		end  
		task.wait(5)  
	end  
end)  

Tabs.Misc:Toggle({
    Title = "命中框可视化",
    Default = false,
    Callback = function(state)
        enabled = state
        if not state then
            clearAll()
        end
    end
})


-- AAAAA

Tabs.Auto_Stun:Button({
    Title = "加载自动隐身",
    Callback = function()

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- Настройки анимации
    local animationId = "75804462760596"
    local loopRunning = false
    local loopThread
    local currentAnim = nil

    -- GUI переменные
    local autoInvis = false
    local animationSpeed = 0
    local invisDuration = 5 -- по умолчанию 5 секунд

    -- Toggle
    Tabs.Auto_Stun:Toggle({
        Title = "克隆时自动隐身 (007n7)",
        Default = false,
        Callback = function(value)
            autoInvis = value
            if not autoInvis then
                StopInvisibility()
            end
        end
    })

    -- Slider длительности эффекта Invisibility
    Tabs.Auto_Stun:Slider({
        Title = "隐身持续时间",
        Step = 1,
        Value = {Min = 1, Max = 45, Default = invisDuration},
        Suffix = "s",
        Callback = function(val)
            invisDuration = val
        end
    })

    -- Функции запуска/остановки анимации
    function StartInvisibility()
        if loopRunning then return end
        loopRunning = true
        print("[自动隐身] 开始隐身")

        local speaker = LocalPlayer
        local humanoid = speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.RigType ~= Enum.HumanoidRigType.R6 then return end

        loopThread = task.spawn(function()
            while loopRunning do
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://" .. animationId
                local loadedAnim = humanoid:LoadAnimation(anim)
                currentAnim = loadedAnim
                loadedAnim.Looped = false
                loadedAnim:Play()
                loadedAnim:AdjustSpeed(animationSpeed)
                while loadedAnim.IsPlaying and loopRunning do
                    loadedAnim:AdjustSpeed(animationSpeed)
                    task.wait(0.05)
                end
                task.wait(0.01)
            end
        end)
    end

    function StopInvisibility()
        loopRunning = false
        if loopThread then
            task.cancel(loopThread)
            loopThread = nil
        end
        if currentAnim then
            currentAnim:Stop()
            currentAnim = nil
        end
        local speaker = LocalPlayer
        local humanoid = speaker.Character and (speaker.Character:FindFirstChildOfClass("Humanoid") or speaker.Character:FindFirstChildOfClass("AnimationController"))
        if humanoid then
            for _, v in pairs(humanoid:GetPlayingAnimationTracks()) do
                v:AdjustSpeed(100000)
            end
        end
        local animateScript = speaker.Character and speaker.Character:FindFirstChild("Animate")
        if animateScript then
            animateScript.Disabled = true
            animateScript.Disabled = false
        end
        print("[自动隐形] 停止隐形")
    end

    -- Проверка GUI каждые 0.1 секунды
    task.spawn(function()
        while true do
            task.wait(0.1)
            if autoInvis then
                local abilityContainer = LocalPlayer.PlayerGui:FindFirstChild("MainUI") 
                                        and LocalPlayer.PlayerGui.MainUI:FindFirstChild("AbilityContainer")
                local cloneGui = abilityContainer and abilityContainer:FindFirstChild("Clone")
                
                if cloneGui then
                    local cloneText = cloneGui:FindFirstChildOfClass("TextLabel")
                    local cloneValue = cloneText and tonumber(cloneText.Text)

                    if cloneValue and cloneValue >= 26 then
                        print("[自动隐身] 克隆数量 >= 26，激活隐身")
                        StartInvisibility()
                        task.delay(invisDuration, StopInvisibility)
                        task.wait(invisDuration + 0.1) -- Ждём, чтобы не спамить
                    end
                end
            end
        end
    end)

end
})

local autoStunChanceActive = false
local autoStunChanceThread = nil

Tabs.Auto_Stun:Toggle({
    Title = "自动眩晕杀手(概率)",
    Default = false,
    Callback = function(state)
        autoStunChanceActive = state
        if autoStunChanceActive then
            WindUI:Notify({ Title = "自动眩晕（概率）", Content = "已启用!", Duration = 2 })
            autoStunChanceThread = task.spawn(function()
                local function getBehindPosition(targetRoot, distance)
                    local back = -targetRoot.CFrame.LookVector * distance
                    return targetRoot.Position + back
                end

                local function stickToBack(playerRoot, targetRoot, duration, offset)
                    local startTime = tick()
                    while tick() - startTime < duration and autoStunChanceActive do
                        if not playerRoot or not targetRoot or not playerRoot.Parent or not targetRoot.Parent then break end
                        local behindPos = getBehindPosition(targetRoot, offset)
                        playerRoot.CFrame = CFrame.new(behindPos, targetRoot.Position)
                        RunService.Heartbeat:Wait()
                    end
                end

                local REMOTE = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
                local KILLERS_FOLDER = Workspace:WaitForChild("Players"):WaitForChild("Killers")
                local CHECK_RADIUS = 16
                local TELEPORT_DELAY = 2
                local CHECK_INTERVAL = 0.2
                local COOLDOWN = 43
                
                local lastActivation = 0

                while autoStunChanceActive do
                    task.wait(CHECK_INTERVAL)
                    if tick() - lastActivation < COOLDOWN then continue end

                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if not root then continue end

                    for _, killer in ipairs(KILLERS_FOLDER:GetChildren()) do
                        local targetRoot = killer:FindFirstChild("HumanoidRootPart")
                        if targetRoot and (root.Position - targetRoot.Position).Magnitude <= CHECK_RADIUS then
                            lastActivation = tick()
                            local originalCFrame = root.CFrame

                            REMOTE:FireServer("UseActorAbility", "Shoot")
                            WindUI:Notify({ Title = "自动眩晕（概率）", Content = "震惊的杀手: " .. killer.Name, Duration = 2 })

                            stickToBack(root, targetRoot, TELEPORT_DELAY, 3)

                            if root and root.Parent then
                                root.CFrame = originalCFrame
                            end

                            break
                        end
                    end
                end
            end)
        else
            if autoStunChanceThread then
                task.cancel(autoStunChanceThread)
                autoStunChanceThread = nil
            end
            WindUI:Notify({ Title = "自动眩晕（概率）", Content = "已禁用!", Duration = 2 })
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local active = false
local aimDuration = 1.7
local prediction = 4
local aimTargets = { "Slasher", "c00lkidd", "JohnDoe", "1x1x1x1", "Noli" }
local trackedAnimations = {
    ["103601716322988"] = true,
    ["133491532453922"] = true,
    ["86371356500204"] = true,
    ["76649505662612"] = true,
    ["81698196845041"] = true
}

local Humanoid, HRP = nil, nil
local lastTriggerTime = 0
local aiming = false
local originalWS, originalJP, originalAutoRotate = nil, nil, nil

local function setupCharacter(char)
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")
end

if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(setupCharacter)

local function getValidTarget()
    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    if killersFolder then
        for _, name in ipairs(aimTargets) do
            local target = killersFolder:FindFirstChild(name)
            if target and target:FindFirstChild("HumanoidRootPart") then
                return target.HumanoidRootPart
            end
        end
    end
    return nil
end

local function getPlayingAnimationIds()
    local ids = {}
    if Humanoid then
        for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
            if track.Animation and track.Animation.AnimationId then
                local id = track.Animation.AnimationId:match("%d+")
                if id then
                    ids[id] = true
                end
            end
        end
    end
    return ids
end

RunService.RenderStepped:Connect(function()
    if not active or not Humanoid or not HRP then return end

    local playing = getPlayingAnimationIds()
    local triggered = false
    for id in pairs(trackedAnimations) do
        if playing[id] then
            triggered = true
            break
        end
    end

    if triggered then
        lastTriggerTime = tick()
        aiming = true
    end

    if aiming and tick() - lastTriggerTime <= aimDuration then
        if not originalWS then
            originalWS = Humanoid.WalkSpeed
            originalJP = Humanoid.JumpPower
            originalAutoRotate = Humanoid.AutoRotate
        end

        Humanoid.AutoRotate = false
        HRP.AssemblyAngularVelocity = Vector3.zero

        local targetHRP = getValidTarget()
        if targetHRP then
            local predictedPos = targetHRP.Position + (targetHRP.CFrame.LookVector * prediction)
            local direction = (predictedPos - HRP.Position).Unit
            local yRot = math.atan2(-direction.X, -direction.Z)
            HRP.CFrame = CFrame.new(HRP.Position) * CFrame.Angles(0, yRot, 0)
        end
    elseif aiming then
        aiming = false
        if originalWS and originalJP and originalAutoRotate ~= nil then
            Humanoid.WalkSpeed = originalWS
            Humanoid.JumpPower = originalJP
            Humanoid.AutoRotate = originalAutoRotate
            originalWS, originalJP, originalAutoRotate = nil, nil, nil
        end
    end
end)

Tabs.Auto_Stun:Toggle({
    Title = "概率自瞄",
    Default = false,
    Callback = function(value)
        active = value
    end
})

Tabs.Auto_Stun:Slider({
    Title = "清晰度（高延迟 => 4）",
    Step = 1,
    Value = {Min = 1, Max = 10, Default = prediction},
    Suffix = "studs",
    Callback = function(val)
        prediction = val
    end
})

--BACKSTAB

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- Vars
local enabled = false
local cooldown = false
local lastTarget = nil
local range = 4
local mode = "Behind"
local matchFacing = false
local attackType = "Normal"

local daggerRemote = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
local killerNames = { "Jason", "c00lkidd", "JohnDoe", "1x1x1x1", "Noli" }
local killersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")

local counterAnimIDs = {
	"126830014841198", "126355327951215", "121086746534252", "18885909645",
	"98456918873918", "105458270463374", "83829782357897", "125403313786645",
	"118298475669935", "82113744478546", "70371667919898", "99135633258223",
	"97167027849946", "109230267448394", "139835501033932", "126896426760253",
	"109667959938617", "126681776859538", "129976080405072", "121293883585738",
	"81639435858902", "137314737492715", "92173139187970", "rbxassetid://126830014841198", "rbxassetid://126355327951215", "rbxassetid://121086746534252"
}

----------------------------------------------------------------
-- WindUI
----------------------------------------------------------------
Tabs.Auto_Stun:Toggle({
    Title = "背刺 V2",
    Default = false,
    Callback = function(state)
        enabled = state
    end
})

Tabs.Auto_Stun:Slider({
    Title = "背刺范围",
    Step = 0.5,
    Value = {Min = 1, Max = 30, Default = range},
    Suffix = " studs",
    Callback = function(val)
        local n = tonumber(val)
        if n then range = n end
    end
})

Tabs.Auto_Stun:Dropdown({
    Title = "背刺模式",
    Values = {"在后面", "大约"},
    Multi = false,
    AllowNone = false,
    Callback = function(selected)
        mode = selected
    end
})

Tabs.Auto_Stun:Dropdown({
    Title = "背刺类型",
    Values = {"普通的", "反击", "合法的"},
    Multi = false,
    AllowNone = false,
    Callback = function(selected)
        attackType = selected
    end
})

Tabs.Auto_Stun:Toggle({
    Title = "合法模式下的自动瞄准",
    Default = false,
    Callback = function(state)
        matchFacing = state
    end
})

----------------------------------------------------------------
-- Helpers
----------------------------------------------------------------
local function killerPlayingCounterAnim(killer)
    local humanoid = killer:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return false end

    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        local anim = track.Animation
        if anim and anim.AnimationId then
            local animIdNum = anim.AnimationId:match("%d+")
            for _, id in ipairs(counterAnimIDs) do
                if tostring(animIdNum) == id then
                    return true
                end
            end
        end
    end
    return false
end

local function isBehindTarget(hrp, targetHRP)
    local r = tonumber(range) or 4
    local distance = (hrp.Position - targetHRP.Position).Magnitude
    if distance > r then return false end

    if mode == "Around" then
        return true
    else
        local direction = -targetHRP.CFrame.LookVector
        local toPlayer = (hrp.Position - targetHRP.Position)
        return toPlayer:Dot(direction) > 0.5
    end
end

----------------------------------------------------------------
-- Cooldown text finder
----------------------------------------------------------------
local daggerCooldownText
local function refreshDaggerRef()
	local mainui = lp:FindFirstChild("PlayerGui") and lp.PlayerGui:FindFirstChild("MainUI")
	if mainui then
		local ability = mainui:FindFirstChild("AbilityContainer")
		if ability then
			local dagger = ability:FindFirstChild("Dagger")
			if dagger then
				local ct = dagger:FindFirstChild("CooldownTime")
				daggerCooldownText = ct
				return
			end
		end
	end
	daggerCooldownText = nil
end
lp.PlayerGui.DescendantAdded:Connect(refreshDaggerRef)
lp.PlayerGui.DescendantRemoving:Connect(function(obj)
	if obj == daggerCooldownText then
		daggerCooldownText = nil
	end
end)
refreshDaggerRef()

----------------------------------------------------------------
-- Main Loop
----------------------------------------------------------------
RunService.RenderStepped:Connect(function()
    if not daggerCooldownText or not daggerCooldownText.Parent then return end
    if tonumber(daggerCooldownText.Text or "") ~= nil then return end
    if not enabled or cooldown then return end
    
	local char = lp.Character
	if not (char and char:FindFirstChild("HumanoidRootPart")) then return end
	local hrp = char.HumanoidRootPart

	local stats = game:GetService("Stats")
	local pingItem = stats.Network and stats.Network.ServerStatsItem and stats.Network.ServerStatsItem["Data Ping"]

	for _, name in ipairs(killerNames) do
		local killer = killersFolder:FindFirstChild(name)
		if killer and killer:FindFirstChild("HumanoidRootPart") then
			local kHRP = killer.HumanoidRootPart

            if attackType == "Legit" then
                local dist = (kHRP.Position - hrp.Position).Magnitude
                local r = tonumber(range) or 4
                if dist <= r then
                    if matchFacing then
                        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + kHRP.CFrame.LookVector)
                    end
                    if mode == "Behind" then
                        local directionToTarget = (kHRP.Position - hrp.Position).Unit
                        local dot = hrp.CFrame.LookVector:Dot(directionToTarget)
                        if dot > 0.6 then return end
                    end
                    daggerRemote:FireServer("UseActorAbility", { buffer.fromstring("\"Dagger\"") })
                end
                return
            end

            if attackType == "Counter" and not killerPlayingCounterAnim(killer) then
            	continue
            end

			if isBehindTarget(hrp, kHRP) and killer ~= lastTarget then
				cooldown = true
				lastTarget = killer

				local start = tick()
				local didDagger = false
				local connection
				connection = RunService.Heartbeat:Connect(function()
					if not (char and char.Parent and kHRP and kHRP.Parent) then
						if connection then connection:Disconnect() end
						return
					end

					local elapsed = tick() - start
					if elapsed >= 0.5 then
						if connection then connection:Disconnect() end
						return
					end

					-- Prediction
					local pingMs = 50
					if pingItem and typeof(pingItem.GetValueString) == "function" then
						pingMs = tonumber((pingItem:GetValueString() or ""):match("%d+")) or pingMs
					end
					local pingSeconds = pingMs / 1000

					local killerVelocity = kHRP.Velocity
					local moveDir = killerVelocity.Magnitude > 0.1 and killerVelocity.Unit or Vector3.new()
					local pingOffset = moveDir * (pingSeconds * killerVelocity.Magnitude)
					local predictedPos = kHRP.Position + pingOffset

					local targetPos
					if mode == "Behind" then
						targetPos = predictedPos - (kHRP.CFrame.LookVector * 0.3)
					else
						local rightVec = kHRP.CFrame.RightVector
						local rel = (hrp.Position - kHRP.Position)
						local lateralSpeed = killerVelocity:Dot(rightVec)
						local baseOffset = (rel.Magnitude > 0.1) and rel.Unit * 0.3 or Vector3.new()
						local lateralOffset = rightVec * lateralSpeed * 0.3
						targetPos = predictedPos + baseOffset + lateralOffset
					end

					hrp.CFrame = CFrame.new(targetPos, targetPos + kHRP.CFrame.LookVector)

					if not didDagger then
						didDagger = true
						daggerRemote:FireServer("UseActorAbility", { buffer.fromstring("\"Dagger\"") })
					end
				end)

				task.delay(2, function()
					RunService.Heartbeat:Wait()
					while kHRP and kHRP.Parent and isBehindTarget(hrp, kHRP) do
						RunService.Heartbeat:Wait()
					end
					lastTarget = nil
					cooldown = false
				end)
				
				break
			end
		end
	end
end)

Tabs.Hitbox_expander:Button({
    Title = "加载 Hitbox Expander V12（扩展您查看的区域，以便更好地与访客互动）",
    Callback = function()

        -- Службы Roblox
        local srvPlayers = game:GetService("Players")
        local srvRun = game:GetService("RunService")

        -- Локальный игрок
        local client = srvPlayers.LocalPlayer
        repeat task.wait() until client and client.Character

        -- Переменные персонажа
        local char = client.Character
        local humanoid = char:WaitForChild("Humanoid")
        local animator = humanoid:WaitForChild("Animator")
        local root = char:WaitForChild("HumanoidRootPart")

        -- Обновление при респавне
        client.CharacterAdded:Connect(function(newChar)
            char = newChar
            humanoid = char:WaitForChild("Humanoid")
            animator = humanoid:WaitForChild("Animator")
            root = char:WaitForChild("HumanoidRootPart")
        end)

        -- ID атак
        local attackIds = {
            "rbxassetid://131430497821198", "rbxassetid://83829782357897", "rbxassetid://126830014841198",
            "rbxassetid://126355327951215", "rbxassetid://121086746534252", "rbxassetid://105458270463374",
            "rbxassetid://127172483138092", "rbxassetid://18885919947", "rbxassetid://18885909645",
            "rbxassetid://87259391926321", "rbxassetid://106014898528300", "rbxassetid://86545133269813",
            "rbxassetid://89448354637442", "rbxassetid://90499469533503", "rbxassetid://116618003477002",
            "rbxassetid://106086955212611", "rbxassetid://107640065977686", "rbxassetid://77124578197357",
            "rbxassetid://101771617803133", "rbxassetid://134958187822107", "rbxassetid://111313169447787",
            "rbxassetid://71685573690338", "rbxassetid://129843313690921", "rbxassetid://97623143664485",
            "rbxassetid://136007065400978", "rbxassetid://86096387000557", "rbxassetid://108807732150251",
            "rbxassetid://138040001965654", "rbxassetid://73502073176819", "rbxassetid://86709774283672",
            "rbxassetid://140703210927645", "rbxassetid://96173857867228", "rbxassetid://121255898612475",
            "rbxassetid://98031287364865", "rbxassetid://119462383658044", "rbxassetid://77448521277146",
            "rbxassetid://103741352379819", "rbxassetid://131696603025265", "rbxassetid://122503338277352",
            "rbxassetid://97648548303678", "rbxassetid://94162446513587", "rbxassetid://84426150435898",
            "rbxassetid://93069721274110", "rbxassetid://114620047310688", "rbxassetid://97433060861952",
            "rbxassetid://82183356141401", "rbxassetid://100592913030351", "rbxassetid://121293883585738",
            "rbxassetid://70447634862911", "rbxassetid://92173139187970", "rbxassetid://106847695270773",
            "rbxassetid://125403313786645", "rbxassetid://81639435858902", "rbxassetid://137314737492715",
            "rbxassetid://120112897026015", "rbxassetid://82113744478546", "rbxassetid://118298475669935",
            "rbxassetid://126681776859538", "rbxassetid://129976080405072", "rbxassetid://109667959938617",
            "rbxassetid://74707328554358", "rbxassetid://133336594357903", "rbxassetid://86204001129974",
            "rbxassetid://124243639579224", "rbxassetid://70371667919898", "rbxassetid://131543461321709",
            "rbxassetid://136323728355613", "rbxassetid://109230267448394"
        }

        -- === Настройки (GUI) ===
        local VELOCITY_ENABLED = false
        local VELOCITY_STRENGTH = 50

        Tabs.Hitbox_expander:Toggle({
            Title = "命中框扩展器 V17",
            Default = VELOCITY_ENABLED,
            Callback = function(val)
                VELOCITY_ENABLED = val
            end
        })

        Tabs.Hitbox_expander:Slider({
            Title = "碰撞箱增大",
            Step = 1,
            Value = {Min = 10, Max = 500, Default = VELOCITY_STRENGTH},
            Suffix = " studs",
            Callback = function(val)
                VELOCITY_STRENGTH = tonumber(val)
            end
        })

        -- Основной цикл
        srvRun.Heartbeat:Connect(function()
            if not VELOCITY_ENABLED or not root then return end

            local attack = false
            for _, track in humanoid:GetPlayingAnimationTracks() do
                local animId = track.Animation and track.Animation.AnimationId
                if animId and table.find(attackIds, animId) and (track.TimePosition / track.Length < 0.75) then
                    attack = true
                    break
                end
            end

            if not attack then return end

            local look = root.CFrame.LookVector
            local original = root.Velocity

            root.Velocity = look * VELOCITY_STRENGTH
            srvRun.RenderStepped:Wait()
            root.Velocity = original
        end)

    end
})

Tabs.Teleport:Button({
    Title = "传送到杀手",
    Callback = function()
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        local workspace = game:GetService("Workspace")

        local KillersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
        if not KillersFolder then
            warn("Killers РЅРµ РЅР°Р№РґРµРЅРѕ РІ Workspace.Players")
            return
        end

        local targetKiller = KillersFolder:FindFirstChildWhichIsA("Model")
        if not targetKiller or not targetKiller.PrimaryPart then
            warn("РЈР±РёР№С†Р° РЅРµ РёРјРµРµС‚ PrimaryPart")
            return
        end

        lp.Character:SetPrimaryPartCFrame(targetKiller.PrimaryPart.CFrame + Vector3.new(0, 0, 0))
    end
})

Tabs.Teleport:Button({
    Title = "传送到幸存者",
    Callback = function()
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        local workspace = game:GetService("Workspace")

        if not lp.Character or not lp.Character.PrimaryPart then
            warn("РќРµ РЅР°Р№РґРµРЅ Character РёР»Рё PrimaryPart")
            return
        end

        local SurvivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if not SurvivorsFolder then
            warn("Survivors РЅРµ РЅР°Р№РґРµРЅ")
            return
        end

        local myPos = lp.Character.PrimaryPart.Position
        local nearest, nearestDist

        for _, survivor in ipairs(SurvivorsFolder:GetChildren()) do
            if survivor:IsA("Model") and survivor.PrimaryPart then
                local dist = (survivor.PrimaryPart.Position - myPos).Magnitude
                if not nearestDist or dist < nearestDist then
                    nearest = survivor
                    nearestDist = dist
                end
            end
        end

        if nearest and nearest.PrimaryPart then
            lp.Character:SetPrimaryPartCFrame(nearest.PrimaryPart.CFrame + Vector3.new(0, 5, 0))
        else
            warn("Р‘Р»РёР¶Р°Р№С€РёР№ Survivor РЅРµ РЅР°Р№РґРµРЅ")
        end
    end
})

Tabs.Teleport:Button({
    Title = "传送到发电机",
    Callback = function()
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer
        local workspace = game:GetService("Workspace")

        if not lp.Character or not lp.Character.PrimaryPart then
            warn("РќРµ РЅР°Р№РґРµРЅ Character РёР»Рё PrimaryPart")
            return
        end

        -- РС‰РµРј Generator РІ Workspace:GetDescendants()
        local target
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "Generator" and obj:IsA("BasePart") then
                target = obj
                break
            elseif obj.Name == "Generator" and obj:IsA("Model") and obj.PrimaryPart then
                target = obj.PrimaryPart
                break
            end
        end

        if not target then
            warn("Generator РЅРµ РЅР°Р№РґРµРЅ")
            return
        end

        -- РўРµР»РµРїРѕСЂС‚РёСЂСѓРµРј РёРіСЂРѕРєР°
        lp.Character:SetPrimaryPartCFrame(target.CFrame + Vector3.new(0, 0, 0))
    end
})

local function teleportTo(part)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    char.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
end

local function getItem(itemName)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "ItemRoot" and v.Parent and v.Parent.Name == itemName then
            return v
        end
    end
end

Tabs.Teleport:Button({
    Title = "传送至医疗箱",
    Callback = function()
        local item = getItem("Medkit")
        if item then
            teleportTo(item)
        end
    end,
})

Tabs.Teleport:Button({
    Title = "传送至饮料",
    Callback = function()
        local item = getItem("BloxyCola")
        if item then
            teleportTo(item)
        end
    end,
})

Tabs.Random:Button({
    Title = "投掷（仅对杀手有效）",
    Callback = function()
        -- СЃРѕР·РґР°С‘Рј GUI Рё РІРµСЃСЊ С„СѓРЅРєС†РёРѕРЅР°Р» С‚РѕР»СЊРєРѕ РїСЂРё РЅР°Р¶Р°С‚РёРё РєРЅРѕРїРєРё

        local ScreenGui = Instance.new("ScreenGui")
        local Frame = Instance.new("Frame")
        local ToggleButton = Instance.new("TextButton")
        local TextLabel = Instance.new("TextLabel")
        local HideButton = Instance.new("TextButton")
        local PowerLabel = Instance.new("TextLabel")
        local PowerSlider = Instance.new("TextButton")
        local PowerBar = Instance.new("Frame")
        local UICorner = Instance.new("UICorner")
        local TimerLabel = Instance.new("TextLabel")

        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.ResetOnSpawn = false

        Frame.Parent = ScreenGui
        Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Frame.Position = UDim2.new(0.35, 0, 0.4, 0)
        Frame.Size = UDim2.new(0, 220, 0, 180)
        Frame.Active = true
        Frame.Draggable = true
        UICorner.Parent = Frame

        TextLabel.Parent = Frame
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(1, 0, 0.2, 0)
        TextLabel.Font = Enum.Font.SourceSansBold
        TextLabel.Text = "Fling | Bublik6241"
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextSize = 22

        ToggleButton.Parent = Frame
        ToggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
        ToggleButton.Size = UDim2.new(0.8, 0, 0.2, 0)
        ToggleButton.Font = Enum.Font.SourceSansBold
        ToggleButton.Text = "OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        ToggleButton.TextSize = 24
        UICorner:Clone().Parent = ToggleButton

        PowerLabel.Parent = Frame
        PowerLabel.BackgroundTransparency = 1
        PowerLabel.Position = UDim2.new(0.1, 0, 0.55, 0)
        PowerLabel.Size = UDim2.new(0.8, 0, 0.15, 0)
        PowerLabel.Font = Enum.Font.SourceSansBold
        PowerLabel.Text = "投掷力：10000"
        PowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        PowerLabel.TextSize = 18

        PowerBar.Parent = Frame
        PowerBar.Position = UDim2.new(0.1, 0, 0.7, 0)
        PowerBar.Size = UDim2.new(0.8, 0, 0.1, 0)
        PowerBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        UICorner:Clone().Parent = PowerBar

        PowerSlider.Parent = PowerBar
        PowerSlider.Size = UDim2.new(0.1, 0, 1, 0)
        PowerSlider.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        UICorner:Clone().Parent = PowerSlider

        TimerLabel.Parent = Frame
        TimerLabel.BackgroundTransparency = 1
        TimerLabel.Position = UDim2.new(0.1, 0, 0.85, 0)
        TimerLabel.Size = UDim2.new(0.8, 0, 0.15, 0)
        TimerLabel.Font = Enum.Font.SourceSansBold
        TimerLabel.Text = "计时器：0秒"
        TimerLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
        TimerLabel.TextSize = 18

        HideButton.Parent = ScreenGui
        HideButton.Position = UDim2.new(0.05, 0, 0.9, 0)
        HideButton.Size = UDim2.new(0, 50, 0, 30)
        HideButton.Font = Enum.Font.SourceSansBold
        HideButton.Text = "🐔🎱👍"
        HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        HideButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        UICorner:Clone().Parent = HideButton

        -- РЎР»СѓР¶Р±С‹
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")

        -- РџРµСЂРµРјРµРЅРЅС‹Рµ
        local hiddenfling = false
        local flingPower = 10000
        local lp = Players.LocalPlayer
        local dragging = false

        -- РћСЃРЅРѕРІРЅР°СЏ fling-С„СѓРЅРєС†РёСЏ СЃ С‚Р°Р№РјРµСЂРѕРј
        local function fling()
            local hrp, c, vel, movel = nil, nil, nil, 0.1

            while true do
                RunService.Heartbeat:Wait()

                if hiddenfling then
                    -- 4 СЃРµРєСѓРЅРґС‹ fling СЂР°Р±РѕС‚Р°РµС‚
                    local start = tick()
                    while hiddenfling and tick() - start < 4 do
                        local left = 4 - math.floor(tick() - start)
                        TimerLabel.Text = "积极的: " .. left .. "秒"

                        RunService.Heartbeat:Wait()
                        c = lp.Character
                        hrp = c and c:FindFirstChild("HumanoidRootPart")

                        if hrp then
                            vel = hrp.Velocity
                            hrp.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
                            RunService.RenderStepped:Wait()
                            hrp.Velocity = vel
                            RunService.Stepped:Wait()
                            hrp.Velocity = vel + Vector3.new(0, movel, 0)
                            movel = movel * -1
                        end
                    end

                    -- 3 СЃРµРєСѓРЅРґС‹ РїР°СѓР·Р°
                    local pauseStart = tick()
                    while hiddenfling and tick() - pauseStart < 4 do
                        local left = 4 - math.floor(tick() - pauseStart)
                        TimerLabel.Text = "暂停: " .. left .. "秒"
                        RunService.Heartbeat:Wait()
                    end
                else
                    TimerLabel.Text = "Timer: 0s"
                end
            end
        end

        -- РљРЅРѕРїРєРё
        ToggleButton.MouseButton1Click:Connect(function()
            hiddenfling = not hiddenfling
            if hiddenfling then
                ToggleButton.Text = "ON"
                ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            else
                ToggleButton.Text = "OFF"
                ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                TimerLabel.Text = "计时器:0秒"
            end
        end)

        HideButton.MouseButton1Click:Connect(function()
            Frame.Visible = not Frame.Visible
            if Frame.Visible then
                HideButton.Text = "🤪"
            else
                HideButton.Text = "🤫"
            end
        end)

        -- РЎР»Р°Р№РґРµСЂ РјРѕС‰РЅРѕСЃС‚Рё fling
        PowerSlider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)

        PowerSlider.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local mousePos = input.Position.X
                local barPos = PowerBar.AbsolutePosition.X
                local barSize = PowerBar.AbsoluteSize.X
                local newPos = math.clamp((mousePos - barPos) / barSize, 0, 1)

                PowerSlider.Position = UDim2.new(newPos, 0, 0, 0)
                flingPower = math.floor(newPos * 50000) + 5000
                PowerLabel.Text = "投掷力量：" .. flingPower
            end
        end)

        -- Р—Р°РїСѓСЃРє fling С†РёРєР»Р°
        task.spawn(fling)
    end
})



local aimbotEnabled = false
local aimbotConnection = nil

Tabs.Random:Toggle({
    Title = "自瞄",
    Default = false,
    Callback = function(state)
        aimbotEnabled = state
        if aimbotEnabled then
            aimbotConnection = RunService.RenderStepped:Connect(function()
                local cam = Workspace.CurrentCamera
                local myChar = LocalPlayer.Character
                if not (myChar and myChar:FindFirstChild("Head")) then return end
                local myHeadPos = myChar.Head.Position
                local minDist = math.huge
                local target
                for _, pl in pairs(Players:GetPlayers()) do
                    if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("Head") then
                        local dist = (pl.Character.Head.Position - myHeadPos).Magnitude
                        if dist < minDist then
                            minDist = dist
                            target = pl
                        end
                    end
                end
                if target and target.Character then
                    local headPos = target.Character.Head.Position
                    local camPos = cam.CFrame.Position
                    cam.CFrame = CFrame.new(camPos, headPos)
                end
            end)
        else
            if aimbotConnection then
                aimbotConnection:Disconnect()
                aimbotConnection = nil
            end
        end
    end
})

Tabs.Random:Button({
    Title = "加载轨道",
    Callback = function()
    
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- РџРµСЂРµРјРµРЅРЅС‹Рµ
local orbitActive = false
local orbitDistance = 10
local orbitSpeed = 5
local angle = 0
local targetPlayer = nil

-- Р¤СѓРЅРєС†РёСЏ РїРѕР»СѓС‡РµРЅРёСЏ РїРµСЂСЃРѕРЅР°Р¶Р°
local function getCharacter(player)
    return player.Character or player.CharacterAdded:Wait()
end

-- РћСЂР±РёС‚Р°
RunService.RenderStepped:Connect(function(dt)
    if not orbitActive or not targetPlayer then return end

    local targetChar = getCharacter(targetPlayer)
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local myChar = getCharacter(LocalPlayer)
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot or not targetRoot then return end

    angle = angle + orbitSpeed * dt
    local offset = Vector3.new(math.cos(angle) * orbitDistance, 0, math.sin(angle) * orbitDistance)
    myRoot.CFrame = CFrame.new(targetRoot.Position + offset, targetRoot.Position)
end)

-- РџРѕР»СѓС‡Р°РµРј СЃРїРёСЃРѕРє РёРіСЂРѕРєРѕРІ (РєСЂРѕРјРµ СЃРµР±СЏ)
local function getPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

Tabs.Random:Toggle({
    Title = "轨道玩家（你可以对屠夫使用，让他无法击中你）",
    Default = false,
    Callback = function(state)
        orbitActive = state
    end
})

-- Dropdown РґР»СЏ РІС‹Р±РѕСЂР° РёРіСЂРѕРєР°
Tabs.Random:Dropdown({
    Title = "选择玩家",
    Values = getPlayerNames(),
    Value = nil,
    Multi = false,
    AllowNone = true,
    Callback = function(choice)
        local chosen = Players:FindFirstChild(choice)
        if chosen then
            targetPlayer = chosen
            print("[环绕] 目标也选择", choice)
        else
            targetPlayer = nil
        end
    end
})

Tabs.Random:Slider({
    Title = "转速 ",
    Step = 0.5,
    Value = {Min = 1, Max = 50, Default = orbitSpeed},
    Suffix = " speed",
    Callback = function(val)
        orbitSpeed = val
    end
})

Tabs.Random:Slider({
    Title = " 轨道距离",
    Step = 1,
    Value = {Min = 1, Max = 20, Default = orbitDistance},
    Suffix = " studs",
    Callback = function(val)
        orbitDistance = val
    end
})

end
})

Tabs.Random:Button({
    Title = "加速",
    Callback = function()
    
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local sprintModule = require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)

-- сохраняем стандартное значение
local defaultSprintSpeed = sprintModule.SprintSpeed

-- создаём GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui

local DragButton = Instance.new("TextButton")
DragButton.Size = UDim2.new(0, 70, 0, 35) -- чуть больше, чтобы текст хорошо помещался
DragButton.Position = UDim2.new(0.05, 0, 0.2, 0)
DragButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- чёрный фон
DragButton.BorderSizePixel = 2
DragButton.Text = "Boost"
DragButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- белый текст
DragButton.TextSize = 16 -- нормальный размер текста
DragButton.Font = Enum.Font.SourceSansBold -- жирный шрифт для читаемости
DragButton.Parent = ScreenGui

-- зелёная обводка
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 0)
UIStroke.Thickness = 2
UIStroke.Parent = DragButton

-- делаем кнопку перетаскиваемой
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	DragButton.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end

DragButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = DragButton.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

DragButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- логика кнопки с таймером
local debounce = false
DragButton.MouseButton1Click:Connect(function()
	if debounce then return end
	debounce = true

	-- ставим SprintSpeed = 37
	sprintModule.SprintSpeed = 37

	-- обратный отсчёт
	for i = 5, 1, -1 do
		DragButton.Text = tostring(i)
		task.wait(1)
	end

	-- возвращаем стандартное значение
	sprintModule.SprintSpeed = defaultSprintSpeed
	DragButton.Text = "Boost"
	debounce = false
end)

end
})

Tabs.Generator:Button({
    Title = "修理发电机手册",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/tPWnvGj6"))()
        WindUI:Notify({ Title = "修理发电机手册", Content = "来自 bublik6241 的问候", Duration = 2 })
    end
})

local loopty = false
local running = true
local BypassCooldown = true
local Dogens = true
local SkibidiWait = 1
local SkibidiRandomness = 0.5
local LopticaWaitTime = 1

local function SkibidiGenerator(shouldLoop)
    while shouldLoop and running do
        loopty = true
        local PuzzleUI = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PuzzleUI", 9999)

        local FartNapFolder = workspace:FindFirstChild("Map")
            and workspace.Map:FindFirstChild("Ingame")
            and workspace.Map.Ingame:FindFirstChild("Map")
        if FartNapFolder then
            local closestGenerator, closestDistance = nil, math.huge
            local playerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            for _, g in ipairs(FartNapFolder:GetChildren()) do
                if g.Name == "Generator" and g.Progress.Value < 100 then
                    local distance = (g:GetPivot().Position - playerPosition).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestGenerator = g
                    end
                end
            end
            if closestGenerator then
                while closestGenerator.Progress.Value < 100 and loopty do
                    if BypassCooldown then
                        while
                            closestGenerator.Progress.Value < 100
                            and loopty
                            and shouldLoop
                            and Dogens
                            and BypassCooldown
                        do
                            task.wait(0.5)
                            closestGenerator.Remotes.RE:FireServer()
                            task.wait(0.5)
                            closestGenerator.Remotes.RF:InvokeServer("leave")
                            if closestGenerator.Main:WaitForChild("Prompt", 1) then
                                fireproximityprompt(closestGenerator.Main:WaitForChild("Prompt", 1))
                            end
                        end
                    else
                        task.wait(SkibidiWait + math.random(0, SkibidiRandomness))
                        closestGenerator.Remotes.RE:FireServer()
                        break
                    end
                end
            else
                return
            end
        end
    end
    loopty = false
end

local function TpDoGenerator()
    local wasloopty = loopty
    if loopty then
        task.spawn(SkibidiGenerator(false))
    end
    local Geneators = workspace:WaitForChild("Map")
        and workspace.Map:WaitForChild("Ingame")
        and workspace.Map.Ingame:WaitForChild("Map")
    local lastPosition = Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    local function findGenerators()
        local folder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
        local map = folder and folder:FindFirstChild("Map")
        local generators = {}
        if map then
            for _, g in ipairs(map:GetChildren()) do
                if g.Name == "Generator" and g.Progress.Value < 100 then
                    local playersNearby = false
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (player.Character.HumanoidRootPart.Position - g.Main.Position).Magnitude
                            if distance < 25 then
                                playersNearby = true
                                break
                            end
                        end
                    end
                    if not playersNearby then
                        table.insert(generators, g)
                    end
                end
            end
        end
        if wasloopty then
            SkibidiGenerator(true)
        end
        return generators
    end

    while true do
        local generators = findGenerators()
        if #generators == 0 then
            break
        end
        for _, g in ipairs(generators) do
            local player = game.Players.LocalPlayer
            local generatorPosition = g.Instances.Generator.Progress.CFrame.Position
            local generatorDirection = (g.Instances.Generator.Cube.CFrame.Position - generatorPosition).Unit
            player.Character.HumanoidRootPart.CFrame = CFrame.new(
                generatorPosition + Vector3.new(0, 0.5, 0),
                generatorPosition + Vector3.new(generatorDirection.X, 0, generatorDirection.Z)
            )
            task.wait(LopticaWaitTime / 1.8)
            fireproximityprompt(g.Main:WaitForChild("Prompt", 1))
            for _ = 1, 6 do
                task.wait(1.7)
                g.Remotes.RE:FireServer()
            end
            task.wait(LopticaWaitTime / 1)
            g.Remotes.RF:InvokeServer("leave")
        end
    end

    if lastPosition then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = lastPosition
    end
end

Tabs.Generator:Button({
    Title = "自动修复发电机",
    Callback = function()
        task.spawn(TpDoGenerator)
        WindUI:Notify({ Title = "自动修复", Content = "开始维修所有发电机！", Duration = 3 })
    end,
})

Tabs.Credits:Divider()

Tabs.Credits:Button({
    Title = "复制汉化作者QQ群",
    Description = "点击复制汉化作者QQ群,
    Callback = function()
        setclipboard("555044756")
        WindUI:Notify({
            Title = "复制成功!",
            Content = "汉化作者QQ群已复制到剪贴板上",
            Duration = 3,
        })
    end,
})

Tabs.Credits:Button({
    Title = "复制汉化作者QQ号",
    Description = "点击复制汉化作者QQ号",
    Callback = function()
        setclipboard("2137844138")
        WindUI:Notify({
            Title = "复制成功!",
            Content = "汉化作者QQ号已复制到剪贴板上",
            Duration = 3,
        })
    end,
})

Tabs.Credits:Divider()

Tabs.Credits:Paragraph({
    Title = "汉化作者",
    Desc = "这个脚本，由YirdeX汉化，源代码取自于别的群，然后再进行汉化，汉化作者在快手和B站上都有号，目前正在做缝合脚本，收集更多有趣的脚本👍",
    Color = "Green",
    Locked = false,
})
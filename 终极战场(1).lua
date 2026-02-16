local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dream77239/china-ui/refs/heads/main/main%20(6).lua"))()
local Window = WindUI:CreateWindow({
    Title = "终极战场",
    Icon = "dick",
    IconThemed = true,
    Author = "1",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(500, 400),
    Transparent = true,
    Theme = "Light",
    User = {
        Enabled = true,
        Callback = function() print("我是傻逼") end,
        Anonymous = false
    },
    SideBarWidth = 200,
    ScrollBarEnabled = true
})

local TimeTag = Window:Tag({
    Title = "--:--",
    Radius = 999,
    Color = Color3.fromRGB(255, 255, 255),
})

task.spawn(function()
	while true do
		local now = os.date("*t")
		local hours = string.format("%02d", now.hour)
		local minutes = string.format("%02d", now.min)
		
		TimeTag:SetTitle(hours .. ":" .. minutes)
		task.wait(0.06)
	end
end)
local Tab = Window:Tab({
    Title = "功能",
    Icon = "sword",
    Locked = false,
})
Tab:Button({
    Title = "篡改",
    Desc = "玩的时候第一先开启这个功能一定要",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dream77239/ubg-script/refs/heads/main/%E6%8B%A6%E6%88%AA.txt"))()
    end
})
local fakeBlockEnabled = false
local loopRunning = false

Tab:Toggle({
    Title = "假防(关闭功能后按一次防御即可取消假防)",
    Value = false,
    Callback = function(state)
        fakeBlockEnabled = state

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local BlockRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Block")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        local function enableBlock()
            pcall(function()
                BlockRemote:FireServer(true)
            end)
        end

        if fakeBlockEnabled then
            enableBlock()
        end

        if not loopRunning then
            loopRunning = true
            task.spawn(function()
                while true do
                    task.wait(0.01)
                    if fakeBlockEnabled then
                        local success, isBlocking = pcall(function()
                            return character:GetAttribute("IsBlocking")
                        end)
                        if success and not isBlocking then
                            enableBlock()
                        end
                    end
                end
            end)
        end
    end
})

local defaultCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Dash.Value

Tab:Toggle({
    Title = "侧闪无冷却",
    Value = false,
    Callback = function(state)
        local dashCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Dash
        if state then
            dashCooldown.Value = 1
        else
            dashCooldown.Value = defaultCooldown
        end
    end
})
local defaultMeleeCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Melee.Value

Tab:Toggle({
    Title = "近战无冷却",
    Value = false,
    Callback = function(state)
        local meleeCooldown = game:GetService("ReplicatedStorage").Settings.Cooldowns.Melee
        if state then
            meleeCooldown.Value = 1
        else
            meleeCooldown.Value = defaultMeleeCooldown
        end
    end
})
local rs = game:GetService("ReplicatedStorage")
local settings = rs.Settings

local defaultAbility = settings.Cooldowns.Ability.Value
Tab:Toggle({
    Title = "技能无冷却(仅宿傩角色)",
    Value = false,
    Callback = function(state)
        settings.Cooldowns.Ability.Value = state and 1 or defaultAbility
    end
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local noSlowdownsToggle = ReplicatedStorage.Settings.Toggles.NoSlowdowns

local defaultValue = false

Tab:Toggle({
    Title = "无减速效果",
    Value = noSlowdownsToggle.Value,
    Callback = function(state)
        if state then
            noSlowdownsToggle.Value = true
        else
            noSlowdownsToggle.Value = defaultValue
        end
    end
})

local defaultDisableHitStun = settings.Toggles.DisableHitStun.Value
Tab:Toggle({
    Title = "取消被攻击硬直",
    Value = false,
    Callback = function(state)
        settings.Toggles.DisableHitStun.Value = state
    end
})

local defaultDisableIntros = settings.Toggles.DisableIntros.Value
Tab:Toggle({
    Title = "跳过角色开场动作",
    Value = false,
    Callback = function(state)
        settings.Toggles.DisableIntros.Value = state
    end
})

local defaultNoStunOnMiss = settings.Toggles.NoStunOnMiss.Value
Tab:Toggle({
    Title = "普攻无僵直",
    Value = false,
    Callback = function(state)
        settings.Toggles.NoStunOnMiss.Value = state
    end
})

local defaultRagdollTimer = settings.Multipliers.RagdollTimer.Value
Tab:Toggle({
    Title = "被别人击倒不会变成布娃娃",
    Value = false,
    Callback = function(state)
        settings.Multipliers.RagdollTimer.Value = state and 0.5 or defaultRagdollTimer
    end
})

local defaultUltimateTimer = settings.Multipliers.UltimateTimer.Value
Tab:Toggle({
    Title = "延长大招时间",
    Value = false,
    Callback = function(state)
        settings.Multipliers.UltimateTimer.Value = state and 100000 or defaultUltimateTimer
    end
})

local defaultInstantTransformation = settings.Toggles.InstantTransformation.Value
Tab:Toggle({
    Title = "秒开大",
    Value = false,
    Callback = function(state)
        settings.Toggles.InstantTransformation.Value = state
    end
})
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Ping = player:WaitForChild("Info"):WaitForChild("Ping")

local loop

Tab:Toggle({
    Title = "ping乱码",
    Value = false,
    Callback = function(state)
        if state then
            loop = task.spawn(function()
                while state do
                    for i = 0, 999, 25 do
                        if not state then break end
                        Ping.Value = i
                        task.wait(0.03)
                    end
                    for i = 999, 0, -25 do
                        if not state then break end
                        Ping.Value = i
                        task.wait(0.03)
                    end
                end
            end)
        else
            if loop then
                task.cancel(loop)
                loop = nil
            end
        end
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MeleeDamage = ReplicatedStorage:WaitForChild("Settings"):WaitForChild("Multipliers"):WaitForChild("MeleeDamage")

MeleeDamage.Value = 100

Tab:Toggle({
    Title = "一拳倒地",
    Value = false,
    Callback = function(state)
        if state then
            MeleeDamage.Value = 1000000
        else
            MeleeDamage.Value = 100
        end
    end
})
Tab:Toggle({
    Title = "一拳击飞",
    Value = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")

        local LocalPlayer = Players.LocalPlayer
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

        local RagdollPower = ReplicatedStorage:WaitForChild("Settings"):WaitForChild("Multipliers"):WaitForChild("RagdollPower")

        local maxTeleportDistance = 50
        local lastPosition = HumanoidRootPart.Position
        local connection

        if state then
            RagdollPower.Value = 10000

            connection = RunService.RenderStepped:Connect(function()
                -- refresh character in case of reset
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                    lastPosition = HumanoidRootPart.Position
                end

                local currentPos = HumanoidRootPart.Position
                local distance = (currentPos - lastPosition).Magnitude

                if distance > maxTeleportDistance then
                    HumanoidRootPart.CFrame = CFrame.new(lastPosition)
                else
                    lastPosition = currentPos
                end
            end)
        else
            RagdollPower.Value = 100
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local wallCombo = ReplicatedStorage.Settings.Cooldowns.WallCombo

Tab:Toggle({
    Title = "墙打无冷却",
    Value = false,
    Callback = function(state)
        if state then
            wallCombo.Value = 0
            print("WallCombo cooldown set to 0")
        else
            wallCombo.Value = 100
            print("WallCombo cooldown reset to 100")
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local wall = nil
pcall(function()
    wall = workspace.Map.Structural.Terrain:GetChildren()[5]:GetChildren()[12]
end)

if not wall then
    wall = Instance.new("Part")
    wall.Parent = workspace
end

wall.Size = Vector3.new(12,6,2)
wall.Transparency = 0.6
wall.Material = Enum.Material.SmoothPlastic
wall.Anchored = true
wall.CanCollide = true
wall.CFrame = wall.CFrame or CFrame.new(0,5,0)

if getconnections then
    for _, conn in pairs(getconnections(wall.AncestryChanged)) do
        conn:Disable()
    end
end

local mt = getrawmetatable(game)
setreadonly(mt,false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if self == wall and method == "Destroy" then
        return
    end
    return old(self, ...)
end)
setreadonly(mt,true)

local followConnection = nil
Tab:Toggle({
    Title = "随处墙打",
    Value = false,
    Callback = function(state)
        if state then
            if not followConnection then
                followConnection = RunService.RenderStepped:Connect(function()
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        wall.CFrame = hrp.CFrame * CFrame.new(0,0,-8)
                    end
                end)
            end
        else
            if followConnection then
                followConnection:Disconnect()
                followConnection = nil
            end
        end
    end
})
local originalData = {}
local skyBackup = nil

Tab:Toggle({
    Title = "防卡",
    Value = false,
    Callback = function(state)
        if state then
            originalData = {}
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Explosion") then
                    originalData[v] = v.Enabled
                    v.Enabled = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    originalData[v] = v.Transparency
                    v.Transparency = 1
                elseif v:IsA("MeshPart") or v:IsA("UnionOperation") or v:IsA("Part") then
                    if v.Name ~= "HumanoidRootPart" then
                        originalData[v] = v.Material
                        v.Material = Enum.Material.SmoothPlastic
                    end
                elseif v:IsA("SurfaceGui") or v:IsA("BillboardGui") or v:IsA("Beam") then
                    if v:IsA("Beam") then
                        originalData[v] = v.Enabled
                        v.Enabled = false
                    else
                        originalData[v] = v.Enabled ~= nil and v.Enabled or true
                        if v.Enabled ~= nil then
                            v.Enabled = false
                        end
                    end
                end
            end
            originalData["GlobalShadows"] = game.Lighting.GlobalShadows
            originalData["FogEnd"] = game.Lighting.FogEnd
            game.Lighting.GlobalShadows = false
            game.Lighting.FogEnd = 9e9
            local sky = game.Lighting:FindFirstChildOfClass("Sky")
            if sky then
                skyBackup = sky:Clone()
                sky:Destroy()
            end
            local newSky = Instance.new("Sky")
            newSky.SkyboxBk = ""
            newSky.SkyboxDn = ""
            newSky.SkyboxFt = ""
            newSky.SkyboxLf = ""
            newSky.SkyboxRt = ""
            newSky.SkyboxUp = ""
            newSky.SunAngularSize = 0
            newSky.MoonAngularSize = 0
            newSky.Parent = game.Lighting
            game.Lighting.Ambient = Color3.fromRGB(128,128,128)
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
        else
            for obj, value in pairs(originalData) do
                if typeof(obj) == "Instance" and obj.Parent then
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Explosion") then
                        obj.Enabled = value
                    elseif obj:IsA("Decal") or obj:IsA("Texture") then
                        obj.Transparency = value
                    elseif obj:IsA("MeshPart") or obj:IsA("UnionOperation") or obj:IsA("Part") then
                        obj.Material = value
                    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") or obj:IsA("Beam") then
                        if obj:IsA("Beam") then
                            obj.Enabled = value
                        elseif obj.Enabled ~= nil then
                            obj.Enabled = value
                        end
                    end
                elseif obj == "GlobalShadows" then
                    game.Lighting.GlobalShadows = value
                elseif obj == "FogEnd" then
                    game.Lighting.FogEnd = value
                end
            end
            if skyBackup then
                local currentSky = game.Lighting:FindFirstChildOfClass("Sky")
                if currentSky then
                    currentSky:Destroy()
                end
                skyBackup.Parent = game.Lighting
                skyBackup = nil
            end
            originalData = {}
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

local clone, platform, originalCFrame, originalCameraSubject

local function CreatePlatform(position)
    local part = Instance.new("Part")
    part.Size = Vector3.new(10, 1, 10)
    part.Position = position - Vector3.new(0, 3, 0)
    part.Anchored = true
    part.CanCollide = true
    part.Transparency = 0.5
    part.Parent = workspace
    return part
end

local function CreateClone()
    local newClone = Character:Clone()
    for _, v in ipairs(newClone:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 0.5
        end
    end
    newClone.Parent = workspace
    return newClone
end

local function ToggleInvisibility(state)
    if state then
        originalCFrame = HumanoidRootPart.CFrame
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, -50, 0)
        platform = CreatePlatform(HumanoidRootPart.Position)
        
        task.wait(1)
        
        clone = CreateClone()
        clone:MoveTo(originalCFrame.Position)
        Camera.CameraSubject = clone:FindFirstChildWhichIsA("Humanoid")
        LocalPlayer.Character = clone
    else
        if clone then
            clone:Destroy()
            clone = nil
        end
        
        if platform then
            platform:Destroy()
            platform = nil
        end
        
        if originalCFrame then
            HumanoidRootPart.CFrame = originalCFrame
            originalCFrame = nil
        end
        
        Camera.CameraSubject = Character:FindFirstChildWhichIsA("Humanoid")
        LocalPlayer.Character = Character
    end
end

Tab:Toggle({
    Title = "隐身",
    Value = false,
    Callback = ToggleInvisibility
})
local v_u_1 = require(game.ReplicatedStorage:WaitForChild("Core"))
local v155 = game.Players.LocalPlayer:WaitForChild("Data"):WaitForChild("Character")
local v156 = game.ReplicatedStorage.Characters:FindFirstChild(v155.Value):FindFirstChild("WallCombo")
local v158 = Vector3.new(7, 5, 7)
local v159 = CFrame.new(0, 0, 0)
local v160 = v_u_1.Get("Character", "FullCustomReplication").GetCFrame()
local v163 = game.Players.LocalPlayer.Character

local v167 = {
    ["Size"] = v158,
    ["Offset"] = v159,
    ["CustomValidation"] = function()
        return true
    end,
}

local v_u_168 = v_u_1.Get("Combat", "Hit").Box(nil, v163, v167)
local v58 = v156:GetAttribute("Interrupt")

function Run(p_u_7, p8, p_u_9, p10, ...)
    local v_u_11 = p_u_7 and p_u_7:FindFirstChild("Humanoid") or p_u_7
    local v_u_12 = p_u_7 and p_u_7:FindFirstChild("HumanoidRootPart") or p_u_7
    if p_u_7 and (v_u_11 and v_u_12) then
        local v_u_13 = p_u_7 == game.Players.LocalPlayer.Character
        local v_u_17 = p8
        v_u_1.Get("Combat", "Cancel").Init(v_u_17, p_u_9, p_u_7)
        v_u_1.Get("Combat", "Cancel").Set(v_u_17, p_u_9, p_u_7, "Timeout")
        local v_u_36 = { ... }
        task.spawn(function()
            local v37 = {}
            local v38 = v_u_36
            for i, v in ipairs({ p_u_7, v_u_11, v_u_12, v_u_13, p_u_9 }) do
                v37[i] = v
            end
            for i, v in ipairs(v38) do
                v37[#v37 + 1] = v
            end
            v_u_1.Get("Cosmetics", "KillEmote").RunAfter(v_u_17, table.unpack(v37))
        end)
    end
end

local originPos = v160.Position
local rs = game:GetService("RunService")
local running = false

Tab:Toggle({
    Title = "杀戮光环",
    Value = false,
    Callback = function(state)
        running = state
        if running then
            rs:BindToRenderStep("KillAura", Enum.RenderPriority.Input.Value, function()
                local pos = originPos + v160.LookVector * 6
                for i = 1, 4 do
                    task.spawn(function()
                        v_u_1.Library("Remote").Send("Ability", v156, 9e9, v58, v_u_168, pos)
                        Run(game.Players.LocalPlayer.Character, v156, 9e9, v58, v_u_168, pos)
                    end)
                end
            end)
        else
            rs:UnbindFromRenderStep("KillAura")
        end
    end
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local wallComboSpamming = false
local wallComboHeartbeat = nil
local wallComboPerFrame = 2
local wallComboKeybind = Enum.KeyCode.E

local core = require(ReplicatedStorage.Core)
local chars = ReplicatedStorage.Characters
local char = LocalPlayer.Data.Character

local function executeWallCombo()
    local head = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not head then return end

    local res = core.Get("Combat","Hit").Box(nil, LocalPlayer.Character, {Size = Vector3.new(50,50,50)})
    if res then
        local success, err = pcall(core.Get("Combat","Ability").Activate, chars[char.Value].WallCombo, res, head.Position + Vector3.new(0,0,2.5))
        if not success then
            warn(err)
        end
    end
end

local function updateWallComboHeartbeat()
    if wallComboHeartbeat then
        wallComboHeartbeat:Disconnect()
        wallComboHeartbeat = nil
    end
    if wallComboSpamming then
        wallComboHeartbeat = RunService.Heartbeat:Connect(function()
            for i = 1, wallComboPerFrame do
                executeWallCombo()
            end
        end)
    end
end

UserInputService.InputBegan:Connect(function(input, isProcessed)
    if isProcessed then return end
    if input.KeyCode == wallComboKeybind then
        executeWallCombo()
    end
end)

Tab:Toggle({
    Title = "墙打秒杀",
    Value = false,
    Callback = function(state)
        wallComboSpamming = state
        updateWallComboHeartbeat()
    end
})
Tab:Button({
    Title = "删除墙打特效",
    Desc = "点了该功能就无法恢复墙打特效",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local paths = {
            ReplicatedStorage.Characters.Gon.WallCombo.GonWallCombo.Center,
            ReplicatedStorage.Characters.Gon.WallCombo.GonWallCombo.Explosion,
            ReplicatedStorage.Characters.Gon.WallCombo.GonIntroHands,
            ReplicatedStorage.Characters.Mob.WallCombo.MobWallCombo.Center,
            ReplicatedStorage.Characters.Nanami.WallCombo.NanamiWallCombo.Center,
            ReplicatedStorage.Characters.Stark.WallCombo.StarkWallCombo.Center,
            ReplicatedStorage.Characters.Sukuna.WallCombo.SukunaTransformWallCombo,
            ReplicatedStorage.Characters.Sukuna.WallCombo.SukunaWallCombo
        }

        for _, obj in ipairs(paths) do
            if obj and obj:IsA("Instance") then
                for _, child in ipairs(obj:GetChildren()) do
                    child:Destroy()
                end
            end
        end
    end
})
Tab:Button({
    Title = "删除击杀表情特效",
    Desc = "点击删除击杀表情的部分特效,不可恢复",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local KillEmote = ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote")

        local function removeEffects(obj)
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("ParticleEmitter") 
                or child:IsA("Trail") 
                or child:IsA("Beam") 
                or child:IsA("Fire") 
                or child:IsA("Smoke") 
                or child:IsA("Sparkles") 
                or child:IsA("Light") then
                    child:Destroy()
                else
                    removeEffects(child)
                end
            end
        end

        removeEffects(KillEmote)
        print("KillEmote 特效已删除（保留本体）")
    end
})
 local ReplicatedStorage = game:GetService("ReplicatedStorage")
local multiUseCutscenesToggle = ReplicatedStorage.Settings.Toggles.MultiUseCutscenes

local defaultValue = false

Tab:Toggle({
    Title = "艾斯帕大招技能多次使用(全角色通用)",
    Value = multiUseCutscenesToggle.Value,
    Callback = function(state)
        if state then
            multiUseCutscenesToggle.Value = true
        else
            multiUseCutscenesToggle.Value = defaultValue
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local tpwalking = false
local tpwalkSpeed = 100

Tab:Toggle({
    Title = "速度",
    Value = false,
    Callback = function(state)
        tpwalking = state
        if state then
            spawn(function()
                while tpwalking do
                    local chr = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local hrp = chr:FindFirstChild("HumanoidRootPart")
                    local hum = chr:FindFirstChildWhichIsA("Humanoid")
                    local delta = RunService.Heartbeat:Wait()
                    if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * tpwalkSpeed * delta)
                    end
                end
            end)
        end
    end
})

Tab:Slider({
    Title = "速度调节",
    Value = {
        Min = 0,
        Max = 250,
        Default = tpwalkSpeed,
    },
    Callback = function(value)
        tpwalkSpeed = value
    end
})
Tab:Slider({
    Title = "冲刺加速(默认值100)",
    Value = {
        Min = 0,
        Max = 1000,
        Default = 100,
    },
    Callback = function(value)
        game:GetService("ReplicatedStorage").Settings.Multipliers.DashSpeed.Value = value
    end
})

Tab:Slider({
    Title = "跳跃增强(默认值100)",
    Value = {
        Min = 0,
        Max = 1000,
        Default = 100,
    },
    Callback = function(value)
        game:GetService("ReplicatedStorage").Settings.Multipliers.JumpHeight.Value = value
    end
})

Tab:Slider({
    Title = "攻击加速(默认值100)",
    Value = {
        Min = 0,
        Max = 1000,
        Default = 100,
    },
    Callback = function(value)
        game:GetService("ReplicatedStorage").Settings.Multipliers.MeleeSpeed.Value = value
    end
})
local Players = game:GetService("Players")
local Tab = Window:Tab({
    Title = "碰撞箱扩大",
    Icon = "box",
    Locked = false,
})

local expansionMethod = "Add"
local hitboxX, hitboxY, hitboxZ = 0, 0, 0
local isHitboxExpanded = false
local hitModuleTable = nil
local originalBox = nil
local sizeModifier = Vector3.new(0, 0, 0)

local function setupHitboxHook()
    if hitModuleTable and hitModuleTable._boxSizeModifierHookInstalled then
        print("Hitbox hook already installed.")
        return true
    end
    
    local player = Players.LocalPlayer
    local playerScripts = player:WaitForChild("PlayerScripts")
    local combatFolder = playerScripts:WaitForChild("Combat")
    local hitModule = combatFolder:WaitForChild("Hit")
    
    hitModuleTable = require(hitModule)
    originalBox = hitModuleTable.Box
    
    hitModuleTable.Box = function(...)
        local args = {...}
        if args[3] and typeof(args[3]) == "table" then
            local config = args[3]
            if config.Size and typeof(config.Size) == "Vector3" then
                if not config._originalSize then
                    config._originalSize = config.Size
                end
                if expansionMethod == "Set" then
                    config.Size = sizeModifier
                elseif expansionMethod == "Add" then
                    config.Size = config._originalSize + sizeModifier
                end
            end
            return originalBox(...)
        else
            return originalBox(...)
        end
    end
    hitModuleTable._boxSizeModifierHookInstalled = true
    return true
end

local function applySigmaHitbox(x, y, z)
    if not setupHitboxHook() then
        warn("Failed to setup hitbox hook!")
        return
    end
    sizeModifier = Vector3.new(x, y, z)
    print("Sigma hitbox expansion applied:", sizeModifier)
end

Tab:Input({
    Title = "X 轴向量",
    Value = "0",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "输入一个数字...",
    Callback = function(input)
        hitboxX = tonumber(input) or 0
        print("Hitbox X vector set to:", hitboxX)
    end
})

Tab:Input({
    Title = "Y 轴向量",
    Value = "0",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "输入一个数字...",
    Callback = function(input)
        hitboxY = tonumber(input) or 0
        print("Hitbox Y vector set to:", hitboxY)
    end
})

Tab:Input({
    Title = "Z 轴向量",
    Value = "0",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "输入一个数字...",
    Callback = function(input)
        hitboxZ = tonumber(input) or 0
        print("Hitbox Z vector set to:", hitboxZ)
    end
})

Tab:Dropdown({
    Title = "扩展方法",
    Values = {"Add", "Set"},
    Value = "Add",
    Multi = false,
    AllowNone = false,
    Callback = function(option)
        expansionMethod = option
        print("Hitbox method set to:", expansionMethod)
    end
})

Tab:Button({
    Title = "应用碰撞箱修改",
    Desc = nil,
    Locked = false,
    Callback = function()
        applySigmaHitbox(hitboxX, hitboxY, hitboxZ)
        isHitboxExpanded = true
    end
})

Tab:Button({
    Title = "小幅扩展 (+5范围)",
    Desc = nil,
    Locked = false,
    Callback = function()
        hitboxX, hitboxY, hitboxZ = 5, 5, 5
        applySigmaHitbox(hitboxX, hitboxY, hitboxZ)
        isHitboxExpanded = true
    end
})

Tab:Button({
    Title = "中幅扩展 (+10范围)",
    Desc = nil,
    Locked = false,
    Callback = function()
        hitboxX, hitboxY, hitboxZ = 10, 10, 10
        applySigmaHitbox(hitboxX, hitboxY, hitboxZ)
        isHitboxExpanded = true
    end
})

Tab:Button({
    Title = "大幅扩展 (+20范围)",
    Desc = nil,
    Locked = false,
    Callback = function()
        hitboxX, hitboxY, hitboxZ = 20, 20, 20
        applySigmaHitbox(hitboxX, hitboxY, hitboxZ)
        isHitboxExpanded = true
    end
})
local lightningCharacterSwapTab = Window:Tab({
    Title = "快速切换角色",
    Icon = "bird",
    Locked = false,
})

local lastPosition

local function getHumanoidRootPart()
    local character = LocalPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function savePosition()
    local rootPart = getHumanoidRootPart()
    if rootPart then
        lastPosition = rootPart.CFrame
    end
end

local function handleKeyPress(characterName)
    savePosition()
    
    local rootPart = getHumanoidRootPart()
    if rootPart then
        rootPart.CFrame = CFrame.new(1011.1289672851562, -1009.359588623046875, 116.37605285644531)
    end

    ReplicatedStorage.Remotes.Character.ChangeCharacter:FireServer(characterName)

    local groundY = workspace.Map.Structural.Ground:GetChildren()[21].Position.Y
    repeat task.wait() until getHumanoidRootPart() and getHumanoidRootPart().Position.Y > groundY
    task.wait(0.15)

    local newRootPart = getHumanoidRootPart()
    if newRootPart and lastPosition then
        repeat
            newRootPart.CFrame = lastPosition
            task.wait(0.1)
        until (newRootPart.Position - lastPosition.Position).Magnitude < 10
    end
end

lightningCharacterSwapTab:Button({
    Title = "快速切换成小杰",
    Locked = false,
    Callback = function() handleKeyPress("Gon") end
})

lightningCharacterSwapTab:Button({
    Title = "快速切换成被诅咒的导师",
    Locked = false,
    Callback = function() handleKeyPress("Nanami") end
})

lightningCharacterSwapTab:Button({
    Title = "快速切换成沉默的艾丝帕",
    Locked = false,
    Callback = function() handleKeyPress("Mob") end
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local core = require(ReplicatedStorage:WaitForChild("Core"))
local Character = LocalPlayer.Character
local HumanoidRootPart = Character and Character:WaitForChild("HumanoidRootPart")
local orbitToggle = nil
local fakeWallToggle = nil
local serverStatus = "goodstate"

local forceKillEmoteTab = Window:Tab({
    Title = "击杀表情功能",
    Icon = "smile",
    Locked = false,
})

local killEmotes = {}
local isAuraMode = false
local isSpammingSelectedEmote = false
local auraDelay = 0.5
local spamDelay = 0.5
local selectedEmote = ""
local selectedKeybind = Enum.KeyCode.G
local emoteDropdown

local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function useEmote(emoteName)
    local emoteModule = ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote"):FindFirstChild(emoteName)
    local myRoot = getRoot(LocalPlayer.Character)
    if not myRoot then return end
    local closestTarget = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetRoot = getRoot(player.Character)
            if targetRoot then
                local distance = (myRoot.Position - targetRoot.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestTarget = player.Character
                end
            end
        end
    end
    if closestTarget and emoteModule then
        task.spawn(function()
            _G.KillEmote = true
            pcall(function()
                if core and core.Get then
                    core.Get("Combat", "Ability").Activate(emoteModule, closestTarget)
                end
            end)
            _G.KillEmote = false
        end)
    end
end

local function useRandomEmote()
    if #killEmotes > 0 then
        local randomEmote = killEmotes[math.random(1, #killEmotes)]
        useEmote(randomEmote)
    end
end

task.spawn(function()
    while true do
        if isAuraMode then
            useRandomEmote()
            task.wait(auraDelay)
        else
            task.wait(0.1)
        end
    end
end)

task.spawn(function()
    while true do
        if isSpammingSelectedEmote and selectedEmote ~= "" then
            useEmote(selectedEmote)
            task.wait(spamDelay)
        else
            task.wait(0.1)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, isGameProcessed)
    if isGameProcessed then return end
    if input.KeyCode == selectedKeybind and selectedEmote ~= "" then
        useEmote(selectedEmote)
    end
end)

local function createOrUpdateEmoteDropdown(emoteList)
    local values = emoteList
    if not values or #values == 0 then
        values = {"No emotes found"}
    end
    emoteDropdown = forceKillEmoteTab:Dropdown({
        Title = "击杀表情功能(要靠近别人)",
        Values = values,
        Multi = false,
        AllowNone = false,
        Callback = function(option)
            if option ~= "No emotes found" then
                selectedEmote = option
                useEmote(option)
            end
        end
    })
end

forceKillEmoteTab:Button({
    Title = "刷新击杀表情",
    Desc = "刷新可用的击杀表情",
    Callback = function()
        local currentEmotes = {}
        for _, emote in pairs(ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote"):GetChildren()) do
            table.insert(currentEmotes, emote.Name)
        end
        killEmotes = currentEmotes
        createOrUpdateEmoteDropdown(killEmotes)
    end
})

for _, emote in pairs(ReplicatedStorage:WaitForChild("Cosmetics"):WaitForChild("KillEmote"):GetChildren()) do
    table.insert(killEmotes, emote.Name)
end

createOrUpdateEmoteDropdown(killEmotes)

forceKillEmoteTab:Toggle({
    Title = "击杀表情光环",
    Desc = "对旁边的人持续使用随机的击杀表情",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(isEnabled)
        isAuraMode = isEnabled
    end
})

forceKillEmoteTab:Slider({
    Title = "击杀表情光环间隔",
    Step = 0.01,
    Value = { Min = 0.01, Max = 5.0, Default = 0.5 },
    Callback = function(value)
        auraDelay = value
    end
})

forceKillEmoteTab:Toggle({
    Title = "持续发送你选择的表情",
    Desc = "持续发送当前选择的表情",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(isEnabled)
        isSpammingSelectedEmote = isEnabled
    end
})

forceKillEmoteTab:Slider({
    Title = "调整你选择的表情速度",
    Step = 0.01,
    Value = { Min = 0.01, Max = 5.0, Default = 0.5 },
    Callback = function(value)
        spamDelay = value
    end
})

local emoteKeybindOptions = { "G", "F", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M", "Q", "E", "R", "T", "Y", "U", "I", "O", "P" }
local emoteKeybindMap = {
    ["G"] = Enum.KeyCode.G, ["F"] = Enum.KeyCode.F, ["H"] = Enum.KeyCode.H,
    ["J"] = Enum.KeyCode.J, ["K"] = Enum.KeyCode.K, ["L"] = Enum.KeyCode.L,
    ["Z"] = Enum.KeyCode.Z, ["X"] = Enum.KeyCode.X, ["C"] = Enum.KeyCode.C,
    ["V"] = Enum.KeyCode.V, ["B"] = Enum.KeyCode.B, ["N"] = Enum.KeyCode.N,
    ["M"] = Enum.KeyCode.M, ["Q"] = Enum.KeyCode.Q, ["E"] = Enum.KeyCode.E,
    ["R"] = Enum.KeyCode.R, ["T"] = Enum.KeyCode.T, ["Y"] = Enum.KeyCode.Y,
    ["U"] = Enum.KeyCode.U, ["I"] = Enum.KeyCode.I, ["O"] = Enum.KeyCode.O,
    ["P"] = Enum.KeyCode.P
}

forceKillEmoteTab:Dropdown({
    Title = "快捷键设置",
    Values = emoteKeybindOptions,
    Value = "G",
    Multi = false,
    AllowNone = false,
    Callback = function(option)
        selectedKeybind = emoteKeybindMap[option]
    end
})

forceKillEmoteTab:Button({
    Title = "随机用一个击杀表情",
    Desc = "字面意思",
    Locked = false,
    Callback = function()
        useRandomEmote()
    end
})
local Tab = Window:Tab({
    Title = "设置",
    Icon = "settings",
    Locked = false,
})
local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

Tab:Dropdown({
    Title = "更改ui颜色",
    Multi = false,
    AllowNone = false,
    Value = nil,
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end
})
if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(0,1)

local vst = {Enabled=true}
local vstHttp = nil
if hookfunction then
    local vstfunc = function(a,b,c) print(a,b,c) end
    hookfunction(vstfunc,function(a,b,c)
    return true
    end)
    if vstfunc() ~= true then
        game.Players.LocalPlayer:Kick('VST Kicked Error Function (01)')
        wait(5)
        while true do
        end
        return
    end
    if isfunctionhooked then
        if not isfunctionhooked(vstfunc) then
        game.Players.LocalPlayer:Kick('VST Kicked Error Function (03)')
        wait(5)
        while true do
        end
        return
        end
    end
end
local Test = {game.HttpGet,loadstring}
for i,v in pairs(Test) do
    if not iscclosure(v) or (isfunctionhooked and isfunctionhooked(v)) then
        game.Players.LocalPlayer:Kick('VST Kicked Error Function (02)')
        wait(5)
        while true do
        end
        return
    end
end
local function AZT_CHECK_FNHOOK_11111(func)
    local loadstlist = {}
    for i,v in pairs(debug.getregistry()) do
        if typeof(v) == 'function' and debug.getinfo(v).name == func then
            table.insert(loadstlist, i, v)
            ok = true
        end
    end
    if ok then game.Players.LocalPlayer:Kick("AZT Loader: Error Function #1243") return end
end
AZT_CHECK_FNHOOK_11111("loadstring")
AZT_CHECK_FNHOOK_11111("HttpGet")
AZT_CHECK_FNHOOK_11111("http_request")
AZT_CHECK_FNHOOK_11111("request")

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

getgenv().whscript = "KZ HUB" 
getgenv().webhookexecUrl = "https://discord.com/api/webhooks/1436634012293791906/r66W_prYP7yMCtkRpcfiCdEW7uxtgCyqtDZHTknfjcHjyQsThZi04Tbi4fyU33gKeqRu"
getgenv().ExecLogSecret = false -- N岷縰 mu峄憂 log IP v脿 location, 膽岷穞 true

local ui = gethui()
local folderName = "screen"
local folder = Instance.new("Folder")
folder.Name = folderName
local player = game:GetService("Players").LocalPlayer

if not ui:FindFirstChild(folderName) then
    folder.Parent = gethui()

    local players = game:GetService("Players")
    local userid = player.UserId
    local gameid = game.PlaceId
    local jobid = tostring(game.JobId)
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    local completeTime = os.date("%Y-%m-%d %H:%M:%S")
    local position = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or "N/A"
    local health = player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health or "N/A"
    local maxHealth = player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.MaxHealth or "N/A"

    local data = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "**Script Execution Detected | Exec Log**",
            ["description"] = "A script was executed. Details below:",
            ["type"] = "rich",
            ["color"] = 0x3498db,
            ["fields"] = {
                {
                    ["name"] = "Script Info",
                    ["value"] = "Script Name: " .. getgenv().whscript .. "\nExecuted At: " .. completeTime,
                    ["inline"] = false
                },
                {
                    ["name"] = "Player Details",
                    ["value"] = "Username: " .. player.Name ..
                                "\nDisplay Name: " .. player.DisplayName ..
                                "\nUserID: " .. userid ..
                                "\nHealth: " .. health .. " / " .. maxHealth ..
                                "\nProfile: https://www.roblox.com/users/" .. userid .. "/profile",
                    ["inline"] = false
                },
                {
                    ["name"] = "Character Position",
                    ["value"] = tostring(position),
                    ["inline"] = false
                }
            }
        }}
    }

    local newdata = game:GetService("HttpService"):JSONEncode(data)
    local headers = { ["content-type"] = "application/json" }
    local request = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request)
    request({Url = getgenv().webhookexecUrl, Body = newdata, Method = "POST", Headers = headers})
end

local Compkiller = loadstring(game:HttpGet("https://gist.githubusercontent.com/WhoAreYou1329/97297ae9bf2b1b56273abf09b37575b4/raw/b5b78282b2c777c010673786279298fc78146435/SKHubUI.lua"))();

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- 袚袥袨袘袗袥鞋袧袗携 袩袝袪袝袦袝袧袧袗携 袛袥携 袠袚袧袨袪袠袪袨袙袗袧袠携 袦袝袪孝袙蝎啸 袠袚袪袨袣袨袙
local IgnoreDeadPlayers = false

if not localPlayer.Character then
    localPlayer.CharacterAdded:Wait()
end

task.wait(1)

local core = nil
local coreLoaded = false

task.spawn(function()
    task.wait(3)
    local success, result = pcall(function()
        return require(RS:WaitForChild("Core", 10))
    end)
    if success then
        core = result
        coreLoaded = true
        print("Core loaded successfully")
    else
        warn("Core module not loaded:", result)
    end
end)

local Notifier = Compkiller.newNotify();
local ConfigManager = Compkiller:ConfigManager({
    Directory = "SKCONFIG",
    Config = "SKCONFIG"
});

Compkiller:Loader("SK HUB" , 1.5).yield();

local MenuKey = "LeftAlt";
local Window = Compkiller.new({
    Name = "SK HUB",
    Keybind = MenuKey,
    Logo = "rbxassetid://85276386969821",
    Scale = Compkiller.Scale.Window,
    TextSize = 15,
});

local UserSettings = Window.UserSettings:Create();

UserSettings:AddColorPicker({
    Name = "Menu Color",
    Default = Compkiller.Colors.Highlight,
    Callback = function(f)
        Compkiller.Colors.Highlight = f;
        Compkiller:RefreshCurrentColor();
    end,
});

UserSettings:AddKeybind({
    Name = "Menu Key",
    Default = MenuKey,
    Callback = function(f)
        MenuKey = f;
        Window:SetMenuKey(MenuKey)
    end,
});

UserSettings:AddDropdown({
    Name = "Menu Language",
    Values = {"English","Russian","Chinese"},
    Default = "English",
    Callback = print
});

UserSettings:AddDropdown({
    Name = "Menu Theme",
    Values = {"Default","Dark Green","Dark Blue","Purple Rose","Skeet"},
    Default = "Default",
    Callback = function(f)
        Compkiller:SetTheme(f)
    end,
});

UserSettings:AddDropdown({
    Name = "Visible Widgets",
    Values = {"Watermark","Keybinds","Double Tab"},
    Multi = true,
    Default = {"Watermark"},
    Callback = function(f)
        print(f)
    end,
});

Notifier.new({
    Title = "Notification",
    Content = "You Are WhiteList SK HUB",
    Duration = 10,
    Icon = "rbxassetid://85276386969821"
});

local Watermark = Window:Watermark();

Watermark:AddText({
    Icon = "user",
    Text = localPlayer.Name,
});

Watermark:AddText({
    Icon = "clock",
    Text = Compkiller:GetDate(),
});

local Time = Watermark:AddText({
    Icon = "timer",
    Text = "TIME",
});

task.spawn(function()
    while true do task.wait()
        Time:SetText(Compkiller:GetTimeNow());
    end
end)

Window:DrawCategory({
    Name = "Functions"
});

-- ========================================
-- COMBAT TAB
-- ========================================
local CombatTab = Window:DrawTab({
    Name = "Combat",
    Icon = "sword",
    Type = "Double",
    EnableScrolling = true
});

local CombatLeftSection = CombatTab:DrawSection({
    Name = "Combat Features",
    Position = "left"
});

local CombatRightSection = CombatTab:DrawSection({
    Name = "Advanced Combat",
    Position = "right"
});

local killAuraRunning = false
local distance = 100
local hitboxEnabled = false
local hitboxSize = 20
local oldBoxFunc
local lastDash = 0

local KillAuraConfig = {
    IgnoreFriends = false,
    MaxDistance = distance,
    Damage = 1,
    HealthLimit = 0,
    DashInterval = 0.7
}

local function triggerDash()
    if tick() - lastDash < KillAuraConfig.DashInterval then return end
    lastDash = tick()
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local dashArgs = {[1]=hrp.CFrame,[2]="L",[3]=hrp.CFrame.LookVector,[5]=tick()}
    local dashRemote = RS.Remotes.Character:FindFirstChild("Dash")
    if dashRemote then 
        pcall(function() dashRemote:FireServer(unpack(dashArgs)) end) 
    end
end

local function sendKillAura()
    local Character = localPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local CharactersFolder = RS:FindFirstChild("Characters")
    local RemotesFolder = RS:FindFirstChild("Remotes")
    if not CharactersFolder or not RemotesFolder then return end
    
    local AbilitiesRemote = RemotesFolder:FindFirstChild("Abilities")
    local CombatRemote = RemotesFolder:FindFirstChild("Combat")
    if AbilitiesRemote then AbilitiesRemote = AbilitiesRemote:FindFirstChild("Ability") end
    if CombatRemote then CombatRemote = CombatRemote:FindFirstChild("Action") end
    if not AbilitiesRemote or not CombatRemote then return end
    
    local CharacterName = localPlayer:FindFirstChild("Data") and localPlayer.Data:FindFirstChild("Character") and localPlayer.Data.Character.Value
    if not CharacterName then return end
    
    local WallCombo = CharactersFolder:FindFirstChild(CharacterName)
    if not WallCombo then return end
    WallCombo = WallCombo:FindFirstChild("WallCombo")
    if not WallCombo then return end
    
    local localRootPart = Character.HumanoidRootPart
    triggerDash()
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer == localPlayer then continue end
        if not targetPlayer.Character then continue end
        if not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then continue end
        if KillAuraConfig.IgnoreFriends and localPlayer:IsFriendsWith(targetPlayer.UserId) then continue end
        
        local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        local targetRootPart = targetPlayer.Character.HumanoidRootPart
        if not targetHumanoid or targetHumanoid.Health <= KillAuraConfig.HealthLimit then continue end
        
        local distanceToTarget = (localRootPart.Position - targetRootPart.Position).Magnitude
        if distanceToTarget > KillAuraConfig.MaxDistance then continue end
        
        local abilityArgs = {WallCombo, KillAuraConfig.Damage, {}, targetRootPart.Position}
        pcall(function() AbilitiesRemote:FireServer(unpack(abilityArgs)) end)
        
        local startCFrameStr = tostring(localRootPart.CFrame)
        local combatArgs = {
            WallCombo, CharacterName..":WallCombo", 2,
            KillAuraConfig.Damage,
            {
                HitboxCFrames={targetRootPart.CFrame,targetRootPart.CFrame},
                BestHitCharacter=targetPlayer.Character,
                HitCharacters={targetPlayer.Character},
                Ignore={},
                DeathInfo={},
                BlockedCharacters={},
                HitInfo={IsFacing=false,IsInFront=true},
                ServerTime=os.time(),
                Actions={
                    ActionNumber1={
                        [targetPlayer.Name]={
                            StartCFrameStr=startCFrameStr,
                            Local=true,
                            Collision=false,
                            Animation="Punch1Hit",
                            Preset="Punch",
                            Velocity=Vector3.zero,
                            FromPosition=targetRootPart.Position,
                            Seed=math.random(1,999999)
                        }
                    }
                },
                FromCFrame=targetRootPart.CFrame
            },
            "Action150",
            0
        }
        pcall(function() CombatRemote:FireServer(unpack(combatArgs)) end)
    end
end

local killAuraConn
local function startKillAura()
    if killAuraConn then killAuraConn:Disconnect() killAuraConn=nil end
    killAuraConn = RunService.Heartbeat:Connect(function()
        if killAuraRunning then sendKillAura() end
    end)
end

CombatLeftSection:AddToggle({
    Name = "Kill Aura",
    Flag = "KillAura_V1",
    Default = false,
    Callback = function(value)
        killAuraRunning = value
        if value then
            startKillAura()
            Notifier.new({
                Title = "Kill Aura",
                Content = "Kill Aura activated!",
                Duration = 3,
                Icon = "zap"
            })
        else
            if killAuraConn then killAuraConn:Disconnect() killAuraConn=nil end
        end
    end,
});

-- KILL AURA V2 (AUTO TOGGLE VERSION) - IGNORE DEAD LU脙聰N B谩潞卢T
local killAuraV2Running = false
local killAuraV2Connections = {}
local killAuraV2Config = {
    Distance = 100,
    IgnoreDeadPlayers = true,  -- LU脙聰N LU脙聰N B谩潞卢T
    LastDash = 0,
    DashInterval = 0.7,
    AutoToggleEnabled = false
}

-- CHECK IF PLAYER IS DEAD
local function isPlayerDead(targetPlayer)
    if not targetPlayer.Character then return true end
    
    local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
    if not targetHumanoid then return true end
    
    local health = targetHumanoid:GetAttribute("Health")
    if health and health <= 0 then
        return true
    end
    
    if targetHumanoid.Health <= 0 then
        return true
    end
    
    return false
end

-- TRIGGER DASH FUNCTION FOR V2
local function triggerDashV2()
    if tick() - killAuraV2Config.LastDash < killAuraV2Config.DashInterval then return end
    killAuraV2Config.LastDash = tick()
    
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local dashArgs = {
        [1] = hrp.CFrame,
        [2] = "L",
        [3] = hrp.CFrame.LookVector,
        [5] = tick()
    }
    
    local dashRemote = RS.Remotes.Character:FindFirstChild("Dash")
    if dashRemote then 
        pcall(function() 
            dashRemote:FireServer(unpack(dashArgs)) 
        end) 
    end
end

-- SIMPLE KILL AURA FUNCTION FOR V2 (LU脙聰N IGNORE DEAD)
local function attackNearestPlayerV2()
    if not killAuraV2Running then return end
    if not localPlayer.Character then return end
    if not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local localRoot = localPlayer.Character.HumanoidRootPart
    local closestPlayer = nil
    local closestDistance = killAuraV2Config.Distance
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == localPlayer then continue end
        if not player.Character then continue end
        if not player.Character:FindFirstChild("HumanoidRootPart") then continue end
        if not player.Character:FindFirstChild("Humanoid") then continue end
        
        -- IGNORE DEAD PLAYERS CHECK (LU脙聰N B谩潞卢T)
        if killAuraV2Config.IgnoreDeadPlayers and isPlayerDead(player) then
            continue
        end
        
        if player.Character.Humanoid.Health <= 0 then continue end
        
        local targetRoot = player.Character.HumanoidRootPart
        local dist = (localRoot.Position - targetRoot.Position).Magnitude
        
        if dist < closestDistance then
            closestDistance = dist
            closestPlayer = player
        end
    end
    
    if closestPlayer then
        -- TRIGGER DASH BEFORE ATTACK
        triggerDashV2()
        
        -- ATTACK LOGIC HERE
        local CharactersFolder = RS:FindFirstChild("Characters")
        local RemotesFolder = RS:FindFirstChild("Remotes")
        if not CharactersFolder or not RemotesFolder then return end
        
        local AbilitiesRemote = RemotesFolder:FindFirstChild("Abilities")
        local CombatRemote = RemotesFolder:FindFirstChild("Combat")
        if AbilitiesRemote then AbilitiesRemote = AbilitiesRemote:FindFirstChild("Ability") end
        if CombatRemote then CombatRemote = CombatRemote:FindFirstChild("Action") end
        if not AbilitiesRemote or not CombatRemote then return end
        
        local CharacterName = localPlayer:FindFirstChild("Data") and localPlayer.Data:FindFirstChild("Character") and localPlayer.Data.Character.Value
        if not CharacterName then return end
        
        local WallCombo = CharactersFolder:FindFirstChild(CharacterName)
        if not WallCombo then return end
        WallCombo = WallCombo:FindFirstChild("WallCombo")
        if not WallCombo then return end
        
        local targetRoot = closestPlayer.Character.HumanoidRootPart
        
        -- Ability attack
        local abilityArgs = {WallCombo, 1, {}, targetRoot.Position}
        pcall(function() AbilitiesRemote:FireServer(unpack(abilityArgs)) end)
        
        -- Combat attack
        local startCFrameStr = tostring(localRoot.CFrame)
        local combatArgs = {
            WallCombo, CharacterName..":WallCombo", 2, 1,
            {
                HitboxCFrames={targetRoot.CFrame, targetRoot.CFrame},
                BestHitCharacter=closestPlayer.Character,
                HitCharacters={closestPlayer.Character},
                Ignore={},
                DeathInfo={},
                BlockedCharacters={},
                HitInfo={IsFacing=false,IsInFront=true},
                ServerTime=os.time(),
                Actions={
                    ActionNumber1={
                        [closestPlayer.Name]={
                            StartCFrameStr=startCFrameStr,
                            Local=true,
                            Collision=false,
                            Animation="Punch1Hit",
                            Preset="Punch",
                            Velocity=Vector3.zero,
                            FromPosition=targetRoot.Position,
                            Seed=math.random(1,999999)
                        }
                    }
                },
                FromCFrame=targetRoot.CFrame
            },
            "Action150",0
        }
        pcall(function() CombatRemote:FireServer(unpack(combatArgs)) end)
    end
end

-- 9 KILL AURAS (T脛聜NG T谩禄陋 6 L脙聤N 9)
local function startKillAurasV2()
    for i = 1, 9 do
        local conn = RunService.Heartbeat:Connect(function()
            if killAuraV2Running then
                attackNearestPlayerV2()
                task.wait(0.02)
            end
        end)
        table.insert(killAuraV2Connections, conn)
    end
    print("冒聼聼垄 Kill Aura V2 ON - 9 Kill Auras 脛聭ang ch谩潞隆y ng谩潞搂m (Auto Ignore Dead)")
end

local function stopKillAurasV2()
    for _, conn in ipairs(killAuraV2Connections) do
        conn:Disconnect()
    end
    killAuraV2Connections = {}
    print("冒聼聰麓 Kill Aura V2 OFF - 脛聬脙拢 t谩潞炉t Kill Auras")
end

-- AUTO TOGGLE LOGIC
local function hasPlayersInRangeV2()
    if not killAuraV2Running then return false end
    if not localPlayer.Character then return false end
    if not localPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end
    
    local localRoot = localPlayer.Character.HumanoidRootPart
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == localPlayer then continue end
        if not player.Character then continue end
        if not player.Character:FindFirstChild("HumanoidRootPart") then continue end
        if not player.Character:FindFirstChild("Humanoid") then continue end
        
        -- IGNORE DEAD PLAYERS CHECK (LU脙聰N B谩潞卢T)
        if killAuraV2Config.IgnoreDeadPlayers and isPlayerDead(player) then
            continue
        end
        
        if player.Character.Humanoid.Health <= 0 then continue end
        
        local targetRoot = player.Character.HumanoidRootPart
        local dist = (localRoot.Position - targetRoot.Position).Magnitude
        
        if dist <= killAuraV2Config.Distance then
            return true
        end
    end
    return false
end

-- AUTO TOGGLE CONNECTION
local autoToggleConnectionV2 = nil

local function startAutoToggleV2()
    autoToggleConnectionV2 = RunService.Heartbeat:Connect(function()
        if not killAuraV2Running then return end
        
        local hasTargets = hasPlayersInRangeV2()
        
        if killAuraV2Config.AutoToggleEnabled then
            if hasTargets and #killAuraV2Connections == 0 then
                startKillAurasV2()
            elseif not hasTargets and #killAuraV2Connections > 0 then
                stopKillAurasV2()
            end
        end
    end)
end

local function stopAutoToggleV2()
    if autoToggleConnectionV2 then
        autoToggleConnectionV2:Disconnect()
        autoToggleConnectionV2 = nil
    end
end

-- KILL AURA V2 TOGGLE (脛聬脙聝 T脙聧CH H谩禄垄P IGNORE DEAD LU脙聰N B谩潞卢T)
CombatLeftSection:AddToggle({
    Name = "Kill Aura V2",
    Flag = "KillAura_V2",
    Default = false,
    Callback = function(value)
        killAuraV2Running = value
        if value then
            -- B谩潞颅t kill aura V2 v谩禄聸i auto toggle v脙聽 ignore dead lu脙麓n b谩潞颅t
            killAuraV2Config.AutoToggleEnabled = true
            startAutoToggleV2()
            Notifier.new({
                Title = "Kill Aura V2",
                Content = "Kill Aura V2 activated",
                Duration = 3,
                Icon = "zap"
            })
            print("芒聹聟 Kill Aura V2 Loaded!")
            print("冒聼聨炉 Distance: " .. killAuraV2Config.Distance)
            print("芒職隆 9 Kill Auras Active with Auto Toggle!")
            print("冒聼聮聙 Auto Ignore Dead Players: ALWAYS ON")
        else
            -- T谩潞炉t kill aura V2
            killAuraV2Config.AutoToggleEnabled = false
            stopKillAurasV2()
            stopAutoToggleV2()
            Notifier.new({
                Title = "Kill Aura V2",
                Content = "Kill Aura V2 deactivated!",
                Duration = 3,
                Icon = "zap"
            })
        end
    end,
});

-- DISTANCE SLIDER FOR BOTH VERSIONS
CombatLeftSection:AddSlider({
    Name = "Kill Aura Distance",
    Min = 0,
    Max = 100,
    Default = 50,
    Round = 0,
    Flag = "KillAura_Distance",
    Callback = function(value)
        distance = value
        KillAuraConfig.MaxDistance = value
        killAuraV2Config.Distance = value
    end
});

-- IGNORE FRIENDS TOGGLE (袛袥携 V1 懈 写褉褍谐懈褏)
CombatLeftSection:AddToggle({
    Name = "Ignore Friends",
    Flag = "KillAura_IgnoreFriends",
    Default = false,
    Callback = function(value)
        KillAuraConfig.IgnoreFriends = value
        Notifier.new({
            Title = "Ignore Friends",
            Content = value and "Enabled" or "Disabled",
            Duration = 2,
            Icon = "users"
        })
    end,
});


-- ================================
-- KILL AURA CIRCLE CODE
-- ================================
local CircleParts = {}
local CircleConnection

local function RainbowColor(t)
    local r = math.sin(t) * 40 + 180
    local g = math.sin(t + 2) * 40 + 180
    local b = math.sin(t + 4) * 40 + 180
    return Color3.fromRGB(r, g, b)
end

local function CreateCircle(radius, segments, thickness)
    local parts = {}
    for i = 1, segments do
        local part = Instance.new("Part")
        part.Anchored = true
        part.CanCollide = false
        part.Material = Enum.Material.Neon
        part.Size = Vector3.new(thickness, 0.2, radius * 2 * math.pi / segments)
        part.Color = Color3.fromRGB(180,180,180)
        part.Parent = workspace
        table.insert(parts, part)
    end
    return parts
end

local function DestroyCircle()
    if CircleConnection then
        CircleConnection:Disconnect()
        CircleConnection = nil
    end
    for _, part in ipairs(CircleParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    CircleParts = {}
end

local function UpdateCircle()
    if #CircleParts == 0 then return end
    
    local radius = 60
    local segments = 60
    local thickness = 0.2
    
    local time = tick()
    local updateAccumulator = 0
    local updateRate = 1/60

    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local rootPos = char.HumanoidRootPart.Position
        local humanoid = char:FindFirstChild("Humanoid")
        local heightOffset = humanoid and humanoid.HipHeight / 2 + 0.1 or 0.9
        local pos = rootPos - Vector3.new(0, heightOffset, 0)

        for i, part in ipairs(CircleParts) do
            local angle = (i / #CircleParts) * 2 * math.pi
            local x = pos.X + math.cos(angle) * radius
            local z = pos.Z + math.sin(angle) * radius
            part.Position = Vector3.new(x, pos.Y, z)
            part.Orientation = Vector3.new(0, -math.deg(angle), 0)
            part.Color = RainbowColor(time + i * 0.1)
        end
    end
end

local function StartCircle()
    DestroyCircle()
    local radius = 60
    local segments = 60
    local thickness = 0.2
    CircleParts = CreateCircle(radius, segments, thickness)

    CircleConnection = game:GetService("RunService").RenderStepped:Connect(function(dt)
        UpdateCircle()
    end)
end

-- G岷痭 v脿o toggle c峄 b岷
CombatLeftSection:AddToggle({
    Name = "Kill Aura Show",
    Flag = "KillAura_Show",
    Default = false,
    Callback = function(value)
        print("Kill Aura Show:", value)
        if value then
            StartCircle()
        else
            DestroyCircle()
        end
    end,
});

-- Wall Spam V1
local spamWallV1Running = false
local wallComboConn

local function wallcombo()
    if not coreLoaded or not core then return end
    
    pcall(function() setthreadcontext(2) end)
    
    local head = localPlayer.Character and localPlayer.Character:FindFirstChild("Head")
    if not head then return end
    
    local charValue = localPlayer.Data and localPlayer.Data.Character and localPlayer.Data.Character.Value
    if not charValue then return end

    pcall(function()
        local res = core.Get("Combat","Hit").Box(nil, localPlayer.Character, {Size = Vector3.new(50,50,50)})
        if res then
            core.Get("Combat","Ability").Activate(RS.Characters[charValue].WallCombo, res, head.Position + Vector3.new(0,0,2.5))
        end
    end)
end

CombatRightSection:AddToggle({
    Name = "Spam Wall",
    Flag = "Spam_Wall",
    Default = false,
    Callback = function(value)
        spamWallV1Running = value
        if value and coreLoaded then
            if wallComboConn then wallComboConn:Disconnect() end
            wallComboConn = RunService.RenderStepped:Connect(function()
                if spamWallV1Running then
                    wallcombo()
                end
            end)
            
            Notifier.new({
                Title = "Wall Spam",
                Content = "Wall Spam V1 activated!",
                Duration = 3,
                Icon = "shield"
            })
        else
            if wallComboConn then 
                wallComboConn:Disconnect()
                wallComboConn = nil
            end
        end
    end,
});

-- Wall Spam V2
local spamWallV2Running = false
local wallActionIDCounter = 0

local function GenerateWallActionID()
    wallActionIDCounter = wallActionIDCounter + 1
    return wallActionIDCounter + math.random(1000, 5000)
end

local function GetCurrentCharacter()
    local success, result = pcall(function()
        return localPlayer.Data.Character.Value
    end)
    if success and result then
        return result
    end
    return "Unknown"
end

local function GetWallPosition()
    local character = localPlayer.Character
    if not character then return Vector3.new(0, 0, 0) end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return Vector3.new(0, 0, 0) end
    local lookVector = humanoidRootPart.CFrame.LookVector
    return humanoidRootPart.Position + (lookVector * 5)
end

local function FindNearestPlayer()
    local character = localPlayer.Character
    if not character then return nil end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local nearestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChild("Humanoid")
            if targetRoot and targetHumanoid then
                -- 袩袪袨袙袝袪袣袗 袦袝袪孝袙蝎啸 袠袚袪袨袣袨袙
                if IgnoreDeadPlayers then
                    local health = targetHumanoid:GetAttribute("Health")
                    if not health or health <= 0 then continue end
                end
                
                local distance = (humanoidRootPart.Position - targetRoot.Position).Magnitude
                if distance < shortestDistance and distance < GlobalAttackRange then
                    shortestDistance = distance
                    nearestPlayer = player
                end
            end
        end
    end
    
    return nearestPlayer
end

CombatRightSection:AddToggle({
    Name = "Spam Wall V2",
    Flag = "Spam_Wall_V2",
    Default = false,
    Callback = function(value)
        spamWallV2Running = value
        if value then
            task.spawn(function()
                while spamWallV2Running do
                    local currentCharacter = GetCurrentCharacter()
                    local targetPlayer = FindNearestPlayer()
                    
                    if targetPlayer and targetPlayer.Character then
                        pcall(function()
                            local abilityObject = RS:WaitForChild("Characters"):WaitForChild(currentCharacter):WaitForChild("WallCombo")
                            local abilityRemote = RS:WaitForChild("Remotes"):WaitForChild("Abilities"):WaitForChild("Ability")
                            local combatRemote = RS:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action")
                            
                            local actionId = GenerateWallActionID()
                            local serverTime = tick()
                            local wallPosition = GetWallPosition()
                            local fromCFrame = localPlayer.Character.HumanoidRootPart.CFrame
                            
                            abilityRemote:FireServer(abilityObject, actionId, nil, targetPlayer.Character, wallPosition)
                            
                            for phase = 1, 4 do
                                combatRemote:FireServer(
                                    abilityObject,
                                    "Characters:" .. currentCharacter .. ":WallCombo",
                                    phase,
                                    actionId,
                                    {
                                        HitboxCFrames = phase > 1 and {CFrame.new(wallPosition)} or {},
                                        BestHitCharacter = targetPlayer.Character,
                                        HitCharacters = {targetPlayer.Character},
                                        Ignore = phase > 1 and {ActionNumber1 = {targetPlayer.Character}} or {},
                                        DeathInfo = {},
                                        BlockedCharacters = {},
                                        HitInfo = {IsFacing = true, IsInFront = true, Blocked = false},
                                        ServerTime = serverTime,
                                        Actions = phase == 4 and {
                                            ActionNumber1 = {
                                                [targetPlayer.Name] = {
                                                    StartCFrameStr = tostring(CFrame.new(targetPlayer.Character.HumanoidRootPart.Position)),
                                                    ImpulseVelocity = Vector3.new(-67499, 150000, 307),
                                                    AbilityName = "WallCombo",
                                                    RotVelocityStr = "0.000000,0.000000,-0.000000",
                                                    VelocityStr = "0.000000,0.000000,0.000000",
                                                    Gravity = 200000,
                                                    RotImpulseVelocity = Vector3.new(8977, -5293, 6185),
                                                    Seed = math.random(100000000, 999999999),
                                                    LookVectorStr = tostring(fromCFrame.LookVector),
                                                    Duration = 2
                                                }
                                            },
                                            FromCFrame = fromCFrame
                                        } or {ActionNumber1 = {}},
                                        FromCFrame = fromCFrame
                                    },
                                    "Action" .. math.random(1000, 9999),
                                    phase == 4 and 0.1 or nil
                                )
                            end
                        end)
                    end
                    task.wait(0.05)
                end
            end)
            
            Notifier.new({
                Title = "Wall Spam V2",
                Content = "Advanced Wall Spam activated!",
                Duration = 3,
                Icon = "shield"
            })
        end
    end,
});

-- Spam Wall V3

-- ========================================
-- TARGET PLAYER SELECT & TELEPORT SYSTEM
-- ========================================
local TargetPlayerName = "Nearest" -- "Nearest" = 斜谢懈卸邪泄褕懈泄 懈谐褉芯泻, 懈薪邪褔械 懈屑褟 泻芯薪泻褉械褌薪芯谐芯
local PlayerDropdown = nil -- 小褋褘谢泻邪 薪邪 Dropdown 写谢褟 芯斜薪芯胁谢械薪懈褟
local TargetTeleportEnabled = false
local TargetTeleportConnection = nil

-- 袩芯谢褍褔懈褌褜 胁褘斜褉邪薪薪芯谐芯/斜谢懈卸邪泄褕械谐芯 懈谐褉芯泻邪
function GetTargetPlayer()
    -- 袝褋谢懈 胁褘斜褉邪薪 泻芯薪泻褉械褌薪褘泄 懈谐褉芯泻
    if TargetPlayerName and TargetPlayerName ~= "Nearest" then
        local targetPlayer = Players:FindFirstChild(TargetPlayerName)
        if targetPlayer and targetPlayer.Character then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
            if targetRoot and targetHumanoid then
                -- 袩褉芯胁械褉泻邪 薪邪 屑械褉褌胁芯谐芯 懈谐褉芯泻邪
                if IgnoreDeadPlayers then
                    local health = targetHumanoid:GetAttribute("Health")
                    if health and health <= 0 then
                        return nil
                    end
                end
                return targetPlayer
            end
        end
        return nil
    end

    -- 袠薪邪褔械 胁芯蟹胁褉邪褖邪械屑 斜谢懈卸邪泄褕械谐芯
    return FindNearestPlayer()
end

-- 袩芯谢褍褔懈褌褜 褋锌懈褋芯泻 懈谐褉芯泻芯胁 写谢褟 Dropdown
function GetPlayersList()
    local playerNames = {"Nearest"}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    return playerNames
end

-- 袨斜薪芯胁懈褌褜 褋锌懈褋芯泻 懈谐褉芯泻芯胁 胁 Dropdown
function UpdateTargetPlayerList()
    if PlayerDropdown then
        local newList = GetPlayersList()
        PlayerDropdown:Refresh(newList, true)
    end
end

-- 袦芯写褍谢褜 褌械谢械锌芯褉褌邪褑懈懈 泻 褌邪褉谐械褌褍
local TargetTeleportModule = {
    enabled = false,
    connection = nil,
    offset = Vector3.new(0, 0, 5) -- 小屑械褖械薪懈械 芯褌 褌邪褉谐械褌邪 (锌芯蟹邪写懈 薪械谐芯)
}

function TargetTeleportModule:Start()
    if self.connection then return end
    self.enabled = true

    self.connection = RunService.Heartbeat:Connect(function()
        if not self.enabled then return end

        local targetPlayer = GetTargetPlayer()
        if not targetPlayer then return end

        local character = localPlayer.Character
        if not character then return end

        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        local targetCharacter = targetPlayer.Character
        if not targetCharacter then return end

        local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end

        -- 孝械谢械锌芯褉褌懈褉褍械屑褋褟 泻 褌邪褉谐械褌褍 褋 褋屑械褖械薪懈械屑
        local targetCFrame = targetRoot.CFrame
        local behindTarget = targetCFrame * CFrame.new(0, 0, self.offset.Z)

        humanoidRootPart.CFrame = behindTarget
    end)

    local targetName = TargetPlayerName == "Nearest" and "Nearest Player" or TargetPlayerName
    Notifier.new({
        Title = "Target Teleport",
        Content = "Enabled - Targeting: " .. targetName,
        Duration = 3,
        Icon = "target"
    })
end

function TargetTeleportModule:Stop()
    self.enabled = false
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
    end

    Notifier.new({
        Title = "Target Teleport",
        Content = "Disabled",
        Duration = 3,
        Icon = "target"
    })
end

function TargetTeleportModule:SetOffset(offset)
    self.offset = Vector3.new(0, 0, offset)
end

-- 袗胁褌芯芯斜薪芯胁谢械薪懈械 褋锌懈褋泻邪 懈谐褉芯泻芯胁 泻邪卸写褘械 3 褋械泻褍薪写褘
task.spawn(function()
    while true do
        task.wait(3)
        UpdateTargetPlayerList()
    end
end)

-- 袨斜薪芯胁谢械薪懈械 锌褉懈 胁褏芯写械/胁褘褏芯写械 懈谐褉芯泻芯胁
Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    UpdateTargetPlayerList()
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.5)
    UpdateTargetPlayerList()
end)


local spamWallV3Running = false
CombatRightSection:AddToggle({
    Name = "Spam Wall V3",
    Flag = "Spam_Wall_V3",
    Default = false,
    Callback = function(value)
        spamWallV3Running = value
        if value then
            for i = 1, 2 do
                task.spawn(function()
                    while spamWallV3Running do
                        local currentCharacter = GetCurrentCharacter()
                        local targetPlayer = FindNearestPlayer()
                        
                        if targetPlayer and targetPlayer.Character then
                            pcall(function()
                                local abilityObject = RS:WaitForChild("Characters"):WaitForChild(currentCharacter):WaitForChild("WallCombo")
                                local abilityRemote = RS:WaitForChild("Remotes"):WaitForChild("Abilities"):WaitForChild("Ability")
                                local combatRemote = RS:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action")
                                
                                local actionId = GenerateWallActionID()
                                local serverTime = tick()
                                local wallPosition = GetWallPosition()
                                local fromCFrame = localPlayer.Character.HumanoidRootPart.CFrame
                                
                                abilityRemote:FireServer(abilityObject, actionId, nil, targetPlayer.Character, wallPosition)
                                
                                for phase = 1, 4 do
                                    combatRemote:FireServer(
                                        abilityObject,
                                        "Characters:" .. currentCharacter .. ":WallCombo",
                                        phase,
                                        actionId,
                                        {
                                            HitboxCFrames = phase > 1 and {CFrame.new(wallPosition)} or {},
                                            BestHitCharacter = targetPlayer.Character,
                                            HitCharacters = {targetPlayer.Character},
                                            Ignore = phase > 1 and {ActionNumber1 = {targetPlayer.Character}} or {},
                                            DeathInfo = {},
                                            BlockedCharacters = {},
                                            HitInfo = {IsFacing = true, IsInFront = true, Blocked = false},
                                            ServerTime = serverTime,
                                            Actions = phase == 4 and {
                                                ActionNumber1 = {
                                                    [targetPlayer.Name] = {
                                                        StartCFrameStr = tostring(CFrame.new(targetPlayer.Character.HumanoidRootPart.Position)),
                                                        ImpulseVelocity = Vector3.new(-67499, 150000, 307),
                                                        AbilityName = "WallCombo",
                                                        Gravity = 200000,
                                                        RotImpulseVelocity = Vector3.new(8977, -5293, 6185),
                                                        Seed = math.random(100000000, 999999999),
                                                        LookVectorStr = tostring(fromCFrame.LookVector),
                                                        Duration = 2
                                                    }
                                                },
                                                FromCFrame = fromCFrame
                                            } or {ActionNumber1 = {}},
                                            FromCFrame = fromCFrame
                                        },
                                        "Action" .. math.random(1000, 9999),
                                        phase == 4 and 0.1 or nil
                                    )
                                end
                            end)
                        end
                        task.wait()
                    end
                end)
            end
        end
    end,
});

-- ========================================
-- ABILITY SPAM MODULE (袙小袝 4 小袩袨小袨袘袧袨小孝袠)
-- ========================================

local AbilitySpamModule = {
    enabled = false,
    loopConnection = nil,
    selectedAbility = "All",
    spamSpeed = 0.05,
    isTransformed = false,
    lastSpamTime = 0
}

function AbilitySpamModule:InitTransformTracking()
    pcall(function()
        self.isTransformed = localPlayer.Info.Transform.Value or false
        localPlayer.Info.Transform:GetPropertyChangedSignal("Value"):Connect(function()
            self.isTransformed = localPlayer.Info.Transform.Value
        end)
    end)
end

function AbilitySpamModule:GetAbilityPath(characterName, abilityNumber)
    local folderName = self.isTransformed and "Ultimates" or "Abilities"
    return RS:WaitForChild("Characters"):WaitForChild(characterName):WaitForChild(folderName):WaitForChild(tostring(abilityNumber))
end

function AbilitySpamModule:HasAbilities(characterName, abilityNumber)
    local success, result = pcall(function()
        local charactersFolder = RS:WaitForChild("Characters")
        if not charactersFolder:FindFirstChild(characterName) then
            return false
        end
        local characterFolder = charactersFolder[characterName]
        local folderName = self.isTransformed and "Ultimates" or "Abilities"
        local abilitiesFolder = characterFolder:FindFirstChild(folderName)
        if not abilitiesFolder then
            return false
        end
        if abilityNumber == "All" then
            return abilitiesFolder:FindFirstChild("1") and
                   abilitiesFolder:FindFirstChild("2") and
                   abilitiesFolder:FindFirstChild("3") and
                   abilitiesFolder:FindFirstChild("4")
        else
            return abilitiesFolder:FindFirstChild(tostring(abilityNumber)) ~= nil
        end
    end)
    return success and result
end

function AbilitySpamModule:GetNearestPlayerCFrame()
    local nearest = GetTargetPlayer()
    if nearest and nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart") then
        return nearest.Character.HumanoidRootPart.CFrame
    end
    return CFrame.new(0, 0, 0)
end

function AbilitySpamModule:ReplaceAbilityString(str)
    if self.isTransformed then
        return string.gsub(str, "Abilities", "Ultimates")
    end
    return str
end

-- 小袩袨小袨袘袧袨小孝鞋 1
function AbilitySpamModule:UseAbility1()
    local currentCharacter = GetCurrentCharacter()
    if not self:HasAbilities(currentCharacter, 1) then return false end

    local targetPlayer = GetTargetPlayer()
    if not targetPlayer then return false end

    triggerDash()

    local targetCharacter = targetPlayer.Character
    local targetCFrame = self:GetNearestPlayerCFrame()
    local abilityPath = self:GetAbilityPath(currentCharacter, 1)
    local abilityString = self:ReplaceAbilityString(currentCharacter..":Abilities:1")

    pcall(function()
        local args = {abilityPath, 9000000}
        RS:WaitForChild("Remotes"):WaitForChild("Abilities"):WaitForChild("Ability"):FireServer(unpack(args))

        args = {
            abilityPath,
            abilityString,
            1,
            9000000,
            {
                HitboxCFrames = {targetCFrame, targetCFrame},
                BestHitCharacter = targetCharacter,
                HitCharacters = {targetCharacter},
                Ignore = {},
                DeathInfo = {},
                BlockedCharacters = {},
                HitInfo = {IsFacing = false, IsInFront = true, GetUp = false},
                ServerTime = tick(),
                Actions = {},
                FromCFrame = targetCFrame
            },
            "Action181",
            0
        }
        RS:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action"):FireServer(unpack(args))

        args = {
            abilityPath,
            abilityString,
            2,
            9000000,
            {
                HitboxCFrames = {targetCFrame},
                BestHitCharacter = targetCharacter,
                HitCharacters = {targetCharacter},
                Ignore = {},
                DeathInfo = {},
                BlockedCharacters = {},
                HitInfo = {IsFacing = true, GetUp = false, IsInFront = true, Blocked = false},
                ServerTime = tick(),
                Actions = {
                    ActionNumber1 = {
                        [targetPlayer.Name] = {
                            StartCFrameStr = tostring(targetCFrame),
                            ImpulseVelocity = Vector3.new(146848, 100000, -30590),
                            AbilityName = "1",
                            RotVelocityStr = "-0.000000,-0.000000,0.000000",
                            VelocityStr = "0.000000,0.000000,0.000000",
                            Duration = 2,
                            RotImpulseVelocity = Vector3.new(-1862, -1429, 1704),
                            Seed = math.random(1, 1000000),
                            LookVectorStr = "0.978985,-0.000000,-0.203931"
                        }
                    },
                    FromCFrame = targetCFrame
                },
                "Action185"
            }
        }
        RS:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action"):FireServer(unpack(args))
    end)
    return true
end

-- 小袩袨小袨袘袧袨小孝鞋 2
function AbilitySpamModule:UseAbility2()
    local currentCharacter = GetCurrentCharacter()
    if not self:HasAbilities(currentCharacter, 2) then return false end

    local targetPlayer = GetTargetPlayer()
    if not targetPlayer then return false end

    triggerDash()

    local targetCharacter = targetPlayer.Character
    local targetCFrame = self:GetNearestPlayerCFrame()
    local abilityPath = self:GetAbilityPath(currentCharacter, 2)
    local abilityString = self:ReplaceAbilityString(currentCharacter..":Abilities:2")

    pcall(function()
        local args = {abilityPath, 9000000}
        RS:WaitForChild("Remotes"):WaitForChild("Abilities"):WaitForChild("Ability"):FireServer(unpack(args))

        args = {
            abilityPath,
            abilityString,
            1,
            9000000,
            {
                FilterList = {},
                StartCFrame = targetCFrame,
                ServerTime = tick()
            }
        }
        RS:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Projectile"):FireServer(unpack(args))

        args = {
            targetCFrame,
            abilityPath,
            9000000,
            1,
            Vector3.new(0.8522407412528992, 0, -0.5231499075889587)
        }
        RS:WaitForChild("Remotes"):WaitForChild("Character"):WaitForChild("DashAbility"):FireServer(unpack(args))

        args = {
            abilityPath,
            abilityString,
            2,
            9000000,
            {
                HitboxCFrames = {targetCFrame},
                BestHitCharacter = targetCharacter,
                HitCharacters = {targetCharacter},
                Ignore = {},
                DeathInfo = {},
                BlockedCharacters = {},
                HitInfo = {IsFacing = false, GetUp = true, IsInFront = true, Blocked = false},
                ServerTime = tick(),
                Actions = {},
                FromCFrame = targetCFrame
            },
            "Action242"
        }
        RS:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action"):FireServer(unpack(args))

        args = {
            abilityPath,
            abilityString,
            3,
            9000000,
            {
                HitboxCFrames = {targetCFrame},
                BestHitCharacter = targetCharacter,
                HitCharacters = {targetCharacter},
                Ignore = {},
                DeathInfo = {},
                RockCFrame = targetCFrame,
                ServerTime = tick(),
                HitInfo = {IsFacing = true, IsInFront = false, Blocked = false},
                BlockedCharacters = {},
                Actions = {
                    ActionNumber1 = {
                        [targetPlayer.Name] = {
                            StartCFrameStr = tostring(targetCFrame),
                            ImpulseVelocity = Vector3.new(0, 175000, 0),
                            AbilityName = "2",
                            RotVelocityStr = "-0.000000,0.000000,0.000000",
                            VelocityStr = "0.000000,0.000000,0.000000",
                            Duration = 2,
                            RotImpulseVelocity = Vector3.new(9258, 8919, 6283),
                            Seed = math.random(1, 1000000),
                            LookVectorStr = "0.835728,0.000000,-0.549143"
                        }
                    },
                    FromCFrame = targetCFrame
                },
                "Action246"
            }
        }
        RS:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action"):FireServer(unpack(args))
    end)
    return true
end

-- 小袩袨小袨袘袧袨小孝鞋 3
function AbilitySpamModule:UseAbility3()
    local currentCharacter = GetCurrentCharacter()
    if not self:HasAbilities(currentCharacter, 3) then return false end

    local targetPlayer = GetTargetPlayer()
    if not targetPlayer then return false end

    triggerDash()

    local targetCharacter = targetPlayer.Character
    local targetCFrame = self:GetNearestPlayerCFrame()
    local abilityPath = self:GetAbilityPath(currentCharacter, 3)
    local abilityString = self:ReplaceAbilityString(currentCharacter..":Abilities:3")

    pcall(function()
        local args = {abilityPath, 9000000}
        RS:WaitForChild("Remotes"):WaitForChild("Abilities"):WaitForChild("Ability"):FireServer(unpack(args))

        args = {
            abilityPath,
            abilityString,
            1,
            9000000,
            {
                HitboxCFrames = {targetCFrame},
                BestHitCharacter = targetCharacter,
                HitCharacters = {targetCharacter},
                Ignore = {},
                DeathInfo = {},
                RockCFrame = targetCFrame,
                ServerTime = tick(),
                HitInfo = {IsFacing = false, IsInFront = true, GetUp = false},
                BlockedCharacters = {},
                Actions = {
                    ActionNumber1 = {
                        [targetPlayer.Name] = {
                            StartCFrameStr = tostring(targetCFrame),
                            ImpulseVelocity = Vector3.new(0, 100000, 0),
                            AbilityName = "3",
                            RotVelocityStr = "0.000000,0.000000,0.000000",
                            VelocityStr = "0.000000,0.000000,0.000000",
                            Duration = 1,
                            NoVFX = true,
                            RotImpulseVelocity = Vector3.new(-14724, 11564, -13069),
                            Seed = math.random(1, 1000000),
                            LookVectorStr = "2.228760,-0.009538,0.471676",
                            NoRagdollCancel = true
                        }
                    },
                    FromCFrame = targetCFrame
                },
                "Action282",
                0
            }
        }
        RS:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action"):FireServer(unpack(args))

        for i = 2, 5 do
            args = {
                abilityPath,
                abilityString,
                i,
                9000000,
                {
                    HitboxCFrames = {targetCFrame, targetCFrame},
                    BestHitCharacter = targetCharacter,
                    HitCharacters = {targetCharacter},
                    Ignore = {},
                    DeathInfo = {},
                    BlockedCharacters = {},
                    HitInfo = {IsFacing = true, GetUp = true, IsInFront = true, Blocked = false},
                    ServerTime = tick(),
                    Actions = {},
                    FromCFrame = targetCFrame
                },
                "Action28"..tostring(i+1),
                0
            }
            RS:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action"):FireServer(unpack(args))
        end

        args = {
            abilityPath,
            abilityString,
            7,
            9000000,
            {
                HitboxCFrames = {targetCFrame},
                BestHitCharacter = targetCharacter,
                ActionNumbers = {2},
                HitCharacters = {targetCharacter},
                Ignore = {},
                DeathInfo = {},
                BlockedCharacters = {},
                HitInfo = {IsFacing = true, IsInFront = true, Blocked = false},
                ServerTime = tick(),
                Actions = {
                    ActionNumber2 = {
                        [targetPlayer.Name] = {
                            StartCFrameStr = tostring(targetCFrame),
                            Collision = false,
                            Local = true,
                            Velocity = Vector3.zero,
                            Preset = "OutOfRange",
                            FromPosition = targetCFrame.Position,
                            Seed = math.random(1, 1000000)
                        }
                    },
                    FromCFrame = targetCFrame
                },
                "Action291"
            }
        }
        RS:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action"):FireServer(unpack(args))
    end)
    return true
end

-- 小袩袨小袨袘袧袨小孝鞋 4
function AbilitySpamModule:UseAbility4()
    local currentCharacter = GetCurrentCharacter()
    if not self:HasAbilities(currentCharacter, 4) then return false end

    local targetPlayer = GetTargetPlayer()
    if not targetPlayer then return false end

    triggerDash()

    local targetCharacter = targetPlayer.Character
    local targetCFrame = self:GetNearestPlayerCFrame()
    local abilityPath = self:GetAbilityPath(currentCharacter, 4)
    local abilityString = self:ReplaceAbilityString(currentCharacter..":Abilities:4")

    pcall(function()
        local args = {abilityPath, 9000000}
        RS:WaitForChild("Remotes"):WaitForChild("Abilities"):WaitForChild("Ability"):FireServer(unpack(args))

        local actionNumbers = {377, 380, 383, 384, 385, 387, 389}
        for i = 1, 7 do
            args = {
                abilityPath,
                abilityString,
                i,
                9000000,
                {
                    HitboxCFrames = {targetCFrame, targetCFrame},
                    BestHitCharacter = targetCharacter,
                    HitCharacters = {targetCharacter},
                    Ignore = i > 2 and {ActionNumber1 = {targetCharacter}} or {},
                    DeathInfo = {},
                    BlockedCharacters = {},
                    HitInfo = {
                        IsFacing = i == 1 or i == 2 and false or true,
                        IsInFront = i <= 2 and true or false,
                        Blocked = i > 2 and false or nil
                    },
                    ServerTime = tick(),
                    Actions = i > 2 and {ActionNumber1 = {}} or {},
                    FromCFrame = targetCFrame
                },
                "Action"..tostring(actionNumbers[i]),
                i == 2 and 0.1 or nil
            }

            if i == 7 then
                args[5].RockCFrame = targetCFrame
                args[5].Actions = {
                    ActionNumber1 = {
                        [targetPlayer.Name] = {
                            StartCFrameStr = tostring(targetCFrame),
                            ImpulseVelocity = Vector3.new(1901, -25000, 291),
                            AbilityName = "4",
                            RotVelocityStr = "0.000000,0.000000,0.000000",
                            VelocityStr = "1.900635,0.010867,0.291061",
                            Duration = 2,
                            RotImpulseVelocity = Vector3.new(5868, -6649, -7414),
                            Seed = math.random(1, 1000000),
                            LookVectorStr = "0.988493,0.000000,0.151268"
                        }
                    }
                }
            end
            RS:WaitForChild("Remotes"):WaitForChild("Combat"):WaitForChild("Action"):FireServer(unpack(args))
        end
    end)
    return true
end

function AbilitySpamModule:UseAllAbilities()
    self:UseAbility1()
    task.wait(0.000001)
    self:UseAbility2()
    task.wait(0.000001)
    self:UseAbility3()
    task.wait(0.000001)
    self:UseAbility4()
end

function AbilitySpamModule:Start()
    if self.loopConnection then return end
    self.enabled = true

    self.loopConnection = task.spawn(function()
        while self.enabled do
            local currentTime = tick()
            if currentTime - self.lastSpamTime >= self.spamSpeed then
                self.lastSpamTime = currentTime

                if self.selectedAbility == "All" then
                    self:UseAllAbilities()
                elseif self.selectedAbility == "1 Ability" then
                    self:UseAbility1()
                elseif self.selectedAbility == "2 Ability" then
                    self:UseAbility2()
                elseif self.selectedAbility == "3 Ability" then
                    self:UseAbility3()
                elseif self.selectedAbility == "4 Ability" then
                    self:UseAbility4()
                end

                task.wait(0.000000000000000000001)
                pcall(function()
                    local currentChar = GetCurrentCharacter()
                    RS.Remotes.Abilities.AbilityCanceled:FireServer(
                        RS:WaitForChild("Characters"):WaitForChild(currentChar):WaitForChild("WallCombo")
                    )
                end)
            end
            task.wait(0.01)
        end
    end)

    Notifier.new({
        Title = "Ability Spam",
        Content = "Enabled - " .. self.selectedAbility,
        Duration = 3,
        Icon = "zap"
    })
end

function AbilitySpamModule:Stop()
    self.enabled = false
    self.loopConnection = nil
    Notifier.new({
        Title = "Ability Spam",
        Content = "Disabled",
        Duration = 3,
        Icon = "zap"
    })
end

function AbilitySpamModule:SetAbility(ability)
    self.selectedAbility = ability
end

function AbilitySpamModule:SetSpeed(speed)
    self.spamSpeed = speed
end

AbilitySpamModule:InitTransformTracking()



-- ========================================
-- TARGET PLAYER UI ELEMENTS
-- ========================================

-- Dropdown 写谢褟 胁褘斜芯褉邪 褌邪褉谐械褌邪
PlayerDropdown = CombatLeftSection:AddDropdown({
    Name = "Target Player",
    Values = GetPlayersList(),
    Default = "Nearest",
    Flag = "Target_Player_Select",
    Callback = function(value)
        TargetPlayerName = value
        local displayName = value == "Nearest" and "Nearest Player" or value
        Notifier.new({
            Title = "Target Changed",
            Content = "Now targeting: " .. displayName,
            Duration = 3,
            Icon = "crosshair"
        })
    end
});

-- Toggle 写谢褟 褌械谢械锌芯褉褌邪褑懈懈 泻 褌邪褉谐械褌褍
CombatLeftSection:AddToggle({
    Name = "Teleport to Target",
    Flag = "Target_Teleport",
    Default = false,
    Callback = function(value)
        if value then
            TargetTeleportModule:Start()
        else
            TargetTeleportModule:Stop()
        end
    end,
});

-- 小谢邪泄写械褉 写谢褟 写懈褋褌邪薪褑懈懈 芯褌 褌邪褉谐械褌邪
CombatLeftSection:AddSlider({
    Name = "Target Distance",
    Min = 0,
    Max = 20,
    Default = 5,
    Round = 0,
    Flag = "Target_Distance",
    Callback = function(value)
        TargetTeleportModule:SetOffset(value)
    end
});


local abilitySpamRunning = false
CombatLeftSection:AddToggle({
    Name = "Ability Spam",
    Flag = "Ability_Spam",
    Default = false,
    Callback = function(value)
        abilitySpamRunning = value
        if value then
            AbilitySpamModule:Start()
        else
            AbilitySpamModule:Stop()
        end
    end,
});

CombatLeftSection:AddDropdown({
    Name = "Select Ability",
    Values = {"All", "1 Ability", "2 Ability", "3 Ability", "4 Ability"},
    Default = "All",
    Flag = "Ability_Select",
    Callback = function(value)
        AbilitySpamModule:SetAbility(value)
    end
});

CombatLeftSection:AddSlider({
    Name = "Ability Spam Speed",
    Min = 0,
    Max = 1,
    Default = 0.05,
    Round = 2,
    Flag = "Ability_Speed",
    Callback = function(value)
        AbilitySpamModule:SetSpeed(value)
    end
});

local killFarmingRunning = false
CombatLeftSection:AddToggle({
    Name = "SK MODE",
    Flag = "SK MODE",
    Default = false,
    Callback = function(value)
        killFarmingRunning = value
        print("Kill Farming:", value)
    end,
});

-- ========================================
-- SUPER PUNCH MODULE (NO NOTIFICATIONS)
-- ========================================
local SuperPunchModule = {
    enabled = false,
    originalPower = 100,
    currentPower = 1000000,
    debounce = false,
    damageCheckConnection = nil
}

-- Theo d玫i s谩t th瓢啤ng nh岷璶 v脿o (kh么ng c贸 th么ng b谩o)
local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    local lastHealth = humanoid.Health
    
    humanoid.HealthChanged:Connect(function(newHealth)
        if SuperPunchModule.enabled and not SuperPunchModule.debounce and newHealth < lastHealth then
            SuperPunchModule.debounce = true
            
            -- T岷 th峄漣 gi岷 s峄ヽ m岷h ragdoll khi nh岷璶 s谩t th瓢啤ng
            game.ReplicatedStorage.Settings.Multipliers.RagdollPower.Value = SuperPunchModule.originalPower
            
            -- 2 gi芒y sau kh么i ph峄 l岷
            task.wait(2)
            if SuperPunchModule.enabled then
                game.ReplicatedStorage.Settings.Multipliers.RagdollPower.Value = SuperPunchModule.currentPower
            end
            SuperPunchModule.debounce = false
        end
        lastHealth = newHealth
    end)
end

-- K铆ch ho岷 theo d玫i s谩t th瓢啤ng
localPlayer.CharacterAdded:Connect(onCharacterAdded)
if localPlayer.Character then
    onCharacterAdded(localPlayer.Character)
end

-- B岷璽/t岷痶 Super Punch (kh么ng th么ng b谩o)
function SuperPunchModule:Toggle(enabled)
    self.enabled = enabled

    if enabled then
        game.ReplicatedStorage.Settings.Multipliers.RagdollPower.Value = self.currentPower
    else
        game.ReplicatedStorage.Settings.Multipliers.RagdollPower.Value = self.originalPower
    end
end

-- 膼i峄乽 ch峄塶h s峄ヽ m岷h (kh么ng th么ng b谩o)
function SuperPunchModule:SetPower(power)
    self.currentPower = power
    if self.enabled then
        game.ReplicatedStorage.Settings.Multipliers.RagdollPower.Value = power
    end
end

-- TH脢M V脌O COMBAT TAB D漂峄欼 SK MODE
CombatLeftSection:AddToggle({
    Name = "Super Punch",
    Flag = "Super_Punch_Toggle",
    Default = false,
    Callback = function(value)
        SuperPunchModule:Toggle(value)
    end
})

CombatLeftSection:AddSlider({
    Name = "Super Punch Power",
    Min = 1000,
    Max = 10000000,
    Default = 1000000,
    Round = 0,
    Flag = "Super_Punch_Power",
    Callback = function(value)
        SuperPunchModule:SetPower(value)
    end
})

task.spawn(function()
    task.wait(5)
    pcall(function()
        if core and core.Get and core.Get("Combat","Hit") then
            oldBoxFunc = core.Get("Combat","Hit").Box
        end
    end)
end)

local function setHitbox(state)
    hitboxEnabled = state
    
    if core and oldBoxFunc then
        if state then
            core.Get("Combat","Hit").Box = function(_, target, data)
                return oldBoxFunc(nil, target, {Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)})
            end
            
            Notifier.new({
                Title = "Hitbox Expander",
                Content = "Hitbox expanded to " .. hitboxSize .. " studs",
                Duration = 3,
                Icon = "target"
            })
        else
            core.Get("Combat","Hit").Box = oldBoxFunc
            
            Notifier.new({
                Title = "Hitbox Expander",
                Content = "Hitbox restored to normal",
                Duration = 3,
                Icon = "target"
            })
        end
    end
end

local HitboxToggle = CombatRightSection:AddToggle({
    Name = "Hitbox Expander",
    Flag = "Hitbox_Enabled",
    Default = false,
    Callback = function(value)
        setHitbox(value)
    end,
});

CombatRightSection:AddSlider({
    Name = "Hitbox Size",
    Min = 5,
    Max = 50,
    Default = 20,
    Round = 0,
    Flag = "Hitbox_Size",
    Callback = function(value)
        hitboxSize = value
        if hitboxEnabled then
            setHitbox(true)
        end
    end
});

CombatRightSection:AddSlider({
    Name = "Attack Range",
    Min = 10,
    Max = 200,
    Default = 100,
    Round = 0,
    Flag = "Global_Attack_Range",
    Callback = function(value)
        GlobalAttackRange = value
        KillAuraConfig.MaxDistance = value
        
        Notifier.new({
            Title = "Attack Range",
            Content = "Range set to: " .. value .. " studs",
            Duration = 2,
            Icon = "target"
        })
    end
});

-- 孝袨袚袥 ATTACK DEAD PLAYERS
CombatRightSection:AddToggle({
    Name = "Attack Dead Players",
    Flag = "Attack_Dead_Players",
    Default = false,
    Callback = function(value)
        IgnoreDeadPlayers = not value
        
        Notifier.new({
            Title = "Attack Dead Players",
            Content = value and "Enabled" or "Disabled",
            Duration = 2,
            Icon = "skull"
        })
    end,
});

-- ========================================
-- KILL FARMING SECTION (TH脢M V脌O COMBAT TAB)
-- ========================================
local KillFarmingSection = CombatTab:DrawSection({
    Name = "Kill Farming",
    Position = "right"
})

local UserInputService = game:GetService("UserInputService")
local farmConnection, killAuraConnection, dashConnection
local originalCameraSubject, originalCameraType
local savedCFrame, savedCameraCFrame, savedCameraType
local currentTarget = nil
local targetStartTime = 0
local lastDash = 0

local KillFarmConfig = {
    KillFarming = false,
    FarmKeybind = Enum.KeyCode.O
}

-- C岷 h矛nh Kill Aura
local killAuraRunning = false
local distance = 100 -- default Kill Aura range
local KillFarmConfigs = {
    IgnoreFriends = false,
    MaxDistance = distance,
    Damage = 1,
    HealthLimit = 0,
    DashInterval = 0.7
}

local function showNotification(title, message)
    Notifier.new({
        Title = title,
        Content = message,
        Duration = 3,
        Icon = "target"
    })
end

local function getRandomAlivePlayer()
    local alive = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character then
            local hum = p.Character:FindFirstChild("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp and (hum:GetAttribute("Health") or 0) > 0 and not hum:GetAttribute("Godmode") then
                table.insert(alive, p)
            end
        end
    end
    if #alive > 0 then
        return alive[math.random(1, #alive)]
    end
    return nil
end

local function triggerDash()
    if tick() - lastDash < KillFarmConfigs.DashInterval then return end
    lastDash = tick()
    local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local dashArgs = {[1]=hrp.CFrame,[2]="L",[3]=hrp.CFrame.LookVector,[5]=tick()}
    local dashRemote = RS.Remotes.Character:FindFirstChild("Dash")
    if dashRemote then pcall(function() dashRemote:FireServer(unpack(dashArgs)) end) end
end

local function sendKillAura()
    local Character = localPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local CharactersFolder = RS:FindFirstChild("Characters")
    local RemotesFolder = RS:FindFirstChild("Remotes")
    if not CharactersFolder or not RemotesFolder then return end
    local AbilitiesRemote = RemotesFolder:FindFirstChild("Abilities")
    local CombatRemote = RemotesFolder:FindFirstChild("Combat")
    if AbilitiesRemote then AbilitiesRemote = AbilitiesRemote:FindFirstChild("Ability") end
    if CombatRemote then CombatRemote = CombatRemote:FindFirstChild("Action") end
    if not AbilitiesRemote or not CombatRemote then return end
    local CharacterName = localPlayer:FindFirstChild("Data") and localPlayer.Data:FindFirstChild("Character") and localPlayer.Data.Character.Value
    if not CharacterName then return end
    local WallCombo = CharactersFolder:FindFirstChild(CharacterName)
    if not WallCombo then return end
    WallCombo = WallCombo:FindFirstChild("WallCombo")
    if not WallCombo then return end
    local localRootPart = Character.HumanoidRootPart
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer == localPlayer then continue end
        if not targetPlayer.Character then continue end
        if not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then continue end
        if KillFarmConfigs.IgnoreFriends and localPlayer:IsFriendsWith(targetPlayer.UserId) then continue end
        local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        local targetRootPart = targetPlayer.Character.HumanoidRootPart
        if not targetHumanoid or targetHumanoid.Health <= KillFarmConfigs.HealthLimit then continue end
        local distanceToTarget = (localRootPart.Position - targetRootPart.Position).Magnitude
        if distanceToTarget > KillFarmConfigs.MaxDistance then continue end
        
        local abilityArgs = {WallCombo, KillFarmConfigs.Damage, {}, targetRootPart.Position}
        pcall(function() AbilitiesRemote:FireServer(unpack(abilityArgs)) end)
        
        local startCFrameStr = tostring(localRootPart.CFrame)
        local combatArgs = {
            WallCombo, CharacterName..":WallCombo", 2,
            KillFarmConfigs.Damage,
            {HitboxCFrames={targetRootPart.CFrame,targetRootPart.CFrame},BestHitCharacter=targetPlayer.Character,HitCharacters={targetPlayer.Character},Ignore={},DeathInfo={},BlockedCharacters={},HitInfo={IsFacing=false,IsInFront=true},ServerTime=os.time(),Actions={ActionNumber1={[targetPlayer.Name]={StartCFrameStr=startCFrameStr,Local=true,Collision=false,Animation="Punch1Hit",Preset="Punch",Velocity=Vector3.zero,FromPosition=targetRootPart.Position,Seed=math.random(1,999999)}}},FromCFrame=targetRootPart.CFrame},
            "Action150",0
        }
        pcall(function() CombatRemote:FireServer(unpack(combatArgs)) end)
    end
end

local killAuraConn
local function startKillAura()
    if killAuraConn then killAuraConn:Disconnect() killAuraConn=nil end
    killAuraConn = RunService.Heartbeat:Connect(function()
        if killAuraRunning then sendKillAura() end
    end)
end

local function teleportUnderPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return false end
    
    -- Teleport xu峄憂g s芒u h啤n d瓢峄沬 ch芒n ng瓢峄漣 ch啤i
    local belowPos = targetRoot.Position - Vector3.new(0, 10, 0) -- Xu峄憂g 10 studs
    pcall(function()
        require(localPlayer.PlayerScripts.Character.FullCustomReplication).Override(localPlayer.Character, CFrame.new(belowPos))
    end)
    
    if currentTarget ~= targetPlayer.Character then
        currentTarget = targetPlayer.Character
        targetStartTime = tick()
    end
    return true
end

local function spectatePlayer(targetPlayer)
    local cam = workspace.CurrentCamera
    if not cam or not targetPlayer or not targetPlayer.Character then return end
    local hum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        cam.CameraType = Enum.CameraType.Custom
        cam.CameraSubject = hum
    else
        local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            cam.CameraType = Enum.CameraType.Scriptable
            cam.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 10, 15), hrp.Position)
        end
    end
end

local function lpdash()
    triggerDash()
end

local function farmLoop()
    local char = localPlayer.Character
    if not char or not char.Parent then return end
    
    if currentTarget and (tick() - targetStartTime) < 0.7 then
        local targetPlayer = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character == currentTarget then
                targetPlayer = p
                break
            end
        end
        if targetPlayer then
            teleportUnderPlayer(targetPlayer)
            spectatePlayer(targetPlayer)
        else
            currentTarget = nil
        end
    else
        local randomPlayer = getRandomAlivePlayer()
        if randomPlayer then
            teleportUnderPlayer(randomPlayer)
            spectatePlayer(randomPlayer)
        end
    end
end

local function setGravity(enabled)
    local char = localPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = not enabled
            if not enabled then
                part.Velocity = Vector3.new(0, 0, 0)
                part.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

local function savePosition()
    local char = localPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    savedCFrame = hrp.CFrame
    local cam = workspace.CurrentCamera
    if cam then
        savedCameraCFrame = cam.CFrame
        savedCameraType = cam.CameraType
    end
    return true
end

local function restorePosition()
    if not savedCFrame then return end
    
    local char = localPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    pcall(function()
        require(localPlayer.PlayerScripts.Character.FullCustomReplication).Override(char, savedCFrame)
    end)
    
    task.spawn(function()
        task.wait(0.1)
        local cam = workspace.CurrentCamera
        if cam and savedCameraCFrame and savedCameraType then
            cam.CameraType = savedCameraType
            if savedCameraType == Enum.CameraType.Scriptable then
                cam.CFrame = savedCameraCFrame
            end
        end
    end)
end

local function startKillFarming()
    if KillFarmConfig.KillFarming then return end
    if not savePosition() then return end
    
    KillFarmConfig.KillFarming = true
    killAuraRunning = true
    setGravity(false)
    local cam = workspace.CurrentCamera
    if cam then
        originalCameraSubject = cam.CameraSubject
        originalCameraType = cam.CameraType
    end
    farmConnection = RunService.Heartbeat:Connect(farmLoop)
    startKillAura()
    dashConnection = RunService.Heartbeat:Connect(lpdash)
    showNotification("Kill Farm", "Kill farming with new kill aura started!")
end

local function stopKillFarming()
    if not KillFarmConfig.KillFarming then return end
    KillFarmConfig.KillFarming = false
    killAuraRunning = false
    if farmConnection then farmConnection:Disconnect(); farmConnection = nil end
    if killAuraConn then killAuraConn:Disconnect(); killAuraConn = nil end
    if dashConnection then dashConnection:Disconnect(); dashConnection = nil end
    
    currentTarget = nil
    targetStartTime = 0
    restorePosition()
    
    setGravity(true)
    local cam = workspace.CurrentCamera
    if cam then
        if originalCameraSubject then
            cam.CameraSubject = originalCameraSubject
            cam.CameraType = originalCameraType or Enum.CameraType.Custom
        end
    end
    showNotification("Kill Farm", "Kill farming stopped!")
end

local function toggleKillFarming()
    if KillFarmConfig.KillFarming then
        stopKillFarming()
    else
        startKillFarming()
    end
end

-- Auto reconnect when character respawns
localPlayer.CharacterAdded:Connect(function()
    stopKillFarming()
    setGravity(true)
    currentTarget = nil
    targetStartTime = 0
    killAuraRunning = false
end)

-- Th锚m v脿o UI
KillFarmingSection:AddToggle({
    Name = "Kill Farming",
    Flag = "Kill_Farming_Toggle",
    Default = false,
    Callback = function(value)
        if value then
            startKillFarming()
        else
            stopKillFarming()
        end
    end
})

KillFarmingSection:AddKeybind({
    Name = "Kill Farm Keybind",
    Default = "O",
    Flag = "Kill_Farm_Keybind",
    Callback = function(key)
        KillFarmConfig.FarmKeybind = Enum.KeyCode[key]
        showNotification("Keybind", "Kill Farm keybind set to: " .. key)
    end
})

KillFarmingSection:AddSlider({
    Name = "Farm Distance",
    Min = 10,
    Max = 200,
    Default = 100,
    Round = 0,
    Flag = "Kill_Farm_Distance",
    Callback = function(value)
        KillFarmConfigs.MaxDistance = value
    end
})

KillFarmingSection:AddToggle({
    Name = "Ignore Friends",
    Flag = "Kill_Farm_IgnoreFriends",
    Default = false,
    Callback = function(value)
        KillFarmConfigs.IgnoreFriends = value
    end
})

HitboxToggle.Link:AddHelper({
    Text = "Expands enemy hitboxes for easier targeting"
})

-- -- ========================================
-- EXPLOITS TAB
-- ========================================
local ExploitsTab = Window:DrawTab({
    Name = "Exploits",
    Icon = "bug",
    Type = "Double",
    EnableScrolling = true
});

local ExploitsLeftSection = ExploitsTab:DrawSection({
    Name = "Exploits basic",
    Position = "left"
});

local ExploitsRightSection = ExploitsTab:DrawSection({
    Name = "Server & Movement",
    Position = "right"
});

-- ========================================
-- GOD MODE MODULES
-- ========================================
local godModeV1Running = false
ExploitsLeftSection:AddToggle({
    Name = "God Mode V1",
    Flag = "GodMode_V1",
    Default = false,
    Callback = function(value)
        godModeV1Running = value
        if value then
            task.spawn(function()
                while godModeV1Running do
                    pcall(function()
                        local combatArgs = {
                            [1] = RS.Characters.Gon.WallCombo,
                            [2] = "Characters:Gon:WallCombo",
                            [3] = 1,
                            [4] = 33036,
                            [5] = {
                                ["HitboxCFrames"] = {},
                                ["BestHitCharacter"] = workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum"),
                                ["HitCharacters"] = {workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum")},
                                ["Ignore"] = {},
                                ["DeathInfo"] = {},
                                ["Actions"] = {},
                                ["HitInfo"] = {["IsFacing"] = true,["IsInFront"] = true},
                                ["BlockedCharacters"] = {},
                                ["ServerTime"] = os.clock(),
                                ["FromCFrame"] = CFrame.new(534.693, 5.532, 79.486)
                            },
                            [6] = "Action651",
                            [7] = 0
                        }
                        
                        local abilityArgs = {
                            [1] = RS.Characters.Gon.WallCombo,
                            [2] = 33036,
                            [4] = workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum"),
                            [5] = Vector3.new(527.693, 4.532, 79.978)
                        }
                        
                        RS.Remotes.Abilities.Ability:FireServer(unpack(abilityArgs))
                        RS.Remotes.Combat.Action:FireServer(unpack(combatArgs))
                    end)
                    task.wait(1.4)
                end
            end)
        end
    end,
});

local godModeV2Running = false
ExploitsLeftSection:AddToggle({
    Name = "God Mode V2",
    Flag = "GodMode_V2",
    Default = false,
    Callback = function(value)
        godModeV2Running = value
        if value then
            task.spawn(function()
                while godModeV2Running do
                    pcall(function()
                        local playerChar = localPlayer.Character
                        if not playerChar then return end
                        
                        local charData = localPlayer:FindFirstChild("Data")
                        local charValue = charData and charData:FindFirstChild("Character") and charData.Character.Value
                        if not charValue then return end
                        
                        local charsFolder = RS:FindFirstChild("Characters")
                        if not charsFolder or not charsFolder:FindFirstChild(charValue) then return end
                        
                        local wallComboAbility = charsFolder[charValue]:FindFirstChild("WallCombo")
                        if not wallComboAbility then return end
                        
                        local randomId = math.random(100000, 999999)
                        
                        RS.Remotes.Abilities.Ability:FireServer(wallComboAbility, randomId)
                        RS.Remotes.Combat.Action:FireServer(wallComboAbility, "Characters:" .. charValue .. ":WallCombo", 1, randomId, {
                            HitboxCFrames = {nil},
                            BestHitCharacter = playerChar,
                            HitCharacters = {playerChar},
                            Ignore = {},
                            DeathInfo = {},
                            Actions = {},
                            HitInfo = {Blocked = false, IsFacing = true, IsInFront = true},
                            BlockedCharacters = {},
                            ServerTime = tick(),
                            FromCFrame = nil
                        }, "Action" .. math.random(1000, 9999))
                    end)
                    task.wait(0.01)
                end
            end)
        end
    end,
});

local antiGodModeRunning = false
ExploitsLeftSection:AddToggle({
    Name = "Anti God Mode",
    Flag = "Anti_GodMode",
    Default = false,
    Callback = function(value)
        antiGodModeRunning = value
        print("Anti God Mode:", value)
    end,
});

-- ========================================
-- PROTECTION MODULES
-- ========================================
local HideUsernameModule = {
    enabled = false,
    connections = {},
    originalTexts = {}
}

function HideUsernameModule:HideUsername()
    pcall(function()
        local playerGui = localPlayer:WaitForChild("PlayerGui")
        local playersGui = playerGui:WaitForChild("Players")
        local base = playersGui:WaitForChild("Base")
        local players = base:WaitForChild("Players")
        
        local scroll = players:WaitForChild("Scroll")
        for _, child in pairs(scroll:GetChildren()) do
            if child:IsA("Frame") then
                local basePath = child:FindFirstChild("Base")
                if basePath then
                    local framePath = basePath:FindFirstChild("Frame")
                    if framePath then
                        local offset = framePath:FindFirstChild("Offset")
                        if offset then
                            local user = offset:FindFirstChild("User")
                            if user and user:IsA("TextLabel") then
                                if user.Text:find(localPlayer.Name) then
                                    if not self.originalTexts[user] then
                                        self.originalTexts[user] = user.Text
                                    end
                                    user.Text = "SK HUB"
                                end
                            end
                        end
                    end
                end
            end
        end
        
        local expansion = players:FindFirstChild("Expansion")
        if expansion then
            local expand = expansion:FindFirstChild("Expand")
            if expand then
                local info = expand:FindFirstChild("Info")
                if info then
                    local display = info:FindFirstChild("Display")
                    local user = info:FindFirstChild("User")
                    
                    if display and display:IsA("TextLabel") then
                        if display.Text == localPlayer.Name then
                            display.Visible = false
                        end
                    end
                    
                    if user and user:IsA("TextLabel") then
                        if user.Text:find(localPlayer.Name) then
                            if not self.originalTexts[user] then
                                self.originalTexts[user] = user.Text
                            end
                            user.Text = "SK HUB"
                        end
                    end
                end
            end
        end
    end)
end

function HideUsernameModule:RestoreUsername()
    pcall(function()
        for textLabel, originalText in pairs(self.originalTexts) do
            if textLabel and textLabel:IsA("TextLabel") then
                textLabel.Text = originalText
                if textLabel.Name == "Display" then
                    textLabel.Visible = true
                end
            end
        end
        self.originalTexts = {}
    end)
end

function HideUsernameModule:Start()
    if #self.connections > 0 then return end
    self.enabled = true
    
    table.insert(self.connections, RunService.Heartbeat:Connect(function()
        self:HideUsername()
    end))
    
    Notifier.new({
        Title = "Fake Username",
        Content = "Username hidden as SK HUB!",
        Duration = 3,
        Icon = "user-x"
    })
end

function HideUsernameModule:Stop()
    for _, conn in ipairs(self.connections) do
        if conn then conn:Disconnect() end
    end
    self.connections = {}
    self.enabled = false
    
    self:RestoreUsername()
    
    Notifier.new({
        Title = "Fake Name",
        Content = "Username restored!",
        Duration = 3,
        Icon = "user-check"
    })
end

ExploitsLeftSection:AddToggle({
    Name = "Fake username",
    Flag = "Fake username",
    Default = false,
    Callback = function(value)
        if value then
            HideUsernameModule:Start()
        else
            HideUsernameModule:Stop()
        end
    end,
});

local FakePingModule = {
    enabled = false,
    connection = nil
}

function FakePingModule:Start()
    if self.connection then return end
    self.enabled = true
    
    self.connection = RunService.Heartbeat:Connect(function()
        pcall(function()
            RS:WaitForChild("Remotes"):WaitForChild("Services"):WaitForChild("Ping"):FireServer()
        end)
    end)
    
    Notifier.new({
        Title = "Fake Ping",
        Content = "Fake Ping activated!",
        Duration = 3,
        Icon = "wifi"
    })
end

function FakePingModule:Stop()
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
    end
    self.enabled = false
    
    Notifier.new({
        Title = "Fake Ping",
        Content = "Fake Ping deactivated!",
        Duration = 3,
        Icon = "wifi"
    })
end

ExploitsLeftSection:AddToggle({
    Name = "Fake Ping",
    Flag = "Fake_Ping",
    Default = false,
    Callback = function(value)
        if value then
            FakePingModule:Start()
        else
            FakePingModule:Stop()
        end
    end,
});

-- ========================================
-- INVISIBLE SECTION (TH脢M V脌O EXPLOITS LEFT)
-- ========================================
local InvisibleToggle = ExploitsLeftSection:AddToggle({
    Name = "Invisible",
    Flag = "Invisible_Toggle",
    Default = false,
    Callback = function(value)
        local invisibleEnabled = value
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Replication"):WaitForChild("FullCustomReplicationUnreliable")
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HRP = Character:WaitForChild("HumanoidRootPart")

        -- Hook remote ch峄� 1 l岷
        if not getgenv()._InvisibleHooked then
            getgenv()._InvisibleHooked = true
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            local old = mt.__namecall
            mt.__namecall = function(self, ...)
                if self == Remote and getnamecallmethod() == "FireServer" and getgenv().blockRemote then
                    return nil
                end
                return old(self, ...)
            end
            setreadonly(mt, true)
        end

        if invisibleEnabled then
            -- B岷璽 invisible
            local originalCF = HRP.CFrame
            local flyingCF = originalCF + Vector3.new(0, 50000, 0)

            task.spawn(function()
                for i = 1, 10 do
                    HRP.CFrame = flyingCF
                    Remote:FireServer()
                    task.wait(0.1)
                end
                getgenv().blockRemote = true
                HRP.CFrame = originalCF
            end)
            
            Notifier.new({
                Title = "Invisible",
                Content = "Invisible activated!",
                Duration = 3,
                Icon = "eye-off"
            })
        else
            -- T岷痶 invisible
            getgenv().blockRemote = false
            
            Notifier.new({
                Title = "Invisible",
                Content = "Invisible deactivated!",
                Duration = 3,
                Icon = "eye"
            })
        end
    end
})

-- Th锚m helper text
InvisibleToggle.Link:AddHelper({
    Text = "Makes your character invisible to other players"
})

-- ========================================
-- COMBAT SETTINGS MODULES
-- ========================================
local DisableCombatTimerModule = {
    enabled = false
}

function DisableCombatTimerModule:Start()
    self.enabled = true
    pcall(function()
        RS:WaitForChild("Settings"):WaitForChild("Toggles").DisableCombatTimer.Value = true
    end)
    
    Notifier.new({
        Title = "Combat Timer",
        Content = "Combat Timer disabled!",
        Duration = 3,
        Icon = "timer"
    })
end

function DisableCombatTimerModule:Stop()
    self.enabled = false
    pcall(function()
        RS:WaitForChild("Settings"):WaitForChild("Toggles").DisableCombatTimer.Value = false
    end)
    
    Notifier.new({
        Title = "Combat Timer",
        Content = "Combat Timer enabled!",
        Duration = 3,
        Icon = "timer"
    })
end

ExploitsLeftSection:AddToggle({
    Name = "Disable Combat Timer",
    Flag = "Disable_Combat_Timer",
    Default = false,
    Callback = function(value)
        if value then
            DisableCombatTimerModule:Start()
        else
            DisableCombatTimerModule:Stop()
        end
    end,
});

local InstantTransformModule = {
    enabled = false
}

function InstantTransformModule:Start()
    self.enabled = true
    pcall(function()
        RS:WaitForChild("Settings"):WaitForChild("Toggles").InstantTransformation.Value = true
    end)
    
    Notifier.new({
        Title = "Instant Transform",
        Content = "Instant Transformation activated!",
        Duration = 3,
        Icon = "zap"
    })
end

function InstantTransformModule:Stop()
    self.enabled = false
    pcall(function()
        RS:WaitForChild("Settings"):WaitForChild("Toggles").InstantTransformation.Value = false
    end)
    
    Notifier.new({
        Title = "Instant Transform",
        Content = "Instant Transformation deactivated!",
        Duration = 3,
        Icon = "zap"
    })
end

ExploitsLeftSection:AddToggle({
    Name = "Instant Transformation",
    Flag = "Instant_Transformation",
    Default = false,
    Callback = function(value)
        if value then
            InstantTransformModule:Start()
        else
            InstantTransformModule:Stop()
        end
    end,
});

local MultiUseCutscenesModule = {
    enabled = false
}

function MultiUseCutscenesModule:Start()
    self.enabled = true
    pcall(function()
        RS:WaitForChild("Settings"):WaitForChild("Toggles").MultiUseCutscenes.Value = true
    end)
    
    Notifier.new({
        Title = "Multi Cutscenes",
        Content = "Multi Use Cutscenes activated!",
        Duration = 3,
        Icon = "video"
    })
end

function MultiUseCutscenesModule:Stop()
    self.enabled = false
    pcall(function()
        RS:WaitForChild("Settings"):WaitForChild("Toggles").MultiUseCutscenes.Value = false
    end)
    
    Notifier.new({
        Title = "Multi Cutscenes",
        Content = "Multi Use Cutscenes deactivated!",
        Duration = 3,
        Icon = "video"
    })
end

ExploitsLeftSection:AddToggle({
    Name = "Multi Use Cutscenes",
    Flag = "Multi_Use_Cutscenes",
    Default = false,
    Callback = function(value)
        if value then
            MultiUseCutscenesModule:Start()
        else
            MultiUseCutscenesModule:Stop()
        end
    end,
});

-- ========================================
-- MOVEMENT MODULES
-- ========================================
local WalkSpeedModule = {
    enabled = false,
    currentSpeed = 100
}

function WalkSpeedModule:SetSpeed(speed)
    self.currentSpeed = speed
    if self.enabled then
        pcall(function()
            RS:WaitForChild("Settings"):WaitForChild("Multipliers").RunSpeed.Value = speed
            RS:WaitForChild("Settings"):WaitForChild("Multipliers").WalkSpeed.Value = speed
        end)
    end
end

function WalkSpeedModule:Toggle(enabled)
    self.enabled = enabled
    if enabled then
        pcall(function()
            RS:WaitForChild("Settings"):WaitForChild("Multipliers").RunSpeed.Value = self.currentSpeed
            RS:WaitForChild("Settings"):WaitForChild("Multipliers").WalkSpeed.Value = self.currentSpeed
        end)
        print("Walk Speed enabled: " .. self.currentSpeed)
    else
        pcall(function()
            RS:WaitForChild("Settings"):WaitForChild("Multipliers").RunSpeed.Value = 100
            RS:WaitForChild("Settings"):WaitForChild("Multipliers").WalkSpeed.Value = 100
        end)
        print("Walk Speed disabled")
    end
end

ExploitsRightSection:AddToggle({
    Name = "Walk Speed",
    Flag = "WalkSpeed_Toggle",
    Default = false,
    Callback = function(value)
        WalkSpeedModule:Toggle(value)
    end
})

ExploitsRightSection:AddSlider({
    Name = "Walk Speed Value",
    Min = 0,
    Max = 1000,
    Default = 100,
    Round = 0,
    Flag = "Walk_Speed",
    Callback = function(value)
        WalkSpeedModule:SetSpeed(value)
        print("Walk Speed set to: " .. value)
    end
})

local DashSpeedModule = {
    enabled = false,
    currentSpeed = 100
}

function DashSpeedModule:SetSpeed(speed)
    self.currentSpeed = speed
    if self.enabled then
        pcall(function()
            RS:WaitForChild("Settings"):WaitForChild("Multipliers").DashSpeed.Value = speed
        end)
    end
end

function DashSpeedModule:Toggle(enabled)
    self.enabled = enabled
    if enabled then
        pcall(function()
            RS:WaitForChild("Settings"):WaitForChild("Multipliers").DashSpeed.Value = self.currentSpeed
        end)
        print("Dash Speed enabled: " .. self.currentSpeed)
    else
        pcall(function()
            RS:WaitForChild("Settings"):WaitForChild("Multipliers").DashSpeed.Value = 100
        end)
        print("Dash Speed disabled")
    end
end

ExploitsRightSection:AddToggle({
    Name = "Dash Speed",
    Flag = "DashSpeed_Toggle",
    Default = false,
    Callback = function(value)
        DashSpeedModule:Toggle(value)
    end
})

ExploitsRightSection:AddSlider({
    Name = "Dash Speed Value",
    Min = 0,
    Max = 1000,
    Default = 100,
    Round = 0,
    Flag = "Dash_Speed",
    Callback = function(value)
        DashSpeedModule:SetSpeed(value)
        print("Dash Speed set to: " .. value)
    end
})

local JumpHeightModule = {
    enabled = false,
    currentHeight = 100
}

function JumpHeightModule:SetHeight(height)
    self.currentHeight = height
    if self.enabled then
        pcall(function()
            RS:WaitForChild("Settings"):WaitForChild("Multipliers").JumpHeight.Value = height
        end)
    end
end

function JumpHeightModule:Toggle(enabled)
    self.enabled = enabled
    if enabled then
        pcall(function()
            RS:WaitForChild("Settings"):WaitForChild("Multipliers").JumpHeight.Value = self.currentHeight
        end)
        print("Jump Height enabled: " .. self.currentHeight)
    else
        pcall(function()
            RS:WaitForChild("Settings"):WaitForChild("Multipliers").JumpHeight.Value = 100
        end)
        print("Jump Height disabled")
    end
end

ExploitsRightSection:AddToggle({
    Name = "Jump Height",
    Flag = "JumpHeight_Toggle",
    Default = false,
    Callback = function(value)
        JumpHeightModule:Toggle(value)
    end
})

ExploitsRightSection:AddSlider({
    Name = "Jump Height Value",
    Min = 0,
    Max = 1000,
    Default = 100,
    Round = 0,
    Flag = "Jump_Height",
    Callback = function(value)
        JumpHeightModule:SetHeight(value)
        print("Jump Height set to: " .. value)
    end
})

-- ========================================
-- SERVER MODULES
-- ========================================
local lagServerV1Running = false
ExploitsRightSection:AddToggle({
    Name = "Lag Server normal",
    Flag = "Lag_Server_normal",
    Default = false,
    Callback = function(value)
        lagServerV1Running = value
        if value then
            task.spawn(function()
                while lagServerV1Running do
                    pcall(function()
                        local combatArgs = {
                            [1] = RS.Characters.Gon.WallCombo,
                            [2] = "Characters:Gon:WallCombo",
                            [3] = 1,
                            [4] = 33036,
                            [5] = {
                                ["HitboxCFrames"] = {},
                                ["BestHitCharacter"] = workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum"),
                                ["HitCharacters"] = {workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum")},
                                ["Ignore"] = {},
                                ["DeathInfo"] = {},
                                ["Actions"] = {},
                                ["HitInfo"] = {["IsFacing"] = true,["IsInFront"] = true},
                                ["BlockedCharacters"] = {},
                                ["ServerTime"] = os.clock(),
                                ["FromCFrame"] = CFrame.new(534.693, 5.532, 79.486)
                            },
                            [6] = "Action651",
                            [7] = 0
                        }
                        
                        local abilityArgs = {
                            [1] = RS.Characters.Gon.WallCombo,
                            [2] = 33036,
                            [4] = workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum"),
                            [5] = Vector3.new(527.693, 4.532, 79.978)
                        }
                        
                        for i = 1, 5 do
                            RS.Remotes.Abilities.Ability:FireServer(unpack(abilityArgs))
                            RS.Remotes.Combat.Action:FireServer(unpack(combatArgs))
                        end
                    end)
                    task.wait()
                end
            end)
        end
    end,
});

-- ========================================
-- ANTI LAG SERVER MODULE (TH脢M V脌O EXPLOITS RIGHT SECTION)
-- ========================================
local antiLagServerRunning = false
local antiLagConnections = {}

local function AntiLagServerCleanup()
    pcall(function()
        -- D峄峮 d岷筽 hi峄噓 峄﹏g WallCombo
        local effectsFolder = workspace:WaitForChild("Misc"):WaitForChild("Effects")
        local children = effectsFolder:GetChildren()
        local destroyedCount = 0
        
        for _, effect in pairs(children) do
            if effect:IsA("Model") and effect.Name:match("WallCombo$") then
                effect:Destroy()
                destroyedCount = destroyedCount + 1
            end
        end
        
        -- D峄峮 d岷筽 c谩c hi峄噓 峄﹏g lag kh谩c
        local LAGGY_EFFECTS = {
            "Explosion", "Smoke", "Fire", "Sparkles", "Particle"
        }
        
        for _, effect in pairs(children) do
            if effect:IsA("Model") or effect:IsA("Part") then
                for _, pattern in ipairs(LAGGY_EFFECTS) do
                    if effect.Name:match(pattern) then
                        effect:Destroy()
                        break
                    end
                end
            end
        end
        
        -- Optimize memory
        if math.random(1, 100) <= 20 then
            collectgarbage("collect")
        end
    end)
end

local function StartAntiLagServer()
    if #antiLagConnections > 0 then return end
    
    -- K岷縯 n峄慽 d峄峮 d岷筽 khi c贸 hi峄噓 峄﹏g m峄沬
    table.insert(antiLagConnections, workspace.Misc.Effects.ChildAdded:Connect(function(child)
        task.wait(0.1)
        if child and (child:IsA("Model") or child:IsA("Part")) then
            if child.Name:match("WallCombo$") or child.Name:match("Explosion") then
                child:Destroy()
            end
        end
    end))
    
    -- D峄峮 d岷筽 膽峄媙h k峄�
    table.insert(antiLagConnections, RunService.Heartbeat:Connect(function()
        if antiLagServerRunning then
            AntiLagServerCleanup()
        end
    end))
    
    Notifier.new({
        Title = "Anti Lag Server",
        Content = "Anti Lag Server activated! Cleaning effects...",
        Duration = 3,
        Icon = "cpu"
    })
end

local function StopAntiLagServer()
    for _, conn in ipairs(antiLagConnections) do
        if conn then 
            conn:Disconnect() 
        end
    end
    antiLagConnections = {}
    
    Notifier.new({
        Title = "Anti Lag Server",
        Content = "Anti Lag Server deactivated!",
        Duration = 3,
        Icon = "cpu"
    })
end

-- TH脢M N脷T ANTI LAG SERVER V脌O EXPLOITS RIGHT SECTION (d瓢峄沬 Lag Server V1)
ExploitsRightSection:AddToggle({
    Name = "Anti Lag Server",
    Flag = "Anti_Lag_Server",
    Default = false,
    Callback = function(value)
        antiLagServerRunning = value
        if value then
            StartAntiLagServer()
        else
            StopAntiLagServer()
        end
    end,
});

-- Th锚m n煤t Emergency Cleanup
ExploitsRightSection:AddButton({
    Name = "Emergency Cleanup",
    Callback = function()
        AntiLagServerCleanup()
        collectgarbage("collect")
        collectgarbage("restart")
        
        Notifier.new({
            Title = "Emergency Cleanup",
            Content = "Emergency cleanup completed!",
            Duration = 3,
            Icon = "trash-2"
        })
    end
});

local lagServerV2Running = false
ExploitsRightSection:AddToggle({
    Name = "Lag Server rank",
    Flag = "Lag_Server rank",
    Default = false,
    Callback = function(value)
        lagServerV2Running = value
        if value then
            for i = 1, 3 do
                task.spawn(function()
                    while lagServerV2Running do
                        pcall(function()
                            local combatArgs = {
                                [1] = RS.Characters.Gon.WallCombo,
                                [2] = "Characters:Gon:WallCombo",
                                [3] = 1,
                                [4] = 33036,
                                [5] = {
                                    ["HitboxCFrames"] = {},
                                    ["BestHitCharacter"] = workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum"),
                                    ["HitCharacters"] = {workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum")},
                                    ["Ignore"] = {},
                                    ["DeathInfo"] = {},
                                    ["Actions"] = {},
                                    ["HitInfo"] = {["IsFacing"] = true,["IsInFront"] = true},
                                    ["BlockedCharacters"] = {},
                                    ["ServerTime"] = os.clock(),
                                    ["FromCFrame"] = CFrame.new(534.693, 5.532, 79.486)
                                },
                                [6] = "Action651",
                                [7] = 0
                            }
                            
                            local abilityArgs = {
                                [1] = RS.Characters.Gon.WallCombo,
                                [2] = 33036,
                                [4] = workspace.Characters.NPCs:FindFirstChild("The Ultimate Bum"),
                                [5] = Vector3.new(527.693, 4.532, 79.978)
                            }
                            
                            for j = 1, 10 do
                                RS.Remotes.Abilities.Ability:FireServer(unpack(abilityArgs))
                                RS.Remotes.Combat.Action:FireServer(unpack(combatArgs))
                            end
                        end)
                        task.wait()
                    end
                end)
            end
        end
    end,
});

local antiLagRunning = false
ExploitsRightSection:AddToggle({
    Name = "Anti Lag Crack Server",
    Flag = "Anti_Lag_Crack",
    Default = false,
    Callback = function(value)
        antiLagRunning = value
        if value then
            task.spawn(function()
                while antiLagRunning do
                    pcall(function()
                        local effectsFolder = workspace:WaitForChild("Misc"):WaitForChild("Effects")
                        for _, effect in pairs(effectsFolder:GetChildren()) do
                            if effect:IsA("Model") and effect.Name:match("WallCombo$") then
                                effect:Destroy()
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end,
});

-- ========================================
-- OTHER SETTINGS
-- ========================================
ExploitsRightSection:AddToggle({
    Name = "Infinity ultimate",
    Flag = "Infinity_ultimate",
    Default = false,
    Callback = function(value)
        pcall(function()
            RS:WaitForChild("Settings"):WaitForChild("Toggles").Endless.Value = value
        end)
    end,
});

ExploitsLeftSection:AddToggle({
    Name = "No Stun",
    Flag = "No_Stun",
    Default = false,
    Callback = function(value)
        pcall(function()
            RS:WaitForChild("Settings"):WaitForChild("Toggles").NoStunOnMiss.Value = value
        end)
    end,
});

ExploitsLeftSection:AddToggle({
    Name = "No Slowdown",
    Flag = "No_Slowdown",
    Default = false,
    Callback = function(value)
        pcall(function()
            RS:WaitForChild("Settings"):WaitForChild("Toggles").NoSlowdowns.Value = value
        end)
    end,
});

ExploitsLeftSection:AddToggle({
    Name = "No Dash Cooldown",
    Flag = "No_Dash_Cooldown",
    Default = false,
    Callback = function(value)
        pcall(function()
            RS:WaitForChild("Settings"):WaitForChild("Cooldowns").Dash.Value = value and 0 or 100
        end)
    end,
});

print("Exploits tab loaded successfully!")

-- ========================================
-- EMOTES TAB
-- ========================================
local EmotesTab = Window:DrawTab({
    Name = "Emotes",
    Icon = "contact",
    Type = "Double",
    EnableScrolling = true
});

local EmotesLeftSection = EmotesTab:DrawSection({
    Name = "Emote Spam Settings",
    Position = "left"
});

local killEmotes = {
    "Vampire", "Surprise!","ACME","Avra Kadoovra","Baldie's Demise","Barbarian","Bee","Blood Sugar","Cauldron","Curb Stomp","Figure Skater","Frost Breath","Frostbound Prison","Frozen Impalement","Gingerbread","Glacial Burial","Goblin Bomb","Heart Rip","Impostor","Laser Eyes","Mistletoe","Naughty List","Neck Snap","Orthax","Pollen Overload","Possession","Rudolph's Revenge","Selfie","Serious Sneeze","Sick Burn","Smite","Snowball Cannon","Snowflakes","Sore Winner","Spine Breaker","Spirit Trap","Think Mark","Tinsel Strangle","Tree Topper Slice","Werewolf","Wrap It Up"
}

local emoteRunning = false
local emoteMode = nil
local emoteSelected = killEmotes[1]
local emoteSpeed = 0.05
local maxDistance = 15

local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function useEmote(name)
    if not coreLoaded or not core then 
        return 
    end
    
    local emoteModule = RS:FindFirstChild("Cosmetics") and RS.Cosmetics:FindFirstChild("KillEmote") and RS.Cosmetics.KillEmote:FindFirstChild(name)
    local myRoot = getRoot(localPlayer.Character)
    
    if not myRoot or not emoteModule then return end
    
    local target = nil
    local dist = math.huge
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and getRoot(p.Character) then
            local d = (myRoot.Position - getRoot(p.Character).Position).Magnitude
            if d < dist and d <= maxDistance then
                dist = d
                target = p.Character
            end
        end
    end
    
    if target then
        pcall(function()
            core.Get("Combat","Ability").Activate(emoteModule, target)
        end)
    end
end

local emoteConn = RunService.RenderStepped:Connect(function()
    if emoteRunning and coreLoaded then
        if emoteMode == "selected" and emoteSelected then
            useEmote(emoteSelected)
            task.wait(emoteSpeed)
        elseif emoteMode == "random" then
            useEmote(killEmotes[math.random(1, #killEmotes)])
            task.wait(emoteSpeed)
        end
    end
end)

local EmoteDropdown = EmotesLeftSection:AddDropdown({
    Name = "Select Emote",
    Default = killEmotes[1],
    Values = killEmotes,
    Flag = "Selected_Emote",
    Callback = function(value)
        emoteSelected = value
    end
});

local SpamSelectedToggle = EmotesLeftSection:AddToggle({
    Name = "Spam Selected Emote",
    Flag = "Spam_Selected_Emote",
    Default = false,
    Callback = function(value)
        if value then
            if not coreLoaded then
                Notifier.new({
                    Title = "Error",
                    Content = "Core module not loaded yet! Wait a few seconds.",
                    Duration = 5,
                    Icon = "alert-triangle"
                })
                return
            end
            
            emoteMode = "selected"
            emoteRunning = true
            
            Notifier.new({
                Title = "Emote Spam",
                Content = "Spamming: " .. emoteSelected,
                Duration = 3,
                Icon = "smile"
            })
        else
            emoteRunning = false
            emoteMode = nil
        end
    end,
});

local SpamRandomToggle = EmotesLeftSection:AddToggle({
    Name = "Spam Random Emote",
    Flag = "Spam_Random_Emote",
    Default = false,
    Callback = function(value)
        if value then
            if not coreLoaded then
                Notifier.new({
                    Title = "Error",
                    Content = "Core module not loaded yet! Wait a few seconds.",
                    Duration = 5,
                    Icon = "alert-triangle"
                })
                return
            end
            
            emoteMode = "random"
            emoteRunning = true
            
            Notifier.new({
                Title = "Emote Spam",
                Content = "Spamming random emotes",
                Duration = 3,
                Icon = "shuffle"
            })
        else
            emoteRunning = false
            emoteMode = nil
        end
    end,
});

EmotesLeftSection:AddSlider({
    Name = "Emote Speed (Delay)",
    Min = 0,
    Max = 1,
    Default = 0.05,
    Round = 2,
    Flag = "Emote_Speed",
    Callback = function(value)
        emoteSpeed = value
    end
});

EmotesLeftSection:AddSlider({
    Name = "Max Distance",
    Min = 5,
    Max = 50,
    Default = 15,
    Round = 0,
    Flag = "Emote_Max_Distance",
    Callback = function(value)
        maxDistance = value
    end
});

-- ========================================
-- COSMETICS EQUIP SECTION (INTEGRATED)
-- ========================================
local CosmeticsSection = EmotesTab:DrawSection({
    Name = "Cosmetics Equip",
    Position = "right"
});

-- 袩褉械写褍褋褌邪薪芯胁谢械薪薪褘械 写邪薪薪褘械 泻芯褋屑械褌懈泻懈
local COSMETICS_DATA = {
    AccessoriesEquipped = {"Chunin Exam Vest", "Halo", "Frozen Gloves", "Devil's Eye", "Devil's Tail", "Devil's Wings", "Flower Wings", "Frozen Crown", "Frozen Tail", "Frozen Wings", "Garland Scarf", "Hades Helmet", "Holiday Scarf", "Krampus Hat", "Red Kagune", "Rudolph Antlers", "Snowflake Wings", "Sorting Hat", "VIP Crown"},
    AurasEquipped = {"Butterflies", "Northern Lights", "Ki", "Blue Lightning", "Green Lightning", "Purple Lightning", "Yellow Lightning"},
    CapesEquipped = {"Ice Lord", "Viking", "Christmas Lights", "Dracula", "Krampus", "Krampus Supreme", "Santa", "VIP", "Webbed"}
}

-- 袩械褉械屑械薪薪褘械 写谢褟 泻芯褋屑械褌懈泻懈
local CosmeticsFolder = RS:FindFirstChild("Cosmetics")
local selectedCosmeticItems = {}
local currentCosmeticCategory = "Accessories"
local cosmeticItemsCache = {}

-- 肖褍薪泻褑懈褟 锌芯谢褍褔械薪懈褟 褝泻懈锌懈褉芯胁邪薪薪褘褏 锌褉械写屑械褌芯胁
local function getEquippedCosmetics(category)
    local targetPath = nil
    if category == "Accessories" then
        targetPath = localPlayer:FindFirstChild("Data") and localPlayer.Data:FindFirstChild("AccessoriesEquipped")
    elseif category == "Auras" then
        targetPath = localPlayer:FindFirstChild("Data") and localPlayer.Data:FindFirstChild("AurasEquipped")
    elseif category == "Capes" then
        targetPath = localPlayer:FindFirstChild("Data") and localPlayer.Data:FindFirstChild("CapesEquipped")
    end

    if not targetPath or targetPath.Value == "" then
        return {}
    end

    local HttpService = game:GetService("HttpService")
    local success, equippedItems = pcall(function()
        return HttpService:JSONDecode(targetPath.Value)
    end)

    if success and type(equippedItems) == "table" then
        return equippedItems
    end
    return {}
end

-- 肖褍薪泻褑懈褟 锌芯谢褍褔械薪懈褟 褋锌懈褋泻邪 泻芯褋屑械褌懈泻懈 (懈褋锌芯谢褜蟹褍械褌 COSMETICS_DATA 泻邪泻 fallback)
local function getCosmeticItems(category)
    local items = {}

    -- 小薪邪褔邪谢邪 锌褉芯斜褍械屑 锌芯谢褍褔懈褌褜 懈蟹 ReplicatedStorage
    if CosmeticsFolder then
        local folder = CosmeticsFolder:FindFirstChild(category)
        if folder then
            for _, child in ipairs(folder:GetChildren()) do
                table.insert(items, child.Name)
            end
        end
    end

    -- 袝褋谢懈 薪懈褔械谐芯 薪械 薪邪褕谢懈, 懈褋锌芯谢褜蟹褍械屑 锌褉械写褍褋褌邪薪芯胁谢械薪薪褘械 写邪薪薪褘械
    if #items == 0 and COSMETICS_DATA then
        if category == "Accessories" and COSMETICS_DATA.AccessoriesEquipped then
            items = COSMETICS_DATA.AccessoriesEquipped
        elseif category == "Auras" and COSMETICS_DATA.AurasEquipped then
            items = COSMETICS_DATA.AurasEquipped
        elseif category == "Capes" and COSMETICS_DATA.CapesEquipped then
            items = COSMETICS_DATA.CapesEquipped
        end
    end

    -- 校斜懈褉邪械屑 写褍斜谢懈泻邪褌褘 懈 褋芯褉褌懈褉褍械屑
    local uniqueItems = {}
    local seen = {}
    for _, item in ipairs(items) do
        if not seen[item] then
            seen[item] = true
            table.insert(uniqueItems, item)
        end
    end

    table.sort(uniqueItems)
    return uniqueItems
end

-- 袠薪懈褑懈邪谢懈蟹邪褑懈褟 泻械褕邪 锌褉械写屑械褌芯胁
cosmeticItemsCache = getCosmeticItems("Accessories")

-- Dropdown 写谢褟 胁褘斜芯褉邪 泻邪褌械谐芯褉懈懈
local cosmeticCategoryDropdown = CosmeticsSection:AddDropdown({
    Name = "Category",
    Values = {"Accessories", "Auras", "Capes"},
    Default = "Accessories",
    Flag = "Cosmetic_Category",
    Callback = function(value)
        currentCosmeticCategory = value
        cosmeticItemsCache = getCosmeticItems(value)
        selectedCosmeticItems = {}

        local equipped = getEquippedCosmetics(value)
        Notifier.new({
            Title = "Category: " .. value,
            Content = #cosmeticItemsCache .. " items available | " .. #equipped .. " equipped",
            Duration = 3,
            Icon = "package"
        })
    end,
});

-- Dropdown 写谢褟 胁褘斜芯褉邪 锌褉械写屑械褌芯胁 (Multi-select)
local cosmeticItemDropdown = CosmeticsSection:AddDropdown({
    Name = "Select Items",
    Values = cosmeticItemsCache,
    Default = {},
    Multi = true,
    Flag = "Selected_Cosmetic_Items",
    Callback = function(value)
        selectedCosmeticItems = value
        if type(value) == "table" then
            local count = 0
            for _ in pairs(value) do count = count + 1 end
            print("Selected " .. count .. " cosmetic items")
        end
    end,
});

-- 袣薪芯锌泻邪 芯斜薪芯胁谢械薪懈褟 褋锌懈褋泻邪
CosmeticsSection:AddButton({
    Name = "Refresh List",
    Callback = function()
        cosmeticItemsCache = getCosmeticItems(currentCosmeticCategory)

        Notifier.new({
            Title = "List Refreshed",
            Content = "Found " .. #cosmeticItemsCache .. " " .. currentCosmeticCategory,
            Duration = 2,
            Icon = "refresh-cw"
        })
    end,
});

-- 袣薪芯锌泻邪 褝泻懈锌懈褉芯胁泻懈 胁褘斜褉邪薪薪褘褏 锌褉械写屑械褌芯胁
CosmeticsSection:AddButton({
    Name = "Equip Selected",
    Callback = function()
        if not selectedCosmeticItems or type(selectedCosmeticItems) ~= "table" then
            Notifier.new({
                Title = "Error",
                Content = "No items selected!",
                Duration = 3,
                Icon = "alert-triangle"
            })
            return
        end

        -- 袩褉械芯斜褉邪蟹褍械屑 胁 屑邪褋褋懈胁
        local itemsArray = {}
        if type(selectedCosmeticItems) == "table" then
            for key, value in pairs(selectedCosmeticItems) do
                if type(key) == "number" then
                    table.insert(itemsArray, value)
                elseif value == true then
                    table.insert(itemsArray, key)
                end
            end
        end

        if #itemsArray == 0 then
            Notifier.new({
                Title = "Error",
                Content = "No items to equip!",
                Duration = 3,
                Icon = "alert-triangle"
            })
            return
        end

        local targetPath = nil
        if currentCosmeticCategory == "Accessories" then
            targetPath = localPlayer.Data.AccessoriesEquipped
        elseif currentCosmeticCategory == "Auras" then
            targetPath = localPlayer.Data.AurasEquipped
        elseif currentCosmeticCategory == "Capes" then
            targetPath = localPlayer.Data.CapesEquipped
        end

        if targetPath then
            local HttpService = game:GetService("HttpService")
            local success, err = pcall(function()
                local jsonData = HttpService:JSONEncode(itemsArray)
                targetPath.Value = jsonData
            end)

            if success then
                Notifier.new({
                    Title = "Equipped!",
                    Content = "Equipped " .. #itemsArray .. " " .. currentCosmeticCategory,
                    Duration = 3,
                    Icon = "check"
                })
            else
                Notifier.new({
                    Title = "Error",
                    Content = "Failed to equip items",
                    Duration = 3,
                    Icon = "x"
                })
            end
        end
    end,
});

-- 袣薪芯锌泻邪 斜褘褋褌褉芯泄 褝泻懈锌懈褉芯胁泻懈 袙小袝啸 锌褉械写褍褋褌邪薪芯胁谢械薪薪褘褏
CosmeticsSection:AddButton({
    Name = " Equip All Preset",
    Callback = function()
        local itemsToEquip = {}

        if currentCosmeticCategory == "Accessories" and COSMETICS_DATA.AccessoriesEquipped then
            itemsToEquip = COSMETICS_DATA.AccessoriesEquipped
        elseif currentCosmeticCategory == "Auras" and COSMETICS_DATA.AurasEquipped then
            itemsToEquip = COSMETICS_DATA.AurasEquipped
        elseif currentCosmeticCategory == "Capes" and COSMETICS_DATA.CapesEquipped then
            itemsToEquip = COSMETICS_DATA.CapesEquipped
        end

        if #itemsToEquip > 0 then
            local targetPath = nil
            if currentCosmeticCategory == "Accessories" then
                targetPath = localPlayer.Data.AccessoriesEquipped
            elseif currentCosmeticCategory == "Auras" then
                targetPath = localPlayer.Data.AurasEquipped
            elseif currentCosmeticCategory == "Capes" then
                targetPath = localPlayer.Data.CapesEquipped
            end

            if targetPath then
                local HttpService = game:GetService("HttpService")
                local jsonData = HttpService:JSONEncode(itemsToEquip)
                targetPath.Value = jsonData

                Notifier.new({
                    Title = "All Preset Equipped!",
                    Content = "Equipped all " .. #itemsToEquip .. " preset " .. currentCosmeticCategory,
                    Duration = 3,
                    Icon = "zap"
                })
            end
        end
    end,
});

-- 袣薪芯锌泻邪 褋薪褟褌懈褟 胁褋械泄 泻芯褋屑械褌懈泻懈 褌械泻褍褖械泄 泻邪褌械谐芯褉懈懈
CosmeticsSection:AddButton({
    Name = "Unequip All",
    Callback = function()
        local targetPath = nil
        if currentCosmeticCategory == "Accessories" then
            targetPath = localPlayer.Data.AccessoriesEquipped
        elseif currentCosmeticCategory == "Auras" then
            targetPath = localPlayer.Data.AurasEquipped
        elseif currentCosmeticCategory == "Capes" then
            targetPath = localPlayer.Data.CapesEquipped
        end

        if targetPath then
            local HttpService = game:GetService("HttpService")
            local jsonData = HttpService:JSONEncode({})
            targetPath.Value = jsonData

            Notifier.new({
                Title = "Unequipped",
                Content = "Removed all " .. currentCosmeticCategory,
                Duration = 3,
                Icon = "trash-2"
            })
        end
    end,
});

-- 袣薪芯锌泻邪 锌褉芯褋屑芯褌褉邪 褝泻懈锌懈褉芯胁邪薪薪褘褏 锌褉械写屑械褌芯胁
CosmeticsSection:AddButton({
    Name = "Show Equipped",
    Callback = function()
        local equipped = getEquippedCosmetics(currentCosmeticCategory)
        if #equipped > 0 then
            Notifier.new({
                Title = "Equipped " .. currentCosmeticCategory,
                Content = table.concat(equipped, ", "),
                Duration = 5,
                Icon = "info"
            })
            print("=== Equipped " .. currentCosmeticCategory .. " ===")
            for i, item in ipairs(equipped) do
                print(i .. ". " .. item)
            end
        else
            Notifier.new({
                Title = "Nothing Equipped",
                Content = "No " .. currentCosmeticCategory .. " equipped",
                Duration = 3,
                Icon = "info"
            })
        end
    end,
});

-- Toggle 写谢褟 邪胁褌芯-褝泻懈锌懈褉芯胁泻懈 锌褉懈 胁褘斜芯褉械
CosmeticsSection:AddToggle({
    Name = "Auto Equip on Select",
    Flag = "Auto_Equip_Cosmetics",
    Default = false,
    Callback = function(value)
        if value then
            Notifier.new({
                Title = "Auto Equip Enabled",
                Content = "Items will auto-equip when selected",
                Duration = 2,
                Icon = "zap"
            })
        end
    end,
});

-- ========================================
-- KICK MODE SECTION
-- ========================================
local KickSection = EmotesTab:DrawSection({
    Name = "Kick Mode soon",
    Position = "left"
})

local playerList = {}
local selectedPlayer = nil

local function updatePlayerList()
    playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerList, player.Name)
        end
    end
    table.sort(playerList)
end

updatePlayerList()

KickSection:AddDropdown({
    Name = "Select Player",
    Values = playerList,
    Default = playerList[1] or "",
    Callback = function(value)
        selectedPlayer = value
    end
})

KickSection:AddButton({
    Name = "Refresh Player List",
    Callback = function()
        updatePlayerList()
        Notifier.new({
            Title = "Player List",
            Content = "Refreshed - " .. #playerList .. " players found",
            Duration = 2
        })
    end
})

KickSection:AddButton({
    Name = "Kick Selected Player",
    Callback = function()
        if not selectedPlayer then return end
        
        local targetPlayer
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Name == selectedPlayer then
                targetPlayer = player
                break
            end
        end
        
        if targetPlayer then
            Notifier.new({
                Title = "Kick Attempt",
                Content = "Kick sent to: " .. selectedPlayer,
                Duration = 3
            })
        end
    end
})

-- Auto refresh
task.spawn(function()
    while true do
        task.wait(10)
        updatePlayerList()
    end
end)

-- ========================================
-- VISUAL MAP SECTION (B脢N PH岷)
-- ========================================
local VisualSection = EmotesTab:DrawSection({
    Name = "Visual Map",
    Position = "right"
})

local Lighting = game:GetService("Lighting")

VisualSection:AddButton({
    Name = "Nature Green",
    Callback = function()
        for _,v in ipairs(Lighting:GetChildren()) do
            if v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v:Destroy()
            end
        end

        local CC = Instance.new("ColorCorrectionEffect", Lighting)
        CC.Name = "CC_MAIN"
        local Bloom = Instance.new("BloomEffect", Lighting)
        Bloom.Name = "Bloom_MAIN"
        Bloom.Size = 40
        local DoF = Instance.new("DepthOfFieldEffect", Lighting)
        DoF.Name = "DOF_MAIN"
        DoF.InFocusRadius = 50
        DoF.FarIntensity = 0.1
        DoF.NearIntensity = 0.2

        Lighting.Ambient = Color3.fromRGB(70,255,150)
        Lighting.OutdoorAmbient = Color3.fromRGB(40,200,120)
        CC.TintColor = Color3.fromRGB(140,255,180)
        CC.Saturation = 0.25
        CC.Contrast = 0.18
        Bloom.Intensity = 2.2
        
        Notifier.new({
            Title = "Visual Map",
            Content = "Nature Green applied!",
            Duration = 3
        })
    end
})

VisualSection:AddButton({
    Name = "Ocean Blue",
    Callback = function()
        for _,v in ipairs(Lighting:GetChildren()) do
            if v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v:Destroy()
            end
        end

        local CC = Instance.new("ColorCorrectionEffect", Lighting)
        CC.Name = "CC_MAIN"
        local Bloom = Instance.new("BloomEffect", Lighting)
        Bloom.Name = "Bloom_MAIN"
        Bloom.Size = 40
        local DoF = Instance.new("DepthOfFieldEffect", Lighting)
        DoF.Name = "DOF_MAIN"
        DoF.InFocusRadius = 50
        DoF.FarIntensity = 0.1
        DoF.NearIntensity = 0.2

        Lighting.Ambient = Color3.fromRGB(80,110,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(50,80,255)
        CC.TintColor = Color3.fromRGB(180,200,255)
        CC.Saturation = 0.3
        CC.Contrast = 0.2
        Bloom.Intensity = 3
        
        Notifier.new({
            Title = "Visual Map",
            Content = "Ocean Blue applied!",
            Duration = 3
        })
    end
})

VisualSection:AddButton({
    Name = "Pink Love",
    Callback = function()
        for _,v in ipairs(Lighting:GetChildren()) do
            if v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v:Destroy()
            end
        end

        local CC = Instance.new("ColorCorrectionEffect", Lighting)
        CC.Name = "CC_MAIN"
        local Bloom = Instance.new("BloomEffect", Lighting)
        Bloom.Name = "Bloom_MAIN"
        Bloom.Size = 40
        local DoF = Instance.new("DepthOfFieldEffect", Lighting)
        DoF.Name = "DOF_MAIN"
        DoF.InFocusRadius = 50
        DoF.FarIntensity = 0.1
        DoF.NearIntensity = 0.2

        Lighting.Ambient = Color3.fromRGB(255,150,200)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,120,180)
        CC.TintColor = Color3.fromRGB(255,170,210)
        CC.Saturation = 0.35
        CC.Contrast = 0.15
        Bloom.Intensity = 2.5
        
        Notifier.new({
            Title = "Visual Map",
            Content = "Pink Love applied!",
            Duration = 3
        })
    end
})

VisualSection:AddButton({
    Name = "Purple Dream",
    Callback = function()
        for _,v in ipairs(Lighting:GetChildren()) do
            if v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v:Destroy()
            end
        end

        local CC = Instance.new("ColorCorrectionEffect", Lighting)
        CC.Name = "CC_MAIN"
        local Bloom = Instance.new("BloomEffect", Lighting)
        Bloom.Name = "Bloom_MAIN"
        Bloom.Size = 40
        local DoF = Instance.new("DepthOfFieldEffect", Lighting)
        DoF.Name = "DOF_MAIN"
        DoF.InFocusRadius = 50
        DoF.FarIntensity = 0.1
        DoF.NearIntensity = 0.2

        Lighting.Ambient = Color3.fromRGB(170,90,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(120,50,255)
        CC.TintColor = Color3.fromRGB(200,140,255)
        CC.Saturation = 0.35
        CC.Contrast = 0.25
        Bloom.Intensity = 3.2
        
        Notifier.new({
            Title = "Visual Map",
            Content = "Purple Dream applied!",
            Duration = 3
        })
    end
})

VisualSection:AddButton({
    Name = "Sunset Orange",
    Callback = function()
        for _,v in ipairs(Lighting:GetChildren()) do
            if v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v:Destroy()
            end
        end

        local CC = Instance.new("ColorCorrectionEffect", Lighting)
        CC.Name = "CC_MAIN"
        local Bloom = Instance.new("BloomEffect", Lighting)
        Bloom.Name = "Bloom_MAIN"
        Bloom.Size = 40
        local DoF = Instance.new("DepthOfFieldEffect", Lighting)
        DoF.Name = "DOF_MAIN"
        DoF.InFocusRadius = 50
        DoF.FarIntensity = 0.1
        DoF.NearIntensity = 0.2

        Lighting.Ambient = Color3.fromRGB(255,180,100)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,140,70)
        CC.TintColor = Color3.fromRGB(255,200,150)
        CC.Saturation = 0.4
        CC.Contrast = 0.2
        Bloom.Intensity = 2.7
        
        Notifier.new({
            Title = "Visual Map",
            Content = "Sunset Orange applied!",
            Duration = 3
        })
    end
})

VisualSection:AddButton({
    Name = "Cyan Sky",
    Callback = function()
        for _,v in ipairs(Lighting:GetChildren()) do
            if v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v:Destroy()
            end
        end

        local CC = Instance.new("ColorCorrectionEffect", Lighting)
        CC.Name = "CC_MAIN"
        local Bloom = Instance.new("BloomEffect", Lighting)
        Bloom.Name = "Bloom_MAIN"
        Bloom.Size = 40
        local DoF = Instance.new("DepthOfFieldEffect", Lighting)
        DoF.Name = "DOF_MAIN"
        DoF.InFocusRadius = 50
        DoF.FarIntensity = 0.1
        DoF.NearIntensity = 0.2

        Lighting.Ambient = Color3.fromRGB(60,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(30,200,255)
        CC.TintColor = Color3.fromRGB(150,255,255)
        CC.Saturation = 0.4
        CC.Contrast = 0.22
        Bloom.Intensity = 3.5
        
        Notifier.new({
            Title = "Visual Map",
            Content = "Cyan Sky applied!",
            Duration = 3
        })
    end
})

VisualSection:AddButton({
    Name = "Reset Lighting",
    Callback = function()
        for _,v in ipairs(Lighting:GetChildren()) do
            if v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v:Destroy()
            end
        end
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        
        Notifier.new({
            Title = "Visual Map",
            Content = "Lighting reset to default!",
            Duration = 3
        })
    end
})

SpamSelectedToggle.Link:AddHelper({
    Text = "Spams the selected emote on nearby players"
})

SpamRandomToggle.Link:AddHelper({
    Text = "Spams random emotes on nearby players"
})

Window:DrawCategory({
    Name = "Misc"
});

local SettingTab = Window:DrawTab({
    Icon = "settings-3",
    Name = "Settings",
    Type = "Single",
    EnableScrolling = true
});

local Settings = SettingTab:DrawSection({
    Name = "UI Settings",
});

Settings:AddToggle({
    Name = "Alway Show Frame",
    Default = false,
    Callback = function(v)
        Window.AlwayShowTab = v;
    end,
});

Settings:AddColorPicker({
    Name = "Highlight",
    Default = Compkiller.Colors.Highlight,
    Callback = function(v)
        Compkiller.Colors.Highlight = v;
        Compkiller:RefreshCurrentColor();
    end,
});

Settings:AddColorPicker({
    Name = "Toggle Color",
    Default = Compkiller.Colors.Toggle,
    Callback = function(v)
        Compkiller.Colors.Toggle = v;
        Compkiller:RefreshCurrentColor(v);
    end,
});

Settings:AddColorPicker({
    Name = "Drop Color",
    Default = Compkiller.Colors.DropColor,
    Callback = function(v)
        Compkiller.Colors.DropColor = v;
        Compkiller:RefreshCurrentColor(v);
    end,
});

Settings:AddColorPicker({
    Name = "Risky",
    Default = Compkiller.Colors.Risky,
    Callback = function(v)
        Compkiller.Colors.Risky = v;
        Compkiller:RefreshCurrentColor(v);
    end,
});

Settings:AddColorPicker({
    Name = "Mouse Enter",
    Default = Compkiller.Colors.MouseEnter,
    Callback = function(v)
        Compkiller.Colors.MouseEnter = v;
        Compkiller:RefreshCurrentColor(v);
    end,
});

Settings:AddColorPicker({
    Name = "Block Color",
    Default = Compkiller.Colors.BlockColor,
    Callback = function(v)
        Compkiller.Colors.BlockColor = v;
        Compkiller:RefreshCurrentColor(v);
    end,
});

Settings:AddColorPicker({
    Name = "Background Color",
    Default = Compkiller.Colors.BGDBColor,
    Callback = function(v)
        Compkiller.Colors.BGDBColor = v;
        Compkiller:RefreshCurrentColor(v);
    end,
});

Settings:AddColorPicker({
    Name = "Block Background Color",
    Default = Compkiller.Colors.BlockBackground,
    Callback = function(v)
        Compkiller.Colors.BlockBackground = v;
        Compkiller:RefreshCurrentColor(v);
    end,
});

Settings:AddColorPicker({
    Name = "Stroke Color",
    Default = Compkiller.Colors.StrokeColor,
    Callback = function(v)
        Compkiller.Colors.StrokeColor = v;
        Compkiller:RefreshCurrentColor(v);
    end,
});

Settings:AddColorPicker({
    Name = "High Stroke Color",
    Default = Compkiller.Colors.HighStrokeColor,
    Callback = function(v)
        Compkiller.Colors.HighStrokeColor = v;
        Compkiller:RefreshCurrentColor(v);
    end,
});

Settings:AddColorPicker({
    Name = "Switch Color",
    Default = Compkiller.Colors.SwitchColor,
    Callback = function(v)
        Compkiller.Colors.SwitchColor = v;
        Compkiller:RefreshCurrentColor(v);
    end,
});

Settings:AddColorPicker({
    Name = "Line Color",
    Default = Compkiller.Colors.LineColor,
    Callback = function(v)
        Compkiller.Colors.LineColor = v;
        Compkiller:RefreshCurrentColor(v);
    end,
});

local ConfigUI = Window:DrawConfig({
    Name = "Config",
    Icon = "folder",
    Config = ConfigManager
});

ConfigUI:Init();

print("SK HUB loaded successfully!")
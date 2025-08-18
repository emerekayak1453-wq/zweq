repeat wait() until game.Loaded and game:GetService'Players'.LocalPlayer
local Version = '1.82'
local plrs = game:GetService'Players'
local plr = plrs.LocalPlayer
local vec0 = Vector3.new()
local prop1000 = PhysicalProperties.new(1000,1000,0,1000,0)
local cf0 = CFrame.new()

local Settings = {
    ['Autofarm'] = false,
    ['AutoPunch'] = false,
    ['SuperPunch'] = false,
    ['Virus'] = false,
    ['AntiAnvil'] = false,
    ['FakeAccs'] = false,
    ['AntiSpinner'] = false,
    ['AntiPunch'] = false,
    ['AntiFling'] = false,
    ['AntiVelocity'] = false,
    ['LessPing'] = false
}

local mouse = plr:GetMouse()
local rs = game:GetService'RunService'
local pinga
local points
local vim = game:GetService'VirtualInputManager'
local LoopFlingV1 = {}
local LoopFlingV2 = {}
local ts = game:GetService'TweenService'
local duping = false

local function findplr(Target)
    if game:GetService'Players':FindFirstChild(Target) then
        return game:GetService'Players':FindFirstChild(Target)
    else
        if Target ~= nil and Target ~= "" and Target ~= " " and Target then
            local name = Target
            local found = false
            for _,v in pairs(game:GetService'Players':GetPlayers()) do 
                if not found and (v.Name:lower():sub(1,#name) == name:lower() or v.DisplayName:lower():sub(1,#name) == name:lower()) then
                    name = v
                    found = true
                end
            end
            if name ~= nil and name ~= Target then
                return name
            end
        end
    end
end
pcall(function()
    if game:GetService('CoreGui'):FindFirstChild('PingGui') then
        ping = game:GetService('CoreGui').PingGui.p
    else
        local pinggui = Instance.new('ScreenGui',game:GetService('CoreGui'))
        pinggui.Name = 'PingGui'
        pinggui.ResetOnSpawn = false
        ping = Instance.new('TextLabel',pinggui)
        ping.Name = 'p'
        ping.Text = 'Loading...'
        ping.Size = UDim2.new(0,150,0,25)
        ping.Position = UDim2.new(0,0,0.85,0)
        Instance.new('UICorner',ping)
        ping.BackgroundColor3 = Color3.fromRGB(0,255,0)
        ping.BackgroundTransparency = 0.7
        ping.TextScaled = true
        ping.Visible = false
    end
end)
pcall(function()
    if game:GetService('CoreGui'):FindFirstChild('PointsGui') then
        ping = game:GetService('CoreGui').PointsGui.p
    else
        local pointsgui = Instance.new('ScreenGui',game:GetService('CoreGui'))
        pointsgui.Name = 'PointsGui'
        pointsgui.ResetOnSpawn = false
        points = Instance.new('TextLabel',pointsgui)
        points.Name = 'p'
        points.Text = 'Loading...'
        points.Size = UDim2.new(0,150,0,25)
        points.Position = UDim2.new(0,0,0.85,50)
        Instance.new('UICorner',points)
        points.BackgroundColor3 = Color3.fromRGB(0,255,0)
        points.BackgroundTransparency = 0.7
        points.TextScaled = true
        points.Visible = false
    end
end)
spawn(function()
    while true do wait()
        pcall(function()
            local pingv = string.split(string.split(game.Stats.Network.ServerStatsItem['Data Ping']:GetValueString(), ' ')[1], '.')
            ping.Text = 'Ping: '..pingv[1]
        end)
        pcall(function()
            points.Text = 'Points: '..plr.leaderstats['Bully Points'].Value
        end)
    end
end)
local punched = false
local punch_anim = Instance.new('Animation')
punch_anim.Name = 'FakePunch'
punch_anim.AnimationId = 'rbxassetid://5193683418'
mouse.KeyDown:Connect(function(key)
    if key == 'v' then
        pcall(function()
            if plr.Character.Picked.Value then
                plr.Character.PuttingDown:FireServer()
            end
            plr.Character.Picking:FireServer(mouse.Target,Vector3.new(math.huge,-math.huge,math.huge))
            wait(0.1)
            plr.Character.PuttingDown:FireServer()
        end)
    elseif key == 'b' then
        pcall(function()
            if mouse.Target:FindFirstAncestorOfClass('Model') and mouse.Target:FindFirstAncestorOfClass('Model'):FindFirstChild('ArmAngleChange') then
                mouse.Target:FindFirstAncestorOfClass('Model').ArmAngleChange:FireServer(CFrame.new(math.huge,math.huge,math.huge))
           end
        end)
    elseif key == 'q' then
        pcall(function()
            if not plr.Character.Picked.Value then
                plr.Character.Picking:FireServer(mouse.Target,mouse.Hit.p)
            else
                plr.Character.PuttingDown:FireServer()
            end
        end)
    elseif key == ' ' then
        pcall(function()
            plr.Character:FindFirstChildOfClass('Humanoid').Jump = true
        end)
    elseif key == 'e' and Settings['SuperPunch'] then
        punched = true
        pcall(function()
            plr.Character.Humanoid:LoadAnimation(punch_anim):Play()
        end)
        wait(0.3)
        punched = false
    end
end)

local connections_AutoPunch = {}
local connections_SuperPunch = {}
local connections_V = {}

function connect_AP()
    table.insert(connections_AutoPunch,plr.Character.HumanoidRootPart.Touched:Connect(function(hit)
        if plr.Character:FindFirstChild('Punch') and hit.Parent:FindFirstChildOfClass('Humanoid') and hit.Parent~=plr.Character then
            local char = hit.Parent
            pcall(function()
                plr.Character.Punch:Activate()
                firetouchinterest(plr.Character.RightHand,char.Head,0)
                firetouchinterest(plr.Character.RightHand,char.Head,1)
            end)
        end
    end))
end
function connect_SP()
    table.insert(connections_SuperPunch,plr.Character.RightHand.Touched:Connect(function(hit)
        pcall(function()
            if punched and hit.Parent:FindFirstChildOfClass('Humanoid') then
                local char = hit.Parent
                plr.Character.PuttingDown:FireServer()
                plr.Character.Picking:FireServer(char.HumanoidRootPart,Vector3.new(math.huge,math.huge,math.huge))
                char.ArmAngleChange:FireServer(CFrame.new(9e38,-9e38,9e38))
                wait(0.1)
                plr.Character.PuttingDown:FireServer()
            elseif punched and hit:IsA('BasePart') and not hit.Anchored and not hit:IsDescendantOf(plr.Character) then
                plr.Character.PuttingDown:FireServer()
                plr.Character.Picking:FireServer(hit,Vector3.new(math.huge,math.huge,math.huge))
                wait(0.1)
                plr.Character.PuttingDown:FireServer()
            end
        end)
    end))
end
function infect(v)
    table.insert(connections_V,v.Touched:Connect(function(hit)
        pcall(function()
            if hit.Parent:FindFirstChildOfClass('Humanoid') then
                local infected = hit.Parent
                plr.Character.PuttingDown:FireServer()
                plr.Character.Picking:FireServer(infected.HumanoidRootPart,Vector3.new(math.huge,math.huge,math.huge))
                infected.ArmAngleChange:FireServer(CFrame.new(9e38,-9e38,9e38))
                wait(0.1)
                plr.Character.PuttingDown:FireServer()
            end
        end)
    end))
end
plr.CharacterAdded:Connect(function()
    if Settings['AutoPunch'] then
        pcall(function()
            for _,v in next,connections_AutoPunch do
                if typeof(v) == 'RBXScriptConnection' then
                    v:Disconnect()
                end
            end
        end)
        repeat wait() until plr.Character:FindFirstChild('HumanoidRootPart')
        connect_AP()
    end
    if Settings['SuperPunch'] then
        pcall(function()
            for _,v in next,connections_SuperPunch do
                if typeof(v) == 'RBXScriptConnection' then
                    v:Disconnect()
                end
            end
        end)
        repeat wait() until plr.Character:FindFirstChild('RightHand')
        connect_SP()
    end
    if Settings['Virus'] then
        pcall(function()
            for _,v in next,connections_V do
                if typeof(v) == 'RBXScriptConnection' then
                    v:Disconnect()
                end
            end
        end)
        spawn(function()
            pcall(function()
                repeat wait() until plr.Character:FindFirstChild('HumanoidRootPart') and plr.Character:FindFirstChildOfClass('Humanoid')
                for _,v in next,plr.Character:GetChildren() do
                    if v:IsA('BasePart') then
                        infect(v)
                    end
                end
            end)
        end) 
    end
end)
local function respawn()
    pcall(function()
        local b = plr.PlayerGui.DeathMenu.Frame.Button.TextButton
        b.Position = UDim2.new(0,0,0,0)
        b.Size = UDim2.new(1,0,1,0)
        b.Text = ''
        b.BackgroundTransparency = 1
        b.ZIndex = (2^31-1)
        local s = Instance.new('ScreenGui',game:GetService('CoreGui'))
        b.Parent = s
        vim:SendMouseButtonEvent(b.AbsolutePosition.X+b.AbsoluteSize.X/2,b.AbsolutePosition.Y+b.AbsoluteSize.Y/2,0,true,game,0)
        vim:SendMouseButtonEvent(b.AbsolutePosition.X+b.AbsoluteSize.X/2,b.AbsolutePosition.Y+b.AbsoluteSize.Y/2,0,false,game,0)
        spawn(function()
            wait()
            s:Destroy()
        end)
    end)
end

local GUI = Instance.new('ScreenGui',game:GetService('CoreGui'))
local function Notify(title,text,duration)
    local text1 = Instance.new('TextLabel',game:GetService'CoreGui')
    text1.Size = UDim2.new(1,0,0,20)
    text1.Position = UDim2.new(0,0,1,22)
    text1.Text = text
    text1.BackgroundTransparency = 0.3
    if duration and typeof(duration)=='number' then
        spawn(function()
            wait(duration)
            text1:Destroy()
        end)
    end
end
local HoverTip = Instance.new('TextLabel',GUI)
local Frame = Instance.new('Frame',GUI)
local Open = Instance.new('TextButton',GUI)
local Refresh = Instance.new('TextButton',GUI)
local Respawn = Instance.new('TextButton',GUI)
Instance.new('UICorner',Open).CornerRadius = UDim.new(0, 5)
local Holder = Instance.new('Frame')
GUI.Name = 'GUI'
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.ResetOnSpawn = false
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.500
Frame.Position = UDim2.new(0, -200, 0.332, 0)
Frame.Size = UDim2.new(0, 90, 0, 208)
Frame.Visible = false
Open.Name = "Open"
Open.BackgroundColor3 = Color3.fromRGB(79, 79, 79)
Open.BackgroundTransparency = 0.300
Open.Position = UDim2.new(0, 0, 0.599787831, 0)
Open.Size = UDim2.new(0, 47, 0, 25)
Open.Font = Enum.Font.SourceSansBold
Open.Text = "Open"
Open.TextColor3 = Color3.fromRGB(0, 0, 0)
Open.TextScaled = true
Open.TextSize = 14.000
Open.TextWrapped = true
Holder.Name = "Holder"
Holder.Parent = GUI
Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Holder.BackgroundTransparency = 1.000
Holder.Position = UDim2.new(0, 180, 0.332, 0)
Holder.Size = UDim2.new(0, 379, 0, 208)
Refresh.Name = "Refresh"
Refresh.AnchorPoint = Vector2.new(1,0)
Refresh.BackgroundColor3 = Color3.fromRGB(163, 163, 163)
Refresh.Position = UDim2.new(1, 0, 0.332121223, 0)
Refresh.Size = UDim2.new(0, 100, 0, 22)
Refresh.Font = Enum.Font.SourceSans
Refresh.Text = "Refresh"
Refresh.TextColor3 = Color3.fromRGB(189, 0, 0)
Refresh.TextScaled = true
Refresh.TextSize = 14.000
Refresh.TextWrapped = true
Respawn.Name = "Respawn"
Respawn.AnchorPoint = Vector2.new(1,0)
Respawn.BackgroundColor3 = Color3.fromRGB(163, 163, 163)
Respawn.Position = UDim2.new(1, 0, 0, Refresh.AbsolutePosition.Y+28)
Respawn.Size = UDim2.new(0, 100, 0, 22)
Respawn.Font = Enum.Font.SourceSans
Respawn.Text = "Respawn"
Respawn.TextColor3 = Color3.fromRGB(189, 0, 0)
Respawn.TextScaled = true
Respawn.TextSize = 14.000
Respawn.TextWrapped = true
HoverTip.Name = 'Hover'
HoverTip.Size = UDim2.new(0,100,0,20)
HoverTip.Position = UDim2.new(0,0,0,0)
HoverTip.Visible = false
HoverTip.Text = ''
HoverTip.ZIndex = 10
HoverTip.BackgroundColor3 = Color3.fromRGB(140,140,140)
local cdFrame = false
Open.MouseButton1Down:Connect(function()
    for _,v in next,Holder:GetChildren() do
        if v:IsA'Frame' then
            v.Visible = false
        end
    end
    if Frame.Visible == true and not cdFrame then
        Open.Text = 'Open'
        cdFrame = true
        Frame.Position = UDim2.new(0, 0, 0.332, 0)
        HoverTip.Visible = false
        Frame:TweenPosition(UDim2.new(0,-100,0.332,0),Enum.EasingDirection.In,Enum.EasingStyle.Linear,0.25,true)
        spawn(function()
            wait(0.25)
            cdFrame = false
            Frame.Visible = false
        end)
    elseif Frame.Visible == false and not cdFrame then
        Open.Text = 'Close'
        cdFrame = true
        Frame.Visible = true
        Frame.Position = UDim2.new(0, -100, 0.332, 0)
        Frame:TweenPosition(UDim2.new(0,0,0.332,0),Enum.EasingDirection.In,Enum.EasingStyle.Linear,0.25,true)
        spawn(function()
            wait(0.25)
            cdFrame = false
        end)
    end
end)
Refresh.MouseButton1Up:Connect(function()
    pcall(function()
        oldpos = plr.Character.HumanoidRootPart.CFrame
        camcf = workspace.CurrentCamera.CFrame
        respawn()
        plr.CharacterAdded:wait()
        repeat rs.RenderStepped:wait() until plr.Character:FindFirstChild'HumanoidRootPart' and plr.Character:FindFirstChildOfClass'Humanoid'
        for i = 1,10 do
            ts:Create(plr.Character.HumanoidRootPart,TweenInfo.new(0),{CFrame=oldpos}):Play()
        end
        workspace.CurrentCamera.CFrame = camcf
    end)
end)
Respawn.MouseButton1Up:Connect(function()
    respawn()
end)
local lpp = 0
local function addPage(name)
    local Page = Instance.new('TextButton',Frame)
    Page.Name = name
    Page.BackgroundColor3 = Color3.fromRGB(163, 163, 163)
    Page.Position = UDim2.new(0,0,0,lpp)
    Page.Size = UDim2.new(1, 0, 0, 22)
    Page.Font = Enum.Font.SourceSansSemibold
    Page.Text = name
    Page.TextColor3 = Color3.fromRGB(0, 0, 0)
    Page.TextScaled = true
    Page.TextSize = 14.000
    Page.TextWrapped = true
    lpp = lpp+28
    local PageFrame = Instance.new('Frame',Holder)
    PageFrame.Name = name
    PageFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    PageFrame.BackgroundTransparency = 0.5
    PageFrame.Size = UDim2.new(0, 409, 0, 208)
    PageFrame.Visible = false
    Page.MouseButton1Down:Connect(function()
        for _,v in next,Holder:GetChildren() do
            v.Visible = false
        end
        PageFrame.Visible = true
    end)
    return PageFrame
end
local table = {}
local function addButton(name,frame,tip)
    if not table[frame] then
        table[frame] = {posX=6,posY=6}
    elseif table[frame] then
        table[frame].posX=table[frame].posX+96
        if table[frame].posX>360 then
            table[frame].posX = 6
            table[frame].posY=table[frame].posY+28
        end
    end
    local Button = Instance.new('TextButton',frame)
    Button.Name = name
    Button.BackgroundColor3 = Color3.fromRGB(163, 163, 163)
    Button.Position = UDim2.new(0, table[frame].posX, 0, table[frame].posY)
    Button.Size = UDim2.new(0, 90, 0, 22)
    Button.Font = Enum.Font.SourceSansSemibold
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(0, 0, 0)
    Button.TextScaled = true
    Button.TextSize = 14.000
    Button.TextWrapped = true
    Button.MouseEnter:Connect(function()
        HoverTip.Visible = true
        HoverTip.Position = UDim2.new(0,mouse.X+20,0,mouse.Y+20)
        HoverTip.Text = tip
        HoverTip.Size = UDim2.new(0,#tip*8,0,22)
    end)
    Button.MouseLeave:Connect(function()
        HoverTip.Visible = false
        HoverTip.Text = ''
    end)
    return Button
end
local function addBox(name,frame,tip)
    if not table[frame] then
        table[frame] = {posX=6,posY=6}
    elseif table[frame] then
        table[frame].posX=table[frame].posX+96
        if table[frame].posX>360 then
            table[frame].posX = 6
            table[frame].posY=table[frame].posY+28
        end
    end
    local Box = Instance.new('TextBox',frame)
    Box.Name = name
    Box.BackgroundColor3 = Color3.fromRGB(163, 163, 163)
    Box.BackgroundTransparency = 0.500
    Box.Position = UDim2.new(0, table[frame].posX, 0, table[frame].posY)
    Box.Size = UDim2.new(0, 90, 0, 22)
    Box.Font = Enum.Font.SourceSans
    Box.Text = name
    Box.TextColor3 = Color3.fromRGB(0, 0, 0)
    Box.TextSize = 14.000
    Box.MouseEnter:Connect(function()
        HoverTip.Visible = true
        HoverTip.Position = UDim2.new(0,mouse.X+20,0,mouse.Y+20)
        HoverTip.Text = tip
        HoverTip.Size = UDim2.new(0,#tip*8,0,22)
    end)
    Box.MouseLeave:Connect(function()
        HoverTip.Visible = false
        HoverTip.Text = ''
    end)
    return Box
end
local Main = addPage('Main')
local Global = addPage('Global')
local Misc = addPage('Misc')
local UI = addPage('UI')
local Info = addPage('Info')
local credits = Instance.new('TextLabel',Info)
local version = Instance.new('TextLabel',Info)
credits.Position = UDim2.new(0,6,0,6)
credits.Size = UDim2.new(1,-12,0,22)
credits.Text = 'Made by KAKOYTO_LOXX and JusttChrxs'
version.Position = UDim2.new(0,6,0,34)
version.Size = UDim2.new(1,-12,0,22)
version.Text = 'Version: '..Version

local b = addButton('AntiFling: Off',Main,'Prevents your character from being flung')
b.MouseButton1Down:Connect(function()
    Settings['AntiFling'] = not Settings['AntiFling']
    if Settings['AntiFling'] == true then
        b.Text = 'AntiFling: On'
        for _,v in next,plr.Character:GetChildren() do
            if v.Name == 'Stabler' or v.Name == 'VelocityDamage' or v.Name == 'GetPicked' or v.Name == 'ArmAngleUpdate' or v.Name == 'ArmAngle' then
                v:Destroy()
            end
        end
    else
        b.Text = 'AntiFling: Off'
    end
end)
local b0 = addButton('AntiVelocity: Off',Main,'Resets velocity')
b0.MouseButton1Down:Connect(function()
    Settings['AntiVelocity'] = not Settings['AntiVelocity']
    if Settings['AntiVelocity'] == true then
        b0.Text = 'AntiVelocity: On'
    else
        b0.Text = 'AntiVelocity: Off'
    end
end)
local b1 = addButton('AntiAnvil: Off',Main,'Flings anvils')
b1.MouseButton1Down:Connect(function()
    Settings['AntiAnvil'] = not Settings['AntiAnvil']
    if Settings['AntiAnvil'] == true then
        b1.Text = 'AntiAnvil: On'
    else
        b1.Text = 'AntiAnvil: Off'
    end
end)
local b2 = addButton('AntiPunch: Off',Main,'Prevents from getting punched')
b2.MouseButton1Down:Connect(function()
    Settings['AntiPunch'] = not Settings['AntiPunch']
    if Settings['AntiPunch'] == true then
        b2.Text = 'AntiPunch: On'
        pcall(function()
            plr.Character.Ragdoll:Destroy()
        end)
    else
        b2.Text = 'AntiPunch: Off'
    end
end)
local b3 = addButton('AntiSpinner: Off',Main,'Prevents from getting flung by spinners')
b3.MouseButton1Down:Connect(function()
    Settings['AntiSpinner'] = not Settings['AntiSpinner']
    if Settings['AntiSpinner'] == true then
        b3.Text = 'AntiSpinner: On'
        pcall(function()
            for _,v in next,plr.Character:GetChildren() do
                if v:IsA'BasePart' then
                    v.CustomPhysicalProperties = prop1000
                end
            end
        end)
    else
        b3.Text = 'AntiSpinner: Off'
        pcall(function()
            for _,v in next,plr.Character:GetDescendants() do
                pcall(function()
                    if v:IsA'BasePart' then
                        v.CustomPhysicalProperties = PhysicalProperties.new(0.3,0.2,0,0.2,0.2)
                    end
                end)
            end
        end)
    end
end)
addButton('Godmode',Main,'Gives you infinite hp (makes bald)').MouseButton1Down:Connect(function()
    pcall(function()
        for _,v in next,plr.Character:GetChildren() do
            if v.Name == 'VelocityDamage' or v.Name == 'GetPicked' or v.Name == 'ArmAngleUpdate' then
                v:Destroy()
            end
        end
    end)
    pcall(function()
        local hum = plr.Character.Humanoid
        local cl = hum:Clone()
        cl.Parent = plr.Character
        hum.Parent = nil
        cl:GetPropertyChangedSignal('Health'):Connect(function()
            if cl.Health<=0 then
                hum.Parent = plr.Character
                wait(1)
                hum:Destroy()
            end
        end)
        workspace.CurrentCamera.CameraSubject = plr.Character
    end)
end)
addButton('AntiBring',Main,'Prevents from getting brought').MouseButton1Down:Connect(function()
    pcall(function()
        plr.Character.RightHand:Destroy()
    end)
end)
local b4 = addButton('FakeAccs: Off',Main,'Prevents from getting flung')
b4.MouseButton1Down:Connect(function()
    Settings['FakeAccs'] = not Settings['FakeAccs']
    if Settings['FakeAccs'] == true then
        b4.Text = 'FakeAccs: On'
        for _,v in next,plr.Character:GetChildren() do
            if v:IsA'Accessory' and v:FindFirstChild'Handle' and v.Name ~= 'FakeAcc' then
                local clone = v:Clone()
                v:Destroy()
                clone.Name = 'FakeAcc'
                clone.Parent = plr.Character
            end
        end
    else
        b4.Text = 'FakeAccs: Off'
    end
end)
local f1_box = addBox('Fling Player',Main,'Fling Player')
f1_box.FocusLost:Connect(function()
    pcall(function()
        local tar = findplr(f1_box.Text)
        local accs = tar.Character:FindFirstChildOfClass'Accessory'
        if accs then
            if accs:FindFirstChild'Handle' then
                plr.Character.Picking:FireServer(accs.Handle,Vector3.new(8.99999981e+37, -8.99999981e+37, 8.99999981e+37, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                wait(0.1)
                plr.Character.PuttingDown:FireServer()
            elseif accs:IsA'BasePart' then
                plr.Character.Picking:FireServer(accs,Vector3.new(8.99999981e+37, -8.99999981e+37, 8.99999981e+37, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                wait(0.1)
                plr.Character.PuttingDown:FireServer()
            end
            wait(0.1)
            plr.Character.PuttingDown:FireServer()
        else
            plr.Character.Picking:FireServer(tar.Character.HumanoidRootPart,Vector3.new(9e37,-9e37,9e37))
            wait(0.1)
            plr.Character.PuttingDown:FireServer()
        end
    end)
    f1_box.Text = 'Fling Player'
end)
local lf1_box = addBox('Loop Fling',Main,'Loop fling player')
lf1_box.FocusLost:Connect(function()
    local tar = findplr(lf1_box.Text)
    if tar and not LoopFlingV1[tar.Name] then
        LoopFlingV1[tar.Name] = tar
    end
    lf1_box.Text = 'Loop Fling'
end)
local f2_box = addBox('Fling v2',Main,'Fling player')
f2_box.FocusLost:Connect(function()
    pcall(function()
        findplr(f2_box.Text).Character.ArmAngleChange:FireServer(CFrame.new(math.huge,math.huge,math.huge))
    end)
    f2_box.Text = 'Fling v2'
end)
local lf2_box = addBox('Loop Fling v2',Main,'Loop fling player')
lf2_box.FocusLost:Connect(function()
    local tar = findplr(lf2_box.Text)
    if tar and not LoopFlingV2[tar.Name] then
        LoopFlingV2[tar.Name] = tar
    end
    lf2_box.Text = 'Loop Fling v2'
end)
addButton('Clear LoopFling',Main,'Stop loop fling').MouseButton1Down:Connect(function()
    LoopFlingV1 = {}
    LoopFlingV2 = {}
end)
local b5 = addButton('AutoPunch: Off',Main,'Equip punch tool and touch player to punch')
b5.MouseButton1Down:Connect(function()
    pcall(function()
        Settings['AutoPunch'] = not Settings['AutoPunch']
        if Settings['AutoPunch'] == true then
            b5.Text = 'AutoPunch: On'
            connect_AP()
        else
            b5.Text = 'AutoPunch: Off'
            pcall(function()
                for _,v in next,connections_AutoPunch do
                    if typeof(v) == 'RBXScriptConnection' then
                        v:Disconnect()
                    end
                end
            end)
        end
    end)
end)
local b6 = addButton('SuperPunch: Off',Main,'Press e to punch')
b6.MouseButton1Down:Connect(function()
    pcall(function()
        Settings['SuperPunch'] = not Settings['SuperPunch']
        if Settings['SuperPunch'] == true then
            b6.Text = 'SuperPunch: On'
            connect_SP()
        else
            b6.Text = 'SuperPunch: Off'
            pcall(function()
                for _,v in next,connections_SuperPunch do
                    if typeof(v) == 'RBXScriptConnection' then
                        v:Disconnect()
                    end
                end
            end)
        end
    end)
end)
local b7 = addButton('Virus: Off',Main,'Touch player to fling')
b7.MouseButton1Down:Connect(function()
    pcall(function()
        Settings['Virus'] = not Settings['Virus']
        if Settings['Virus'] == true then
            b7.Text = 'Virus: On'
            for _,v in next,plr.Character:GetChildren() do
                if v:IsA'BasePart' then
                    infect(v)
                end
            end
        else
            b7.Text = 'Virus: Off'
            pcall(function()
                for _,v in next,connections_V do
                    if typeof(v) == 'RBXScriptConnection' then
                        v:Disconnect()
                    end
                end
            end)
        end
    end)
end)
addButton('Crash Server',Global,'Crash Server').MouseButton1Down:Connect(function()
    pcall(function()
        for _,v in next,workspace.Map:GetDescendants() do
            if v:IsA'SpawnLocation' then
                plr.Character.PuttingDown:FireServer()
                wait(0.1)
                plr.Character.Picking:FireServer(v,Vector3.new(9e37,-9e37,9e37))
            end
        end
    end)
end)

addButton('SafeZone',Misc,'Teleport to safe zone').MouseButton1Down:Connect(function()
    pcall(function()
        if not workspace:FindFirstChild'SafeZone' then
            local sp = Instance.new('Part',workspace)
            sp.Name = 'SafeZone'
            sp.Size = Vector3.new(500,3,500)
            sp.CFrame = CFrame.new(2000,workspace.FallenPartsDestroyHeight+2,2000)
            sp.Anchored = true
        end
        plr.Character.HumanoidRootPart.CFrame = CFrame.new(2000,workspace.FallenPartsDestroyHeight+10,2000)
    end)
end)
addButton('TPSpawn',Misc,'Teleport to spawn').MouseButton1Down:Connect(function()
    pcall(function()
        for _,v in next,workspace.Map:GetDescendants() do
            if v:IsA'SpawnLocation' then
                plr.Character.HumanoidRootPart.CFrame = v.CFrame*CFrame.new(0,5,0)
            end
        end
    end)
end)
local b8 = addButton('LessPing: Off',Misc,'Boost internet')
b8.MouseButton1Down:Connect(function()
    Settings['LessPing'] = not Settings['LessPing']
    if Settings['LessPing'] == true then
        b8.Text = 'LessPing: On'
        pcall(function()
            plr.Character.BodyFollowMouse.Disabled = true
            plr.Character.HeadWaist:FireServer(CFrame.new(0,0.8,0),CFrame.new(0,0.2,0))
        end)
    else
        b8.Text = 'LessPing: Off'
        pcall(function()
            plr.Character.BodyFollowMouse.Disabled = false
        end)
    end
end)
local fa_box = addBox('Fake Accessory Id',Misc,'Gives client sided accessory')
fa_box.FocusLost:Connect(function()
    pcall(function()
        local hat_id = tonumber(fa_box.Text)
        local hat = game:GetObjects('rbxassetid://'..hat_id)[1]
        plr.Character.Humanoid:AddAccessory(hat)
        local type = hat.Handle:FindFirstChildOfClass'Attachment'.Name
        local attachment = nil
        for _,v in next,plr.Character:GetDescendants() do
            if v.Name == type and v.Parent.Name ~= 'Handle' then
                attachment = v
            end
        end
        local weld = Instance.new('Weld',hat.Handle)
        weld.Name = 'AccessoryWeld'
        weld.Part0 = hat.Handle
        weld.Part1 = attachment.Parent
        weld.C1 = attachment.CFrame-hat.Handle:FindFirstChildOfClass'Attachment'.CFrame.p
    end)
    fa_box.Text = 'Fake Accessory Id'
end)
addButton('Legs Fling',Misc,'Removes your torso and makes you heavy').MouseButton1Down:Connect(function()
    pcall(function()
        for _,v in next,plr.Character:GetChildren() do
            if v:IsA'BasePart' and v.Name~='HumanoidRootPart' then
                v.Massless = true
            end
        end
        pcall(function()
            plr.Character.BodyFollowMouse.Disabled = true
        end)
        plr.Character.HeadWaist:FireServer(CFrame.new(0,9e37,-9e37),CFrame.new(0,-9e37,9e37))
    end)
end)
addButton('Big jacket',Misc,'Must have layered clothing (jacket, shirt or tshirt)').MouseButton1Down:Connect(function()
    pcall(function()
        local char = plr.Character
        for _,v in next,char:GetChildren() do
            if v:IsA'BasePart' and v.Name~='HumanoidRootPart' then
                v.Massless = true
            end
        end
        pcall(function()
            char.BodyFollowMouse.Disabled = true
        end)
        local old = Settings['AntiFling']
        Settings['AntiFling'] = false
        char.RagdollEvent:FireServer()
        wait()
        char.HeadWaist:FireServer(CFrame.new(0,0,9e37),CFrame.new(0,0,9e37))
        wait()
        char.HeadWaist:FireServer(CFrame.new(0,0,-9e37),CFrame.new(0,0,-9e37))
        wait()
        char.GetUpEvent:FireServer()
        Settings['AntiFling'] = old
        wait()
        char.HeadWaist:FireServer(CFrame.new(0,0.8,0),CFrame.new(0,0.2,0))
        char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame+Vector3.new(0,5,0)
    end)
end)
local dupe_box = addBox('Dupe to player',Misc,'Give duped tools to player (requires gamepass)')
dupe_box.FocusLost:Connect(function(enterpressed)
    if enterpressed then
        pcall(function()
            local target = findplr(dupe_box.Text)
            duping = target
            while target and duping==target and duping~=nil do 
                repeat wait() until plr.Character and plr.Character:FindFirstChildOfClass'Humanoid'
                wait(0.5)
                local hum = plr.Character.Humanoid
                local cl = hum:Clone()
                cl.Parent = plr.Character
                hum:Destroy()
                for _,v in next,plr.Backpack:GetChildren() do
                    if v:FindFirstChild'Handle' then
                        v.Parent = plr.Character
                        for i = 1,5 do
                            firetouchinterest(v.Handle,target.Character.HumanoidRootPart,0)
                            firetouchinterest(v.Handle,target.Character.HumanoidRootPart,1)
                        end
                    end
                end
                respawn()
                plr.CharacterAdded:wait()
            end
        end)
    end
    dupe_box.Text = 'Dupe to player'
end)
addButton('Stop duping',Misc,'Stop duping').MouseButton1Down:Connect(function()
    duping = false
end)
addButton('Spam bombs',Misc,'Spam bombs (requires duped bombs)').MouseButton1Down:Connect(function()
    for _,v in next,plr.Backpack:GetChildren() do
        if v.Name == 'Bomb' then
            v.Parent = plr.Character
            v:Activate()
            v.Parent = plr.Backpack
        end
    end
end)
addButton('Spam anvils',Misc,'Spam anvils (requires duped anvils)').MouseButton1Down:Connect(function()
    for _,v in next,plr.Backpack:GetChildren() do
        if v.Name == 'Anvil' then
            v.Parent = plr.Character
            v:Activate()
            v.Parent = plr.Backpack
        end
    end
end)
local af_button = addButton('Autofarm: Off',Misc,'Autofarm')
af_button.MouseButton1Down:Connect(function()
    Settings['Autofarm'] = not Settings['Autofarm']
    if Settings['Autofarm'] then
        af_button.Text = 'Autofarm: On'
        while Settings['Autofarm'] do
            pcall(function()
                local char = plr.Character
                repeat rs.RenderStepped:wait() until plr.PlayerGui.DeathMenu.Frame.Button:FindFirstChild'TextButton' and char:FindFirstChild'HumanoidRootPart' and (plr.Backpack:FindFirstChild'Punch' or char:FindFirstChild'Punch')
                local tool = plr.Backpack:FindFirstChild'Punch' or plr.Character:FindFirstChild'Punch'
                tool.Parent = plr.Character
                tool:Activate()
                plr.Character.RagdollEvent:FireServer()
                wait()
                firetouchinterest(char.RightHand,char.HumanoidRootPart,0)
                firetouchinterest(char.RightHand,char.HumanoidRootPart,1)
                respawn()
                spawn(function()
                    pcall(function()
                        wait(0.5)
                        if char then
                            repeat respawn() wait(0.5) until not char or not char.Parent
                        end
                    end)
                end)
                plr.CharacterAdded:wait()
            end)
        end
    else
        af_button.Text = 'Autofarm: Off'
    end
end)
local trap_box = addBox('Trap player',Misc,'Traps player untill you respawn')
trap_box.FocusLost:Connect(function()
    pcall(function()
        local target = findplr(trap_box.Text)
        if target and target.Character:FindFirstChild'GetPicked' and target.Character:FindFirstChild'HumanoidRootPart' then
            plr.Character.RightHand.Anchored = true
            plr.Character.HumanoidRootPart.Anchored = true
            plr.Character.Picking:FireServer(target.Character.HumanoidRootPart,target.Character.HumanoidRootPart.Position)
            plr.Character:WaitForChild('Stabler',5).Transparency = 0
            plr.Character.RightHand:Destroy()
            plr.Character.HumanoidRootPart.Anchored = false
        end
    end)
    trap_box.Text = 'Trap player'
end)
addButton('Show Ping',UI,'Show ping').MouseButton1Down:Connect(function()
    pcall(function()
        ping.Visible = not ping.Visible
    end)
end)
addButton('Show Points',UI,'Show bully points').MouseButton1Down:Connect(function()
    pcall(function()
        points.Visible = not points.Visible
    end)
end)
pcall(function()
    for _,v in next,workspace.Map:GetDescendants() do
        if v.Name == 'Donate' then 
            for _,x in next,v:GetDescendants() do
                if x:IsA'BasePart' then
                    x.Anchored = false
                end
            end
            break
        end
    end
end)
pcall(function()
    for _,v in next,workspace.Map:FindFirstChildOfClass'Model'.Noob:GetDescendants() do
        if v.Name == 'Sword' or v.Name == 'Drink' or v.Name == 'Handle' then
            v.Anchored = false
        end
    end
end)
spawn(function()
    while true do wait(0.1)
        spawn(function()
            pcall(function()
                if LoopFlingV1~={} then
                    for _,v in next,LoopFlingV1 do
                        pcall(function()
                            local accs = v.Character:FindFirstChildOfClass'Accessory'
                            if accs then
                                if accs:FindFirstChild'Handle' then
                                    plr.Character.Picking:FireServer(accs.Handle,Vector3.new(8.99999981e+37, -8.99999981e+37, 8.99999981e+37, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                                elseif accs:IsA'BasePart' then
                                    plr.Character.Picking:FireServer(accs,Vector3.new(8.99999981e+37, -8.99999981e+37, 8.99999981e+37, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                                end
                                wait(0.1)
                                plr.Character.PuttingDown:FireServer()
                            else
                                plr.Character.Picking:FireServer(v.Character.HumanoidRootPart,Vector3.new(8.99999981e+37, -8.99999981e+37, 8.99999981e+37, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                                wait(0.1)
                                plr.Character.PuttingDown:FireServer()
                            end
                        end)
                    end
                end
            end)
        end)
        spawn(function()
            pcall(function()
                if LoopFlingV2~={} then
                    for _,v in next,LoopFlingV2 do
                        pcall(function()
                            v.Character.ArmAngleChange:FireServer(CFrame.new(8.99999981e+37, -8.99999981e+37, 8.99999981e+37, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                        end)
                    end
                end
            end)
        end)
    end
end)
workspace.DescendantAdded:Connect(function(v)
    pcall(function()
        if Settings['AntiFling']  then
            if v.Name=='Stabler' and v.Parent~=plr.Character then
                v:Destroy()
            end
        end
        if Settings['AntiSpinner'] and v:IsA('Model') and plrs:GetPlayerFromCharacter(v) and v~=plr.Character then
            for _,x in next,v:GetChildren() do
                if x:IsA('BasePart') then
                    v.Massless = true
                end
            end
        end
        if v.Name == 'Donate' then 
            for _,x in next,v:GetDescendants() do
                if x:IsA'BasePart' then
                    x.Anchored = false
                end
            end
        end
        if v.Name == 'Sword' or v.Name == 'Drink' or v.Name == 'Handle' then
            v.Anchored = false
        end
    end)
end)
spawn(function()
    while true do rs.RenderStepped:wait()
        if Settings['AntiVelocity'] then
            pcall(function()
                plr.Character.RagdollDetect:Destroy()
            end)
            pcall(function()
                if plr.Character.HumanoidRootPart.Velocity.X>=30 or plr.Character.HumanoidRootPart.Velocity.X<=-30 or plr.Character.HumanoidRootPart.Velocity.Y>=100 or plr.Character.HumanoidRootPart.Velocity.Z>=30 or plr.Character.HumanoidRootPart.Velocity.Z<=-30 then
                    plr.Character.HumanoidRootPart.Velocity = vec0
                end
                if plr.Character.HumanoidRootPart.RotVelocity.magnitude>100 then
                    plr.Character.HumanoidRootPart.RotVelocity = vec0
                end
            end)
        end
        if Settings['AntiPunch'] then
            pcall(function()
                plr.Character.Ragdoll:Destroy()
            end)
        end
        if Settings['FakeAccs'] then
            for _,v in next,plr.Character:GetChildren() do
                if v:IsA'Accessory' and v:FindFirstChild'Handle' and v.Name ~= 'FakeAcc' then
                    local clone = v:Clone()
                    v:Destroy()
                    clone.Name = 'FakeAcc'
                    clone.Parent = plr.Character
                end
            end
        end
        if Settings['AntiFling'] then
            pcall(function()
                if plr.Character.Ragdoll.Value then
                    plr.Character.GetUpEvent:FireServer()
                end
            end)
            for _,v in next,plr.Character:GetChildren() do
                if v.Name == 'Stabler' or v.Name == 'VelocityDamage' or v.Name == 'GetPicked' or v.Name == 'ArmAngleUpdate' or v.Name == 'ArmAngle' then
                    v:Destroy()
                end
            end
        end
        if Settings['AntiAnvil'] then
            for _,v in next,plrs:GetPlayers() do
                pcall(function()
                    if v.Character:FindFirstChild'Anvil' then
                        v.Character.Anvil.send:FireServer(v.Character.HumanoidRootPart.CFrame.p+Vector3.new(0,10,0))
                    end
                end)
            end
        end
    end
end)
plr.CharacterAdded:Connect(function()
    pcall(function()
        if Settings['AntiSpinner'] then
            repeat wait() until plr.Character:FindFirstChild'HumanoidRootPart' and plr.Character:FindFirstChild'Head'
            for _,v in next,plr.Character:GetChildren() do
                if v:IsA'BasePart' then
                    v.CustomPhysicalProperties = prop1000
                end
            end
        end
        if Settings['LessPing'] then
            spawn(function()
                pcall(function()
                    repeat rs.RenderStepped:wait() until plr.Character:FindFirstChild'BodyFollowMouse' and plr.Character:FindFirstChild'HeadWaist'
                    plr.Character.BodyFollowMouse.Disabled = true
                    plr.Character.HeadWaist:FireServer(CFrame.new(0,0.8,0),CFrame.new(0,0.2,0))
                end)
            end)
        end
    end)
end)
Notify('Script Loaded!','Script made by KAKOYTO_LOXX and JusttChrxs\nKeybinds:\nv - Fling things\nq - Pick up things',5)

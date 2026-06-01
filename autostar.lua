-- Anime Astral Simulator | Auto Open Stars
-- Uso: servidor privado unicamente

local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

local autoOn, delay, count = false, 0.2, 0

-- Detectar remote
local remote
for _, v in ipairs(RS:GetDescendants()) do
    if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) then
        local n = v.Name:lower()
        if n:find("star") or n:find("open") or n:find("roll") or n:find("summon") then
            remote = v break
        end
    end
end

-- GUI
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false
local f = Instance.new("Frame", gui)
f.Size, f.Position = UDim2.new(0,240,0,160), UDim2.new(0,20,0.4,0)
f.BackgroundColor3 = Color3.fromRGB(12,12,22)
Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)
local stroke = Instance.new("UIStroke", f)
stroke.Color, stroke.Thickness = Color3.fromRGB(255,200,0), 2

local function lbl(txt, y, col)
    local l = Instance.new("TextLabel", f)
    l.Size, l.Position = UDim2.new(1,-10,0,22), UDim2.new(0,5,0,y)
    l.BackgroundTransparency, l.TextScaled = 1, true
    l.Font, l.Text = Enum.Font.GothamBold, txt
    l.TextColor3 = col or Color3.fromRGB(255,220,80)
    return l
end

local function btn(txt, y, col)
    local b = Instance.new("TextButton", f)
    b.Size, b.Position = UDim2.new(0.48,0,0,34), UDim2.new(y > 90 and 0.52 or 0,y > 90 and -2 or 0,0,y)
    b.BackgroundColor3, b.TextColor3 = col, Color3.fromRGB(255,255,255)
    b.Text, b.TextScaled, b.Font = txt, true, Enum.Font.GothamBold
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,7)
    return b
end

lbl("⭐ AUTO OPEN STARS", 5, Color3.fromRGB(255,200,0))
local status = lbl("Estado: Detenido", 30, Color3.fromRGB(180,180,180))
local counter = lbl("Abiertos: 0", 54, Color3.fromRGB(255,220,80))
local rname = lbl(remote and "Remote: "..remote.Name or "Remote: no encontrado", 76, Color3.fromRGB(100,200,255))
rname.TextScaled = false rname.TextSize = 11

local startBtn = Instance.new("TextButton", f)
startBtn.Size, startBtn.Position = UDim2.new(0.47,0,0,34), UDim2.new(0,5,0,110)
startBtn.BackgroundColor3 = Color3.fromRGB(40,180,80)
startBtn.Text, startBtn.TextColor3, startBtn.Font = "▶ START", Color3.new(1,1,1), Enum.Font.GothamBold
startBtn.TextScaled, startBtn.BorderSizePixel = true, 0
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,7)

local stopBtn = Instance.new("TextButton", f)
stopBtn.Size, stopBtn.Position = UDim2.new(0.47,0,0,34), UDim2.new(0.52,-2,0,110)
stopBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
stopBtn.Text, stopBtn.TextColor3, stopBtn.Font = "⏹ STOP", Color3.new(1,1,1), Enum.Font.GothamBold
stopBtn.TextScaled, stopBtn.BorderSizePixel = true, 0
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0,7)

-- Drag
local drag, ds, dp = false
f.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=true; ds=i.Position; dp=f.Position end
end)
f.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=false end end)
UIS.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - ds
        f.Position = UDim2.new(dp.X.Scale, dp.X.Offset+d.X, dp.Y.Scale, dp.Y.Offset+d.Y)
    end
end)

-- Lógica
local function fire()
    if not remote then return end
    pcall(function()
        if remote:IsA("RemoteEvent") then remote:FireServer()
        else remote:InvokeServer() end
    end)
    count += 1
    counter.Text = "Abiertos: "..count
end

startBtn.MouseButton1Click:Connect(function()
    if not remote then status.Text="Remote no encontrado"; return end
    autoOn = true
    status.Text, status.TextColor3 = "Estado: ✅ Activo", Color3.fromRGB(80,255,120)
    task.spawn(function()
        while autoOn do fire(); task.wait(delay) end
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    autoOn = false
    status.Text, status.TextColor3 = "Estado: ⏸ Detenido", Color3.fromRGB(180,180,180)
end)

print("[AutoStar] Cargado | Remote: "..(remote and remote.Name or "N/A"))

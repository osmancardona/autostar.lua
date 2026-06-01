-- Anime Astral Simulator | Auto Open Stars v3
-- Con selector de mundo
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local LP = game:GetService("Players").LocalPlayer

local autoOn, delay, count = false, 0.3, 0
local selectedWorld = "World1"

local Network = RS:WaitForChild("SimpleWorld")
    :WaitForChild("Library")
    :WaitForChild("Network")
    :WaitForChild("Functions")

local BuyTicket     = Network:WaitForChild("BuyWithTicket")
local GetWorldsData = Network:WaitForChild("GetWorldsData")
local GetCurrentWorld = Network:WaitForChild("GetCurrentWorld")

-- Mundos disponibles (detectados)
local WORLDS = {
    {name = "🌍 World 1",  key = "World1"},
    {name = "🌎 World 2",  key = "World2"},
    {name = "🌏 World 3",  key = "World3"},
    {name = "⚔️ Raids",    key = "RaidArenas"},
    {name = "🛡️ Defense",  key = "DefenseArenas"},
    {name = "⏱️ TimeTrial", key = "TimeTrialArenas"},
    {name = "🐾 Pets",     key = "Pets"},
    {name = "👹 Titans",   key = "Titans"},
}

-- ► GUI
local oldGui = LP.PlayerGui:FindFirstChild("AutoStarV3")
if oldGui then oldGui:Destroy() end

local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name, gui.ResetOnSpawn = "AutoStarV3", false

-- Frame principal
local f = Instance.new("Frame", gui)
f.Size = UDim2.new(0, 260, 0, 420)
f.Position = UDim2.new(0, 20, 0.1, 0)
f.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
f.BorderSizePixel = 0
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
local sk = Instance.new("UIStroke", f)
sk.Color, sk.Thickness = Color3.fromRGB(255, 200, 0), 2

-- Título
local title = Instance.new("Frame", f)
title.Size = UDim2.new(1, 0, 0, 38)
title.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
title.BorderSizePixel = 0
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

local titleLbl = Instance.new("TextLabel", title)
titleLbl.Size = UDim2.new(1, 0, 1, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "⭐ AUTO OPEN STARS v3"
titleLbl.TextColor3 = Color3.fromRGB(15, 15, 25)
titleLbl.TextScaled = true
titleLbl.Font = Enum.Font.GothamBold

-- Drag
local drag, ds, dp = false
title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag, ds, dp = true, i.Position, f.Position
    end
end)
title.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)
UIS.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - ds
        f.Position = UDim2.new(dp.X.Scale, dp.X.Offset+d.X, dp.Y.Scale, dp.Y.Offset+d.Y)
    end
end)

-- Labels
local function lbl(txt, y, col, sz)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -10, 0, 20)
    l.Position = UDim2.new(0, 5, 0, y)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBold
    l.Text = txt
    l.TextColor3 = col or Color3.fromRGB(255, 220, 80)
    if sz then l.TextSize = sz l.TextScaled = false
    else l.TextScaled = true end
    return l
end

local statusLbl  = lbl("Estado: ⏸ Detenido", 44, Color3.fromRGB(180,180,180))
local counterLbl = lbl("⭐ Abiertos: 0", 66, Color3.fromRGB(255,220,80))
local worldLbl   = lbl("🗺️ Mundo: World1", 88, Color3.fromRGB(100,200,255), 12)

-- Separador
local sep = Instance.new("Frame", f)
sep.Size = UDim2.new(1, -20, 0, 1)
sep.Position = UDim2.new(0, 10, 0, 112)
sep.BackgroundColor3 = Color3.fromRGB(255,200,0)
sep.BorderSizePixel = 0

lbl("🗺️ SELECCIONAR MUNDO:", 118, Color3.fromRGB(255,200,0), 12)

-- Scroll para mundos
local scroll = Instance.new("ScrollingFrame", f)
scroll.Size = UDim2.new(1, -10, 0, 185)
scroll.Position = UDim2.new(0, 5, 0, 136)
scroll.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(255,200,0)
scroll.CanvasSize = UDim2.new(0, 0, 0, #WORLDS * 38)
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 8)

local selectedBtn = nil

for i, world in ipairs(WORLDS) do
    local wb = Instance.new("TextButton", scroll)
    wb.Size = UDim2.new(1, -8, 0, 32)
    wb.Position = UDim2.new(0, 4, 0, (i-1)*36 + 4)
    wb.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    wb.Text = world.name
    wb.TextColor3 = Color3.fromRGB(200, 200, 200)
    wb.Font = Enum.Font.GothamBold
    wb.TextScaled = true
    wb.BorderSizePixel = 0
    Instance.new("UICorner", wb).CornerRadius = UDim.new(0, 6)

    -- Highlight World1 por defecto
    if i == 1 then
        wb.BackgroundColor3 = Color3.fromRGB(255,180,0)
        wb.TextColor3 = Color3.fromRGB(15,15,25)
        selectedBtn = wb
    end

    wb.MouseButton1Click:Connect(function()
        -- Deseleccionar anterior
        if selectedBtn then
            selectedBtn.BackgroundColor3 = Color3.fromRGB(30,30,50)
            selectedBtn.TextColor3 = Color3.fromRGB(200,200,200)
        end
        -- Seleccionar nuevo
        wb.BackgroundColor3 = Color3.fromRGB(255,180,0)
        wb.TextColor3 = Color3.fromRGB(15,15,25)
        selectedBtn = wb
        selectedWorld = world.key
        worldLbl.Text = "🗺️ Mundo: " .. world.key
    end)
end

-- Botones START / STOP
local function mkbtn(txt, xScale, xOff, col)
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0.47, 0, 0, 36)
    b.Position = UDim2.new(xScale, xOff, 0, 332)
    b.BackgroundColor3 = col
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local startBtn = mkbtn("▶ START", 0, 10, Color3.fromRGB(40,180,80))
local stopBtn  = mkbtn("⏹ STOP", 0.52, -2, Color3.fromRGB(200,50,50))

-- Reset contador
local resetBtn = Instance.new("TextButton", f)
resetBtn.Size = UDim2.new(1, -10, 0, 26)
resetBtn.Position = UDim2.new(0, 5, 0, 378)
resetBtn.BackgroundColor3 = Color3.fromRGB(40,40,60)
resetBtn.Text = "🔄 Reset contador"
resetBtn.TextColor3 = Color3.fromRGB(160,160,160)
resetBtn.Font = Enum.Font.Gotham
resetBtn.TextScaled = true
resetBtn.BorderSizePixel = 0
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,6)

resetBtn.MouseButton1Click:Connect(function()
    count = 0
    counterLbl.Text = "⭐ Abiertos: 0"
end)

-- ► Función abrir estrella
local function openStar()
    local ok, res = pcall(function()
        return BuyTicket:InvokeServer(selectedWorld)
    end)
    if ok then
        count += 1
        counterLbl.Text = "⭐ Abiertos: " .. count
    else
        -- Intenta sin argumento
        pcall(function()
            BuyTicket:InvokeServer()
            count += 1
            counterLbl.Text = "⭐ Abiertos: " .. count
        end)
    end
end

startBtn.MouseButton1Click:Connect(function()
    if autoOn then return end
    autoOn = true
    statusLbl.Text = "Estado: ✅ Activo — " .. selectedWorld
    statusLbl.TextColor3 = Color3.fromRGB(80,255,120)
    task.spawn(function()
        while autoOn do
            openStar()
            task.wait(delay)
        end
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    autoOn = false
    statusLbl.Text = "Estado: ⏸ Detenido"
    statusLbl.TextColor3 = Color3.fromRGB(180,180,180)
end)

print("[AutoStar v3] ✅ Listo con selector de mundos")

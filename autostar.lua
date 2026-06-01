-- Anime Astral Simulator | Auto Open Stars v4 Fix
local LP = game:GetService("Players").LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

local autoOn, count, minimized = false, 0, false

local ISLANDS = {
    {name = "🏯 Ninja Village", key = "World1"},
    {name = "🌍 World 2",       key = "World2"},
    {name = "🌏 World 3",       key = "World3"},
    {name = "⚔️ Raids",         key = "RaidArenas"},
    {name = "🛡️ Defense",       key = "DefenseArenas"},
    {name = "⏱️ Time Trial",    key = "TimeTrialArenas"},
    {name = "🐾 Pets",          key = "Pets"},
    {name = "👹 Titans",        key = "Titans"},
}

local old = PG:FindFirstChild("AutoStarV4")
if old then old:Destroy() end

-- Click botones del juego
local function clickOpen()
    pcall(function()
        PG.Windows.Star.Content.Buttons.Open.MouseButton1Click:Fire()
    end)
end

local function clickAuto()
    pcall(function()
        PG.Windows.Star.Content.Buttons.Auto.MouseButton1Click:Fire()
    end)
end

-- GUI
local gui = Instance.new("ScreenGui", PG)
gui.Name = "AutoStarV4"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999

-- ICONO flotante (TextButton para poder usar Text)
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,48,0,48)
icon.Position = UDim2.new(0,20,0.5,0)
icon.BackgroundColor3 = Color3.fromRGB(255,180,0)
icon.Text = "⭐"
icon.TextScaled = true
icon.Font = Enum.Font.GothamBold
icon.TextColor3 = Color3.fromRGB(15,15,25)
icon.BorderSizePixel = 0
icon.Visible = false
Instance.new("UICorner", icon).CornerRadius = UDim.new(0.5,0)
local iconStroke = Instance.new("UIStroke", icon)
iconStroke.Color = Color3.fromRGB(255,255,255)
iconStroke.Thickness = 2

-- FRAME PRINCIPAL
local f = Instance.new("Frame", gui)
f.Size = UDim2.new(0,260,0,430)
f.Position = UDim2.new(0,20,0.08,0)
f.BackgroundColor3 = Color3.fromRGB(12,12,22)
f.BorderSizePixel = 0
Instance.new("UICorner", f).CornerRadius = UDim.new(0,12)
local fStroke = Instance.new("UIStroke", f)
fStroke.Color = Color3.fromRGB(255,200,0)
fStroke.Thickness = 2

-- TÍTULO
local titleBar = Instance.new("Frame", f)
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.BackgroundColor3 = Color3.fromRGB(255,180,0)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,12)

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(1,-80,1,0)
titleLbl.Position = UDim2.new(0,10,0,0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "⭐ AUTO STARS v4"
titleLbl.TextColor3 = Color3.fromRGB(15,15,25)
titleLbl.TextScaled = true
titleLbl.Font = Enum.Font.GothamBold

-- Botón minimizar
local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size = UDim2.new(0,28,0,28)
minBtn.Position = UDim2.new(1,-66,0,6)
minBtn.BackgroundColor3 = Color3.fromRGB(50,50,80)
minBtn.Text = "—"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextScaled = true
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,6)

-- Botón cerrar
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-34,0,6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

-- CONTENIDO
local content = Instance.new("Frame", f)
content.Size = UDim2.new(1,0,1,-40)
content.Position = UDim2.new(0,0,0,40)
content.BackgroundTransparency = 1

local function lbl(parent, txt, y, col, sz)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1,-10,0,20)
    l.Position = UDim2.new(0,5,0,y)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBold
    l.Text = txt
    l.TextColor3 = col or Color3.fromRGB(255,220,80)
    if sz then l.TextSize=sz l.TextScaled=false
    else l.TextScaled=true end
    return l
end

local statusLbl  = lbl(content,"Estado: ⏸ Detenido", 5, Color3.fromRGB(180,180,180))
local counterLbl = lbl(content,"⭐ Abiertos: 0", 28, Color3.fromRGB(255,220,80))
local islandLbl  = lbl(content,"Isla: Ninja Village", 50, Color3.fromRGB(100,200,255), 11)

local sep = Instance.new("Frame", content)
sep.Size = UDim2.new(1,-20,0,1)
sep.Position = UDim2.new(0,10,0,74)
sep.BackgroundColor3 = Color3.fromRGB(255,200,0)
sep.BorderSizePixel = 0

lbl(content,"🗺️ SELECCIONAR ISLA:", 80, Color3.fromRGB(255,200,0), 12)

-- Scroll islas
local scroll = Instance.new("ScrollingFrame", content)
scroll.Size = UDim2.new(1,-10,0,175)
scroll.Position = UDim2.new(0,5,0,98)
scroll.BackgroundColor3 = Color3.fromRGB(18,18,30)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(255,200,0)
scroll.CanvasSize = UDim2.new(0,0,0,#ISLANDS*38)
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0,8)

local selectedIsland = ISLANDS[1]
local selectedBtn = nil

for i, island in ipairs(ISLANDS) do
    local wb = Instance.new("TextButton", scroll)
    wb.Size = UDim2.new(1,-8,0,32)
    wb.Position = UDim2.new(0,4,0,(i-1)*36+4)
    wb.BackgroundColor3 = i==1 and Color3.fromRGB(255,180,0) or Color3.fromRGB(30,30,50)
    wb.Text = island.name
    wb.TextColor3 = i==1 and Color3.fromRGB(15,15,25) or Color3.fromRGB(200,200,200)
    wb.Font = Enum.Font.GothamBold
    wb.TextScaled = true
    wb.BorderSizePixel = 0
    Instance.new("UICorner", wb).CornerRadius = UDim.new(0,6)
    if i==1 then selectedBtn = wb end

    wb.MouseButton1Click:Connect(function()
        if selectedBtn then
            selectedBtn.BackgroundColor3 = Color3.fromRGB(30,30,50)
            selectedBtn.TextColor3 = Color3.fromRGB(200,200,200)
        end
        wb.BackgroundColor3 = Color3.fromRGB(255,180,0)
        wb.TextColor3 = Color3.fromRGB(15,15,25)
        selectedBtn = wb
        selectedIsland = island
        islandLbl.Text = "Isla: " .. island.name
    end)
end

-- Botones
local function mkbtn(parent, txt, xScale, xOff, y, col)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.47,0,0,34)
    b.Position = UDim2.new(xScale,xOff,0,y)
    b.BackgroundColor3 = col
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local startBtn    = mkbtn(content,"▶ START",  0,    10, 282, Color3.fromRGB(40,180,80))
local stopBtn     = mkbtn(content,"⏹ STOP",   0.52, -2, 282, Color3.fromRGB(200,50,50))

local autoGameBtn = Instance.new("TextButton", content)
autoGameBtn.Size = UDim2.new(1,-10,0,30)
autoGameBtn.Position = UDim2.new(0,5,0,323)
autoGameBtn.BackgroundColor3 = Color3.fromRGB(80,60,200)
autoGameBtn.Text = "🔁 Activar AUTO! del juego"
autoGameBtn.TextColor3 = Color3.new(1,1,1)
autoGameBtn.Font = Enum.Font.GothamBold
autoGameBtn.TextScaled = true
autoGameBtn.BorderSizePixel = 0
Instance.new("UICorner", autoGameBtn).CornerRadius = UDim.new(0,8)

local resetBtn = Instance.new("TextButton", content)
resetBtn.Size = UDim2.new(1,-10,0,26)
resetBtn.Position = UDim2.new(0,5,0,360)
resetBtn.BackgroundColor3 = Color3.fromRGB(40,40,60)
resetBtn.Text = "🔄 Reset contador"
resetBtn.TextColor3 = Color3.fromRGB(160,160,160)
resetBtn.Font = Enum.Font.Gotham
resetBtn.TextScaled = true
resetBtn.BorderSizePixel = 0
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,6)

-- DRAG frame principal
local drag, ds, dp = false
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag,ds,dp = true,i.Position,f.Position
    end
end)
titleBar.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=false end
end)
UIS.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position-ds
        f.Position = UDim2.new(dp.X.Scale,dp.X.Offset+d.X,dp.Y.Scale,dp.Y.Offset+d.Y)
    end
end)

-- DRAG icono
local idrag, ids, idp = false
icon.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        idrag,ids,idp = true,i.Position,icon.Position
    end
end)
icon.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then idrag=false end
end)
UIS.InputChanged:Connect(function(i)
    if idrag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position-ids
        icon.Position = UDim2.new(idp.X.Scale,idp.X.Offset+d.X,idp.Y.Scale,idp.Y.Offset+d.Y)
    end
end)

-- MINIMIZAR
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    f.Size = minimized and UDim2.new(0,260,0,40) or UDim2.new(0,260,0,430)
    minBtn.Text = minimized and "▢" or "—"
end)

-- CERRAR
closeBtn.MouseButton1Click:Connect(function()
    autoOn = false
    f.Visible = false
    icon.Visible = true
end)

-- RESTAURAR desde icono
icon.MouseButton1Click:Connect(function()
    if not idrag then
        f.Visible = true
        icon.Visible = false
    end
end)

-- LÓGICA
startBtn.MouseButton1Click:Connect(function()
    if autoOn then return end
    autoOn = true
    statusLbl.Text = "Estado: ✅ Abriendo..."
    statusLbl.TextColor3 = Color3.fromRGB(80,255,120)
    task.spawn(function()
        while autoOn do
            clickOpen()
            count += 1
            counterLbl.Text = "⭐ Abiertos: "..count
            task.wait(0.4)
        end
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    autoOn = false
    statusLbl.Text = "Estado: ⏸ Detenido"
    statusLbl.TextColor3 = Color3.fromRGB(180,180,180)
end)

autoGameBtn.MouseButton1Click:Connect(function()
    clickAuto()
    autoGameBtn.BackgroundColor3 = Color3.fromRGB(40,180,80)
    autoGameBtn.Text = "✅ AUTO! activado"
end)

resetBtn.MouseButton1Click:Connect(function()
    count = 0
    counterLbl.Text = "⭐ Abiertos: 0"
end)

print("[AutoStar v4] ✅ Cargado correctamente")

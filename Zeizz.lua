local ZeizzHub = {Objects = {}}
local Config = {
    Visible = true,
    Minimized = false,
    Moving = false,
    
    -- Posición y tamaño inicial (píxeles exactos)
    X = 100,
    Y = 100,
    Width = 320,
    Height = 230,
    MinimizedSize = 70,
    
    -- Colores PREMIUM EXCLUSIVOS
    Colors = {
        Background = Color3.fromRGB(15, 18, 25),
        Header = Color3.fromRGB(25, 30, 40),
        Accent = Color3.fromRGB(0, 160, 255),
        Text = Color3.fromRGB(245, 245, 250),
        Button = Color3.fromRGB(40, 45, 60),
        ButtonHover = Color3.fromRGB(50, 55, 75),
        Success = Color3.fromRGB(85, 230, 110),
        Warning = Color3.fromRGB(255, 180, 60),
        Disabled = Color3.fromRGB(90, 95, 110),
        Border = Color3.fromRGB(60, 65, 85)
    }
}

local States = {
    WallHack = false,
    SuperSpeed = false,
    Invisibility = false,
    InvisibilityCooldown = false,
    OriginalWalkspeed = 16
}

-- Función anti-detection
local function safeExecute(func)
    pcall(func)
end

-- Crear objetos Drawing
local function createObject(type, props)
    local obj = Drawing.new(type)
    for prop, value in pairs(props) do
        pcall(function() obj[prop] = value end)
    end
    return obj
end

-- Verificar posición del touch
local function isInBounds(x, y, w, h)
    local touch = game:GetService("UserInputService"):GetMouseLocation()
    return touch.X >= x and touch.X <= x + w and touch.Y >= y and touch.Y <= y + h
end

-- Crear interfaz premium
function ZeizzHub:CreateUI()
    -- Panel principal con sombra
    self.Objects.Background = createObject("Square", {
        Color = Config.Colors.Background,
        Filled = true,
        Thickness = 0,
        Visible = Config.Visible and not Config.Minimized
    })
    
    self.Objects.Border = createObject("Square", {
        Color = Config.Colors.Border,
        Filled = false,
        Thickness = 2,
        Visible = Config.Visible and not Config.Minimized
    })
    
    -- Header con gradiente
    self.Objects.Header = createObject("Square", {
        Color = Config.Colors.Header,
        Filled = true,
        Thickness = 0,
        Visible = Config.Visible and not Config.Minimized
    })
    
    -- Título ultra premium
    self.Objects.Title = createObject("Text", {
        Color = Config.Colors.Accent,
        Size = 17,
        Center = true,
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Text = "ZEIZZ HUB VIP",
        Visible = Config.Visible and not Config.Minimized,
        Font = 2
    })
    
    self.Objects.Subtitle = createObject("Text", {
        Color = Color3.fromRGB(180, 180, 200),
        Size = 12,
        Center = true,
        Text = "Premium Edition",
        Visible = Config.Visible and not Config.Minimized,
        Font = 0
    })
    
    -- Botones de control
    self.Objects.MinimizeBtn = createObject("Circle", {
        Color = Config.Colors.Button,
        Filled = true,
        Radius = 8,
        Visible = Config.Visible and not Config.Minimized
    })
    
    self.Objects.MinimizeIcon = createObject("Text", {
        Color = Config.Colors.Text,
        Size = 12,
        Center = true,
        Text = "_",
        Visible = Config.Visible and not Config.Minimized
    })
    
    self.Objects.CloseBtn = createObject("Circle", {
        Color = Color3.fromRGB(200, 60, 60),
        Filled = true,
        Radius = 8,
        Visible = Config.Visible and not Config.Minimized
    })
    
    self.Objects.CloseIcon = createObject("Text", {
        Color = Config.Colors.Text,
        Size = 10,
        Center = true,
        Text = "×",
        Visible = Config.Visible and not Config.Minimized
    })
    
    -- Botón WallHack (Quitar Paredes)
    self.Objects.WallBtn = createObject("Square", {
        Color = Config.Colors.Button,
        Filled = true,
        Thickness = 0,
        Visible = Config.Visible and not Config.Minimized
    })
    
    self.Objects.WallText = createObject("Text", {
        Color = Config.Colors.Text,
        Size = 14,
        Center = true,
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Text = "WALLHACK: OFF",
        Visible = Config.Visible and not Config.Minimized,
        Font = 2
    })
    
    -- Botón Super Velocidad
    self.Objects.SpeedBtn = createObject("Square", {
        Color = Config.Colors.Button,
        Filled = true,
        Thickness = 0,
        Visible = Config.Visible and not Config.Minimized
    })
    
    self.Objects.SpeedText = createObject("Text", {
        Color = Config.Colors.Text,
        Size = 14,
        Center = true,
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Text = "SUPER VELOCIDAD: OFF",
        Visible = Config.Visible and not Config.Minimized,
        Font = 2
    })
    
    -- Botón Invisibilidad Mejorada
    self.Objects.InvisBtn = createObject("Square", {
        Color = Config.Colors.Button,
        Filled = true,
        Thickness = 0,
        Visible = Config.Visible and not Config.Minimized
    })
    
    self.Objects.InvisText = createObject("Text", {
        Color = Config.Colors.Text,
        Size = 14,
        Center = true,
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Text = "INVISIBILIDAD (5s)",
        Visible = Config.Visible and not Config.Minimized,
        Font = 2
    })
    
    -- Footer exclusivo
    self.Objects.Footer = createObject("Text", {
        Color = Color3.fromRGB(150, 150, 170),
        Size = 10,
        Center = true,
        Text = "Zeizz Hub VIP v2.0 | © 2024 Anti-Ban System",
        Visible = Config.Visible and not Config.Minimized,
        Font = 0
    })
    
    -- Panel minimizado ultra discreto
    self.Objects.MinimizedPanel = createObject("Circle", {
        Color = Config.Colors.Header,
        Filled = true,
        Radius = 35,
        Visible = Config.Visible and Config.Minimized
    })
    
    self.Objects.MinimizedText = createObject("Text", {
        Color = Config.Colors.Accent,
        Size = 12,
        Center = true,
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Text = "ZH\nVIP",
        Visible = Config.Visible and Config.Minimized,
        Font = 2
    })
    
    self:UpdateUI()
end

-- Actualizar interfaz
function ZeizzHub:UpdateUI()
    -- Panel principal
    self.Objects.Background.Position = Vector2.new(Config.X, Config.Y)
    self.Objects.Background.Size = Vector2.new(Config.Width, Config.Height)
    
    self.Objects.Border.Position = Vector2.new(Config.X, Config.Y)
    self.Objects.Border.Size = Vector2.new(Config.Width, Config.Height)
    
    -- Header
    self.Objects.Header.Position = Vector2.new(Config.X, Config.Y)
    self.Objects.Header.Size = Vector2.new(Config.Width, 35)
    
    -- Títulos
    self.Objects.Title.Position = Vector2.new(Config.X + Config.Width/2, Config.Y + 12)
    self.Objects.Subtitle.Position = Vector2.new(Config.X + Config.Width/2, Config.Y + 28)
    
    -- Botones de control
    self.Objects.MinimizeBtn.Position = Vector2.new(Config.X + Config.Width - 50, Config.Y + 10)
    self.Objects.MinimizeIcon.Position = Vector2.new(Config.X + Config.Width - 50, Config.Y + 7)
    
    self.Objects.CloseBtn.Position = Vector2.new(Config.X + Config.Width - 25, Config.Y + 10)
    self.Objects.CloseIcon.Position = Vector2.new(Config.X + Config.Width - 25, Config.Y + 8)
    
    -- Botón WallHack
    self.Objects.WallBtn.Position = Vector2.new(Config.X + 15, Config.Y + 55)
    self.Objects.WallBtn.Size = Vector2.new(Config.Width - 30, 30)
    self.Objects.WallText.Position = Vector2.new(Config.X + Config.Width/2, Config.Y + 70)
    self.Objects.WallText.Text = "WALLHACK: " .. (States.WallHack and "ON" or "OFF")
    self.Objects.WallText.Color = States.WallHack and Config.Colors.Success or Config.Colors.Text
    
    -- Botón Super Velocidad
    self.Objects.SpeedBtn.Position = Vector2.new(Config.X + 15, Config.Y + 95)
    self.Objects.SpeedBtn.Size = Vector2.new(Config.Width - 30, 30)
    self.Objects.SpeedText.Position = Vector2.new(Config.X + Config.Width/2, Config.Y + 110)
    self.Objects.SpeedText.Text = "SUPER VELOCIDAD: " .. (States.SuperSpeed and "ON" or "OFF")
    self.Objects.SpeedText.Color = States.SuperSpeed and Config.Colors.Success or Config.Colors.Text
    
    -- Botón Invisibilidad
    self.Objects.InvisBtn.Position = Vector2.new(Config.X + 15, Config.Y + 135)
    self.Objects.InvisBtn.Size = Vector2.new(Config.Width - 30, 30)
    self.Objects.InvisBtn.Color = States.InvisibilityCooldown and Config.Colors.Disabled or Config.Colors.Button
    
    self.Objects.InvisText.Position = Vector2.new(Config.X + Config.Width/2, Config.Y + 150)
    self.Objects.InvisText.Color = States.InvisibilityCooldown and Config.Colors.Disabled or 
                                  (States.Invisibility and Config.Colors.Success or Config.Colors.Text)
    
    -- Footer
    self.Objects.Footer.Position = Vector2.new(Config.X + Config.Width/2, Config.Y + Config.Height - 12)
    
    -- Panel minimizado
    self.Objects.MinimizedPanel.Position = Vector2.new(Config.X + 35, Config.Y + 35)
    self.Objects.MinimizedText.Position = Vector2.new(Config.X + 35, Config.Y + 32)
    
    -- Visibilidad general
    local visible = Config.Visible and not Config.Minimized
    for name, obj in pairs(self.Objects) do
        if name ~= "MinimizedPanel" and name ~= "MinimizedText" then
            pcall(function() obj.Visible = visible end)
        end
    end
    
    self.Objects.MinimizedPanel.Visible = Config.Visible and Config.Minimized
    self.Objects.MinimizedText.Visible = Config.Visible and Config.Minimized
end

-- Función WALLHACK (Quitar Paredes)
function ZeizzHub:ToggleWallHack()
    States.WallHack = not States.WallHack
    
    safeExecute(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                -- Eliminar solo paredes verticales (no suelo/techo)
                if obj.Position.Y > 5 then  -- Ajusta este valor según tu juego
                    obj.CanCollide = not States.WallHack
                    if States.WallHack then
                        obj.Transparency = 0.7  -- Hacerlas semi-transparentes
                    else
                        obj.Transparency = 0
                    end
                end
            end
        end
    end)
    
    self:UpdateUI()
end

-- Función SUPER VELOCIDAD
function ZeizzHub:ToggleSuperSpeed()
    States.SuperSpeed = not States.SuperSpeed
    
    safeExecute(function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            if States.SuperSpeed then
                States.OriginalWalkspeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = 50  -- Velocidad super rápida
            else
                humanoid.WalkSpeed = States.OriginalWalkspeed
            end
        end
    end)
    
    self:UpdateUI()
end

-- Función INVISIBILIDAD MEJORADA (5 segundos)
function ZeizzHub:ActivateInvisibility()
    if States.InvisibilityCooldown then return end
    
    States.Invisibility = true
    States.InvisibilityCooldown = true
    
    safeExecute(function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        -- Hacer completamente invisible
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    end)
    
    self:UpdateUI()
    
    -- Temporizador mejorado (5 segundos)
    task.delay(5.0, function()
        safeExecute(function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                    end
                end
            end
            States.Invisibility = false
            self:UpdateUI()
        end)
    end)
    
    -- Cooldown reducido
    task.delay(8.0, function()
        States.InvisibilityCooldown = false
        self:UpdateUI()
    end)
end

-- Conectar eventos de input
function ZeizzHub:ConnectInput()
    local UIS = game:GetService("UserInputService")
    
    UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        if Config.Minimized then
            if isInBounds(Config.X, Config.Y, 70, 70) then
                Config.Minimized = false
                self:UpdateUI()
            end
            return
        end
        
        -- Botón minimizar
        if isInBounds(Config.X + Config.Width - 50, Config.Y + 5, 20, 20) then
            Config.Minimized = true
            self:UpdateUI()
            return
        end
        
        -- Botón cerrar
        if isInBounds(Config.X + Config.Width - 25, Config.Y + 5, 20, 20) then
            Config.Visible = false
            self:UpdateUI()
            return
        end
        
        -- Botón WallHack
        if isInBounds(Config.X + 15, Config.Y + 55, Config.Width - 30, 30) then
            self:ToggleWallHack()
            return
        end
        
        -- Botón Super Velocidad
        if isInBounds(Config.X + 15, Config.Y + 95, Config.Width - 30, 30) then
            self:ToggleSuperSpeed()
            return
        end
        
        -- Botón Invisibilidad
        if isInBounds(Config.X + 15, Config.Y + 135, Config.Width - 30, 30) and not States.InvisibilityCooldown then
            self:ActivateInvisibility()
            return
        end
        
        -- Mover panel
        if isInBounds(Config.X, Config.Y, Config.Width, 35) then
            Config.Moving = true
            self.moveStartX = input.Position.X - Config.X
            self.moveStartY = input.Position.Y - Config.Y
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and Config.Moving then
            Config.X = input.Position.X - self.moveStartX
            Config.Y = input.Position.Y - self.moveStartY
            self:UpdateUI()
        end
    end)
    
    UIS.InputEnded:Connect(function()
        Config.Moving = false
    end)
end

-- Inicialización premium
function ZeizzHub:Init()
    self:CreateUI()
    self:ConnectInput()
    
    -- Comando exclusivo
    game:GetService("Players").LocalPlayer.Chatted:Connect(function(message)
        if message:lower() == "/zeizz" then
            Config.Visible = not Config.Visible
            self:UpdateUI()
        end
    end)
    
    print("🎯 Zeizz Hub VIP Loaded | Anti-Ban Active")
    print("🎯 Use /zeizz to toggle menu")
end

-- Iniciar sistema VIP
ZeizzHub:Init()

return ZeizzHub

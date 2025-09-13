local ZeizzHub = {Objects = {}}
local Config = {
    Visible = true,
    Minimized = false,
    Moving = false,
    Resizing = false,
    
    -- Posición y tamaño inicial (en píxeles para mayor precisión)
    X = 100,
    Y = 100,
    Width = 300,
    Height = 200,
    MinWidth = 200,
    MinHeight = 150,
    MinimizedSize = 80,
    
    -- Colores PREMIUM (esquema oscuro profesional)
    Colors = {
        Background = Color3.fromRGB(20, 20, 30),
        Header = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(0, 150, 255),
        Text = Color3.fromRGB(240, 240, 245),
        Button = Color3.fromRGB(45, 45, 60),
        ButtonHover = Color3.fromRGB(55, 55, 75),
        Success = Color3.fromRGB(80, 220, 100),
        Disabled = Color3.fromRGB(100, 100, 120),
        Border = Color3.fromRGB(70, 70, 90)
    }
}

local States = {
    Noclip = false,
    Invisibility = false,
    InvisibilityCooldown = false
}

-- Función para crear objetos Drawing con propiedades
local function createObject(type, props)
    local obj = Drawing.new(type)
    for prop, value in pairs(props) do
        pcall(function() obj[prop] = value end)
    end
    return obj
end

-- Función para verificar si el touch está en un área
local function isInBounds(x, y, w, h)
    local touch = game:GetService("UserInputService"):GetMouseLocation()
    return touch.X >= x and touch.X <= x + w and touch.Y >= y and touch.Y <= y + h
end

-- Crear la interfaz de usuario
function ZeizzHub:CreateUI()
    -- Panel principal (fondo)
    self.Objects.Background = createObject("Square", {
        Color = Config.Colors.Background,
        Filled = true,
        Thickness = 1,
        Visible = Config.Visible and not Config.Minimized
    })
    
    -- Borde del panel
    self.Objects.Border = createObject("Square", {
        Color = Config.Colors.Border,
        Filled = false,
        Thickness = 2,
        Visible = Config.Visible and not Config.Minimized
    })
    
    -- Barra de título
    self.Objects.Header = createObject("Square", {
        Color = Config.Colors.Header,
        Filled = true,
        Thickness = 1,
        Visible = Config.Visible and not Config.Minimized
    })
    
    -- Título del panel
    self.Objects.Title = createObject("Text", {
        Color = Config.Colors.Text,
        Size = 16,
        Center = true,
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Text = "ZEIZZ HUB | PANEL PREMIUM",
        Visible = Config.Visible and not Config.Minimized,
        Font = 2
    })
    
    -- Botón de minimizar
    self.Objects.MinimizeBtn = createObject("Square", {
        Color = Config.Colors.Button,
        Filled = true,
        Thickness = 1,
        Visible = Config.Visible and not Config.Minimized
    })
    
    self.Objects.MinimizeText = createObject("Text", {
        Color = Config.Colors.Text,
        Size = 14,
        Center = true,
        Text = "_",
        Visible = Config.Visible and not Config.Minimized
    })
    
    -- Botón de cerrar
    self.Objects.CloseBtn = createObject("Square", {
        Color = Color3.fromRGB(180, 50, 50),
        Filled = true,
        Thickness = 1,
        Visible = Config.Visible and not Config.Minimized
    })
    
    self.Objects.CloseText = createObject("Text", {
        Color = Config.Colors.Text,
        Size = 12,
        Center = true,
        Text = "X",
        Visible = Config.Visible and not Config.Minimized
    })
    
    -- Botón de NoClip
    self.Objects.NoclipBtn = createObject("Square", {
        Color = Config.Colors.Button,
        Filled = true,
        Thickness = 1,
        Visible = Config.Visible and not Config.Minimized
    })
    
    self.Objects.NoclipText = createObject("Text", {
        Color = Config.Colors.Text,
        Size = 14,
        Center = true,
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Text = "NOCLIP: DESACTIVADO",
        Visible = Config.Visible and not Config.Minimized,
        Font = 2
    })
    
    -- Botón de Invisibilidad
    self.Objects.InvisBtn = createObject("Square", {
        Color = Config.Colors.Button,
        Filled = true,
        Thickness = 1,
        Visible = Config.Visible and not Config.Minimized
    })
    
    self.Objects.InvisText = createObject("Text", {
        Color = Config.Colors.Text,
        Size = 14,
        Center = true,
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Text = "INVISIBILIDAD",
        Visible = Config.Visible and not Config.Minimized,
        Font = 2
    })
    
    -- Footer (pie de página)
    self.Objects.Footer = createObject("Text", {
        Color = Color3.fromRGB(160, 160, 170),
        Size = 11,
        Center = true,
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Text = "Zeizz Hub v1.0 | © 2023 Todos los derechos reservados",
        Visible = Config.Visible and not Config.Minimized,
        Font = 0
    })
    
    -- Panel minimizado
    self.Objects.MinimizedPanel = createObject("Square", {
        Color = Config.Colors.Header,
        Filled = true,
        Thickness = 2,
        Visible = Config.Visible and Config.Minimized
    })
    
    self.Objects.MinimizedText = createObject("Text", {
        Color = Config.Colors.Text,
        Size = 14,
        Center = true,
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Text = "Zeizz Hub",
        Visible = Config.Visible and Config.Minimized,
        Font = 2
    })
    
    -- Actualizar posiciones
    self:UpdateUI()
end

-- Actualizar todas las posiciones y estados
function ZeizzHub:UpdateUI()
    -- Panel principal
    self.Objects.Background.Position = Vector2.new(Config.X, Config.Y)
    self.Objects.Background.Size = Vector2.new(Config.Width, Config.Height)
    self.Objects.Background.Visible = Config.Visible and not Config.Minimized
    
    self.Objects.Border.Position = Vector2.new(Config.X, Config.Y)
    self.Objects.Border.Size = Vector2.new(Config.Width, Config.Height)
    self.Objects.Border.Visible = Config.Visible and not Config.Minimized
    
    -- Header
    self.Objects.Header.Position = Vector2.new(Config.X, Config.Y)
    self.Objects.Header.Size = Vector2.new(Config.Width, 30)
    self.Objects.Header.Visible = Config.Visible and not Config.Minimized
    
    -- Título
    self.Objects.Title.Position = Vector2.new(Config.X + Config.Width/2, Config.Y + 15)
    self.Objects.Title.Visible = Config.Visible and not Config.Minimized
    
    -- Botón minimizar
    self.Objects.MinimizeBtn.Position = Vector2.new(Config.X + Config.Width - 50, Config.Y + 5)
    self.Objects.MinimizeBtn.Size = Vector2.new(20, 20)
    self.Objects.MinimizeBtn.Visible = Config.Visible and not Config.Minimized
    
    self.Objects.MinimizeText.Position = Vector2.new(Config.X + Config.Width - 40, Config.Y + 10)
    self.Objects.MinimizeText.Visible = Config.Visible and not Config.Minimized
    
    -- Botón cerrar
    self.Objects.CloseBtn.Position = Vector2.new(Config.X + Config.Width - 25, Config.Y + 5)
    self.Objects.CloseBtn.Size = Vector2.new(20, 20)
    self.Objects.CloseBtn.Visible = Config.Visible and not Config.Minimized
    
    self.Objects.CloseText.Position = Vector2.new(Config.X + Config.Width - 15, Config.Y + 10)
    self.Objects.CloseText.Visible = Config.Visible and not Config.Minimized
    
    -- Botón NoClip
    self.Objects.NoclipBtn.Position = Vector2.new(Config.X + 15, Config.Y + 50)
    self.Objects.NoclipBtn.Size = Vector2.new(Config.Width - 30, 30)
    self.Objects.NoclipBtn.Visible = Config.Visible and not Config.Minimized
    
    self.Objects.NoclipText.Position = Vector2.new(Config.X + Config.Width/2, Config.Y + 65)
    self.Objects.NoclipText.Text = "NOCLIP: " .. (States.Noclip and "ACTIVADO" or "DESACTIVADO")
    self.Objects.NoclipText.Color = States.Noclip and Config.Colors.Success or Config.Colors.Text
    self.Objects.NoclipText.Visible = Config.Visible and not Config.Minimized
    
    -- Botón Invisibilidad
    self.Objects.InvisBtn.Position = Vector2.new(Config.X + 15, Config.Y + 90)
    self.Objects.InvisBtn.Size = Vector2.new(Config.Width - 30, 30)
    self.Objects.InvisBtn.Color = States.InvisibilityCooldown and Config.Colors.Disabled or Config.Colors.Button
    self.Objects.InvisBtn.Visible = Config.Visible and not Config.Minimized
    
    self.Objects.InvisText.Position = Vector2.new(Config.X + Config.Width/2, Config.Y + 105)
    local invisStatus = States.InvisibilityCooldown and " (ENFRIAMIENTO)" or (States.Invisibility and " (ACTIVO)" or "")
    self.Objects.InvisText.Text = "INVISIBILIDAD" .. invisStatus
    self.Objects.InvisText.Color = States.InvisibilityCooldown and Config.Colors.Disabled or (States.Invisibility and Config.Colors.Success or Config.Colors.Text)
    self.Objects.InvisText.Visible = Config.Visible and not Config.Minimized
    
    -- Footer
    self.Objects.Footer.Position = Vector2.new(Config.X + Config.Width/2, Config.Y + Config.Height - 15)
    self.Objects.Footer.Visible = Config.Visible and not Config.Minimized
    
    -- Panel minimizado
    self.Objects.MinimizedPanel.Position = Vector2.new(Config.X, Config.Y)
    self.Objects.MinimizedPanel.Size = Vector2.new(Config.MinimizedSize, Config.MinimizedSize)
    self.Objects.MinimizedPanel.Visible = Config.Visible and Config.Minimized
    
    self.Objects.MinimizedText.Position = Vector2.new(Config.X + Config.MinimizedSize/2, Config.Y + Config.MinimizedSize/2)
    self.Objects.MinimizedText.Visible = Config.Visible and Config.Minimized
end

-- Conectar eventos de input
function ZeizzHub:ConnectInput()
    local UIS = game:GetService("UserInputService")
    
    UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        if Config.Minimized then
            if isInBounds(Config.X, Config.Y, Config.MinimizedSize, Config.MinimizedSize) then
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
        
        -- Botón NoClip
        if isInBounds(Config.X + 15, Config.Y + 50, Config.Width - 30, 30) then
            self:ToggleNoclip()
            return
        end
        
        -- Botón Invisibilidad
        if isInBounds(Config.X + 15, Config.Y + 90, Config.Width - 30, 30) and not States.InvisibilityCooldown then
            self:ActivateInvisibility()
            return
        end
        
        -- Mover panel
        if isInBounds(Config.X, Config.Y, Config.Width, 30) then
            Config.Moving = true
            self.moveStartX = input.Position.X - Config.X
            self.moveStartY = input.Position.Y - Config.Y
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            if Config.Moving then
                Config.X = input.Position.X - self.moveStartX
                Config.Y = input.Position.Y - self.moveStartY
                self:UpdateUI()
            end
        end
    end)
    
    UIS.InputEnded:Connect(function()
        Config.Moving = false
    end)
end

-- Función NoClip
function ZeizzHub:ToggleNoclip()
    States.Noclip = not States.Noclip
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not States.Noclip
        end
    end
    
    self:UpdateUI()
end

-- Función Invisibilidad
function ZeizzHub:ActivateInvisibility()
    if States.InvisibilityCooldown then return end
    
    States.Invisibility = true
    States.InvisibilityCooldown = true
    
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Hacer invisible
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        end
    end
    
    self:UpdateUI()
    
    -- Temporizador para restaurar visibilidad
    task.delay(1.8, function()
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
    
    -- Cooldown
    task.delay(4.0, function()
        States.InvisibilityCooldown = false
        self:UpdateUI()
    end)
end

-- Inicializar el panel
function ZeizzHub:Init()
    self:CreateUI()
    self:ConnectInput()
    
    -- Comando de chat
    game:GetService("Players").LocalPlayer.Chatted:Connect(function(message)
        if message:lower() == "/zeizz" then
            Config.Visible = not Config.Visible
            self:UpdateUI()
        end
    end)
    
    print("Zeizz Hub Premium loaded! Use /zeizz to toggle.")
end

-- Iniciar
ZeizzHub:Init()

return ZeizzHub

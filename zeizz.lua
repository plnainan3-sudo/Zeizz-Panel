-- Zeizz Hub - Panel Premium Profesional para Roblox (Delta Executor)
-- Desarrollado para Daniel Trujillo y su empresa.

-- Instancia principal del script
local ZeizzHub = {}

-- Configuración Premium
ZeizzHub.Config = {
    Visible = true,
    Minimized = false,
    Moving = false,
    Resizing = false,
    
    -- Colores de la marca Zeizz
    Colors = {
        Background = Color3.fromRGB(15, 15, 25),
        Header = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(0, 150, 255),
        Text = Color3.fromRGB(240, 240, 245),
        Button = Color3.fromRGB(40, 40, 50),
        ButtonHover = Color3.fromRGB(50, 50, 65),
        Success = Color3.fromRGB(70, 200, 90),
        Border = Color3.fromRGB(60, 60, 80)
    },
    
    -- Posición y tamaño inicial
    X = 0.3,
    Y = 0.3,
    Width = 0.4,
    Height = 0.25,
    MinWidth = 0.2,
    MinHeight = 0.15,
    
    -- Tamaño minimizado
    MinimizedSize = 0.05,
}

-- Referencias a los objetos de la GUI
ZeizzHub.Objects = {
    Background = nil,
    Header = nil,
    Title = nil,
    MinimizeButton = nil,
    CloseButton = nil,
    NoclipButton = nil,
    InvisButton = nil,
    Footer = nil,
    ResizeHandle = nil,
    MinimizedPanel = nil
}

-- Estados de las funciones
ZeizzHub.States = {
    Noclip = false,
    Invisibility = false,
    InvisibilityCooldown = false
}

-- Función para crear un nuevo objeto Drawing
function ZeizzHub:NewObject(Type, Properties)
    local Object = Drawing.new(Type)
    for Property, Value in pairs(Properties) do
        Object[Property] = Value
    end
    return Object
end

-- Función para verificar si el touch/ratón está en un área
function ZeizzHub:IsInBounds(X, Y, Width, Height, Input)
    local InputX, InputY = Input.Position.X, Input.Position.Y
    return InputX >= X and InputX <= X + Width and InputY >= Y and InputY <= Y + Height
end

-- Función para convertir proporciones a píxeles (para responsive design)
function ZeizzHub:ScaleX(Proportion)
    return Proportion * workspace.CurrentCamera.ViewportSize.X
end

function ZeizzHub:ScaleY(Proportion)
    return Proportion * workspace.CurrentCamera.ViewportSize.Y
end

-- Inicializar la GUI
function ZeizzHub:Init()
    -- Crear el fondo del panel principal
    self.Objects.Background = self:NewObject("Square", {
        Color = self.Config.Colors.Background,
        Filled = true,
        Thickness = 1,
        Visible = self.Config.Visible and not self.Config.Minimized
    })
    
    -- Crear la barra de header
    self.Objects.Header = self:NewObject("Square", {
        Color = self.Config.Colors.Header,
        Filled = true,
        Thickness = 1,
        Visible = self.Config.Visible and not self.Config.Minimized
    })
    
    -- Crear el título
    self.Objects.Title = self:NewObject("Text", {
        Color = self.Config.Colors.Text,
        Size = 16,
        Center = true,
        Outline = true,
        Text = "ZEIZZ HUB | PANEL PREMIUM",
        Visible = self.Config.Visible and not self.Config.Minimized
    })
    
    -- Botón de minimizar
    self.Objects.MinimizeButton = self:NewObject("Square", {
        Color = self.Config.Colors.Button,
        Filled = true,
        Thickness = 1,
        Visible = self.Config.Visible and not self.Config.Minimized
    })
    
    -- Botón de cerrar
    self.Objects.CloseButton = self:NewObject("Square", {
        Color = Color3.fromRGB(150, 40, 40),
        Filled = true,
        Thickness = 1,
        Visible = self.Config.Visible and not self.Config.Minimized
    })
    
    -- Botón de NoClip
    self.Objects.NoclipButton = self:NewObject("Square", {
        Color = self.Config.Colors.Button,
        Filled = true,
        Thickness = 1,
        Visible = self.Config.Visible and not self.Config.Minimized
    })
    
    -- Texto del botón NoClip
    self.Objects.NoclipText = self:NewObject("Text", {
        Color = self.Config.Colors.Text,
        Size = 14,
        Center = true,
        Outline = true,
        Text = "NOCLIP: DESACTIVADO",
        Visible = self.Config.Visible and not self.Config.Minimized
    })
    
    -- Botón de Invisibilidad
    self.Objects.InvisButton = self:NewObject("Square", {
        Color = self.Config.Colors.Button,
        Filled = true,
        Thickness = 1,
        Visible = self.Config.Visible and not self.Config.Minimized
    })
    
    -- Texto del botón Invisibilidad
    self.Objects.InvisText = self:NewObject("Text", {
        Color = self.Config.Colors.Text,
        Size = 14,
        Center = true,
        Outline = true,
        Text = "INVISIBILIDAD",
        Visible = self.Config.Visible and not self.Config.Minimized
    })
    
    -- Pie de página
    self.Objects.Footer = self:NewObject("Text", {
        Color = Color3.fromRGB(150, 150, 160),
        Size = 12,
        Center = true,
        Outline = true,
        Text = "Zeizz Hub v1.0 | © 2023 Todos los derechos reservados",
        Visible = self.Config.Visible and not self.Config.Minimized
    })
    
    -- Mango para redimensionar
    self.Objects.ResizeHandle = self:NewObject("Square", {
        Color = self.Config.Colors.Border,
        Filled = true,
        Thickness = 1,
        Visible = self.Config.Visible and not self.Config.Minimized
    })
    
    -- Panel minimizado
    self.Objects.MinimizedPanel = self:NewObject("Square", {
        Color = self.Config.Colors.Header,
        Filled = true,
        Thickness = 1,
        Visible = self.Config.Visible and self.Config.Minimized
    })
    
    self.Objects.MinimizedText = self:NewObject("Text", {
        Color = self.Config.Colors.Text,
        Size = 14,
        Center = true,
        Outline = true,
        Text = "Zeizz Hub",
        Visible = self.Config.Visible and self.Config.Minimized
    })
    
    -- Conectar los eventos de input
    self:ConnectInput()
    
    -- Actualizar la posición y el tamaño inicial
    self:Update()
    
    print("Zeizz Hub Premium loaded! Use /zeizz to toggle.")
end

-- Actualizar todas las posiciones y tamaños
function ZeizzHub:Update()
    local Config = self.Config
    local Objects = self.Objects
    
    -- Calcular posiciones en píxeles
    local X = self:ScaleX(Config.X)
    local Y = self:ScaleY(Config.Y)
    local Width = self:ScaleX(Config.Width)
    local Height = self:ScaleY(Config.Height)
    local MinimizedSize = self:ScaleX(Config.MinimizedSize)
    
    -- Panel principal
    if Objects.Background then
        Objects.Background.Position = Vector2.new(X, Y)
        Objects.Background.Size = Vector2.new(Width, Height)
        Objects.Background.Visible = Config.Visible and not Config.Minimized
    end
    
    -- Header
    if Objects.Header then
        Objects.Header.Position = Vector2.new(X, Y)
        Objects.Header.Size = Vector2.new(Width, 30)
        Objects.Header.Visible = Config.Visible and not Config.Minimized
    end
    
    -- Título
    if Objects.Title then
        Objects.Title.Position = Vector2.new(X + Width / 2, Y + 15)
        Objects.Title.Visible = Config.Visible and not Config.Minimized
    end
    
    -- Botón minimizar
    if Objects.MinimizeButton then
        Objects.MinimizeButton.Position = Vector2.new(X + Width - 60, Y + 5)
        Objects.MinimizeButton.Size = Vector2.new(20, 20)
        Objects.MinimizeButton.Visible = Config.Visible and not Config.Minimized
    end
    
    -- Botón cerrar
    if Objects.CloseButton then
        Objects.CloseButton.Position = Vector2.new(X + Width - 30, Y + 5)
        Objects.CloseButton.Size = Vector2.new(20, 20)
        Objects.CloseButton.Visible = Config.Visible and not Config.Minimized
    end
    
    -- Botón NoClip
    if Objects.NoclipButton then
        Objects.NoclipButton.Position = Vector2.new(X + 20, Y + 75)
        Objects.NoclipButton.Size = Vector2.new(Width - 40, 30)
        Objects.NoclipButton.Visible = Config.Visible and not Config.Minimized
    end
    
    -- Texto NoClip
    if Objects.NoclipText then
        Objects.NoclipText.Position = Vector2.new(X + Width / 2, Y + 90)
        Objects.NoclipText.Text = "NOCLIP: " .. (self.States.Noclip and "ACTIVADO" or "DESACTIVADO")
        Objects.NoclipText.Color = self.States.Noclip and self.Config.Colors.Success or self.Config.Colors.Text
        Objects.NoclipText.Visible = Config.Visible and not Config.Minimized
    end
    
    -- Botón Invisibilidad
    if Objects.InvisButton then
        Objects.InvisButton.Position = Vector2.new(X + 20, Y + 115)
        Objects.InvisButton.Size = Vector2.new(Width - 40, 30)
        Objects.InvisButton.Color = self.States.InvisibilityCooldown and Color3.fromRGB(80, 80, 90) or self.Config.Colors.Button
        Objects.InvisButton.Visible = Config.Visible and not Config.Minimized
    end
    
    -- Texto Invisibilidad
    if Objects.InvisText then
        Objects.InvisText.Position = Vector2.new(X + Width / 2, Y + 130)
        local text = "INVISIBILIDAD"
        if self.States.InvisibilityCooldown then
            text = text .. " (EN ENFRIAMIENTO)"
        elseif self.States.Invisibility then
            text = text .. " (ACTIVO)"
        end
        Objects.InvisText.Text = text
        Objects.InvisText.Color = self.States.InvisibilityCooldown and Color3.fromRGB(150, 150, 150) or (self.States.Invisibility and self.Config.Colors.Success or self.Config.Colors.Text)
        Objects.InvisText.Visible = Config.Visible and not Config.Minimized
    end
    
    -- Pie de página
    if Objects.Footer then
        Objects.Footer.Position = Vector2.new(X + Width / 2, Y + Height - 10)
        Objects.Footer.Visible = Config.Visible and not Config.Minimized
    end
    
    -- Mango para redimensionar
    if Objects.ResizeHandle then
        Objects.ResizeHandle.Position = Vector2.new(X + Width - 20, Y + Height - 20)
        Objects.ResizeHandle.Size = Vector2.new(20, 20)
        Objects.ResizeHandle.Visible = Config.Visible and not Config.Minimized and not Config.Moving
    end
    
    -- Panel minimizado
    if Objects.MinimizedPanel then
        Objects.MinimizedPanel.Position = Vector2.new(X, Y)
        Objects.MinimizedPanel.Size = Vector2.new(MinimizedSize, MinimizedSize)
        Objects.MinimizedPanel.Visible = Config.Visible and Config.Minimized
    end
    
    if Objects.MinimizedText then
        Objects.MinimizedText.Position = Vector2.new(X + MinimizedSize / 2, Y + MinimizedSize / 2)
        Objects.MinimizedText.Visible = Config.Visible and Config.Minimized
    end
end

-- Conectar eventos de input (touch/ratón)
function ZeizzHub:ConnectInput()
    local UserInputService = game:GetService("UserInputService")
    
    UserInputService.InputBegan:Connect(function(Input, Processed)
        if Processed then return end
        
        local Config = self.Config
        local X = self:ScaleX(Config.X)
        local Y = self:ScaleY(Config.Y)
        local Width = self:ScaleX(Config.Width)
        local Height = self:ScaleY(Config.Height)
        local MinimizedSize = self:ScaleX(Config.MinimizedSize)
        
        if Config.Minimized then
            -- Click en panel minimizado
            if self:IsInBounds(X, Y, MinimizedSize, MinimizedSize, Input) then
                Config.Minimized = false
                self:Update()
            end
            return
        end
        
        -- Verificar clicks en los botones
        if self:IsInBounds(X + Width - 60, Y + 5, 20, 20, Input) then
            -- Minimizar
            Config.Minimized = true
            self:Update()
            return
        end
        
        if self:IsInBounds(X + Width - 30, Y + 5, 20, 20, Input) then
            -- Cerrar
            Config.Visible = false
            self:Update()
            return
        end
        
        if self:IsInBounds(X + 20, Y + 75, Width - 40, 30, Input) then
            -- NoClip
            self:ToggleNoclip()
            return
        end
        
        if self:IsInBounds(X + 20, Y + 115, Width - 40, 30, Input) and not self.States.InvisibilityCooldown then
            -- Invisibilidad
            self:ActivateInvisibility()
            return
        end
        
        -- Comenzar a mover
        if self:IsInBounds(X, Y, Width, 30, Input) then
            Config.Moving = true
            self.MoveStartX = Input.Position.X - X
            self.MoveStartY = Input.Position.Y - Y
            return
        end
        
        -- Comenzar a redimensionar
        if self:IsInBounds(X + Width - 20, Y + Height - 20, 20, 20, Input) then
            Config.Resizing = true
            self.ResizeStartX = Input.Position.X
            self.ResizeStartY = Input.Position.Y
            return
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        local Config = self.Config
        
        if Config.Moving then
            -- Mover el panel
            Config.X = (Input.Position.X - self.MoveStartX) / workspace.CurrentCamera.ViewportSize.X
            Config.Y = (Input.Position.Y - self.MoveStartY) / workspace.CurrentCamera.ViewportSize.Y
            
            -- Limitar a los bordes de la pantalla
            Config.X = math.max(0, math.min(1 - Config.Width, Config.X))
            Config.Y = math.max(0, math.min(1 - Config.Height, Config.Y))
            
            self:Update()
        elseif Config.Resizing then
            -- Redimensionar el panel
            local NewWidth = math.max(Config.MinWidth, (Input.Position.X - self:ScaleX(Config.X)) / workspace.CurrentCamera.ViewportSize.X)
            local NewHeight = math.max(Config.MinHeight, (Input.Position.Y - self:ScaleY(Config.Y)) / workspace.CurrentCamera.ViewportSize.Y)
            
            Config.Width = NewWidth
            Config.Height = NewHeight
            
            self:Update()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        self.Config.Moving = false
        self.Config.Resizing = false
    end)
end

-- Función para toggle de NoClip
function ZeizzHub:ToggleNoclip()
    self.States.Noclip = not self.States.Noclip
    local Player = game.Players.LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    
    if self.States.Noclip then
        -- Activar NoClip (desactivar colisiones)
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.CanCollide = false
            end
        end
    else
        -- Desactivar NoClip
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.CanCollide = true
            end
        end
    end
    
    self:Update()
end

-- Función para activar invisibilidad
function ZeizzHub:ActivateInvisibility()
    if self.States.InvisibilityCooldown then return end
    
    local Player = game.Players.LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    
    self.States.Invisibility = true
    self.States.InvisibilityCooldown = true
    
    -- Hacer invisible el personaje
    for _, Part in pairs(Character:GetDescendants()) do
        if Part:IsA("BasePart") then
            Part.Transparency = 1
        end
    end
    
    -- Restaurar después de 1.8 segundos
    task.delay(1.8, function()
        if Character then
            for _, Part in pairs(Character:GetDescendants()) do
                if Part:IsA("BasePart") then
                    Part.Transparency = 0
                end
            end
        end
        self.States.Invisibility = false
        self:Update()
    end)
    
    -- Cooldown de 4 segundos
    task.delay(4, function()
        self.States.InvisibilityCooldown = false
        self:Update()
    end)
    
    self:Update()
end

-- Comando para mostrar/ocultar el panel
function ZeizzHub:TogglePanel()
    self.Config.Visible = not self.Config.Visible
    self:Update()
end

-- Inicializar el Hub
ZeizzHub:Init()

-- Comando de chat
game:GetService("Players").LocalPlayer.Chatted:Connect(function(Message)
    if Message:lower() == "/zeizz" then
        ZeizzHub:TogglePanel()
    end
end)

return ZeizzHub

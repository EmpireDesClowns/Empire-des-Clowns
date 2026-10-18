
-- EMPIRE DES CLOWNS V2.3
-- Interface mobile avec chargement et mot de passe

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

if not player then return end

local playerGui = player:WaitForChild("PlayerGui")
local previous = playerGui:FindFirstChild("EmpireDesClownsV2")

if previous then
    previous:Destroy()
end

-- Configuration
local PASSWORD = "empire"
local DISCORD = "https://discord.gg/KN4fUU252y"

local scripts = {
    {
        name = "Beanz Main.lua",
        url = "https://beanzz.wtf/Main.lua"
    },
    {
        name = "Vortex",
        url = "https://api.getvortex.vip/scripts/VortexMain"
    }
}

local colors = {
    bg = Color3.fromRGB(20, 19, 29),
    panel = Color3.fromRGB(43, 40, 59),
    purple = Color3.fromRGB(109, 68, 164),
    white = Color3.fromRGB(245, 240, 255),
    muted = Color3.fromRGB(180, 171, 195),
    red = Color3.fromRGB(255, 100, 115)
}

local function create(className, properties, parent)
    local object = Instance.new(className)

    for property, value in pairs(properties) do
        object[property] = value
    end

    object.Parent = parent
    return object
end

local function round(object, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius or 9)
    }, object)
end

local function label(parent, caption, position, size, fontSize)
    return create("TextLabel", {
        Position = position,
        Size = size,
        Text = caption,
        BackgroundTransparency = 1,
        TextColor3 = colors.white,
        Font = Enum.Font.Gotham,
        TextSize = fontSize or 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center
    }, parent)
end

local function button(parent, caption, position, size, callback, highlighted)
    local object = create("TextButton", {
        Position = position,
        Size = size,
        Text = caption,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextColor3 = colors.white,
        BackgroundColor3 = highlighted and colors.purple or colors.panel,
        BorderSizePixel = 0,
        AutoButtonColor = true
    }, parent)

    round(object, 9)
    object.MouseButton1Click:Connect(callback)

    return object
end

local gui = create("ScreenGui", {
    Name = "EmpireDesClownsV2",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, playerGui)

-- Adaptation aux telephones
local camera = workspace.CurrentCamera
local viewport = camera and camera.ViewportSize or Vector2.new(400, 700)

local scale = math.min(
    1,
    (viewport.X - 24) / 360,
    (viewport.Y - 32) / 346
)

scale = math.max(0.4, scale)

local function centerFrame(size, visible)
    local frame = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = size,
        BackgroundColor3 = colors.bg,
        BorderSizePixel = 0,
        Visible = visible ~= false
    }, gui)

    round(frame, 12)
    create("UIScale", {Scale = scale}, frame)

    return frame
end

-- Animation de chargement
local loading = centerFrame(UDim2.fromOffset(260, 125))

local heading = label(
    loading,
    "EMPIRE DES CLOWNS",
    UDim2.fromOffset(10, 12),
    UDim2.fromOffset(240, 30),
    15
)

heading.Font = Enum.Font.GothamBold

local info = label(
    loading,
    "Initialisation...",
    UDim2.fromOffset(10, 45),
    UDim2.fromOffset(240, 20),
    11
)

info.TextColor3 = colors.muted

local track = create("Frame", {
    Position = UDim2.fromOffset(20, 77),
    Size = UDim2.fromOffset(220, 8),
    BackgroundColor3 = colors.panel,
    BorderSizePixel = 0
}, loading)

round(track, 8)

local fill = create("Frame", {
    Size = UDim2.fromScale(0, 1),
    BackgroundColor3 = colors.purple,
    BorderSizePixel = 0
}, track)

round(fill, 8)

local percent = label(
    loading,
    "0%",
    UDim2.fromOffset(10, 93),
    UDim2.fromOffset(240, 20),
    11
)

local duration = 1.8
local startTime = os.clock()

local progressTween = TweenService:Create(
    fill,
    TweenInfo.new(duration, Enum.EasingStyle.Linear),
    {Size = UDim2.fromScale(1, 1)}
)

progressTween:Play()

while gui.Parent do
    local elapsed = os.clock() - startTime
    local progress = math.clamp(elapsed / duration, 0, 1)

    percent.Text = math.floor(progress * 100) .. "%"

    if progress >= 1 then
        break
    end

    task.wait(0.03)
end

if not gui.Parent then return end

progressTween:Cancel()
fill.Size = UDim2.fromScale(1, 1)
percent.Text = "100%"
info.Text = "Termine !"

task.wait(0.15)
loading:Destroy()

-- Connexion par mot de passe
local login = centerFrame(UDim2.fromOffset(300, 238))

local loginHeading = label(
    login,
    "EMPIRE DES CLOWNS",
    UDim2.fromOffset(10, 14),
    UDim2.fromOffset(280, 32),
    17
)

loginHeading.Font = Enum.Font.GothamBold

label(
    login,
    "Mot de passe disponible sur Discord",
    UDim2.fromOffset(10, 52),
    UDim2.fromOffset(280, 25),
    12
)

local passwordInput = create("TextBox", {
    Position = UDim2.fromOffset(30, 88),
    Size = UDim2.fromOffset(240, 37),
    Text = "",
    PlaceholderText = "Mot de passe",
    ClearTextOnFocus = false,
    TextColor3 = colors.white,
    PlaceholderColor3 = colors.muted,
    Font = Enum.Font.Gotham,
    TextSize = 13,
    BackgroundColor3 = colors.panel
}, login)

round(passwordInput)

local feedback = label(
    login,
    "",
    UDim2.fromOffset(15, 175),
    UDim2.fromOffset(270, 27),
    11
)

-- Menu principal
local main = centerFrame(UDim2.fromOffset(360, 346), false)

main.Active = true
main.Draggable = true

local title = label(
    main,
    "EMPIRE DES CLOWNS",
    UDim2.fromOffset(15, 8),
    UDim2.fromOffset(250, 38),
    16
)

title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local tabs = create("Frame", {
    Position = UDim2.fromOffset(10, 58),
    Size = UDim2.new(1, -20, 0, 40),
    BackgroundTransparency = 1
}, main)

local body = create("Frame", {
    Position = UDim2.fromOffset(12, 106),
    Size = UDim2.new(1, -24, 1, -115),
    BackgroundTransparency = 1
}, main)

local function bodyLabel(caption, y, height)
    local object = label(
        body,
        caption,
        UDim2.fromOffset(5, y),
        UDim2.new(1, -10, 0, height or 35),
        12
    )

    object.TextXAlignment = Enum.TextXAlignment.Left
    return object
end

local status
local busy = false

-- Les scripts tiers ne sont pas executes dans cette version.
local function execute(entry)
    if busy then return end

    if status and status.Parent then
        status.Text = entry.name .. " : execution externe non activee."
    end
end

local function show(page)
    for _, child in ipairs(body:GetChildren()) do
        child:Destroy()
    end

    status = nil

    if page == "Scripts" then
        bodyLabel("SCRIPTS DISPONIBLES", 0)

        for i, entry in ipairs(scripts) do
            local y = 43 + (i - 1) * 58

            bodyLabel(entry.name, y)

            button(
                body,
                "EXECUTER",
                UDim2.new(1, -110, 0, y),
                UDim2.fromOffset(105, 36),
                function()
                    execute(entry)
                end,
                true
            )
        end

        status = bodyLabel(
            "Scripts externes non verifies.",
            171,
            48
        )

    elseif page == "Anti-Ban" then
        bodyLabel(
            "Aucun anti-ban ne garantit une protection contre les bannissements.",
            8,
            70
        )

    elseif page == "VOC" then
        bodyLabel(
            "Parametres vocaux a venir.",
            8,
            70
        )

    elseif page == "Discord" then
        bodyLabel("Notre Discord :", 8, 30)
        bodyLabel(DISCORD, 42, 40)

        button(
            body,
            "COPIER DISCORD",
            UDim2.fromOffset(5, 95),
            UDim2.fromOffset(175, 40),
            function()
                if type(setclipboard) == "function" then
                    setclipboard(DISCORD)
                    bodyLabel("Lien copie !", 145, 30)
                else
                    bodyLabel(DISCORD, 145, 45)
                end
            end,
            true
        )
    end
end

for i, name in ipairs({
    "Scripts",
    "Anti-Ban",
    "VOC",
    "Discord"
}) do
    button(
        tabs,
        name,
        UDim2.new((i - 1) / 4, 1, 0, 0),
        UDim2.new(0.25, -4, 0, 36),
        function()
            show(name)
        end
    )
end

-- Reduire et fermer
local minimized = false
local minimize

minimize = button(
    main,
    "-",
    UDim2.new(1, -75, 0, 11),
    UDim2.fromOffset(28, 28),
    function()
        minimized = not minimized

        tabs.Visible = not minimized
        body.Visible = not minimized

        main.Size = UDim2.fromOffset(
            360,
            minimized and 52 or 346
        )

        minimize.Text = minimized and "+" or "-"
    end
)

button(
    main,
    "X",
    UDim2.new(1, -40, 0, 11),
    UDim2.fromOffset(28, 28),
    function()
        gui:Destroy()
    end
)

show("Scripts")

-- Verification du mot de passe
local function unlock()
    if passwordInput.Text == PASSWORD then
        login:Destroy()
        main.Visible = true
    else
        feedback.Text = "Mot de passe incorrect."
        feedback.TextColor3 = colors.red
    end
end

button(
    login,
    "ACCEDER AU MENU",
    UDim2.fromOffset(30, 135),
    UDim2.fromOffset(240, 36),
    unlock,
    true
)

passwordInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        unlock()
    end
end)

button(
    login,
    "DISCORD",
    UDim2.fromOffset(95, 207),
    UDim2.fromOffset(110, 25),
    function()
        if type(setclipboard) == "function" then
            setclipboard(DISCORD)
            feedback.Text = "Lien Discord copie."
        else
            feedback.Text = DISCORD
        end
    end
)

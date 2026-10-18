
-- EMPIRE DES CLOWNS V2.1
-- Interface mobile avec animation et mot de passe

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

if not player then return end

local playerGui = player:WaitForChild("PlayerGui")
local old = playerGui:FindFirstChild("EmpireDesClownsV2")
if old then old:Destroy() end

local PASSWORD = "empire"
local DISCORD = "https://discord.gg/KN4fUU252y"

local scripts = {
    {name = "Beanz Main.lua", url = "https://beanzz.wtf/Main.lua"},
    {name = "Vortex", url = "https://api.getvortex.vip/scripts/VortexMain"}
}

local bg = Color3.fromRGB(20, 19, 29)
local panel = Color3.fromRGB(43, 40, 59)
local purple = Color3.fromRGB(109, 68, 164)
local white = Color3.fromRGB(245, 240, 255)
local muted = Color3.fromRGB(180, 171, 195)

local function new(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    new("UICorner", {
        CornerRadius = UDim.new(0, radius or 9)
    }, obj)
end

local function button(parent, caption, pos, size, callback, accent)
    local b = new("TextButton", {
        Position = pos,
        Size = size,
        Text = caption,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextColor3 = white,
        BackgroundColor3 = accent and purple or panel,
        BorderSizePixel = 0
    }, parent)

    round(b)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function label(parent, caption, pos, size, fontSize)
    return new("TextLabel", {
        Position = pos,
        Size = size,
        Text = caption,
        Font = Enum.Font.Gotham,
        TextSize = fontSize or 12,
        TextColor3 = white,
        BackgroundTransparency = 1,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center
    }, parent)
end

local gui = new("ScreenGui", {
    Name = "EmpireDesClownsV2",
    ResetOnSpawn = false,
    IgnoreGuiInset = true
}, playerGui)

local camera = workspace.CurrentCamera
local viewport = camera and camera.ViewportSize
    or Vector2.new(400, 700)

local scale = math.min(
    1,
    (viewport.X - 24) / 360,
    (viewport.Y - 32) / 346
)

-- Animation de lancement
local loading = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(260, 125),
    BackgroundColor3 = bg,
    BorderSizePixel = 0
}, gui)
round(loading, 12)

new("UIScale", {Scale = scale}, loading)

local loadingTitle = label(
    loading,
    "EMPIRE DES CLOWNS",
    UDim2.fromOffset(10, 12),
    UDim2.fromOffset(240, 30),
    15
)
loadingTitle.Font = Enum.Font.GothamBold

local loadingStatus = label(
    loading,
    "Initialisation...",
    UDim2.fromOffset(10, 45),
    UDim2.fromOffset(240, 20),
    11
)
loadingStatus.TextColor3 = muted

local track = new("Frame", {
    Position = UDim2.fromOffset(20, 77),
    Size = UDim2.fromOffset(220, 8),
    BackgroundColor3 = panel,
    BorderSizePixel = 0
}, loading)
round(track, 8)

local fill = new("Frame", {
    Size = UDim2.fromScale(0, 1),
    BackgroundColor3 = purple,
    BorderSizePixel = 0
}, track)
round(fill, 8)

local percent = label(
    loading, "0%",
    UDim2.fromOffset(10, 93),
    UDim2.fromOffset(240, 20), 11
)

local animation = TweenService:Create(
    fill,
    TweenInfo.new(1.8, Enum.EasingStyle.Linear),
    {Size = UDim2.fromScale(1, 1)}
)
animation:Play()

for i = 0, 100 do
    if not gui.Parent then return end
    percent.Text = i .. "%"
    task.wait(1.8 / 100)
end

animation.Completed:Wait()
loading:Destroy()

-- Mot de passe
local login = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(300, 225),
    BackgroundColor3 = bg,
    BorderSizePixel = 0
}, gui)
round(login, 12)
new("UIScale", {Scale = scale}, login)

local loginTitle = label(
    login, "EMPIRE DES CLOWNS",
    UDim2.fromOffset(10, 15),
    UDim2.fromOffset(280, 35), 17
)
loginTitle.Font = Enum.Font.GothamBold

label(
    login, "Mot de passe disponible sur Discord",
    UDim2.fromOffset(10, 52),
    UDim2.fromOffset(280, 25), 12
)

local passwordBox = new("TextBox", {
    Position = UDim2.fromOffset(30, 88),
    Size = UDim2.fromOffset(240, 37),
    Text = "",
    PlaceholderText = "Mot de passe",
    ClearTextOnFocus = false,
    TextColor3 = white,
    PlaceholderColor3 = muted,
    Font = Enum.Font.Gotham,
    TextSize = 13,
    BackgroundColor3 = panel
}, login)
round(passwordBox)

local errorText = label(
    login, "",
    UDim2.fromOffset(20, 174),
    UDim2.fromOffset(260, 30), 12
)

-- Menu principal
local main = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(360, 346),
    BackgroundColor3 = bg,
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Visible = false
}, gui)
round(main, 12)
new("UIScale", {Scale = scale}, main)

local title = label(
    main, "EMPIRE DES CLOWNS",
    UDim2.fromOffset(15, 8),
    UDim2.fromOffset(250, 38), 16
)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local tabs = new("Frame", {
    Position = UDim2.fromOffset(10, 58),
    Size = UDim2.new(1, -20, 0, 40),
    BackgroundTransparency = 1
}, main)

local body = new("Frame", {
    Position = UDim2.fromOffset(12, 106),
    Size = UDim2.new(1, -24, 1, -115),
    BackgroundTransparency = 1
}, main)

local function bodyLabel(caption, y, height)
    local item = label(
        body, caption,
        UDim2.fromOffset(5, y),
        UDim2.new(1, -10, 0, height or 35), 12
    )
    item.TextXAlignment = Enum.TextXAlignment.Left
    return item
end

local status

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
                body, "VOIR",
                UDim2.new(1, -110, 0, y),
                UDim2.fromOffset(105, 36),
                function()
                    if type(setclipboard) == "function" then
                        setclipboard(entry.url)
                        status.Text = "Lien " .. entry.name .. " copie."
                    else
                        status.Text = entry.url
                    end
                end, true
            )
        end

        status = bodyLabel(
            "Les scripts externes ne sont pas verifies.",
            171, 48
        )

    elseif page == "Anti-Ban" then
        bodyLabel(
            "Aucun anti-ban ne garantit une protection contre les bannissements.",
            8, 70
        )

    elseif page == "VOC" then
        bodyLabel(
            "Parametres vocaux a venir.",
            8, 70
        )

    elseif page == "Discord" then
        bodyLabel("Notre Discord :", 8, 30)
        bodyLabel(DISCORD, 42, 40)

        button(
            body, "COPIER DISCORD",
            UDim2.fromOffset(5, 95),
            UDim2.fromOffset(175, 40),
            function()
                if type(setclipboard) == "function" then
                    setclipboard(DISCORD)
                    bodyLabel("Lien copie !", 145, 30)
                end
            end, true
        )
    end
end

for i, name in ipairs({
    "Scripts", "Anti-Ban", "VOC", "Discord"
}) do
    button(
        tabs, name,
        UDim2.new((i - 1) / 4, 1, 0, 0),
        UDim2.new(.25, -4, 0, 36),
        function()
            show(name)
        end
    )
end

local minimized = false
local minimize

minimize = button(
    main, "-",
    UDim2.new(1, -75, 0, 11),
    UDim2.fromOffset(28, 28),
    function()
        minimized = not minimized
        tabs.Visible = not minimized
        body.Visible = not minimized
        main.Size = UDim2.fromOffset(
            360, minimized and 52 or 346
        )
        minimize.Text = minimized and "+" or "-"
    end
)

button(
    main, "X",
    UDim2.new(1, -40, 0, 11),
    UDim2.fromOffset(28, 28),
    function()
        gui:Destroy()
    end
)

show("Scripts")

local function unlock()
    if passwordBox.Text == PASSWORD then
        login:Destroy()
        main.Visible = true
    else
        errorText.Text = "Mot de passe incorrect."
        errorText.TextColor3 = Color3.fromRGB(255, 100, 115)
    end
end

button(
    login, "ACCEDER AU MENU",
    UDim2.fromOffset(30, 135),
    UDim2.fromOffset(240, 36),
    unlock, true
)

passwordBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        unlock()
    end
end)

button(
    login, "DISCORD",
    UDim2.fromOffset(95, 204),
    UDim2.fromOffset(110, 19),
    function()
        if type(setclipboard) == "function" then
            setclipboard(DISCORD)
            errorText.Text = "Invitation Discord copiee."
        else
            errorText.Text = DISCORD
        end
    end
)

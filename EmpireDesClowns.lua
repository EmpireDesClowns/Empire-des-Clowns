
-- EMPIRE DES CLOWNS V2 - Menu communautaire
-- Attention : les scripts tiers sont chargés depuis Internet et peuvent changer.
local Players = game:GetService('Players')
local TweenService = game:GetService('TweenService')
local player = Players.LocalPlayer
if not player then return end
local parent = player:WaitForChild('PlayerGui')
local old = parent:FindFirstChild('EmpireDesClownsV2')
if old then old:Destroy() end

local sources = {
    {name = 'Beanz', url = 'https://beanzz.wtf/Main.lua'},
    {name = 'Beanz AutoRob', url = 'https://beanzz.wtf/Autorob.lua'},
    {name = 'Vortex', url = 'https://api.getvortex.vip/scripts/VortexMain'},
}
local discord = 'https://discord.gg/KN4fUU252y'
local function new(class, props, parentObj)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    obj.Parent = parentObj
    return obj
end
local function round(obj)
    new('UICorner', {CornerRadius = UDim.new(0, 9)}, obj)
end
local ui = new('ScreenGui', {
    Name = 'EmpireDesClownsV2',
    ResetOnSpawn = false
}, parent)

local main = new('Frame', {
    Size = UDim2.fromOffset(360, 346),
    Position = UDim2.new(.5, -180, .5, -173),
    BackgroundColor3 = Color3.fromRGB(20, 19, 29),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Visible = false
}, ui)
round(main)

local title = new('TextLabel', {
    Size = UDim2.new(1, -90, 0, 52),
    Position = UDim2.fromOffset(15, 0),
    Text = 'EMPIRE DES CLOWNS',
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(245, 240, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
}, main)

local function makeButton(parentObj, text, position, size, callback, purple)
    local b = new('TextButton', {
        Text = text,
        Position = position,
        Size = size,
        BorderSizePixel = 0,
        TextColor3 = Color3.fromRGB(245, 240, 255),
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        BackgroundColor3 = purple and Color3.fromRGB(109, 68, 164) or Color3.fromRGB(43, 40, 59)
    }, parentObj)
    round(b)
    b.MouseButton1Click:Connect(callback)
    return b
end

local tabs = new('Frame', {
    Position = UDim2.fromOffset(10, 58),
    Size = UDim2.new(1, -20, 0, 40),
    BackgroundTransparency = 1
}, main)

local body = new('Frame', {
    Position = UDim2.fromOffset(12, 106),
    Size = UDim2.new(1, -24, 1, -115),
    BackgroundTransparency = 1
}, main)

local function label(msg, posY, height)
    return new('TextLabel', {
        Text = msg,
        Position = UDim2.fromOffset(5, posY),
        Size = UDim2.new(1, -10, 0, height or 35),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(230, 224, 245),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    }, body)
end

local statusLabel
local busy = false
local function execute(entry)
    if busy then return end
    busy = true
    statusLabel.Text = 'Chargement de ' .. entry.name .. '...'
    task.spawn(function()
        local ok, err = pcall(function()
            local code = game:HttpGet(entry.url)
            local f, parseErr = loadstring(code)
            if not f then error(parseErr or 'Impossible de compiler le script') end
            f()
        end)
        if statusLabel and statusLabel.Parent then
            statusLabel.Text = ok and (entry.name .. ' : lancement demandé.') or ('Erreur : ' .. tostring(err):sub(1, 85))
        end
        busy = false
    end)
end

local function show(page)
    for _, child in ipairs(body:GetChildren()) do child:Destroy() end
    if page == 'Scripts' then
        label('SCRIPTS DISPONIBLES', 0)
        for i, entry in ipairs(sources) do
            local y = 37 + (i - 1) * 52
            label(entry.name, y)
            makeButton(body, 'EXÉCUTER', UDim2.new(1, -110, 0, y), UDim2.fromOffset(105, 35), function()
                execute(entry)
            end, true)
        end
        statusLabel = label('Les scripts externes ne sont pas vérifiés ici.', 195, 45)
    elseif page == 'Anti-Ban' then
        label('Aucun script ne garantit une protection contre les bannissements.', 6, 65)
    elseif page == 'VOC' then
        label('Espace des réglages vocaux à venir.', 6, 65)
    else
        label('Notre Discord : ' .. discord, 6, 60)
        makeButton(body, 'COPIER LE DISCORD', UDim2.fromOffset(5, 72), UDim2.fromOffset(175, 40), function()
            if type(setclipboard) == 'function' then
                setclipboard(discord)
                label('Lien copié.', 120)
            else
                label('Copie le lien affiché ci-dessus.', 120)
            end
        end, true)
    end
end

for i, name in ipairs({'Scripts', 'Anti-Ban', 'VOC', 'Discord'}) do
    makeButton(tabs, name, UDim2.new((i - 1) / 4, 1, 0, 0), UDim2.new(.25, -4, 0, 36), function()
        show(name)
    end)
end

local minimized = false
local minimize
minimize = makeButton(main, '−', UDim2.new(1, -75, 0, 11), UDim2.fromOffset(28, 28), function()
    minimized = not minimized
    tabs.Visible = not minimized
    body.Visible = not minimized
    main.Size = UDim2.fromOffset(360, minimized and 52 or 346)
    minimize.Text = minimized and '+' or '−'
end)
makeButton(main, 'X', UDim2.new(1, -40, 0, 11), UDim2.fromOffset(28, 28), function()
    ui:Destroy()
end)
show('Scripts')

-- Animation et accès au menu
local gate = new('Frame', {
    Size = UDim2.fromOffset(350, 230),
    Position = UDim2.new(.5, -175, .5, -115),
    BackgroundColor3 = Color3.fromRGB(20, 19, 29),
    BorderSizePixel = 0
}, ui)
round(gate)

new('TextLabel', {
    Text = 'EMPIRE DES CLOWNS',
    Size = UDim2.new(1, -20, 0, 50),
    Position = UDim2.fromOffset(10, 12),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(245, 240, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 19
}, gate)

local loadingText = new('TextLabel', {
    Text = 'CHARGEMENT... 0%',
    Size = UDim2.new(1, -30, 0, 35),
    Position = UDim2.fromOffset(15, 75),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(230, 224, 245),
    Font = Enum.Font.GothamSemibold,
    TextSize = 14
}, gate)

local barBackground = new('Frame', {
    Size = UDim2.new(1, -40, 0, 17),
    Position = UDim2.fromOffset(20, 125),
    BackgroundColor3 = Color3.fromRGB(43, 40, 59),
    BorderSizePixel = 0
}, gate)
round(barBackground)

local progress = new('Frame', {
    Size = UDim2.fromScale(0, 1),
    BackgroundColor3 = Color3.fromRGB(109, 68, 164),
    BorderSizePixel = 0
}, barBackground)
round(progress)

local passwordInput = new('TextBox', {
    Size = UDim2.new(1, -40, 0, 40),
    Position = UDim2.fromOffset(20, 90),
    BackgroundColor3 = Color3.fromRGB(43, 40, 59),
    TextColor3 = Color3.fromRGB(245, 240, 255),
    PlaceholderText = 'Mot de passe...',
    PlaceholderColor3 = Color3.fromRGB(165, 155, 185),
    Text = '',
    TextSize = 14,
    Font = Enum.Font.Gotham,
    ClearTextOnFocus = false,
    Visible = false
}, gate)
round(passwordInput)

local errorText = new('TextLabel', {
    Text = '',
    Size = UDim2.new(1, -30, 0, 25),
    Position = UDim2.fromOffset(15, 183),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 100, 115),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    Visible = false
}, gate)

local unlocked = false
local function verify()
    if unlocked then return end
    if passwordInput.Text == 'empire' then
        unlocked = true
        gate:Destroy()
        main.Visible = true
    else
        errorText.Text = 'Mot de passe incorrect !'
        errorText.Visible = true
        passwordInput.Text = ''
    end
end

local accessButton = makeButton(
    gate,
    'ACCÉDER AU MENU',
    UDim2.fromOffset(70, 143),
    UDim2.fromOffset(210, 36),
    verify,
    true
)
accessButton.Visible = false

passwordInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then verify() end
end)

task.spawn(function()
    local startTime = os.clock()
    while gate.Parent do
        local elapsed = os.clock() - startTime
        local percent = math.clamp(elapsed / 5, 0, 1)
        progress.Size = UDim2.fromScale(percent, 1)
        loadingText.Text = 'CHARGEMENT... ' .. math.floor(percent * 100) .. '%'
        if percent >= 1 then break end
        task.wait()
    end

    if not gate.Parent then return end

    loadingText.Text = 'ENTRE LE MOT DE PASSE'
    barBackground.Visible = false
    passwordInput.Visible = true
    accessButton.Visible = true
end)

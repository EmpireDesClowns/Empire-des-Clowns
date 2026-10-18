-- EMPIRE DES CLOWNS V2 - Menu communautaire
-- Les scripts tiers viennent d'Internet et peuvent changer.

local Players = game:GetService('Players')
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
local password = 'empire'

local function new(class, props, parentObj)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parentObj
    return obj
end

local function round(obj)
    new('UICorner', {
        CornerRadius = UDim.new(0, 9)
    }, obj)
end

local ui = new('ScreenGui', {
    Name = 'EmpireDesClownsV2',
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 100
}, parent)

-- Adapte les fenêtres aux écrans de téléphone.
local function mobileScale(frame, width, height)
    local scale = new('UIScale', {Scale = 1}, frame)

    local function update()
        local camera = workspace.CurrentCamera
        if not camera then return end

        local viewport = camera.ViewportSize
        if viewport.X <= 0 or viewport.Y <= 0 then return end

        scale.Scale = math.min(
            1,
            (viewport.X - 24) / width,
            (viewport.Y - 24) / height
        )
    end

    update()

    local camera = workspace.CurrentCamera
    if camera then
        camera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
            if frame.Parent then update() end
        end)
    end
end

local main = new('Frame', {
    Size = UDim2.fromOffset(360, 346),
    AnchorPoint = Vector2.new(.5, .5),
    Position = UDim2.fromScale(.5, .5),
    BackgroundColor3 = Color3.fromRGB(20, 19, 29),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Visible = false
}, ui)
round(main)
mobileScale(main, 360, 346)

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
        BackgroundColor3 = purple
            and Color3.fromRGB(109, 68, 164)
            or Color3.fromRGB(43, 40, 59)
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

            if not f then
                error(parseErr or 'Impossible de compiler le script')
            end

            f()
        end)

        if statusLabel and statusLabel.Parent then
            statusLabel.Text = ok
                and (entry.name .. ' : lancement demandé.')
                or ('Erreur : ' .. tostring(err):sub(1, 85))
        end

        busy = false
    end)
end

local function show(page)
    for _, child in ipairs(body:GetChildren()) do
        child:Destroy()
    end

    if page == 'Scripts' then
        label('SCRIPTS DISPONIBLES', 0)

        for i, entry in ipairs(sources) do
            local y = 37 + (i - 1) * 52
            label(entry.name, y)

            makeButton(
                body,
                'EXÉCUTER',
                UDim2.new(1, -110, 0, y),
                UDim2.fromOffset(105, 35),
                function()
                    execute(entry)
                end,
                true
            )
        end

        statusLabel = label(
            'Les scripts externes ne sont pas vérifiés ici.',
            195,
            45
        )

    elseif page == 'Anti-Ban' then
        label(
            'Aucun script ne garantit une protection contre les bannissements.',
            6,
            65
        )

    elseif page == 'VOC' then
        label('Espace des réglages vocaux à venir.', 6, 65)

    else
        label('Notre Discord : ' .. discord, 6, 60)

        makeButton(
            body,
            'COPIER LE DISCORD',
            UDim2.fromOffset(5, 72),
            UDim2.fromOffset(175, 40),
            function()
                if type(setclipboard) == 'function' then
                    setclipboard(discord)
                    label('Lien copié.', 120)
                else
                    label('Copie le lien affiché ci-dessus.', 120)
                end
            end,
            true
        )
    end
end

for i, name in ipairs({
    'Scripts',
    'Anti-Ban',
    'VOC',
    'Discord'
}) do
    makeButton(
        tabs,
        name,
        UDim2.new((i - 1) / 4, 1, 0, 0),
        UDim2.new(.25, -4, 0, 36),
        function()
            show(name)
        end
    )
end

local minimized = false
local minimize

minimize = makeButton(
    main,
    '−',
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
        minimize.Text = minimized and '+' or '−'
    end
)

makeButton(
    main,
    'X',
    UDim2.new(1, -40, 0, 11),
    UDim2.fromOffset(28, 28),
    function()
        ui:Destroy()
    end
)

show('Scripts')

-- ÉCRAN DE CHARGEMENT ET MOT DE PASSE

local gate = new('Frame', {
    Size = UDim2.fromOffset(350, 285),
    AnchorPoint = Vector2.new(.5, .5),
    Position = UDim2.fromScale(.5, .5),
    BackgroundColor3 = Color3.fromRGB(20, 19, 29),
    BorderSizePixel = 0
}, ui)

round(gate)
mobileScale(gate, 350, 285)

new('TextLabel', {
    Text = 'EMPIRE DES CLOWNS',
    Size = UDim2.new(1, -20, 0, 42),
    Position = UDim2.fromOffset(10, 13),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(245, 240, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 19
}, gate)

local loadingText = new('TextLabel', {
    Text = 'CHARGEMENT... 0%',
    Size = UDim2.new(1, -30, 0, 35),
    Position = UDim2.fromOffset(15, 95),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(230, 224, 245),
    Font = Enum.Font.GothamSemibold,
    TextSize = 15
}, gate)

local barBackground = new('Frame', {
    Size = UDim2.new(1, -40, 0, 19),
    Position = UDim2.fromOffset(20, 145),
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

local discordInfo = new('TextLabel', {
    Text = '🔐 Pour obtenir le mot de passe,\nrejoins notre Discord !',
    Size = UDim2.new(1, -30, 0, 48),
    Position = UDim2.fromOffset(15, 60),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(230, 224, 245),
    Font = Enum.Font.GothamSemibold,
    TextSize = 13,
    TextWrapped = true,
    Visible = false
}, gate)

local discordButton = makeButton(
    gate,
    'COPIER LE LIEN DISCORD',
    UDim2.fromOffset(55, 111),
    UDim2.fromOffset(240, 34),
    function()
        if type(setclipboard) == 'function' then
            setclipboard(discord)
        end
    end,
    true
)
discordButton.Visible = false

local passwordInput = new('TextBox', {
    Size = UDim2.new(1, -40, 0, 39),
    Position = UDim2.fromOffset(20, 156),
    BackgroundColor3 = Color3.fromRGB(43, 40, 59),
    TextColor3 = Color3.fromRGB(245, 240, 255),
    PlaceholderText = 'Entre le mot de passe...',
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
    Position = UDim2.fromOffset(15, 246),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 100, 115),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    Visible = false
}, gate)

local unlocked = false

local function verify()
    if unlocked then return end

    if passwordInput.Text == password then
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
    UDim2.fromOffset(70, 204),
    UDim2.fromOffset(210, 36),
    verify,
    true
)
accessButton.Visible = false

passwordInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        verify()
    end
end)

-- Animation de 0 à 100 % en exactement 5 secondes
task.spawn(function()
    local startTime = os.clock()

    while gate.Parent do
        local elapsed = os.clock() - startTime
        local percent = math.clamp(elapsed / 5, 0, 1)

        progress.Size = UDim2.fromScale(percent, 1)

        loadingText.Text = 'CHARGEMENT... '
            .. math.floor(percent * 100)
            .. '%'

        if percent >= 1 then
            break
        end

        task.wait()
    end

    if not gate.Parent then return end

    loadingText.Text = 'CHARGEMENT TERMINÉ !'

    task.wait(.3)

    if not gate.Parent then return end

    loadingText.Visible = false
    barBackground.Visible = false

    discordInfo.Visible = true
    discordButton.Visible = true
    passwordInput.Visible = true
    accessButton.Visible = true
end)

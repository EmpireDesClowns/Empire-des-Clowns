
-- Empire des Clowns V3 | Interface communautaire Roblox
-- Interface uniquement : aucun script distant n'est execute automatiquement.
local Players = game:GetService('Players')
local TweenService = game:GetService('TweenService')
local UIS = game:GetService('UserInputService')
local player = Players.LocalPlayer
if not player then return end
local parent = player:WaitForChild('PlayerGui')
local previous = parent:FindFirstChild('EmpireDesClownsV3')
if previous then previous:Destroy() end

local entries = {
    {name = 'Beanz', url = 'https://beanzz.wtf/Main.lua', about = 'Script externe fourni par la communaute.'},
    {name = 'Beanz AutoRob', url = 'https://beanzz.wtf/Autorob.lua', about = 'Script externe : contenu non verifie.'},
    {name = 'Vortex', url = 'https://api.getvortex.vip/scripts/VortexMain', about = 'Script externe : contenu non verifie.'}
}
local discordURL = 'https://discord.gg/KN4fUU252y'
local favorites, history = {}, {}
local palette = {
    Violet = Color3.fromRGB(150, 97, 247),
    Rouge = Color3.fromRGB(234, 78, 106),
    Bleu = Color3.fromRGB(78, 160, 249),
    Noir = Color3.fromRGB(126, 132, 149)
}
local accent = palette.Violet
local bg = Color3.fromRGB(14, 15, 23)
local panel = Color3.fromRGB(28, 30, 43)
local pale = Color3.fromRGB(193, 195, 213)
local white = Color3.fromRGB(247, 244, 255)
local settings = {animations = true, sounds = false, compact = false}
local gui = Instance.new('ScreenGui')
gui.Name = 'EmpireDesClownsV3'
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent

local function create(kind, props, root)
    local obj = Instance.new(kind)
    for key, value in pairs(props or {}) do obj[key] = value end
    obj.Parent = root
    return obj
end
local function rounded(obj, radius)
    create('UICorner', {CornerRadius = UDim.new(0, radius or 10)}, obj)
end
local function tween(obj, props, seconds)
    if not settings.animations then
        for key, value in pairs(props) do obj[key] = value end
        return
    end
    TweenService:Create(obj, TweenInfo.new(seconds or 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end
local function text(root, title, height, size, color, bold)
    return create('TextLabel', {
        Size = UDim2.new(1, 0, 0, height or 24), BackgroundTransparency = 1,
        Text = title, Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = size or 13, TextColor3 = color or white,
        TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left
    }, root)
end
local function button(root, caption, color, callback)
    local btn = create('TextButton', {
        Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = color or panel,
        BorderSizePixel = 0, Text = caption, TextColor3 = white,
        Font = Enum.Font.GothamSemibold, TextSize = 12, AutoButtonColor = false
    }, root)
    rounded(btn, 9)
    btn.MouseEnter:Connect(function() tween(btn, {BackgroundTransparency = 0.2}, .12) end)
    btn.MouseLeave:Connect(function() tween(btn, {BackgroundTransparency = 0}, .12) end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end
local function vertical(root, gap)
    return create('UIListLayout', {Padding = UDim.new(0, gap or 8), SortOrder = Enum.SortOrder.LayoutOrder}, root)
end
local function pad(root, n)
    create('UIPadding', {PaddingTop = UDim.new(0,n),PaddingBottom = UDim.new(0,n),PaddingLeft = UDim.new(0,n),PaddingRight = UDim.new(0,n)},root)
end

-- Introduction de chargement, sans attente artificielle de reseau
local splash = create('Frame',{Size = UDim2.fromScale(1,1), BackgroundColor3 = bg, ZIndex = 20},gui)
local intro = create('Frame',{AnchorPoint = Vector2.new(.5,.5), Position = UDim2.fromScale(.5,.47), Size = UDim2.new(.88,0,0,180), BackgroundTransparency = 1, ZIndex=21},splash)
create('UISizeConstraint',{MaxSize=Vector2.new(400,200)},intro)
local introTitle = create('TextLabel',{Size=UDim2.new(1,0,0,60),BackgroundTransparency=1,Text='♛  EMPIRE DES CLOWNS',Font=Enum.Font.GothamBold,TextColor3=white,TextScaled=true,ZIndex=22},intro)
local subtitle = create('TextLabel',{Position=UDim2.fromOffset(0,64),Size=UDim2.new(1,0,0,25),BackgroundTransparency=1,Text='INITIALISATION DU HUB V3',Font=Enum.Font.Gotham,TextSize=12,TextColor3=pale,ZIndex=22},intro)
local progressBack=create('Frame',{Position=UDim2.new(0,0,0,116),Size=UDim2.new(1,0,0,10),BackgroundColor3=panel,BorderSizePixel=0,ZIndex=22},intro)
rounded(progressBack,8)
local progress=create('Frame',{Size=UDim2.fromScale(0,1),BackgroundColor3=accent,BorderSizePixel=0,ZIndex=23},progressBack)
rounded(progress,8)
local percentage=create('TextLabel',{Position=UDim2.new(0,0,0,135),Size=UDim2.new(1,0,0,22),Text='0 %',TextColor3=pale,BackgroundTransparency=1,Font=Enum.Font.GothamBold,TextSize=13,ZIndex=22},intro)

local main=create('Frame',{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(400,480),BackgroundColor3=bg,BorderSizePixel=0,Visible=false,ClipsDescendants=true},gui)
rounded(main,15)
local limit=create('UISizeConstraint',{MinSize=Vector2.new(285,100),MaxSize=Vector2.new(440,570)},main)
local stroke=create('UIStroke',{Color=accent,Thickness=1,Transparency=.4},main)
local header=create('Frame',{Size=UDim2.new(1,0,0,57),BackgroundColor3=panel,BorderSizePixel=0},main)
local heading=create('TextLabel',{Position=UDim2.fromOffset(13,6),Size=UDim2.new(1,-100,0,27),BackgroundTransparency=1,Text='♛ EMPIRE DES CLOWNS',Font=Enum.Font.GothamBold,TextColor3=white,TextSize=15,TextXAlignment=Enum.TextXAlignment.Left},header)
create('TextLabel',{Position=UDim2.fromOffset(14,31),Size=UDim2.new(1,-100,0,16),BackgroundTransparency=1,Text='PREMIUM HUB • V3.0',TextColor3=pale,Font=Enum.Font.Gotham,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left},header)
local mini=create('TextButton',{Position=UDim2.new(1,-76,0,14),Size=UDim2.fromOffset(27,27),BackgroundColor3=bg,Text='−',TextSize=19,TextColor3=white},header)
rounded(mini,7)
local close=create('TextButton',{Position=UDim2.new(1,-41,0,14),Size=UDim2.fromOffset(27,27),BackgroundColor3=bg,Text='×',TextSize=19,TextColor3=white},header)
rounded(close,7)
local tabBar=create('ScrollingFrame',{Position=UDim2.fromOffset(8,65),Size=UDim2.new(1,-16,0,37),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,ScrollingDirection=Enum.ScrollingDirection.X,CanvasSize=UDim2.fromOffset(570,0)},main)
local tabLayout=create('UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,5)},tabBar)
local body=create('ScrollingFrame',{Position=UDim2.fromOffset(10,111),Size=UDim2.new(1,-20,1,-122),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromOffset(0,0)},main)
local bodyLayout=vertical(body,9)
local notice=create('TextLabel',{AnchorPoint=Vector2.new(.5,1),Position=UDim2.new(.5,0,1,-12),Size=UDim2.new(1,-30,0,37),BackgroundColor3=panel,TextColor3=white,TextSize=11,Font=Enum.Font.Gotham,Text='',Visible=false,ZIndex=10},main)
rounded(notice,8)
local noticeSerial=0
local function notify(s)
    noticeSerial=noticeSerial+1
    local id=noticeSerial
    notice.Text=s; notice.Visible=true
    task.delay(2.4,function() if noticeSerial==id and notice.Parent then notice.Visible=false end end)
end
local function changeAccent(color)
    accent=color
    tween(stroke,{Color=color},.2)
end
local function clear()
    for _,child in ipairs(body:GetChildren()) do if child ~= bodyLayout then child:Destroy() end end
    body.CanvasPosition=Vector2.zero
end
local function section(name)
    text(body,name,28,15,white,true)
end
local function panelCard(root)
    local f=create('Frame',{Size=UDim2.new(1,-3,0,70),BackgroundColor3=panel,BorderSizePixel=0},root)
    rounded(f,10); pad(f,10)
    return f
end
local function copy(value, message)
    if type(setclipboard)=='function' then
        setclipboard(value); notify(message or 'Copié !')
    else
        notify('Copie le lien affiche dans le menu.')
    end
end
local tab='Accueil'
local render
local function scriptCard(entry)
    local card=panelCard(body)
    card.Size=UDim2.new(1,-3,0,91)
    local name=text(card,entry.name,21,14,white,true)
    name.Size=UDim2.new(1,-20,0,21)
    local description=text(card,entry.about,20,10,pale)
    description.Position=UDim2.fromOffset(0,22)
    description.Size=UDim2.new(1,0,0,18)
    local actions=create('Frame',{Position=UDim2.new(0,0,0,47),Size=UDim2.new(1,0,0,30),BackgroundTransparency=1},card)
    local row=create('UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,6)},actions)
    local open=button(actions,'LIEN',accent,function()
        copy(entry.url,'Adresse du script copiée')
        table.insert(history,1,entry.name)
        if #history>15 then table.remove(history) end
    end)
    open.Size=UDim2.new(.46,-4,1,0)
    local favorite=button(actions,favorites[entry.name] and '★ FAVORI' or '☆ FAVORI',panel,function()
        favorites[entry.name]=not favorites[entry.name]
        notify(favorites[entry.name] and 'Ajouté aux favoris' or 'Retiré des favoris')
        render(tab)
    end)
    favorite.Size=UDim2.new(.54,-4,1,0)
end
render=function(nextTab)
    tab=nextTab; clear()
    if tab=='Accueil' then
        section('Bienvenue dans l’Empire !')
        local cards=panelCard(body)
        cards.Size=UDim2.new(1,-3,0,95)
        text(cards,'3 scripts référencés',27,17,white,true)
        local total=0; for _ in pairs(favorites) do total=total+1 end
        text(cards,tostring(total)..' favoris   •   '..tostring(#history)..' liens consultés',25,13,pale)
        text(body,'Choisis une catégorie pour explorer le hub.',42,12,pale)
    elseif tab=='Scripts' or tab=='Favoris' then
        section(tab=='Scripts' and 'Bibliothèque de scripts' or 'Mes favoris')
        if tab=='Scripts' then
            local search=create('TextBox',{Size=UDim2.new(1,-3,0,39),BackgroundColor3=panel,TextColor3=white,PlaceholderColor3=pale,PlaceholderText='Rechercher un script...',ClearTextOnFocus=false,Text='',TextSize=13,Font=Enum.Font.Gotham},body)
            rounded(search,9)
            local results=create('Frame',{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},body)
            local layout=vertical(results,8)
            local function fill(q)
                for _,child in ipairs(results:GetChildren()) do if child~=layout then child:Destroy() end end
                -- Utiliser le meme composant visuel avec parent temporaire
                local old=body
                body=results
                for _,entry in ipairs(entries) do
                    if string.find(string.lower(entry.name),string.lower(q),1,true) then scriptCard(entry) end
                end
                body=old
            end
            search:GetPropertyChangedSignal('Text'):Connect(function() fill(search.Text) end)
            fill('')
        else
            local count=0
            for _,entry in ipairs(entries) do
                if favorites[entry.name] then scriptCard(entry); count=count+1 end
            end
            if count==0 then text(body,'Aucun favori pour le moment.',50,13,pale) end
        end
    elseif tab=='Historique' then
        section('Historique des liens consultés')
        if #history==0 then text(body,'Aucun lien consulté.',40,13,pale) end
        for i,name in ipairs(history) do text(body,tostring(i)..'. '..name,27,13,pale) end
        button(body,'EFFACER L’HISTORIQUE',panel,function() table.clear(history); render(tab) end)
    elseif tab=='Anti-Ban' then
        section('Sécurité et informations')
        text(body,'Aucun anti-ban garanti : utiliser des scripts inconnus peut compromettre ton compte ou provoquer une sanction.',110,13,pale)
    elseif tab=='VOC' then
        section('Espace vocal')
        text(body,'Réglages vocaux à venir. Ce menu ne peut pas modifier les autorisations vocales de Roblox.',85,13,pale)
    elseif tab=='Discord' then
        section('Rejoindre la communauté')
        text(body,discordURL,46,13,pale)
        button(body,'COPIER LE LIEN DISCORD',accent,function() copy(discordURL,'Invitation Discord copiée') end)
    elseif tab=='Paramètres' then
        section('Personnalisation')
        button(body,'Animations : '..(settings.animations and 'ON' or 'OFF'),panel,function()
            settings.animations=not settings.animations; render(tab)
        end)
        button(body,'Sons : '..(settings.sounds and 'ON' or 'OFF'),panel,function()
            settings.sounds=not settings.sounds; notify('Option sonore mémorisée pour cette session'); render(tab)
        end)
        button(body,'Taille : '..(settings.compact and 'compacte' or 'normale'),panel,function()
            settings.compact=not settings.compact
            tween(main,{Size=UDim2.fromOffset(settings.compact and 315 or 400,settings.compact and 420 or 480)},.25)
            render(tab)
        end)
        text(body,'Thème de couleur',27,14,white,true)
        for name,color in pairs(palette) do
            button(body,name,color,function() changeAccent(color); notify('Thème '..name..' appliqué') end)
        end
    end
end
for _,name in ipairs({'Accueil','Scripts','Favoris','Historique','Anti-Ban','VOC','Discord','Paramètres'}) do
    local b=button(tabBar,name,panel,function() render(name) end)
    b.Size=UDim2.fromOffset(math.max(65,#name*8+17),35)
end
tabBar.CanvasSize=UDim2.fromOffset(tabLayout.AbsoluteContentSize.X+10,0)
tabLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
    tabBar.CanvasSize=UDim2.fromOffset(tabLayout.AbsoluteContentSize.X+10,0)
end)

-- Glisser-deposer sur ecran tactile ou souris via entete
local dragging,startMouse,startPos=false,nil,nil
header.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true; startMouse=input.Position; startPos=main.Position
        input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and startMouse and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local delta=input.Position-startMouse
        main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)
local minimized=false
mini.MouseButton1Click:Connect(function()
    minimized=not minimized
    tabBar.Visible=not minimized; body.Visible=not minimized
    tween(main,{Size=UDim2.fromOffset(settings.compact and 315 or 400,minimized and 57 or (settings.compact and 420 or 480))},.22)
    mini.Text=minimized and '+' or '−'
end)
close.MouseButton1Click:Connect(function() gui:Destroy() end)
render('Accueil')

-- Le pourcentage represente la preparation de l'interface, pas un telechargement externe
for _,p in ipairs({15,32,51,74,93,100}) do
    percentage.Text=tostring(p)..' %'
    tween(progress,{Size=UDim2.fromScale(p/100,1)},.17)
    task.wait(.20)
end
percentage.Text='Empire des Clowns prêt !'
task.wait(.35)
main.Visible=true
main.Size=UDim2.fromOffset(380,450)
tween(main,{Size=UDim2.fromOffset(400,480)},.3)
splash:Destroy()
notify('Bienvenue dans Empire des Clowns V3 !')

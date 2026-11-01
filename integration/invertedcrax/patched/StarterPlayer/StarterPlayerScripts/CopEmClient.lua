-- GoldenBookTitleFix_v2
-- PlumberFix_v2
-- CraxBookBulk_v1
-- FantasticBook_v1
-- GhostyBookNames_v3
-- CopEmSkillBookChurch_v15 — grimoire 3D + HUD de lecture
-- CraxPrestige_v1
-- CopEmLogoCorrection_v2
-- CopEmShopPro_v1 — interface seule; toutes les transactions restent validées par CraxSkillServer.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local HttpService=game:GetService("HttpService")
local SoundService=game:GetService("SoundService")
local UserInputService=game:GetService("UserInputService")
local ContentProvider=game:GetService("ContentProvider")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")
local config=require(RS:WaitForChild("CraxSkillCatalog"))
local catalog=require(RS:WaitForChild("CraxCatalog"))
local style=require(RS:WaitForChild("CopEmShopStyle"))
local ShopLogos=require(RS:WaitForChild("CopEmShopLogos"))
local Prestige=require(RS:WaitForChild("CraxPrestigeVisuals"))
local smileAtlas=RS:WaitForChild("CopEmBranding"):WaitForChild("SmileLevelsAtlas")
local remote=RS:WaitForChild("CraxSkillEvent")
local levels=player:WaitForChild("CraxSkillLevels")
local trophyModule=RS:FindFirstChild("CraxTrophyIcons")
local TrophyIcons=trophyModule and require(trophyModule)
local old=pg:FindFirstChild("CopEmGui");if old then old:Destroy()end
local C={bg=Color3.fromRGB(8,11,17),card=Color3.fromRGB(22,28,40),gold=Color3.fromRGB(255,205,91),blue=Color3.fromRGB(76,209,242),white=Color3.fromRGB(251,248,237),muted=Color3.fromRGB(174,184,202),red=Color3.fromRGB(245,63,72)}
local metals={Color3.fromRGB(214,147,89),Color3.fromRGB(215,232,246),C.gold,Color3.fromRGB(151,237,255)}
local rarity={Commun=Color3.fromRGB(126,214,255),Rare=Color3.fromRGB(255,158,52),["Épique"]=Color3.fromRGB(192,116,255),Epique=Color3.fromRGB(192,116,255),["LEGENDAIRE"]=C.gold,Secret=Color3.fromRGB(234,144,255),["Édition limitée"]=Color3.fromRGB(112,255,78)}
local gui
local shineEntries={};local previews={};local particles={};local actionButtons={};local tabs={}
local currentTab="News";local currentCrax="Crax_Monster";local pending;local rebuild;local buildScheduled=false
local skillPopupOpen=false
local bookOpened=false;local gaugeFill;local gaugeCaption;local bookPrompt;local switching=false
local hold;local transaction;local celebration;local cancelHold
local nodes={};local links={};local neonEntries={};local bookStrip
local HOLD_SECONDS=1.8
local paymentPopup;local suppressSealClickUntil=0
local bookNav={};local bookDust={};local bookDustStarted=0;local chapterSnapshot;local chapterShadow;local bookScale;local dustLast=0
local selectedSkill;local book;local turnPage;local heroView;local cinema
local confirmedLevels={}
local pulseEntries={};local viewEpoch=0;local pageTurningUntil=0
local sharedConnections={}
local function connect(signal,callback)
 local connection=signal:Connect(callback);sharedConnections[#sharedConnections+1]=connection
 return connection
end
local function make(class,props,parent)local o=Instance.new(class);for k,v in pairs(props)do o[k]=v end;o.Parent=parent;return o end
local function round(o,r)make("UICorner",{CornerRadius=UDim.new(0,r)},o)end
local function text(parent,value,x,y,w,h,size,color)
 return make("TextLabel",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundTransparency=1,Text=value,
 Font=Enum.Font.GothamBold,TextSize=size,TextColor3=color or C.white,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true},parent)
end
local function gradient(parent,a,b,rotation)return make("UIGradient",{Rotation=rotation or 90,Color=ColorSequence.new(a,b)},parent)end
local function rim(parent,color)
 local stroke=make("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Color=Color3.new(1,1,1),Thickness=2.2,Transparency=.12},parent)
 local g=make("UIGradient",{Rotation=35,Color=ColorSequence.new({ColorSequenceKeypoint.new(0,color:Lerp(Color3.new(0,0,0),.5)),
  ColorSequenceKeypoint.new(.4,color),ColorSequenceKeypoint.new(.5,Color3.new(1,1,1)),ColorSequenceKeypoint.new(.6,color),ColorSequenceKeypoint.new(1,color:Lerp(Color3.new(0,0,0),.5))})},stroke)
 shineEntries[#shineEntries+1]={gradient=g,parent=parent};return stroke
end
local function card(parent,x,y,w,h,color)
 local f=make("Frame",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundColor3=C.card,BorderSizePixel=0,ClipsDescendants=true},parent)
 round(f,15);gradient(f,color:Lerp(C.bg,.87),C.bg,115);rim(f,color);return f
end
local sounds={}
for name,pitch in pairs({Hover=1.25,Click=1,Success=.9,Open=.75})do
 sounds[name]=make("Sound",{Name="CopEm"..name,SoundId="rbxassetid://113397864512278",Volume=name=="Hover"and .045 or .13,PlaybackSpeed=pitch},pg)
end
for name,pitch in pairs({Page=.72,Reveal=1.4,Max=.5})do
 sounds[name]=make("Sound",{Name="CopEm"..name,SoundId=(name=="Page"and style.SkillPageSoundId or name=="Reveal"and style.SkillRevealSoundId or style.SkillMaxSoundId)or sounds.Click.SoundId,Volume=name=="Max"and .23 or .12,PlaybackSpeed=pitch},pg)
end
if type(style.SkillSuccessSoundId)=="string"and style.SkillSuccessSoundId~=""then sounds.Success.SoundId=style.SkillSuccessSoundId end
sounds.Charge=make("Sound",{Name="CopEmCharge",SoundId=style.SkillChargeSoundId or sounds.Click.SoundId,Volume=.075,PlaybackSpeed=.65,Looped=true},pg)
-- SoundService effect playback does not mute existing music or replace combat sounds.
local lastHover=0
local function play(name)
 if name=="Hover"then if os.clock()-lastHover<.08 then return end;lastHover=os.clock()end
 local sound=sounds[name];sound:Stop();SoundService:PlayLocalSound(sound)
end
task.spawn(function()pcall(function()ContentProvider:PreloadAsync({sounds.Hover,sounds.Click,sounds.Success,sounds.Open})end)end)
local function button(parent,value,x,y,w,h,color,callback)
 local b=make("TextButton",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundColor3=color,
  BorderSizePixel=0,AutoButtonColor=false,Text=value,TextColor3=C.white,Font=Enum.Font.GothamBlack,TextSize=16},parent)
 round(b,9);gradient(b,color:Lerp(Color3.new(1,1,1),.15),color:Lerp(C.bg,.35));local edge=rim(b,color)
 local scale=make("UIScale",{Scale=1},b);local tween
 local function animate(v)if tween then tween:Cancel()end;tween=TweenService:Create(scale,TweenInfo.new(.13,Enum.EasingStyle.Quad),{Scale=v});tween:Play()end
 b.MouseEnter:Connect(function()if b.Active then play("Hover");animate(1.035);edge.Transparency=0 end end)
 b.MouseLeave:Connect(function()animate(1);edge.Transparency=.12 end)
 b.MouseButton1Down:Connect(function()if b.Active then animate(.97)end end)
 b.MouseButton1Up:Connect(function()animate(1)end)
 b.Activated:Connect(function()if b.Active then play("Click");callback()end end);return b
end
local function circleCharge(parent,color)
 local frame=make("Frame",{Name="ContinuousChargeRing",Position=UDim2.fromOffset(-8,-8),Size=UDim2.fromOffset(78,78),BackgroundTransparency=1,ZIndex=5},parent)
 local base=make("Frame",{Position=UDim2.fromOffset(2,2),Size=UDim2.fromOffset(74,74),BackgroundTransparency=1},frame);round(base,100)
 make("UIStroke",{Thickness=3,Color=Color3.fromRGB(100,73,35),Transparency=.6},base)
 local masks={}
 for i=1,2 do
  local clip=make("Frame",{Position=UDim2.fromOffset(i==1 and 39 or 0,0),Size=UDim2.fromOffset(39,78),ClipsDescendants=true,BackgroundTransparency=1,ZIndex=6},frame)
  local circle=make("Frame",{Position=UDim2.fromOffset(i==1 and -37 or 2,2),Size=UDim2.fromOffset(74,74),BackgroundTransparency=1},clip);round(circle,100)
  local edge=make("UIStroke",{Thickness=3,Color=color,Transparency=0},circle)
  local mask=make("UIGradient",{Rotation=0,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(.499,0),NumberSequenceKeypoint.new(.501,1),NumberSequenceKeypoint.new(1,1)})},edge)
  masks[i]={clip=clip,mask=mask,edge=edge}
 end
 local ring={}
 function ring:Set(value,newColor)
  value=math.clamp(value,0,1)
  masks[1].clip.Visible=value>0;masks[2].clip.Visible=value>.5
  masks[1].mask.Rotation=math.min(value*2,1)*180
  masks[2].mask.Rotation=180+math.max(value*2-1,0)*180
  if newColor then for _,e in ipairs(masks)do e.edge.Color=newColor end end
 end
 ring:Set(0);return ring
end
-- SpideyBook_v1
local SpideyIcons=require(RS:WaitForChild("CraxSpideyIcons"))
local function emblem(parent,kind,color,x,y,size)
 if type(kind)=='string'and kind:sub(1,8)=='Inverted'then
  local symbols={InvertedHack='HACK',InvertedCopy='COPY',InvertedRewind='CTRL-Z',Inverted404='404'}
  local f=make('Frame',{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(size,size),BackgroundColor3=Color3.fromRGB(13,15,20),BorderSizePixel=0},parent);round(f,math.max(8,size*.2))
  make('UIStroke',{Color=Color3.fromRGB(240,238,228),Thickness=2},f)
  make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text=symbols[kind]or'×',Font=Enum.Font.GothamBlack,TextScaled=true,TextColor3=Color3.fromRGB(245,242,232)},f)
  return
 end
 local f=make("Frame",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(size,size),BackgroundTransparency=1,Active=false},parent)
 -- FleauSkillImages_v1
 do
  local catalog=require(game:GetService("ReplicatedStorage"):WaitForChild("CraxSkillCatalog"))
  local spec=catalog.Crax_Fleau
  local images={
   "rbxassetid://96136223791989",
   "rbxassetid://135838189195225",
   "rbxassetid://94632742584795",
  }
  if spec and spec.Upgrades then
   for level=1,3 do
    local upgrade=spec.Upgrades[level]
    if upgrade and upgrade.Id~=nil and kind==upgrade.Id then
     local image=Instance.new("ImageLabel")
     image.Name="FleauSkillIcon"..level
     image.BackgroundTransparency=1
     image.Size=UDim2.fromScale(1,1)
     image.Image=images[level]
     image.ScaleType=Enum.ScaleType.Fit
     image.ZIndex=4
     image.Parent=f
     return
    end
   end
  end
 end

 -- PlumberSkillImages_v1
 local plumber=require(RS:WaitForChild("CraxSkillCatalog")).Crax_Plumber
 local images={
  "rbxassetid://86593576514423",
  "rbxassetid://75663879647026",
  "rbxassetid://121269049718514",
 }

 if plumber and plumber.Upgrades then
  for level=1,3 do
   local upgrade=plumber.Upgrades[level]

   if upgrade and upgrade.Id~=nil and upgrade.Id==kind then
    make("ImageLabel",{
     Name="PlumberSkillIcon_Level"..level,
     BackgroundTransparency=1,
     Size=UDim2.fromScale(1,1),
     Image=images[level],
     ScaleType=Enum.ScaleType.Fit,
     Active=false,
     ZIndex=4,
    },f)
    return
   end
  end
 end

 -- GoldenPlumberTrophyPopup_v1
 local skills=require(RS:WaitForChild("CraxSkillCatalog"))
 local victories=require(RS:WaitForChild("CraxVictoryCatalog"))
 local isTrophy=false

 for _,craxId in ipairs({"Crax_Plumber","Crax_Golden"})do
  local spec=skills[craxId]
  local maximum=spec and spec.Upgrades and spec.Upgrades[4]
  local victory=victories[craxId]

  if kind~=nil and (
   maximum and maximum.Id~=nil and kind==maximum.Id
   or victory and victory.Id~=nil and kind==victory.Id
   or victory and victory.TrophyId~=nil and kind==victory.TrophyId
  )then
   isTrophy=true
   break
  end
 end

 if isTrophy then
  local image=require(RS:WaitForChild("CraxTrophyIcons")).Build(f,true)

  if image then
   image.Visible=true
   image.ImageTransparency=0
   image.ScaleType=Enum.ScaleType.Fit
   image.ZIndex=4
  else
   warn("Image du trophée absente : vérifier CraxTrophyImages.Acquired.")
  end

  return
 end

 -- GoldenSkillImages_v1
 local golden=require(RS:WaitForChild("CraxSkillCatalog")).Crax_Golden
 local images={
  "rbxassetid://126529258520474",
  "rbxassetid://71440977110481",
  "rbxassetid://133977363317754",
 }

 if golden and golden.Upgrades then
  for level=1,3 do
   local upgrade=golden.Upgrades[level]

   if upgrade and upgrade.Id==kind then
    make("ImageLabel",{
     Name="GoldenSkillIcon_Level"..level,
     BackgroundTransparency=1,
     Size=UDim2.fromScale(1,1),
     Image=images[level],
     ScaleType=Enum.ScaleType.Fit,
     Active=false,
     ZIndex=4,
    },f)
    return
   end
  end
 end

 if require(RS:WaitForChild("CraxDeadlyIcons")).Build(f,kind)then return end
 if kind=="Weaver"or kind=="DoubleSilk"or kind=="SilkTrap"or kind=="Venom"then SpideyIcons.Build(f,kind);return end
 if kind=="GhostExecution"then require(RS:WaitForChild("CraxGhostyTrophyIcons")).Build(f);return end
 if kind=="Devourer"and TrophyIcons then TrophyIcons.Build(f);return end
 if require(RS:WaitForChild("CraxGhostySkillLogos")).Build(f,kind)then return end
 if require(RS:WaitForChild("CraxFantasticIcons")).Build(f,kind)then return end
 if kind=="Coins"then Prestige.Coin(f);return end
 if kind=="Gems"then
  local image=make("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=4,Active=false,ScaleType=Enum.ScaleType.Fit},f)
  image.Name="CraxGemIcon";ShopLogos.BindGem(image,true);image.ScaleType=Enum.ScaleType.Fit;return
 end
 if ShopLogos.Power(f,kind)then return end
 local imageId=style.PowerLogos and style.PowerLogos[kind]
 if type(imageId)=="string"and imageId~=""then make("ImageLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=imageId,ScaleType=Enum.ScaleType.Fit},f);return end
 if kind=="Gems"then
  local d=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromScale(.48,.48),Rotation=45,BackgroundColor3=color,BorderSizePixel=0},f)
  gradient(d,Color3.fromRGB(250,255,255),Color3.fromRGB(60,161,225),25);rim(d,color);return
 elseif kind=="Coins"then
  local coin=make("Frame",{Position=UDim2.fromScale(.18,.18),Size=UDim2.fromScale(.64,.64),BackgroundColor3=C.gold,BorderSizePixel=0},f)
  round(coin,100);gradient(coin,Color3.fromRGB(255,248,169),Color3.fromRGB(171,97,7),25);rim(coin,C.gold)
  make("TextLabel",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text="C",Font=Enum.Font.GothamBlack,TextScaled=true,TextColor3=Color3.fromRGB(122,63,9)},coin);return
 end
 local disk=make("Frame",{Position=UDim2.fromScale(.1,.1),Size=UDim2.fromScale(.8,.8),BackgroundColor3=color:Lerp(C.bg,.7),BorderSizePixel=0},f);round(disk,100);rim(disk,color)
 if kind=="TongueSweep"then
  local tongue=make("Frame",{Position=UDim2.fromScale(.15,.4),Size=UDim2.fromScale(.72,.28),Rotation=-25,BackgroundColor3=Color3.fromRGB(255,103,145),BorderSizePixel=0},disk);round(tongue,30);gradient(tongue,Color3.fromRGB(255,172,190),Color3.fromRGB(186,26,74))
 else
  local mouth=make("Frame",{Position=UDim2.fromScale(.13,.35),Size=UDim2.fromScale(.74,.36),BackgroundColor3=Color3.fromRGB(66,4,16),BorderSizePixel=0},disk);round(mouth,10)
  for i=1,(kind=="LifeSteal"and 2 or 5)do
   local n=kind=="LifeSteal"and(i==1 and .1 or .68)or(i-1)*.18+.05
   local tooth=make("Frame",{Position=UDim2.fromScale(n,0),Size=UDim2.fromScale(.15,kind=="LifeSteal"and .9 or .6),BackgroundColor3=Color3.fromRGB(255,244,213),BorderSizePixel=0},mouth);round(tooth,4)
  end
 end
end
local function glitter(parent,color,count)
 for i=1,count do
  local p=make("TextLabel",{BackgroundTransparency=1,Size=UDim2.fromOffset(14,14),Text=i%3==0 and "✦"or "·",Font=Enum.Font.GothamBlack,TextSize=i%3==0 and 17 or 22,TextColor3=color,ZIndex=2,Active=false},parent)
  particles[#particles+1]={object=p,seed=i*.618,color=color}
 end
end
local function preview(parent,id,x,y,w,h)
 local view=make("ViewportFrame",{Position=UDim2.fromOffset(x,y),Size=UDim2.fromOffset(w,h),BackgroundTransparency=1,Ambient=Color3.fromRGB(205,217,236),LightColor=Color3.fromRGB(255,242,217),LightDirection=Vector3.new(-1,-1,-2),ZIndex=3},parent)
 local data=catalog[id];local folder=RS:FindFirstChild("CraxPreviews");local donor=data and folder and folder:FindFirstChild(data.TemplateName)
 if not donor or not donor:IsA("Model")then text(view,"Aperçu en préparation",4,0,w-8,h,17,C.muted);return end
 local world=make("WorldModel",{},view);local model=donor:GetAttribute('DeadlySpiral')and require(RS:WaitForChild('CraxDeadlyVisuals')).PreviewClone(donor)or donor:Clone();model.Parent=world
 for _,o in ipairs(model:GetDescendants())do
  if o:IsA("BasePart")then o.Anchored=true;o.CanCollide=false;o.CanTouch=false;o.CanQuery=false
  elseif o:IsA("Script")or o:IsA("LocalScript")or o:IsA("Sound")or o:IsA("BillboardGui")or o:IsA("Highlight")then o:Destroy()end
 end
 local head=model:FindFirstChild("Head",true);if head and not head:IsA("BasePart")then head=head:FindFirstChildWhichIsA("BasePart",true)end
 local box,size=model:GetBoundingBox();local center=head and head.Position or box.Position
 local diameter=head and math.max(head.Size.X,head.Size.Y,head.Size.Z,size.Y*.85)or math.max(size.X,size.Y,size.Z)
 local sum=Vector3.zero;local count=0
 for _,o in ipairs(model:GetDescendants())do if o:IsA("BasePart")then
  local n=o;while n and n~=model do if n.Name=="EyeLeft"or n.Name=="EyeRight"or n.Name=="AngryEyeLeft"or n.Name=="AngryEyeRight"then sum=sum+o.Position;count=count+1;break end;n=n.Parent end
 end end
 local front=Vector3.new(0,0,-1);if count>0 then local d=sum/count-center;local horizontal=Vector3.new(d.X,0,d.Z);if horizontal.Magnitude>.001 then front=horizontal.Unit end end
 local camera=make("Camera",{FieldOfView=35,CFrame=CFrame.lookAt(center+front*diameter*1.95,center)},view);view.CurrentCamera=camera;require(RS:WaitForChild("CraxDeadlyVisuals")).Fit(view,model)
 previews[#previews+1]={view=view,camera=camera,center=center,front=front,diameter=diameter,locked=model:GetAttribute("DeadlySpiral")==true};return view
end
gui=make("ScreenGui",{Name="CopEmGui",ResetOnSpawn=false,DisplayOrder=80,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},pg)
local logoFolder=RS:FindFirstChild("CopEmBranding");local logoValue=logoFolder and logoFolder:FindFirstChild("LogoImage")
local open=button(gui,"Cop'Em",12,0,136,146,C.bg,function()end);open.Name="CopEmButton";open.AnchorPoint=Vector2.new(0,.5);open.Position=UDim2.new(0,-4,style.ButtonY or .62,0);open.BackgroundTransparency=1;open.Text="";open.Visible=false
for _,o in ipairs(open:GetChildren())do if o:IsA("UIStroke")then o.Enabled=false end end
local openLogo=make("ImageLabel",{Position=UDim2.fromOffset(7,0),Size=UDim2.fromOffset(122,115),BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit},open)
local caption=text(open,"Cop'Em",0,111,136,32,27,C.white);caption.TextXAlignment=Enum.TextXAlignment.Center;caption.Font=Enum.Font.GothamBlack;caption.ZIndex=5
local captionGradient=gradient(caption,Color3.fromRGB(255,253,196),C.gold);shineEntries[#shineEntries+1]={gradient=captionGradient,parent=caption}
local shade=make("Frame",{Name="ShopOverlay",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=.32,Visible=false,Active=true},gui)
local panel=make("Frame",{Name="ShopPanel",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(1080,720),BackgroundColor3=C.bg,BorderSizePixel=0},shade);round(panel,20);rim(panel,C.gold)
gradient(panel,Color3.fromRGB(18,25,38),C.bg,110)
local panelScale=make("UIScale",{Scale=1},panel)
local entrance=make("NumberValue",{Value=1},panel);local openingTween
local logoHeader=make("ImageLabel",{Position=UDim2.fromOffset(21,7),Size=UDim2.fromOffset(73,73),BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit},panel)
for i=1,3 do
 local depth=text(panel,"Cop'Em",104,12+(4-i),285,54,40,Color3.fromRGB(65+i*25,31+i*12,4))
 depth.Font=Enum.Font.GothamBlack;depth.ZIndex=i+1
end
local title=text(panel,"Cop'Em",104,12,285,54,40,C.white);title.ZIndex=5;title.Font=Enum.Font.GothamBlack;title.TextStrokeColor3=Color3.fromRGB(110,54,6);title.TextStrokeTransparency=.2
local titleGold=gradient(title,Color3.fromRGB(255,252,207),Color3.fromRGB(226,155,32));shineEntries[#shineEntries+1]={gradient=titleGold,parent=title}
text(panel,"COLLECTION • COMPÉTENCES • TROPHÉES",105,63,430,20,12,C.muted)
local function logoRefresh()
 local id=ShopLogos.Normalize(logoValue and logoValue.Value or "")
 openLogo.Image=id;logoHeader.Image=id;openLogo.Visible=id~="";logoHeader.Visible=id~=""
 caption.Position=id~=""and UDim2.fromOffset(0,111)or UDim2.fromOffset(0,52)
end
if logoValue then connect(logoValue.Changed,logoRefresh)end;logoRefresh()
local wallet=player:WaitForChild("Wallet")
local coins=wallet:WaitForChild("Coins");local gems=wallet:WaitForChild("CraxGems")
local function number(value)local s=tostring(math.max(0,math.floor(value)));return(s:reverse():gsub("(%d%d%d)","%1 "):reverse():gsub("^ ",""))end
local coinPill=card(panel,582,20,181,45,C.gold);emblem(coinPill,"Coins",C.gold,3,4,37)
local coinText=text(coinPill,"",47,3,129,39,19,C.gold)
local gemPill=card(panel,776,20,180,45,C.blue);emblem(gemPill,"Gems",C.blue,3,4,37)
local gemText=text(gemPill,"",47,3,128,39,19,C.blue)
local function balance()coinText.Text=number(coins.Value);gemText.Text=number(gems.Value)end
connect(coins.Changed,balance);connect(gems.Changed,balance);balance()
local content=make("Frame",{Position=UDim2.fromOffset(24,153),Size=UDim2.fromOffset(1032,502),BackgroundTransparency=1},panel)
local message=text(panel,"",28,667,1020,34,17,C.gold)
local burstPool={}
for i=1,28 do burstPool[i]=make("TextLabel",{Size=UDim2.fromOffset(8,8),BackgroundTransparency=1,Text="·",Font=Enum.Font.GothamBlack,TextSize=21,TextColor3=C.gold,ZIndex=20,Visible=false},panel)end
local effectLayer=make("Frame",{Name="BookCeremony",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ZIndex=30,Active=false},panel)
local flash=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=C.gold,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=1,Active=false},effectLayer);round(flash,20)
local vignette=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(15,1,3),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=1,Active=false},effectLayer);round(vignette,20)
local shock=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(100,100),BackgroundTransparency=1,Visible=false,ZIndex=2,Active=false},effectLayer);round(shock,1000)
local shockEdge=make("UIStroke",{Color=C.gold,Thickness=3,Transparency=1},shock)
local spark=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(10,10),BackgroundColor3=C.gold,BorderSizePixel=0,Visible=false,ZIndex=3,Active=false},effectLayer);round(spark,20)
local awardPlate=card(effectLayer,175,553,730,89,C.gold);awardPlate.ZIndex=3;awardPlate.Visible=false
local orbit={}
for i=1,24 do
 orbit[i]=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(i%3==0 and 5 or 3,i%3==0 and 5 or 3),BackgroundColor3=C.gold,BorderSizePixel=0,Visible=false,ZIndex=2,Active=false},effectLayer);round(orbit[i],20)
end
local ceremonyText=text(effectLayer,"",180,563,720,42,28,C.gold);ceremonyText.TextXAlignment=Enum.TextXAlignment.Center;ceremonyText.Font=Enum.Font.Antique;ceremonyText.Visible=false;ceremonyText.ZIndex=4
local ceremonySub=text(effectLayer,"",180,606,720,24,14,C.muted);ceremonySub.TextXAlignment=Enum.TextXAlignment.Center;ceremonySub.Visible=false;ceremonySub.ZIndex=4
local function effectReset()
 flash.BackgroundTransparency=1;vignette.BackgroundTransparency=1;shock.Visible=false
 ceremonyText.Visible=false;ceremonySub.Visible=false;awardPlate.Visible=false;spark.Visible=false
 for _,o in ipairs(orbit)do o.Visible=false end
end
local burstStart=-100
local function schedule()
 if hold or pending or celebration or cinema and(cinema.mode=="opening"or cinema.mode=="closing"or cinema.mode=="chapter")then return end
 if buildScheduled then return end;buildScheduled=true
 task.defer(function()buildScheduled=false;if shade.Visible and rebuild and not hold and not pending and not celebration and(not cinema or cinema.mode~="opening"and cinema.mode~="closing"and cinema.mode~="chapter")then rebuild()end end)
end
local function own(id)local inv=player:FindFirstChild("Inventory");local v=inv and inv:FindFirstChild(id);return v and v:IsA("BoolValue")and v.Value==true end
local function level(id)local v=levels:FindFirstChild(id);return math.max(v and v.Value or 0,confirmedLevels[id]or 0)end
local function available(id,step)
 local spec=config[id];return not pending and not celebration and os.clock()>=pageTurningUntil and(not cinema or cinema.mode~="opening"and cinema.mode~="closing"and cinema.mode~="chapter")and player:GetAttribute("InventoryReady")==true and player:GetAttribute("ArenaSeat")==nil and own(id)and bookOpened
  and spec and spec.Enabled and step==level(id)+1 and spec.Upgrades[step]~=nil
end
local function buy(id,step,currency)
 if not available(id,step)then return end
 local spec=config[id];local cost=spec.Upgrades[step][currency];local balanceValue=currency=="Coins"and coins.Value or gems.Value
 if type(cost)~="number"or cost<=0 then return end
 if balanceValue<cost then message.Text="Il te faut "..number(cost).." "..(currency=="Coins"and "CraxCoins"or "CraxGems")..".";return end
 pending=HttpService:GenerateGUID(false);local request=pending
 transaction={id=id,step=step,currency=currency,epoch=viewEpoch}
 for _,b in ipairs(actionButtons)do if b.Parent then b.Active=false;local label=b:FindFirstChild("PriceLabel");if label then label.Text="VALIDATION…"end end end
 message.Text="Validation de l'achat…";remote:FireServer("Buy",request,id,step,currency)
 task.delay(12,function()if pending==request then message.Text="La réponse tarde. Attends la confirmation avant un autre achat."end end)
end
-- A hold never pays locally. Only buy() can submit a request to the server.
cancelHold=function()
 if not hold then return end
 local h=hold;hold=nil;sounds.Charge:Stop();if cinema then cinema:CancelCharge()end
 if h.fill.Parent then h.fill.Size=UDim2.fromScale(0,1)end
 if h.label.Parent then h.label.Text=h.caption end
 if h.cardScale.Parent then h.cardScale.Scale=1 end
 local n=nodes[h.step];if n then n.ring:Set(0) end
 if gaugeFill then gaugeFill.Size=UDim2.fromScale(0,1)end
 if gaugeCaption then gaugeCaption.Text="ÉVEIL • 0 %"end
 for _,o in ipairs(orbit)do o.Visible=false end
end
local function neon(parent)
 local edge=make("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Thickness=3,Transparency=.05,Color=Color3.new(1,1,1)},parent)
 local g=gradient(edge,Color3.fromRGB(255,51,39),Color3.fromRGB(255,184,48),0)
 neonEntries[#neonEntries+1]={edge=edge,g=g}
end
local function holdButton(parent,caption,x,y,w,h,color,id,step,currency,cardScale)
 local b=button(parent,"",x,y,w,h,color,function()end)
 b.ClipsDescendants=true
 local fill=make("Frame",{Name="HoldFill",Size=UDim2.fromScale(0,1),BackgroundColor3=color:Lerp(C.white,.4),BackgroundTransparency=.15,BorderSizePixel=0,ZIndex=2,Active=false},b);round(fill,9)
 local label=text(b,caption,32,0,w-38,h,17,C.white);label.Name="PriceLabel";label.TextXAlignment=Enum.TextXAlignment.Right;label.ZIndex=5
 emblem(b,currency,currency=="Coins"and C.gold or C.blue,2,2,28)
 local cost=config[id].Upgrades[step][currency]
 b.Active=available(id,step)and type(cost)=="number"and cost>0
 b.InputBegan:Connect(function(input)
  local kind=input.UserInputType
  if kind~=Enum.UserInputType.MouseButton1 and kind~=Enum.UserInputType.Touch then return end
  if not available(id,step)or not b.Active then return end
  cancelHold()
  if (currency=="Coins"and coins.Value or gems.Value)<cost then
   message.Text="Il te faut "..number(cost).." "..(currency=="Coins"and "CraxCoins"or "CraxGems")..".";return
  end
  if gaugeFill then gaugeFill.Size=UDim2.fromScale(0,1)end
  if gaugeCaption then gaugeCaption.Text="ÉVEIL • 0 %"end
  fill.Size=UDim2.fromScale(0,1)
  hold={button=b,fill=fill,label=label,caption=caption,input=input,start=os.clock(),id=id,step=step,currency=currency,cardScale=cardScale}
  message.Text="Maintiens pour débloquer • relâche pour annuler."
  if cinema then cinema:Charge(.001)end
 end)
 b.MouseLeave:Connect(function()if hold and hold.button==b and hold.input.UserInputType==Enum.UserInputType.MouseButton1 then cancelHold()end end)
 b.InputEnded:Connect(function(input)if hold and hold.button==b and input==hold.input then cancelHold()end end)
 actionButtons[#actionButtons+1]=b
 return b
end
local function choosePayment(id,step,all)
 if pending or celebration or not available(id,step)then return end
 skillPopupOpen=false
 local old=panel:FindFirstChild("BurntParchmentDescription");if old then old:Destroy()end
 if paymentPopup then paymentPopup:Destroy()end
 local epoch=viewEpoch
 local popup=make("Frame",{Name="SkillPaymentChoice",Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=.25,Active=true,ZIndex=110},panel);paymentPopup=popup
 local box=card(popup,215,205,650,285,C.gold);box.ZIndex=111
 text(box,all and "TOUT ACHETER"or "DÉBLOQUER CE NIVEAU",25,15,600,42,29,C.gold).ZIndex=112
 text(box,"Choisis une seule monnaie pour le paiement.",25,59,600,30,19,C.white).ZIndex=112
 local from=level(id)
 for n,currency in ipairs({"Coins","Gems"})do
  local balanceValue=currency=="Coins"and coins.Value or gems.Value
  local spent=0;local target=from
  local last=all and #config[id].Upgrades or step
  for k=from+1,last do local cost=config[id].Upgrades[k][currency]
   if type(cost)~="number"or cost<=0 or cost%1~=0 or spent+cost>balanceValue then break end
   spent=spent+cost;target=k
  end
  local count=target-from
  local caption=(currency=="Coins"and "CRAXCOINS"or "CRAXGEMS").." • "..count.." niveau(x) • "..number(spent)
  local pay=button(box,caption,25,102+(n-1)*58,600,49,currency=="Coins"and C.gold or C.blue,function()
   if viewEpoch~=epoch or currentCrax~=id or not available(id,step)then popup:Destroy();return end
   popup:Destroy();paymentPopup=nil
   if not all then buy(id,step,currency);return end
   pending=HttpService:GenerateGUID(false);transaction={id=id,step=target,from=from,currency=currency,epoch=epoch,all=true}
   message.Text="Validation de l’achat groupé…"
   remote:FireServer("BuyAll",pending,id,0,currency)
  end);pay.ZIndex=112;pay.Active=count>0
 end
 local close=button(box,"ANNULER",225,226,200,40,C.red,function()popup:Destroy();paymentPopup=nil end);close.ZIndex=112
 local connection;connection=RunService.RenderStepped:Connect(function()
  if not popup.Parent then connection:Disconnect();return end
  if not shade.Visible or not bookOpened or currentTab~="Skills"or epoch~=viewEpoch then popup:Destroy();paymentPopup=nil;connection:Disconnect()end
 end)
end
local inputEnded=UserInputService.InputEnded:Connect(function(input)
 if hold and (input==hold.input or input.UserInputType==Enum.UserInputType.MouseButton1 and hold.input.UserInputType==Enum.UserInputType.MouseButton1)then cancelHold()end
end)
local focusLost=UserInputService.WindowFocusReleased:Connect(function()cancelHold()end)
local function tab(tabId)
 if switching or cinema and(cinema.mode=="opening"or cinema.mode=="closing"or cinema.mode=="chapter")then return end
 local previousTab=currentTab
 local function finish()
  switching=false;cancelHold();celebration=nil;effectReset();viewEpoch=viewEpoch+1;selectedSkill=nil
  if cinema then cinema:Hide()end
  currentTab=tabId;bookOpened=false;message.Text=pending and "Validation de l'achat…"or ""
  if shade.Visible and rebuild then rebuild();if tabId=="Skills"and cinema then cinema:Closed()end end
 end
 if previousTab=="Skills"and tabId~="Skills"and bookOpened and cinema then
  switching=true;cancelHold();celebration=nil;effectReset();cinema:Close(finish)
 else finish()end
end
local function select(id)
 if switching or cinema and(cinema.mode=="opening"or cinema.mode=="closing"or cinema.mode=="chapter")then return end
 if currentTab~="Skills"then currentCrax=id;tab("Skills");return end
 if id==currentCrax then return end
 if not bookOpened then currentCrax=id;selectedSkill=nil;viewEpoch=viewEpoch+1;rebuild();cinema:Closed();return end
 -- Atomic replacement: no cloned folio, rotating texture, fade or chapter animation.
 cancelHold();skillPopupOpen=false;viewEpoch=viewEpoch+1
 currentCrax=id;selectedSkill=nil;rebuild()

end
local function list(parent) return make("ScrollingFrame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=5,ScrollBarImageColor3=C.gold,CanvasSize=UDim2.fromOffset(0,0)},parent)end
rebuild=function()
 local oldPopup=panel:FindFirstChild("BurntParchmentDescription");if oldPopup then oldPopup:Destroy()end
 cancelHold()
 if cinema then cinema:DetachHome()end
 for _,o in ipairs(content:GetChildren())do o:Destroy()end;previews={};actionButtons={};nodes={};links={};neonEntries={};bookStrip=nil;book=nil;heroView=nil;pulseEntries={};gaugeFill=nil;gaugeCaption=nil;bookPrompt=nil;bookDust={};bookNav={}
 for id,b in pairs(tabs)do b.BackgroundColor3=id==currentTab and Color3.fromRGB(48,104,122)or C.card end
 panel.BackgroundColor3=currentTab=="Skills"and Color3.fromRGB(25,17,12)or C.bg
 local sc=list(content)
 if currentTab=="News"then
  -- CraxFeaturedReveal_v1: presentation confined to the News page.
  local data=catalog.Crax_Monster
  local accent=data and (data.RarityColor or rarity[data.Rarity]) or C.gold
  local dark=Color3.fromRGB(22,24,32)
  local ink=Color3.fromRGB(9,11,17)
  local alive=true
  local connections={}
  local saved={}
  local tweens={}
  local heartbeat
  local function bind(signal,fn)
   local c=signal:Connect(fn);connections[#connections+1]=c;return c
  end
  local function set(o,props)
   saved[o]=saved[o] or {}
   for key,value in pairs(props)do
    if saved[o][key]==nil then saved[o][key]=o[key]end
    o[key]=value
   end
  end
  local function tween(o,seconds,props,style)
   local t=TweenService:Create(o,TweenInfo.new(seconds,style or Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props)
   tweens[#tweens+1]=t;t:Play();return t
  end
  local function cancelTweens()
   for _,t in ipairs(tweens)do t:Cancel()end;table.clear(tweens)
  end
  local function box(parent,name,color,z)
   local f=make("Frame",{Name=name,BackgroundColor3=color,BorderSizePixel=0,ZIndex=z or 1,ClipsDescendants=true},parent)
   round(f,22);make("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Thickness=3,Color=ink},f)
   return f
  end
  local featured=make("CanvasGroup",{Name="FeaturedReveal",BackgroundColor3=dark,BorderSizePixel=0,ClipsDescendants=true,GroupTransparency=1},sc)
  round(featured,24)
  local edge=make("UIStroke",{ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Thickness=4,Color=accent,Transparency=.12},featured)
  local shine=make("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,accent),ColorSequenceKeypoint.new(.46,accent),ColorSequenceKeypoint.new(.5,Color3.new(1,1,1)),ColorSequenceKeypoint.new(.54,accent),ColorSequenceKeypoint.new(1,accent)}),Rotation=25,Offset=Vector2.new(-1,0)},edge)
  local revealScale=make("UIScale",{Scale=.965},featured)
  local heading=text(featured,"À LA UNE",24,16,520,44,32,accent);heading.Font=Enum.Font.FredokaOne
  heading.TextStrokeColor3=ink;heading.TextStrokeTransparency=.15
  local stage=make("Frame",{Name="CraxStage",BackgroundTransparency=1,ClipsDescendants=true,ZIndex=2},featured)
  local halo={}
  for i=1,4 do
   local h=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromScale(.90-i*.11,.90-i*.11),BackgroundColor3=accent,BackgroundTransparency=.96-i*.015,BorderSizePixel=0,ZIndex=1,Active=false},stage)
   round(h,1000);make("UIAspectRatioConstraint",{AspectRatio=1},h);halo[i]=h
  end
  local rays=make("Frame",{Name="SoftRays",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromScale(.84,.84),BackgroundTransparency=1,ZIndex=1,Active=false},stage)
  make("UIAspectRatioConstraint",{AspectRatio=1},rays)
  for i=1,8 do
   local ray=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromScale(.91,.055),Rotation=(i-1)*22.5,BackgroundColor3=accent,BackgroundTransparency=.94,BorderSizePixel=0,ZIndex=1,Active=false},rays)
   round(ray,100);make("UIGradient",{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(.3,.5),NumberSequenceKeypoint.new(.5,0),NumberSequenceKeypoint.new(.7,.5),NumberSequenceKeypoint.new(1,1)})},ray)
  end
  local view=preview(stage,"Crax_Monster",0,0,360,360)
  if view then view.Name="FeaturedCraxViewport";view.Position=UDim2.fromScale(.04,.04);view.Size=UDim2.fromScale(.92,.92)end
  -- Use the existing clone, sanitization and camera orbit, never a replacement character.
  local sparks={}
  for i=1,6 do
   sparks[i]=make("TextLabel",{Name="RevealSpark"..i,BackgroundTransparency=1,AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(24,24),Text="✦",Font=Enum.Font.GothamBold,TextSize=22,TextColor3=accent,TextTransparency=1,ZIndex=4,Active=false},stage)
  end
  local name=text(featured,data and data.DisplayName or "CRAX SOURIRE",24,0,450,54,36,C.white);name.Font=Enum.Font.FredokaOne
  local badge=box(featured,"ExistingRarity",accent,2)
  local rarityLabel=text(badge,data and string.upper(data.Rarity) or "",12,2,230,28,17,ink)
  local slogan=text(featured,"UN SOURIRE.\nQUATRE ÉVOLUTIONS.",24,0,430,82,27,accent);slogan.Font=Enum.Font.FredokaOne
  local body=text(featured,"Morsures, langue fouettante, vol de vie… puis Dévoreur MAX.",24,0,410,65,20,C.muted)
  local discover=button(featured,"DÉCOUVRIR SON ARBRE  ›",24,0,420,54,accent,function()select("Crax_Monster")end)
  discover.Name="DiscoverExistingCraxTree";discover.TextColor3=ink;discover.Font=Enum.Font.FredokaOne;discover.TextSize=20
  local secondary={}
  for _,id in ipairs({"Crax_Spidey","Crax_Ghosty"})do
   local d=catalog[id]
   if d then
    local col=d.RarityColor or rarity[d.Rarity] or C.gold
    local f=box(sc,"ExistingCrax_"..id,dark)
    local r=text(f,string.upper(d.Rarity),18,12,230,24,16,col)
    local n=text(f,d.DisplayName,18,43,230,34,25,C.white);n.Font=Enum.Font.FredokaOne
    local b=text(f,"Dans Casin'O Crax",18,88,230,26,17,C.muted)
    local v=preview(f,id,250,8,150,140)
    secondary[#secondary+1]={f=f,r=r,n=n,b=b,v=v}
   end
  end
  local articles={}
  for _,news in ipairs(style.News or {})do
   local f=box(sc,"ExistingNews",dark)
   local v=preview(f,news.Crax or "Crax_Monster",12,12,140,140)
   local title=text(f,news.Title or "ACTUALITÉ",173,16,700,36,25,accent);title.Font=Enum.Font.FredokaOne
   local bodyLabel=text(f,news.Body or "",173,60,700,85,20,C.muted)
   articles[#articles+1]={f=f,v=v,title=title,body=bodyLabel}
  end
  local compact=false
  local lastW,lastH
  local function layout()
   local size=gui.AbsoluteSize
   if size.X<=0 or size.Y<=0 then return end
   if size.X==lastW and size.Y==lastH then return end
   lastW,lastH=size.X,size.Y
   compact=size.X<800 or size.X/size.Y<1.1
   -- Restore the shared shell first; only News overrides it, and teardown restores it.
   for o,props in pairs(saved)do if o.Parent then for key,value in pairs(props)do o[key]=value end end end
   local width=compact and 720 or 1080
   local height=compact and math.clamp(720*size.Y/size.X*.95,650,1320) or 720
   set(panel,{Size=UDim2.fromOffset(width,height)})
   set(content,{Position=UDim2.fromOffset(24,153),Size=UDim2.fromOffset(width-48,height-218)})
   set(message,{Position=UDim2.fromOffset(28,height-53),Size=UDim2.fromOffset(width-56,34)})
   if compact then
    set(coinPill,{Position=UDim2.fromOffset(350,14),Size=UDim2.fromOffset(181,40)})
    set(gemPill,{Position=UDim2.fromOffset(350,60),Size=UDim2.fromOffset(181,40)})
    for _,child in ipairs(panel:GetChildren())do
     if child:IsA("TextLabel")and child.Text=="COLLECTION • COMPÉTENCES • TROPHÉES"then set(child,{Size=UDim2.fromOffset(235,28),TextSize=11})end
    end
   end
   local close=panel:FindFirstChild("CloseCopEm")
   if close then set(close,{Position=UDim2.fromOffset(width-70,22),Size=UDim2.fromOffset(47,43)})end
   for i,id in ipairs({"News","Skills","Support"})do
    set(tabs[id],{Position=UDim2.fromOffset(26+(i-1)*(width-48)/3,105),Size=UDim2.fromOffset((width-48)/3-10,35),TextSize=compact and 13 or 16})
   end
   local w=width-56
   local fh=compact and 780 or 446
   featured.Position=UDim2.fromOffset(4,5);featured.Size=UDim2.fromOffset(w,fh)
   heading.Size=UDim2.fromOffset(w-48,44)
   stage.Position=compact and UDim2.fromOffset(65,66) or UDim2.fromOffset(498,60)
   stage.Size=compact and UDim2.fromOffset(w-130,350) or UDim2.fromOffset(500,360)
   name.Position=UDim2.fromOffset(24,compact and 432 or 85);name.Size=UDim2.fromOffset(compact and w-48 or 460,54)
   badge.Position=UDim2.fromOffset(24,compact and 494 or 150);badge.Size=UDim2.fromOffset(250,34)
   slogan.Position=UDim2.fromOffset(24,compact and 544 or 202);slogan.Size=UDim2.fromOffset(compact and w-48 or 450,76)
   body.Position=UDim2.fromOffset(24,compact and 628 or 287);body.Size=UDim2.fromOffset(compact and w-48 or 440,62)
   discover.Position=UDim2.fromOffset(24,compact and 706 or 365);discover.Size=UDim2.fromOffset(compact and w-48 or 440,54)
   local y=fh+25
   for i,e in ipairs(secondary)do
    local sw=compact and w or (w-16)/2
    e.f.Position=UDim2.fromOffset(4+(compact and 0 or (i-1)*(sw+16)),y+(compact and (i-1)*166 or 0));e.f.Size=UDim2.fromOffset(sw,150)
    if e.v then e.v.Position=UDim2.fromOffset(sw-154,5);e.v.Size=UDim2.fromOffset(145,140)end
    e.n.Size=UDim2.fromOffset(sw-180,34)
   end
   y=y+(compact and #secondary*166 or (#secondary>0 and 166 or 0))
   for _,e in ipairs(articles)do
    local h=compact and 196 or 170
    e.f.Position=UDim2.fromOffset(4,y);e.f.Size=UDim2.fromOffset(w,h)
    e.title.Size=UDim2.fromOffset(w-195,42);e.body.Size=UDim2.fromOffset(w-195,h-70)
    y=y+h+16
   end
   sc.CanvasSize=UDim2.fromOffset(0,y+12)
  end
  local elapsed=0
  local accumulator=0
  local function active()
   return alive and shade.Visible and gui.Enabled and sc.Parent~=nil
  end
  local function stop()
   if heartbeat then heartbeat:Disconnect();heartbeat=nil end
   cancelTweens()
  end
  local function start()
   stop()
   if not active()then return end
   layout();elapsed=0;accumulator=0;featured.GroupTransparency=1;revealScale.Scale=.965
   tween(featured,.28,{GroupTransparency=0})
   tween(revealScale,.4,{Scale=1},Enum.EasingStyle.Back)
   heartbeat=RunService.Heartbeat:Connect(function(dt)
    accumulator=accumulator+dt
    if accumulator<(UserInputService.TouchEnabled and 1/20 or 1/30)then return end
    elapsed=elapsed+accumulator;accumulator=0
    rays.Rotation=(elapsed*5)%360
    for i,h in ipairs(halo)do h.BackgroundTransparency=.96-i*.015+math.sin(elapsed*1.4)*.012 end
    local count=UserInputService.TouchEnabled and 4 or 6
    for i,p in ipairs(sparks)do
     local phase=(elapsed*.32+i*.173)%1
     local a=i*2.39996
     p.Visible=i<=count
     p.Position=UDim2.fromScale(.5+math.cos(a)*(.33+phase*.05),.5+math.sin(a)*.34-phase*.035)
     p.TextTransparency=1-math.sin(phase*math.pi)^4*.72;p.Rotation=phase*30
    end
    local phase=elapsed%7
    shine.Offset=Vector2.new(phase<1.2 and (-1+phase/1.2*2) or 1,0)
   end)
  end
  bind(shade:GetPropertyChangedSignal("Visible"),start)
  bind(gui:GetPropertyChangedSignal("Enabled"),start)
  bind(gui:GetPropertyChangedSignal("AbsoluteSize"),layout)
  sc.Destroying:Connect(function()
   alive=false;stop()
   for _,c in ipairs(connections)do c:Disconnect()end
   for o,props in pairs(saved)do if o.Parent then for key,value in pairs(props)do o[key]=value end end end
   table.clear(saved)
  end)
  layout();start()
 elseif currentTab=="Support"then
  sc.CanvasSize=UDim2.fromOffset(0,510)
  local titles={"CRAXGEMS","PASS'CRAX","SOUTIEN"}
  local bodies={"Les doublons de Casin'O Crax rapportent des CraxGems. Les packs Robux seront disponibles après configuration.","Le contenu du Pass'Crax et ses modalités seront présentés ici après configuration.","Les dons de soutien seront activés après configuration des produits Roblox."}
  for i=1,3 do
   local f=card(sc,4+(i-1)*342,8,327,465,i==1 and C.blue or C.gold);glitter(f,i==1 and C.blue or C.gold,7)
   emblem(f,i==1 and "Gems"or "Devourer",i==1 and C.blue or C.gold,96,43,135)
   text(f,titles[i],19,199,290,42,27,C.white)
   text(f,bodies[i],19,264,290,117,18,C.muted)
   local b=button(f,"BIENTÔT DISPONIBLE",20,405,287,39,C.card,function()end);b.Active=false
  end
 else
  local ids={};for id in pairs(config)do if catalog[id]then ids[#ids+1]=id end end
  table.sort(ids,function(a,b)local oa,ob=config[a].Order or 100,config[b].Order or 100;return oa==ob and a<b or oa<ob end)
  if not config[currentCrax]or not catalog[currentCrax]then currentCrax=ids[1]end
  if not currentCrax then text(sc,"Aucun arbre configuré",20,20,800,60,26,C.gold);return end
  -- Navigation only through owned Crax; locked collection entries remain in the picker.
  local ownedIds={};for _,id in ipairs(ids)do if own(id)then ownedIds[#ownedIds+1]=id end end
  local currentIndex;for n,id in ipairs(ownedIds)do if id==currentCrax then currentIndex=n end end
  local function navigate(id)skillPopupOpen=false;select(id)end
  if currentIndex and currentIndex>1 then local back=button(sc,"‹",7,220,46,65,Color3.fromRGB(90,57,27),function()navigate(ownedIds[currentIndex-1])end);back.Name="PreviousOwnedCrax";back.TextSize=44;back.ZIndex=20;back.Visible=bookOpened;bookNav[#bookNav+1]=back end
  if currentIndex and currentIndex<#ownedIds then local next=button(sc,"›",979,220,46,65,Color3.fromRGB(90,57,27),function()navigate(ownedIds[currentIndex+1])end);next.Name="NextOwnedCrax";next.TextSize=44;next.ZIndex=20;next.Visible=bookOpened;bookNav[#bookNav+1]=next end
  local picker=make("Frame",{Name="CraxBookPicker",Position=UDim2.fromOffset(605,40),Size=UDim2.fromOffset(360,math.min(340,65+#ids*52)),BackgroundColor3=Color3.fromRGB(244,226,184),BorderSizePixel=0,Visible=false,ZIndex=95},sc);round(picker,12);rim(picker,Color3.fromRGB(106,65,29))
  local pickerTitle=text(picker,"CHOISIR UN CRAX",16,10,278,35,25,Color3.fromRGB(46,28,16));pickerTitle.ZIndex=96
  local dismiss=button(picker,"×",309,9,35,35,Color3.fromRGB(102,58,27),function()picker.Visible=false end);dismiss.ZIndex=96
  local choices=make("ScrollingFrame",{Position=UDim2.fromOffset(12,53),Size=UDim2.new(1,-24,1,-63),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,CanvasSize=UDim2.fromOffset(0,#ids*52),ZIndex=96},picker)
  for n,id in ipairs(ids)do
   local choice=button(choices,catalog[id].DisplayName,0,(n-1)*52,329,46,Color3.fromRGB(104,67,32),function()picker.Visible=false;navigate(id)end)
   choice.Name="Choose_"..id;choice.TextSize=24;choice.ZIndex=97
   if not own(id)then choice.Text=choice.Text.." • VERROUILLÉ";choice.Active=false end
  end
  local spec=config[currentCrax];local data=catalog[currentCrax];local lv=level(currentCrax);local owned=own(currentCrax)
  local total=#(spec.Upgrades or {});local color=Color3.fromRGB(88,58,27)
  if not selectedSkill or selectedSkill>total then selectedSkill=math.min(lv+1,math.max(1,total))end
  -- Thick leather cover, stepped paper edges, two independent pages, central binding.
  local shadow=make("Frame",{Position=UDim2.fromOffset(13,81),Size=UDim2.fromOffset(1008,414),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,BorderSizePixel=0},sc);round(shadow,18)
  if cinema then cinema:SetHome(sc,UDim2.fromOffset(5,48),UDim2.fromOffset(1016,452));cinema:SetProgress(lv);cinema:SetCrax(currentCrax,data.TemplateName)end
  local cover=make("Frame",{Name="NewIllustratedGrimoire",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset(513,274),Size=UDim2.fromOffset(1016,452),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=false,ZIndex=5},sc);book=cover
  bookScale=make("UIScale",{Scale=1},cover)
  for _,o in ipairs(cover:GetChildren())do if o:IsA("UIStroke")then o.Enabled=false end end
  -- No parent gradient: preserve ivory pages and untinted text/character.
  local function page(x,w)
   local f=make("Frame",{Position=UDim2.fromOffset(x,9),Size=UDim2.fromOffset(w,416),BackgroundTransparency=0,BackgroundColor3=Color3.fromRGB(241,226,184),BorderSizePixel=0,ClipsDescendants=true},cover);round(f,9)
   gradient(f,Color3.fromRGB(248,235,201),Color3.fromRGB(225,205,158),115)
   for y=30,370,24 do make("Frame",{Position=UDim2.fromOffset(14,y),Size=UDim2.new(1,-28,0,1),BackgroundColor3=Color3.fromRGB(91,57,24),BackgroundTransparency=.975,BorderSizePixel=0},f)end
   for _,v in ipairs({{12,12,0},{w-29,12,90},{12,364,270},{w-29,364,180}})do
    local flourish=text(f,"⌜",v[1],v[2],18,18,21,Color3.fromRGB(171,123,65));flourish.Rotation=v[3]
   end
   local visuals=RS:FindFirstChild("CraxBookVisuals");local parchment=visuals and visuals:FindFirstChild("Parchment")
   if parchment and parchment.Value~=""then make("ImageLabel",{Name="ParchmentGrain",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=parchment.Value,ImageTransparency=.92,ZIndex=1},f)end
   return f
  end
  local left=page(95,458);local right=page(520,460)
  right.Size=UDim2.fromOffset(460,465)
  left.Position=UDim2.fromOffset(95,20);right.Position=UDim2.fromOffset(520,20)
  make("UIScale",{Scale=.85},left);make("UIScale",{Scale=.85},right)
  local artFolder=RS:FindFirstChild("CraxBookVisuals");local art=artFolder and artFolder:FindFirstChild("OpenArt")
  if art and art.Value~=""then
   local background=make("ImageLabel",{Name="IllustratedOpenGrimoire",Size=UDim2.fromScale(1,1),Image=art.Value,BackgroundTransparency=1,ZIndex=1},cover)
   left.ZIndex=2;right.ZIndex=2;left.BackgroundTransparency=1;right.BackgroundTransparency=1
  end
  -- Separate 3D character window sits above the painted page; no brown cover occlusion.
  heroView=preview(left,currentCrax,85,116,288,181)
  text(left,"BESTIAIRE : CRAXTOYS",58,10,378,34,24,Color3.fromRGB(91,57,24))
  local title=text(left,data.DisplayName,22,46,412,43,34,Color3.fromRGB(61,36,19));title.TextXAlignment=Enum.TextXAlignment.Center
  local rarityColor=rarity[data.Rarity]or C.gold
  local rare=text(left,tostring(data.Rarity):upper(),22,91,412,30,24,rarityColor);rare.TextXAlignment=Enum.TextXAlignment.Center
  -- The Crax is a model in the book WorldModel. This area has no separate viewport.
  if currentCrax~="Crax_Inverted"and lv>=4 and TrophyIcons then
   local earned=make("Frame",{Name="EarnedTrophy",Position=UDim2.fromOffset(359,228),Size=UDim2.fromOffset(88,88),BackgroundTransparency=1,ZIndex=4},left)
   if currentCrax=="Crax_Deadly"then require(RS:WaitForChild("CraxDeadlyIcons")).Build(earned,"DeadlyFather")elseif currentCrax=="Crax_Ghosty"then require(RS:WaitForChild("CraxGhostyTrophyIcons")).Build(earned)elseif currentCrax=="Crax_Spidey"then SpideyIcons.Build(earned,"Weaver")else TrophyIcons.Build(earned)end
   local name=text(left,currentCrax=="Crax_Golden"and "VRAIE RICHESSE"or currentCrax=="Crax_Plumber"and "MAMAMIA"or currentCrax=="Crax_Ghosty"and "EXÉCUTION FANTÔME"or currentCrax=="Crax_Spidey"and "TISSEUR"or "DEVOREUR",316,300,130,29,currentCrax=="Crax_Ghosty"and 13 or 21,Color3.fromRGB(103,67,34));name.TextXAlignment=Enum.TextXAlignment.Center
   if currentCrax=="Crax_Fantastic"then name.Text="FANTASTIC"elseif currentCrax=="Crax_Deadly"then name.Text="PÈRE DE FAMILLE"end
   -- CraxTrophyCaptionCentered_v2
   name.Name="CraxTrophyCaption"
   name.AnchorPoint=Vector2.new(.5,0)
   name.Position=UDim2.new(earned.Position.X.Scale,earned.Position.X.Offset+earned.Size.X.Offset/2,earned.Position.Y.Scale,earned.Position.Y.Offset+earned.Size.Y.Offset+6)
   name.Size=UDim2.fromOffset(126,32)
   name.TextXAlignment=Enum.TextXAlignment.Center
   name.TextYAlignment=Enum.TextYAlignment.Center
   name.TextScaled=true;name.TextWrapped=false;name.ZIndex=8
   local captionLimit=Instance.new("UITextSizeConstraint")
   captionLimit.MinTextSize=10;captionLimit.MaxTextSize=20;captionLimit.Parent=name

  end
  local status=not owned and "À DÉBLOQUER"or lv==4 and(currentCrax=="Crax_Golden"and "MAX · VRAIE RICHESSE"or currentCrax=="Crax_Deadly"and "MAX · PÈRE DE FAMILLE"or currentCrax=="Crax_Fantastic"and "MAX · FANTASTIC"or currentCrax=="Crax_Ghosty"and "MAX · EXÉCUTION FANTÔME"or currentCrax=="Crax_Spidey"and "MAX · TISSEUR"or currentCrax=="Crax_Plumber"and "MAX · MAMAMIA"or "MAX · DEVOREUR")or lv>0 and("NIVEAU "..lv)or "CRAX DE BASE"
  local levelColor=lv<=0 and Color3.fromRGB(0,0,0)or metals[math.min(lv,4)]
  local statusText=text(left,status,26,316,430,42,28,levelColor);statusText.Name="CraxLevelTitle";statusText.Font=Enum.Font.GothamBold;statusText.TextXAlignment=Enum.TextXAlignment.Center
  if lv>=4 then statusText.Size=UDim2.fromOffset(292,42);if currentCrax=="Crax_Ghosty"then statusText.TextScaled=true end end
  if lv>0 then
   -- Embossed lettering: lower shadow and upper bevel, both behind the face.
   local shadow=text(left,status,27,318,statusText.Size.X.Offset,42,28,Color3.fromRGB(49,31,18));shadow.Name="LevelTitleRelief";if currentCrax=="Crax_Ghosty"and lv>=4 then shadow.TextScaled=true end;shadow.Font=Enum.Font.GothamBold;shadow.TextXAlignment=Enum.TextXAlignment.Center;shadow.TextTransparency=.22;shadow.ZIndex=3
   local bevel=text(left,status,25,315,statusText.Size.X.Offset,42,28,Color3.fromRGB(255,247,218));bevel.Name="LevelTitleBevel";if currentCrax=="Crax_Ghosty"and lv>=4 then bevel.TextScaled=true end;bevel.Font=Enum.Font.GothamBold;bevel.TextXAlignment=Enum.TextXAlignment.Center;bevel.TextTransparency=.3;bevel.ZIndex=3
   statusText.ZIndex=4;statusText.TextColor3=Color3.new(1,1,1);statusText.TextStrokeColor3=Color3.fromRGB(68,43,22);statusText.TextStrokeTransparency=.3
   local tones={
    {Color3.fromRGB(127,65,29),Color3.fromRGB(255,198,137),Color3.fromRGB(176,104,53)},
    {Color3.fromRGB(92,110,130),Color3.fromRGB(255,255,255),Color3.fromRGB(164,188,213)},
    {Color3.fromRGB(157,94,13),Color3.fromRGB(255,241,157),Color3.fromRGB(234,174,31)},
    {Color3.fromRGB(234,174,31),Color3.fromRGB(255,241,173),Color3.fromRGB(49,137,199)},
   }
   local tonesForLevel=tones[math.min(lv,4)]
   local gilded=make("UIGradient",{Name="LevelMetalShimmer",Rotation=15,Color=ColorSequence.new({ColorSequenceKeypoint.new(0,tonesForLevel[1]),ColorSequenceKeypoint.new(.45,tonesForLevel[2]),ColorSequenceKeypoint.new(1,tonesForLevel[3])})},statusText)
   shineEntries[#shineEntries+1]={gradient=gilded,parent=statusText}
  end
  -- CraxMaxLayoutFix_v1
  if lv >= 4 then
   local caption = left:FindFirstChild("CraxTrophyCaption")
   local trophy = left:FindFirstChild("EarnedTrophy")
   if caption and trophy then
    caption.Size = UDim2.fromOffset(104, 28)
    caption.Position = UDim2.fromOffset(
     trophy.Position.X.Offset + trophy.Size.X.Offset / 2,
     trophy.Position.Y.Offset + trophy.Size.Y.Offset + 4
    )
    caption.TextScaled = true
    caption.TextWrapped = true
    local limit = caption:FindFirstChildWhichIsA("UITextSizeConstraint")
    if limit then limit.MinTextSize = 8; limit.MaxTextSize = 18 end
   end

   for _, item in ipairs(left:GetChildren()) do
    if item.Name == "CraxLevelTitle"
     or item.Name == "LevelTitleRelief"
     or item.Name == "LevelTitleBevel" then
     local dx = item.Name == "LevelTitleRelief" and 1
      or item.Name == "LevelTitleBevel" and -1 or 0
     local dy = item.Name == "LevelTitleRelief" and 2
      or item.Name == "LevelTitleBevel" and -1 or 0
     item.Position = UDim2.fromOffset(22 + dx, 350 + dy)
     item.Size = UDim2.fromOffset(414, 28)
     item.TextScaled = true
     item.TextWrapped = false
     item.TextXAlignment = Enum.TextXAlignment.Center
     item.TextYAlignment = Enum.TextYAlignment.Center
    end
   end
  end

  local track=make("Frame",{Position=UDim2.fromOffset(42,380),Size=UDim2.fromOffset(373,7),BackgroundColor3=C.card,BorderSizePixel=0},left);round(track,4)
  local progress=make("Frame",{Size=UDim2.fromScale(0,1),BackgroundColor3=Color3.fromRGB(91,57,24),BorderSizePixel=0},track);gaugeFill=progress;round(progress,4);gradient(progress,C.red,Color3.fromRGB(91,57,24),0)
  text(right,"LES ÉVOLUTIONS",22,9,320,36,29,Color3.fromRGB(91,57,24))
  local search=button(right,"",366,8,65,47,Color3.fromRGB(126,82,39),function()picker.Visible=not picker.Visible end);search.Name="SearchCrax";search.ZIndex=8
  local lens=make("Frame",{Position=UDim2.fromOffset(19,9),Size=UDim2.fromOffset(22,22),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=9},search);round(lens,100)
  make("UIStroke",{Color=Color3.fromRGB(255,237,195),Thickness=3},lens)
  make("Frame",{Position=UDim2.fromOffset(39,29),Size=UDim2.fromOffset(13,4),Rotation=45,BackgroundColor3=Color3.fromRGB(255,237,195),BorderSizePixel=0,ZIndex=9},search)
  if not spec.Enabled or total==0 then
   local seal=text(right,"?",150,88,190,160,110,Color3.fromRGB(105,105,122));seal.TextXAlignment=Enum.TextXAlignment.Center
   text(right,"CHAPITRE SCELLÉ",35,260,424,37,27,Color3.fromRGB(91,57,24)).TextXAlignment=Enum.TextXAlignment.Center
   text(right,"Les compétences de ce Crax seront révélées ici lorsqu'elles seront disponibles.",45,306,404,57,17,Color3.fromRGB(71,49,29)).TextXAlignment=Enum.TextXAlignment.Center
  else
   local positions={Vector2.new(58,103),Vector2.new(398,155),Vector2.new(58,207),Vector2.new(398,259)}
   local stepWidth=218
   -- All four medallions fit on the right page. No horizontal card carousel.
   for i,upgrade in ipairs(spec.Upgrades)do
    local revealed=Prestige.CanReveal(lv,i);local acquired=lv>=i;local nextAvailable=owned and i==lv+1
    local metal=revealed and Color3.fromRGB(145,102,35)or Color3.fromRGB(91,78,55)
    local center=positions[i]or Vector2.new(130,110);local cx,cy=center.X,center.Y
    if i<total then
     local nextPosition=positions[i+1]
     if nextPosition then
      local delta=nextPosition-center;local length=delta.Magnitude
      local direction=delta/length;local start=center
      local rail=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset((center.X+nextPosition.X)/2,(center.Y+nextPosition.Y)/2),Size=UDim2.fromOffset(length,3),Rotation=math.deg(math.atan2(delta.Y,delta.X)),BackgroundColor3=Color3.fromRGB(108,79,43),BackgroundTransparency=1,BorderSizePixel=0},right);round(rail,5)
      local beam=make("Frame",{Name="LevelThread_"..i,Size=UDim2.fromScale(lv>=i and 1 or 0,1),BackgroundColor3=Color3.fromRGB(91,57,24),BorderSizePixel=0},rail);round(beam,5);gradient(beam,C.red,Color3.fromRGB(91,57,24),0);links[i]=beam
     end
    end
    local pedestal=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset(cx,cy),Size=UDim2.fromOffset(74,74),BackgroundColor3=Color3.fromRGB(128,83,39),BackgroundTransparency=.12,BorderSizePixel=0},right);round(pedestal,100)
    local node=make("TextButton",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset(cx,cy),Size=UDim2.fromOffset(62,62),BackgroundColor3=Color3.fromRGB(216,181,112),BorderSizePixel=0,AutoButtonColor=false,Text="",ZIndex=3},right);round(node,100);rim(node,metal);gradient(node,Color3.fromRGB(229,204,150),Color3.fromRGB(162,113,59),120)
    local cs=make("UIScale",{Scale=1},node)
    -- CraxTrophyStates_v1
    if i==4 and currentCrax=="Crax_Inverted"then
     if revealed then emblem(node,upgrade.Id,metal,3,3,56)else local hidden=text(node,"?",0,0,62,62,35,C.muted);hidden.TextXAlignment=Enum.TextXAlignment.Center end
    elseif i==4 then
     local holder=make("Frame",{Position=UDim2.fromOffset(3,3),Size=UDim2.fromOffset(56,56),BackgroundTransparency=1,ZIndex=4},node)
     if currentCrax=="Crax_Deadly"then require(RS:WaitForChild("CraxDeadlyIcons")).Build(holder,"DeadlyFather",not acquired)else require(RS:WaitForChild("CraxTrophyIcons")).Build(holder,acquired)end
    elseif revealed then emblem(node,upgrade.Id or "FiveBites",metal,3,3,56)
    else
     local mystery=text(node,"?",0,0,62,45,39,Color3.fromRGB(118,122,139));mystery.TextXAlignment=Enum.TextXAlignment.Center
     text(node,"SCELLÉ",0,44,62,18,12,Color3.fromRGB(71,49,29)).TextXAlignment=Enum.TextXAlignment.Center
    end
    if nextAvailable or selectedSkill==i and revealed then rim(node,Color3.fromRGB(139,85,25))end
    local ring=circleCharge(node,Color3.fromRGB(255,133,30));ring:Set(acquired and 1 or 0)
    if acquired then local edge=make("UIStroke",{Color=Color3.fromRGB(255,135,25),Thickness=2,Transparency=.2},node);local g=gradient(edge,Color3.fromRGB(255,87,15),Color3.fromRGB(255,207,74),0);neonEntries[#neonEntries+1]={edge=edge,g=g}end
    local top=text(node,i==total and i==4 and "MAX"or string.format("%02d",i),-7,-9,36,24,16,metal);top.ZIndex=5;top.TextXAlignment=Enum.TextXAlignment.Center
    local name=text(right,i==4 and ""or(revealed and upgrade.Name or "ÉVOLUTION MYSTÈRE"),106,cy-23,243,46,24,revealed and Color3.fromRGB(61,36,19) or Color3.fromRGB(71,49,29));name.TextXAlignment=Enum.TextXAlignment.Center;name.BorderSizePixel=0;name.BackgroundTransparency=.1;name.BackgroundColor3=Color3.fromRGB(243,227,187);name.ZIndex=4;name.Visible=i~=4
    local badge=text(node,acquired and "✓"or nextAvailable and "✦"or "",42,43,22,19,14,metal);badge.ZIndex=5;badge.TextXAlignment=Enum.TextXAlignment.Center
    node.Name="SkillSeal_"..i;nodes[i]={node=node,card=node,scale=cs,top=badge,ring=ring}
    if nextAvailable then pulseEntries[#pulseEntries+1]={scale=cs}end
    local sealFill=make("Frame",{Size=UDim2.fromScale(0,1),BackgroundTransparency=1,Visible=false},node)
    local sealLabel=make("TextLabel",{Text="",Visible=false},node)
    node.InputBegan:Connect(function(input)
     if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
     if not nextAvailable or paymentPopup and paymentPopup.Parent or not available(currentCrax,i)then return end
     cancelHold();selectedSkill=i;skillPopupOpen=false
     local old=panel:FindFirstChild("BurntParchmentDescription");if old then old:Destroy()end
     hold={button=node,fill=sealFill,label=sealLabel,caption="",input=input,start=os.clock(),id=currentCrax,step=i,currency="Coins",cardScale=cs,seal=true}
     message.Text="Maintiens pour remplir le sceau • paiement à confirmer ensuite."
    end)
    node.MouseLeave:Connect(function()if hold and hold.button==node and hold.input.UserInputType==Enum.UserInputType.MouseButton1 then cancelHold()end end)
    node.MouseEnter:Connect(function()if revealed and not hold and not celebration then play("Hover");TweenService:Create(cs,TweenInfo.new(.15),{Scale=1.06}):Play()end end)
    node.MouseLeave:Connect(function()if not hold and not celebration then TweenService:Create(cs,TweenInfo.new(.2),{Scale=1}):Play()end end)
    node.Activated:Connect(function()
     if switching or hold or pending or celebration or paymentPopup and paymentPopup.Parent or os.clock()<suppressSealClickUntil or cinema and cinema.mode=="chapter"or os.clock()<pageTurningUntil then return end
     if not revealed then message.Text="Achète le niveau précédent pour briser ce sceau.";return end
     selectedSkill=i;skillPopupOpen=true;play("Click");rebuild()
    end)
   end
   if owned and lv<total then
    local all=button(right,"TOUT ACHETER",218,416,232,42,Color3.fromRGB(196,116,25),function()choosePayment(currentCrax,level(currentCrax)+1,true)end)
    all.Name="BuyAllSkills";all.TextSize=25;all.ZIndex=8;all.Active=not pending and not celebration
   end
   local i=selectedSkill;local upgrade=spec.Upgrades[i];local reveal=Prestige.CanReveal(lv,i);local metal=Color3.fromRGB(59,36,18)
   make("Frame",{Position=UDim2.fromOffset(22,304),Size=UDim2.fromOffset(418,1),BackgroundColor3=Color3.fromRGB(91,57,24),BackgroundTransparency=.68,BorderSizePixel=0},right)
   -- Skill names are already attached to their seals; no repeated footer title.
   local help=text(right,"Clique sur un sceau pour lire ses effets",22,286,418,43,28,Color3.fromRGB(48,29,17));help.TextXAlignment=Enum.TextXAlignment.Center
   if skillPopupOpen and bookOpened then
    local popup=make("Frame",{Name="BurntParchmentDescription",Position=UDim2.fromOffset(183,178),Size=UDim2.fromOffset(714,326),BackgroundColor3=Color3.fromRGB(66,32,15),BorderSizePixel=0,ZIndex=100},panel);round(popup,16)
    local paper=make("Frame",{Position=UDim2.fromOffset(8,8),Size=UDim2.new(1,-16,1,-16),BackgroundColor3=Color3.fromRGB(249,235,198),BorderSizePixel=0,ZIndex=101},popup);round(paper,12)
    gradient(paper,Color3.fromRGB(254,245,219),Color3.fromRGB(215,176,111),105)
    rim(paper,Color3.fromRGB(133,74,31))
    emblem(paper,upgrade.Id,C.gold,24,89,112)
    for _,art in ipairs(paper:GetDescendants())do if art:IsA("GuiObject")then art.ZIndex=102 end end
    local heading=text(paper,upgrade.Name,158,18,460,57,32,Color3.fromRGB(42,25,14));heading.Font=Enum.Font.Antique;heading.ZIndex=102
    local scroll=make("ScrollingFrame",{Position=UDim2.fromOffset(158,86),Size=UDim2.new(1,-186,1,-108),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=5,CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=102},paper)
    local description=make("TextLabel",{Size=UDim2.new(1,-15,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Text=upgrade.Description,Font=Enum.Font.Gotham,TextSize=28,TextColor3=Color3.fromRGB(42,25,14),TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,ZIndex=103},scroll)
    local x=button(paper,"×",636,14,40,40,Color3.fromRGB(111,65,30),function()skillPopupOpen=false;popup:Destroy()end);x.TextSize=29;x.ZIndex=104
    -- Destroy on category/book close without intercepting the purchase controls below.
    local connection;connection=RunService.RenderStepped:Connect(function()if not popup.Parent then connection:Disconnect();return end;if not bookOpened or currentTab~="Skills"or cinema and cinema.mode=="closing"then popup:Destroy();skillPopupOpen=false;connection:Disconnect()end end)
   end
   if lv>=i then
   elseif owned and i==lv+1 then
    for n,currency in ipairs({"Coins","Gems"})do
     local cost=upgrade[currency];local caption=type(cost)=="number"and(number(cost).." "..(currency=="Coins"and "CraxCoins"or "CraxGems"))or "Non configuré"
     local b=holdButton(right,caption,250,334+(n-1)*35,200,33,currency=="Coins"and Color3.fromRGB(147,92,28)or Color3.fromRGB(30,102,143),currentCrax,i,currency,nodes[i].scale)
     if pending then b.Active=false;local label=b:FindFirstChild("PriceLabel");label.Text="VALIDATION…"end
    end
   else
    text(right,not owned and "CRAX À DÉBLOQUER"or "SCEAU VERROUILLÉ",250,369,200,34,18,Color3.fromRGB(71,49,29)).TextXAlignment=Enum.TextXAlignment.Center
    text(right,not owned and "Dans Casin'O Crax"or "Niveau précédent requis",22,372,214,40,16,Color3.fromRGB(71,49,29)).TextXAlignment=Enum.TextXAlignment.Center
   end
  end


  for _,o in ipairs(cover:GetDescendants())do if o:IsA("TextLabel")or o:IsA("TextButton")then if o.Name~="CraxLevelTitle"and o.Name~="LevelTitleRelief"and o.Name~="LevelTitleBevel"then o.Font=Enum.Font.Antique end;if o.Size.Y.Offset>=25 then o.TextSize=math.max(o.TextSize,24) end end end
  cover.Visible=bookOpened and cinema:ReadingVisible()
  bookPrompt=button(sc,"OUVRIR ?",371,451,290,45,Color3.fromRGB(70,43,24),function()
   if switching or not cinema or cinema.mode~="closed"then return end
   bookOpened=true;bookPrompt.Visible=false;cover.Visible=false
   cinema:Open(currentCrax,level(currentCrax),false,data.DisplayName)
  end)
  if total>0 and lv>=total then
   bookDustStarted=os.clock()
   for i=1,96 do
    local dust=make("Frame",{Name="CompletedBookGoldDust",Size=UDim2.fromOffset(i%3==0 and 4 or 2,i%3==0 and 4 or 2),BackgroundColor3=Color3.fromRGB(232,185,82),BorderSizePixel=0,ZIndex=12,Active=false},sc);round(dust,4)
    bookDust[#bookDust+1]={o=dust,seed=i*.618,life=1.5+(i%17)*.06}
   end
  end
  bookPrompt.Name="OpenBookPrompt";bookPrompt.Font=Enum.Font.Antique;bookPrompt.TextSize=25
  bookPrompt.Visible=not bookOpened
  if not bookOpened and cinema and cinema.mode~="opening"and cinema.mode~="closing"and cinema.mode~="chapter"then cinema:Closed()end
  sc.CanvasSize=UDim2.fromOffset(0,496)
 end
end
for i,item in ipairs({{"News","À LA UNE",C.gold},{"Skills","LIVRE DE COMPÉTENCES",C.blue},{"Support","GEMS & SOUTIEN",Color3.fromRGB(144,215,122)}})do
 local b=button(panel,item[2],26+(i-1)*344,105,333,35,item[3],function()tab(item[1])end);tabs[item[1]]=b
end
local ambient
if type(style.AmbientMusicId)=="string"and style.AmbientMusicId~=""then ambient=make("Sound",{Name="CopEmShopMusic",SoundId=style.AmbientMusicId,Volume=.12,Looped=true},gui)end
if ambient then
 local group=SoundService:FindFirstChild("CraxMusicControl");if group and group:IsA("SoundGroup")then ambient.SoundGroup=group end
end
connect(player:GetAttributeChangedSignal("CraxMusicMuted"),function()
 if ambient then if player:GetAttribute("CraxMusicMuted")then ambient:Pause()elseif shade.Visible then ambient:Resume()end end
end)
local function finishClose()
 shade.Visible=false;bookOpened=false;switching=false;if chapterSnapshot then chapterSnapshot:Destroy();chapterSnapshot=nil end;if ambient then ambient:Stop()end;if cinema then cinema:Hide()end
end
local function closeShop(instant)
 if cinema and cinema.mode=="chapter"then cinema:Skip()end
 cancelHold();celebration=nil;viewEpoch=viewEpoch+1;effectReset();for _,p in ipairs(burstPool)do p.Visible=false end
 if not instant and shade.Visible and currentTab=="Skills"and bookOpened and cinema then cinema:Close(finishClose)else finishClose()end
end
local function openShop()
 if player:GetAttribute("ArenaSeat")~=nil or player:GetAttribute("InventoryReady")~=true then return end
 viewEpoch=viewEpoch+1;bookOpened=false;shade.Visible=true;message.Text=pending and "Un achat attend encore sa confirmation."or "";rebuild();play("Open");if currentTab=="Skills"and cinema then cinema:Closed()end
 if openingTween then openingTween:Cancel()end;entrance.Value=.96
 openingTween=TweenService:Create(entrance,TweenInfo.new(.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Value=1});openingTween:Play()
 if ambient and not player:GetAttribute("CraxMusicMuted")then ambient:Play()end
end
open.Activated:Connect(openShop)
local shopClose=button(panel,"×",997,22,47,43,C.red,closeShop);shopClose.Name="CloseCopEm";shopClose.TextSize=29
local function visibility()
 local ready=player:GetAttribute("ArenaSeat")==nil and player:GetAttribute("InventoryReady")==true
 open.Visible=ready;if not ready then closeShop(true)end
end
connect(player:GetAttributeChangedSignal("ArenaSeat"),visibility);connect(player:GetAttributeChangedSignal("InventoryReady"),visibility)
local burstOrigin=Vector2.new(540,335)
local function originFor(node)
 local scale=math.max(panelScale.Scale,.001)
 return (node.AbsolutePosition+node.AbsoluteSize*.5-panel.AbsolutePosition)/scale
end
local function burst(node,color)
 burstOrigin=originFor(node);burstStart=os.clock()
 for _,p in ipairs(burstPool)do p.TextColor3=color end
end
cinema=require(RS:WaitForChild("CraxBookCinema")).new(gui,function()
 -- Skip never changes balances and never cancels an outstanding server request.
 cancelHold();celebration=nil;effectReset();selectedSkill=math.min(level(currentCrax)+1,#(config[currentCrax].Upgrades or {}))
 if shade.Visible and currentTab=="Skills"then rebuild()end
end,sounds.Click.SoundId,function()if shade.Visible and currentTab=="Skills"then rebuild()end end)
local replyConnection=remote.OnClientEvent:Connect(function(data)
 if type(data)~="table"or data.RequestId~=pending then return end
 local purchase=transaction;pending=nil;transaction=nil;message.Text=data.Message or ""
 if data.Success and purchase then
  local replicated=levels:FindFirstChild(purchase.id)
  if not replicated or replicated.Value<purchase.step then confirmedLevels[purchase.id]=purchase.step else confirmedLevels[purchase.id]=nil end
 end
 if data.Success and purchase and purchase.all then
  local target=data.Level or purchase.step
  confirmedLevels[purchase.id]=target
  if shade.Visible and currentTab=="Skills"and bookOpened and currentCrax==purchase.id and purchase.epoch==viewEpoch then
   selectedSkill=math.min(target+1,#config[purchase.id].Upgrades);rebuild();play("Success")
   for k=(data.FromLevel or purchase.from)+1,target do local n=nodes[k];if n then
    n.ring:Set(1,Color3.fromRGB(255,133,30));n.scale.Scale=.65;n.top.Text="✓"
    TweenService:Create(n.scale,TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
   end end
   flash.BackgroundTransparency=.78;TweenService:Create(flash,TweenInfo.new(.45),{BackgroundTransparency=1}):Play()
  else schedule()end
  return
 end
 if data.Success and purchase and shade.Visible and currentTab=="Skills"and bookOpened and not switching and cinema.mode~="closing"and currentCrax==purchase.id and purchase.epoch==viewEpoch and nodes[purchase.step]then
  cancelHold()
  if gaugeFill then gaugeFill.Size=UDim2.fromScale(0,1)end
  local n=nodes[purchase.step];local metal=metals[math.min(purchase.step,4)]
  n.top.Text="ÉVEIL EN COURS"
  celebration={start=os.clock(),step=purchase.step,id=purchase.id,phase=0,max=purchase.step==4}
  cinema:Celebrate(purchase.step,purchase.step==4)
  -- Brief anticipation precedes the confirmed impact.
  ceremonyText.Visible=true;ceremonySub.Visible=true;awardPlate.Visible=true
  ceremonyText.Text=purchase.step==4 and "CONSÉCRATION MAX"or "ÉVOLUTION ÉVEILLÉE"
  ceremonyText.TextColor3=purchase.step==4 and C.red or metal
  ceremonySub.Text=config[purchase.id].Upgrades[purchase.step].Name
  sounds.Charge:Stop()
  TweenService:Create(n.scale,TweenInfo.new(.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1.025}):Play()
 else if data.Success then selectedSkill=nil end;schedule()end
end)
local function bindLevel(v)if v:IsA("IntValue")then connect(v.Changed,function()if v.Value>=(confirmedLevels[v.Name]or 0)then confirmedLevels[v.Name]=nil end;schedule()end)end end
for _,v in ipairs(levels:GetChildren())do bindLevel(v)end;connect(levels.ChildAdded,bindLevel)
connect(smileAtlas.Changed,schedule)
local render=RunService.RenderStepped:Connect(function()
 if not gui.Parent then return end
 local time=os.clock();local camera=workspace.CurrentCamera
 if time-dustLast>=1/30 then dustLast=time
 for _,e in ipairs(bookDust)do if shade.Visible and e.o.Parent then
  local phase=((time-bookDustStarted)/e.life+e.seed)%1
  e.o.Position=UDim2.fromOffset(80+(e.seed%1)*860+math.sin(time*.4+e.seed)*12,475-phase*350)
  e.o.BackgroundTransparency=1-math.sin(phase*math.pi)*.7
 end end
 end
 if book and book.Parent then
  book.Visible=bookOpened and cinema:ReadingVisible()
  if bookScale then bookScale.Scale=cinema:ReadingScale()end
 end
 if book and book.Parent then
  book.Rotation=0
 end
 for _,nav in ipairs(bookNav)do if nav.Parent then nav.Visible=bookOpened and(cinema.mode=="idle"or cinema.mode=="ceremony")end end
 if bookPrompt and bookPrompt.Parent then bookPrompt.Visible=not bookOpened and cinema and cinema.mode=="closed"end
 if hold then
  local h=hold
  local touchOutside=false
  if h.input.UserInputType==Enum.UserInputType.Touch then
   local p=h.input.Position;local a=h.button.AbsolutePosition;local z=h.button.AbsoluteSize
   touchOutside=p.X<a.X or p.Y<a.Y or p.X>a.X+z.X or p.Y>a.Y+z.Y
  end
  if touchOutside or not shade.Visible or currentTab~="Skills"or currentCrax~=h.id or not h.button.Parent or not available(h.id,h.step)then cancelHold()
  else
   local progress=math.clamp((time-h.start)/HOLD_SECONDS,0,1)
   if gaugeFill then gaugeFill.Size=UDim2.fromScale(progress,1)end
   if gaugeCaption then gaugeCaption.Text="ÉVEIL • "..math.floor(progress*100).." %"end
   h.fill.Size=UDim2.fromScale(progress,1);h.label.Text="MAINTIENS • "..math.floor(progress*100).." %"
   h.cardScale.Scale=1+progress*.07+math.sin(time*28)*progress*.003
   local n=nodes[h.step]
   if n then
    n.ring:Set(progress,Color3.fromRGB(255,133,30))
    local center=originFor(n.node)
    for k,o in ipairs(orbit)do
     o.Visible=true
     local t=(time*.8+k/24)%1;local angle=k*2.39996+time*.8
     local radius=65+(1-t)*(90+progress*45)
     o.Position=UDim2.fromOffset(center.X+math.cos(angle)*radius,center.Y+math.sin(angle)*radius)
     o.BackgroundTransparency=1-math.sin(t*math.pi)*progress;o.BackgroundColor3=C.gold
    end
   end
   if cinema then cinema:Charge(progress)end
   if progress>=1 then local id,step,currency=h.id,h.step,h.currency;local seal=h.seal;cancelHold();if seal then suppressSealClickUntil=os.clock()+.5;choosePayment(id,step,false)else buy(id,step,currency)end end
  end
 end
 if celebration then
  local c=celebration;local age=time-c.start;
  local charge=math.clamp(age/2.05,0,1)
  if gaugeFill then gaugeFill.Size=UDim2.fromScale(charge,1)end
  if gaugeCaption then gaugeCaption.Text="ÉVEIL • "..math.floor(charge*100).." %"end;local n=nodes[c.step]
  local metal=c.max and Color3.fromRGB(255,98,45)or metals[math.min(c.step,4)]
  local anticipation=.28;local impactEnd=.95;local arrival=2.05;local finish=c.max and 5.2 or 2.7
  if c.max then vignette.BackgroundTransparency=1-math.sin(math.clamp(age/finish,0,1)*math.pi)*.38 end
  if age<anticipation and n then n.scale.Scale=1-age*.25 end
  if age>=anticipation and c.phase==0 then
   c.phase=1
   if n then
    n.top.Text="ACQUIS ✓";burst(n.node,metal)
    TweenService:Create(n.scale,TweenInfo.new(.38,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1.1}):Play()
    shock.Position=UDim2.fromOffset(burstOrigin.X,burstOrigin.Y);shock.Visible=true;shockEdge.Color=metal
    n.ring:Set(1,Color3.fromRGB(255,133,30))
   end
   if cinema then cinema:Impact()end
  end
  if c.phase>0 then
   local impact=age-anticipation
   flash.BackgroundColor3=metal;flash.BackgroundTransparency=1-math.max(0,1-impact/.35)*.23
   shock.Size=UDim2.fromOffset(100+impact*180,100+impact*180);shockEdge.Transparency=math.clamp(impact/.8,0,1)
  end
  local link=links[c.step]
  if age>=impactEnd and not c.conductorStarted then c.conductorStarted=true;if cinema and not c.max then cinema:Conductor()end end
  if age>=impactEnd and link and link.Parent then
   local travel=math.clamp((age-impactEnd)/(arrival-impactEnd),0,1)
   link.Size=UDim2.fromScale(travel,1)
   local rail=link.Parent;local fit=math.max(panelScale.Scale,.001)
   local from=nodes[c.step]and originFor(nodes[c.step].node)
   local to=nodes[c.step+1]and originFor(nodes[c.step+1].node)
   local tip=from and to and from:Lerp(to,travel)or Vector2.new(0,0)
   spark.Visible=travel<1;spark.Position=UDim2.fromOffset(tip.X,tip.Y);spark.BackgroundColor3=metal
  end
  if age>=arrival and c.phase==1 and level(c.id)>=c.step then
   c.phase=2;selectedSkill=math.min(c.step+1,#config[c.id].Upgrades);rebuild()
   local nextNode=nodes[c.step+1]
   if nextNode then
    if cinema then cinema:Reveal()end;burst(nextNode.node,metals[math.min(c.step+1,4)])
    nextNode.scale.Scale=.78
    TweenService:Create(nextNode.scale,TweenInfo.new(.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
    message.Text="Sceau brisé • prochaine évolution révélée."
   elseif c.max then
    ceremonyText.Text=config[c.id].Upgrades[c.step].Name.." • MAX"
    ceremonySub.Text="Trophée débloqué • animation de victoire activée"
    burst(nodes[c.step].node,metal)
    flash.BackgroundTransparency=.78
   end
  end
  if age>=finish and c.phase==2 then celebration=nil;effectReset();if cinema then cinema:EndCelebration()end;rebuild()end
 end
 if shade.Visible and camera then
  local fit=math.min(1,camera.ViewportSize.X*.95/(currentTab=="News" and panel.Size.X.Offset or 1080),camera.ViewportSize.Y*.9/(currentTab=="News" and panel.Size.Y.Offset or 720))
  panelScale.Scale=fit*entrance.Value
  for _,e in ipairs(previews)do if e.view.Parent and not e.locked then
   local yaw=math.sin(time*.6)*.10;local direction=CFrame.Angles(0,yaw,0):VectorToWorldSpace(e.front)
   local zoom=e.view==heroView and(hold and .08*math.clamp((time-hold.start)/HOLD_SECONDS,0,1)or celebration and .1 or 0)or 0
   e.camera.CFrame=CFrame.lookAt(e.center+direction*e.diameter*(1.95-zoom)+Vector3.new(0,math.sin(time*.9)*.05,0),e.center)
  end end
  for i=#particles,1,-1 do local e=particles[i]
   if not e.object.Parent then table.remove(particles,i)else
    local t=(time*.10+e.seed)%1;e.object.Position=UDim2.fromScale((e.seed*.73)%1,1-t)
    e.object.TextTransparency=.3+math.abs(.5-t)*1.1;e.object.Rotation=time*12
   end
  end
  local age=time-burstStart
  for i,p in ipairs(burstPool)do
   p.Visible=age>=0 and age<.8
   if p.Visible then local angle=i*2.39996;local radius=10+age*170
    p.Position=UDim2.fromOffset(burstOrigin.X+math.cos(angle)*radius,burstOrigin.Y+math.sin(angle)*radius*.6)
    p.TextTransparency=age/.8;p.Rotation=age*130
   end
  end
 end
 for _,e in ipairs(pulseEntries)do
  if e.scale.Parent and shade.Visible and not hold and not celebration then e.scale.Scale=1+math.sin(time*2.1)*.018 end
 end
 for _,e in ipairs(neonEntries)do
  if e.edge.Parent and shade.Visible then e.g.Rotation=(time*85)%360;e.edge.Transparency=.08+(.5+.5*math.sin(time*3))*.18 end
 end
 for i=#shineEntries,1,-1 do local e=shineEntries[i]
  if not e.parent.Parent then table.remove(shineEntries,i)
  elseif shade.Visible or e.parent:IsDescendantOf(open)then e.gradient.Offset=Vector2.new(math.sin(time*.7)*.23,0);e.gradient.Rotation=35+math.sin(time*.45)*35 end
 end
end)
-- Disconnect shared signals and dispose pooled sounds if the UI is replaced.
gui.Destroying:Connect(function()cancelHold();if cinema then cinema:Destroy()end;render:Disconnect();inputEnded:Disconnect();focusLost:Disconnect();replyConnection:Disconnect();for _,connection in ipairs(sharedConnections)do connection:Disconnect()end;for _,sound in pairs(sounds)do sound:Destroy()end end)
visibility()

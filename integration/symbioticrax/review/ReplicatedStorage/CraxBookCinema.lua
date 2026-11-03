-- SymbiotiCraxIntegrationV1
-- SuperCraxIntegrationV1
-- GoldenBookTitleFix_v2
-- v8: one closed cover only; illustrated folios for opening/reading/transitions.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local CP=game:GetService("ContentProvider")
local Cinema={};Cinema.__index=Cinema
local function make(class,props,parent)local o=Instance.new(class);for k,v in pairs(props)do o[k]=v end;o.Parent=parent;return o end
local function ease(t,a,b)local x=math.clamp((t-a)/(b-a),0,1);return x*x*(3-2*x)end
local specs={Room=.07,Seal=.15,Clasp=.2,Leather=.19,Page1=.18,Page2=.19,Page3=.18,Ink=.13,Charge=.16,Unlock=.27,Conductor=.17,Reveal=.22,Max=.32,Close=.21}
function Cinema.new(gui,onSkip,unused,onOpened)
 local self=setmetatable({gui=gui,onSkip=onSkip,onOpened=onOpened,alive=true,mode="hidden",audio={},connections={},charge=0},Cinema)
 self.short=Players.LocalPlayer:GetAttribute("CraxBookShortAnimations")==true
 self.overlay=make("Frame",{Name="GrimoireParking",Visible=false,BackgroundTransparency=1,Size=UDim2.fromScale(1,1)},gui)
 self.scene=make("Frame",{Name="ChurchLecternScene",BackgroundColor3=Color3.fromRGB(10,9,8),BorderSizePixel=0,Size=UDim2.fromScale(1,1),Visible=false,ZIndex=1},self.overlay)
 local visuals=RS:WaitForChild("CraxBookVisuals")
 local room=visuals:FindFirstChild("RoomArt")
 self.roomArt=make("ImageLabel",{Name="DarkChurch",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=room and room.Value or "",ScaleType=Enum.ScaleType.Crop,ZIndex=1},self.scene)
 if room then self.connections[#self.connections+1]=room.Changed:Connect(function()self.roomArt.Image=room.Value end)end
 self.view=make("ViewportFrame",{Name="AncientBook3D",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Ambient=Color3.fromRGB(185,171,150),LightColor=Color3.fromRGB(255,243,216),LightDirection=Vector3.new(-.4,-1,-.7),ZIndex=2},self.overlay)
 self.world=make("WorldModel",{},self.view)
 self.camera=make("Camera",{FieldOfView=27},self.view);self.view.CurrentCamera=self.camera
 local meshes=RS:FindFirstChild("CraxBookMeshes");local donor=meshes and meshes:FindFirstChild("Cover")
 assert(donor and donor:IsA("MeshPart"),"Le MeshPart Cover manque dans CraxBookMeshes.")
 self.cover=donor:Clone()
 self.cover.Name="NewGrimoireCoverOnly";self.cover.Size=Vector3.new(5.2,.3,4.1);self.cover.Color=Color3.fromRGB(97,32,24)
 self.cover.Anchored=true;self.cover.CanCollide=false;self.cover.CanTouch=false;self.cover.CanQuery=false;self.cover.Parent=self.world
 -- No folio, page block, old seal, clasp or old grimoire geometry is created.
 for _,o in ipairs(self.cover:GetChildren())do if o:IsA("Decal")or o:IsA("SurfaceAppearance")then o:Destroy()end end
 self.cover.TextureID=""
 make("Decal",{Name="CorrectFacingCoverArt",Face=Enum.NormalId.Top,Texture=visuals:WaitForChild("CoverArt").Value},self.cover)
 self.cover.Color=Color3.fromRGB(54,17,14)
 self.base=CFrame.new(0,0,0)*CFrame.Angles(math.rad(28),math.pi,0)
 self.camera.CFrame=CFrame.lookAt(Vector3.new(0,6.8,13),Vector3.new(0,0,0),Vector3.new(0,1,0))
 self.skip=make("TextButton",{Name="SkipBookAnimation",AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-23,0,12),Size=UDim2.fromOffset(100,34),BackgroundColor3=Color3.fromRGB(27,21,15),BackgroundTransparency=.2,Text="Passer ›",TextSize=14,Font=Enum.Font.Antique,TextColor3=Color3.fromRGB(235,219,183),Visible=false,ZIndex=110},gui)
 self.connections[#self.connections+1]=self.skip.Activated:Connect(function()self:Skip()end)
 self.trophyIcon=make("Frame",{Name="OriginalDevourerTrophy",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.48),Size=UDim2.fromOffset(176,176),BackgroundTransparency=1,Visible=false,ZIndex=112},gui)
 self.trophyArt=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1},self.trophyIcon)
 local icons=RS:FindFirstChild("CraxTrophyIcons");if icons then require(icons).Build(self.trophyArt)end
 self.trophyScale=make("UIScale",{Scale=1},self.trophyIcon)
 make("TextLabel",{Name="TrophyTitle",Position=UDim2.fromOffset(-52,182),Size=UDim2.fromOffset(280,42),Text="DEVOREUR",TextSize=31,Font=Enum.Font.Antique,TextColor3=Color3.fromRGB(230,185,77),BackgroundTransparency=1,ZIndex=120},self.trophyIcon)
 local audioFolder=RS:FindFirstChild("CraxBookAudio");local pg=Players.LocalPlayer:WaitForChild("PlayerGui");local preload={self.roomArt}
 for name,volume in pairs(specs)do
  local value=audioFolder and audioFolder:FindFirstChild(name)
  local sound=make("Sound",{Name="Book"..name,SoundId=value and value.Value or "",Volume=volume,Looped=name=="Room"or name=="Charge"},pg)
  self.audio[name]=sound;preload[#preload+1]=sound
 end
 task.spawn(function()pcall(function()CP:PreloadAsync(preload)end)end)
 self.connections[#self.connections+1]=RunService.RenderStepped:Connect(function()self:_update()end)
 return self
end
function Cinema:_sound(name)local s=self.audio[name];if s and s.SoundId~=""then s:Stop();s.TimePosition=0;s:Play()end end
function Cinema:_stopLoops()for _,sound in pairs(self.audio)do if sound.Looped then sound:Stop()end end end
function Cinema:_stopSounds()for _,s in pairs(self.audio)do s:Stop()end end
function Cinema:SetProgress(level)self.level=level end
-- SpideyBookCinema_v1
function Cinema:SetCrax(id)
 if self.crax==id then return end;self.crax=id
 self.trophyArt:ClearAllChildren()
 if self._symTitleScaled==nil then self._symTitleScaled=self.trophyIcon.TrophyTitle.TextScaled end
 self.trophyIcon.TrophyTitle.TextScaled=self._symTitleScaled
 if id=='Crax_Symbioti'then
  local C=require(game:GetService('ReplicatedStorage').CraxSymConfig);local image=C.Icons.Max
  if image~=''then make('ImageLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=image,ScaleType=Enum.ScaleType.Fit,ZIndex=113},self.trophyArt)
  else make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='MAX',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(255,211,87),ZIndex=113},self.trophyArt)end
  self.trophyIcon.TrophyTitle.Text=C.TrophyTitle;self.trophyIcon.TrophyTitle.TextScaled=true;return
 end
 if id=='Crax_Super'then
  local C=require(game:GetService('ReplicatedStorage'):WaitForChild('CraxSuperConfig'));local image=C.Icons.Max
  if image~=''then make('ImageLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=image,ScaleType=Enum.ScaleType.Fit,ZIndex=113},self.trophyArt)
  else make('TextLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Text='SUPER MAX',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(246,192,42),ZIndex=113},self.trophyArt)end
  self.trophyIcon.TrophyTitle.Text='EXÉCUTION MAX';return
 end
 if id=='Crax_Inverted'then
  make('TextLabel',{Size=UDim2.fromScale(1,1),Text='404',TextScaled=true,Font=Enum.Font.FredokaOne,TextColor3=Color3.fromRGB(244,242,232),BackgroundTransparency=1,ZIndex=113},self.trophyArt)
  self.trophyIcon.TrophyTitle.Text='ERREUR 404';return
 end
 if id=="Crax_Spidey"then require(RS:WaitForChild("CraxSpideyIcons")).Build(self.trophyArt,"Weaver")
 else local icons=RS:FindFirstChild("CraxTrophyIcons");if icons then require(icons).Build(self.trophyArt)end end
 self.trophyIcon.TrophyTitle.Text=id=="Crax_Golden"and "VRAIE RICHESSE"or id=="Crax_Spidey"and "TISSEUR"or "DEVOREUR"
end -- The client already draws the Crax on its illustrated page.
function Cinema:SetHome(parent,pos,size)
 self.home={parent=parent,pos=pos,size=size}
 self.scene.Parent=parent;self.scene.Position=pos;self.scene.Size=size
 self.view.Parent=parent
 -- Cover sits on the central reading plane of the generated stone lectern.
 self.view.Position=UDim2.new(pos.X.Scale,pos.X.Offset+size.X.Offset*.18,pos.Y.Scale,pos.Y.Offset+size.Y.Offset*.17)
 self.view.Size=UDim2.fromOffset(size.X.Offset*.64,size.Y.Offset*.69)
 self.scene.Visible=self.mode~="hidden";self.view.Visible=self.mode=="closed"or self.mode=="opening"or self.mode=="closing"
 self.cover.CFrame=self.base
end
function Cinema:DetachHome()
 self.home=nil;self.scene.Parent=self.overlay;self.view.Parent=self.overlay
end
function Cinema:Closed()
 self.mode="closed";self.skip.Visible=false;self.trophyIcon.Visible=false;self:_stopSounds()
 self.scene.Visible=true;self.view.Visible=true;self.view.ImageTransparency=0;self.cover.CFrame=self.base
end
function Cinema:Open(id,level,chapterOnly,displayName)
 self:_stopSounds();self.mode="opening";self.start=os.clock();self.skip.Visible=true;self.scene.Visible=true;self.view.Visible=true;self.view.ImageTransparency=0
 self.fired={};self:_sound("Clasp")
end
function Cinema:ReadingVisible()
 return self.mode=="idle"or self.mode=="ceremony"or self.mode=="chapter"or self.mode=="opening"and(os.clock()-self.start)>.18 or self.mode=="closing"and(os.clock()-self.start)<.45
end
function Cinema:ReadingFade()
 if self.mode=="opening"then return 1-ease((os.clock()-self.start)/(self.short and .4 or .9),.2,.85)end
 if self.mode=="closing"then return ease((os.clock()-self.start)/.7,0,.6)end
 return 0
end
function Cinema:ReadingScale()
 if self.mode=="opening"then return .84+.16*ease((os.clock()-self.start)/(self.short and .4 or .9),.2,1)end
 if self.mode=="closing"then return 1-.1*ease((os.clock()-self.start)/.7,0,1)end
 return 1
end
function Cinema:_finishOpen()
 self.mode="idle";self.view.Visible=false;self.skip.Visible=false;self:_stopSounds();if self.onOpened then self.onOpened()end
end
function Cinema:TurnChapter(commit,finished)
 self.mode="chapter";self.start=os.clock();self.chapterCommit=commit;self.chapterFinished=finished;self.committed=false;self.skip.Visible=true;self.view.Visible=false;self:_sound("Page2")
end
function Cinema:ChapterProgress()return self.mode=="chapter"and math.clamp((os.clock()-self.start)/.68,0,1)or 0 end
function Cinema:_finishChapter()
 if not self.committed then self.committed=true;if self.chapterCommit then self.chapterCommit()end end
 local done=self.chapterFinished;self.chapterCommit=nil;self.chapterFinished=nil;self.mode="idle";self.skip.Visible=false;self.view.Visible=false
 if done then done()end
end
function Cinema:Close(callback)
 if self.mode=="closed"or not self.alive then if callback then callback()end;return end
 self:_stopSounds();self.mode="closing";self.start=os.clock();self.closeCallback=callback;self.skip.Visible=true;self.trophyIcon.Visible=false;self.view.Visible=true;self.view.ImageTransparency=1;self:_sound("Close")
end
function Cinema:_finishClose()local done=self.closeCallback;self.closeCallback=nil;self:Hide();if done then done()end end
function Cinema:Charge(value)self.charge=value;if value>0 and not self.audio.Charge.IsPlaying then self:_sound("Charge")end end
function Cinema:CancelCharge()self.charge=0;self.audio.Charge:Stop()end
function Cinema:Celebrate(step,isMax)self.mode="ceremony";self.start=os.clock();self.isMax=isMax;self.level=step;self.skip.Visible=true;self:CancelCharge()end
function Cinema:Impact()self:_sound(self.isMax and "Max"or "Unlock")end
function Cinema:Conductor()self:_sound("Conductor")end
function Cinema:Reveal()self:_sound("Reveal")end
function Cinema:EndCelebration()self.mode="idle";self.skip.Visible=false;self.trophyIcon.Visible=false;self:_stopLoops();self.view.Visible=false end
function Cinema:Skip()
 if self.mode=="opening"then self:_finishOpen()
 elseif self.mode=="chapter"then self:_finishChapter()
 elseif self.mode=="closing"then self:_finishClose()
 elseif self.mode=="ceremony"then self:EndCelebration();if self.onSkip then self.onSkip()end end
end
function Cinema:Hide()self.mode="hidden";self.scene.Visible=false;self.view.Visible=false;self.skip.Visible=false;self.trophyIcon.Visible=false;self:_stopSounds()end
function Cinema:_update()
 if not self.alive or self.mode=="hidden"then return end
 local now=os.clock()
 if self.mode=="opening"then
  local t=(now-self.start)/(self.short and .4 or .9)
  self.cover.CFrame=self.base*CFrame.Angles(0,0,-ease(t,0,.6)*.65)
  self.view.ImageTransparency=ease(t,.17,.55)
  if t>.2 and not self.fired.leather then self.fired.leather=true;self:_sound("Leather")end
  if t>.43 and not self.fired.page then self.fired.page=true;self:_sound("Page1")end
  if t>=1 then self:_finishOpen()end
 elseif self.mode=="closing"then
  local t=(now-self.start)/.7
  self.view.ImageTransparency=1-ease(t,.35,.85);self.cover.CFrame=self.base*CFrame.Angles(0,0,-.4*(1-ease(t,.35,1)))
  if t>=1 then self:_finishClose()end
 elseif self.mode=="chapter"then
  local t=self:ChapterProgress()
  if t>=.55 and not self.committed then self.committed=true;if self.chapterCommit then self.chapterCommit()end end
  if t>=1 then self:_finishChapter()end
 elseif self.mode=="ceremony"and self.isMax then
  local t=now-self.start;self.trophyIcon.Visible=t>.25 and t<5.2;self.trophyScale.Scale=.8+.2*ease(t,.25,1)
 end
end
function Cinema:Destroy()
 if not self.alive then return end;self:Hide();self.alive=false
 for _,c in ipairs(self.connections)do c:Disconnect()end
 for _,s in pairs(self.audio)do s:Destroy()end
 self.scene:Destroy();self.view:Destroy();self.overlay:Destroy();self.skip:Destroy();self.trophyIcon:Destroy()
end
return Cinema

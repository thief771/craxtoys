-- Play arrêté : duel PolariCrax contre PolariCrax, perdant de face et gagnant de profil.
do
assert(not game:GetService('RunService'):IsRunning(),'Arrêter Play')
local editor=game:GetService('ScriptEditorService');local SS=game:GetService('ServerStorage')
local client=assert(game:GetService('StarterPlayer'):FindFirstChild('StarterPlayerScripts'):FindFirstChild('CraxPolariClient'),'Client Polari absent')
local marker='-- PolariMirrorPortraitV1'
local before=editor:GetEditorSource(client)
if before:find(marker,1,true)then print('Duel Polari déjà ajusté. Enregistrer puis nouveau Play.');return end
local function once(source,old,new)
 local a,b=source:find(old,1,true);assert(a and not source:find(old,b+1,true),'Version de cinématique différente : aucun fichier modifié')
 return source:sub(1,a-1)..new..source:sub(b+1)
end
local after=before
after=once(after,[====[ -- Authored eyes define the face: some head meshes face +Z instead of Roblox's -Z.
 local faceOffset=heroOffset
 local eyeLeft=s.hero:FindFirstChild('EyeLeft',true);local eyeRight=s.hero:FindFirstChild('EyeRight',true)
 if eyeLeft and not eyeLeft:IsA('BasePart')then eyeLeft=eyeLeft:FindFirstChildWhichIsA('BasePart',true)end
 if eyeRight and not eyeRight:IsA('BasePart')then eyeRight=eyeRight:FindFirstChildWhichIsA('BasePart',true)end
 if heroHead and eyeLeft and eyeRight then
  local eyes=(eyeLeft.Position+eyeRight.Position)*.5
  if(eyes-heroHead.Position).Magnitude>.01 then faceOffset=s.hero:GetPivot():ToObjectSpace(aim(heroHead.Position,eyes,heroHead.CFrame.UpVector))end
 end
]====],[====[ -- Authored eyes define each face, including meshes authored on the opposite axis.
 local function actorFaceOffset(model,fallback)
  local actorHead=model:FindFirstChild('Head',true)
  local leftEye=model:FindFirstChild('EyeLeft',true);local rightEye=model:FindFirstChild('EyeRight',true)
  if leftEye and not leftEye:IsA('BasePart')then leftEye=leftEye:FindFirstChildWhichIsA('BasePart',true)end
  if rightEye and not rightEye:IsA('BasePart')then rightEye=rightEye:FindFirstChildWhichIsA('BasePart',true)end
  if actorHead and leftEye and rightEye then
   local eyes=(leftEye.Position+rightEye.Position)*.5
   if(eyes-actorHead.Position).Magnitude>.01 then return model:GetPivot():ToObjectSpace(aim(actorHead.Position,eyes,actorHead.CFrame.UpVector))end
  end
  return fallback
 end
 local faceOffset=actorFaceOffset(s.hero,heroOffset)
 local victimFaceOffset=actorFaceOffset(s.victim,victimOffset)
 local mirrorMatch=loser:GetAttribute('CraxId')==C.Id
]====])
after=once(after,[====[  local heroPose=heroCenter*wr*heroOffset:Inverse()
  local faceCamera=aim(heroCenter.Position,wanted.Position,basis.UpVector)*faceOffset:Inverse()
  s.hero:PivotTo(heroPose:Lerp(faceCamera,closing))
  local back=ease(t,C.FinaleDuration-.8,C.FinaleDuration)
]====],[====[  local heroPose=heroCenter*wr*heroOffset:Inverse()
  local faceCamera=aim(heroCenter.Position,wanted.Position,basis.UpVector)*faceOffset:Inverse()
  local back=ease(t,C.FinaleDuration-.8,C.FinaleDuration)
  if mirrorMatch then
   local view=wanted:Lerp(s.saved.CFrame,back)
   s.victim:PivotTo(aim(victimCenter.Position,view.Position,basis.UpVector)*victimFaceOffset:Inverse())
   -- A quarter-turn relative to the actual camera: the winner is always in profile.
   local side=(view.Position-heroCenter.Position):Cross(basis.UpVector)
   if side.Magnitude<1e-6 then side=basis:VectorToWorldSpace(Vector3.new(1,0,0))end
   s.hero:PivotTo(aim(heroCenter.Position,heroCenter.Position+side,basis.UpVector)*faceOffset:Inverse())
  else s.hero:PivotTo(heroPose:Lerp(faceCamera,closing))end
]====])
after=marker..'\n'..after
local safetyName='PolariCrax_MirrorPose_Safety_V1'
assert(not SS:FindFirstChild(safetyName),'Inspecter la sauvegarde existante '..safetyName..' avant de continuer')
local safety=Instance.new('Folder');safety.Name=safetyName;safety:SetAttribute('PolariOwned',true);safety:SetAttribute('Incomplete',true)
for key,value in pairs({Original=before,Installed=after})do local v=Instance.new('StringValue');v.Name=key;v.Value=value;v.Parent=safety end
safety.Parent=SS
local ok,problem=pcall(function()
 editor:UpdateSourceAsync(client,function(current)assert(current==before,'Édition concurrente ; ne pas écraser');return after end)
 assert(editor:GetEditorSource(client)==after,'Écriture non vérifiée')
end)
if not ok then
 if editor:GetEditorSource(client)==before then safety:Destroy()else warn('Édition concurrente préservée ; sauvegarde conservée dans '..safetyName)end
 error(tostring(problem))
end
local backup=SS:FindFirstChild('PolariCrax_Backup_V1');local entries=backup and backup:FindFirstChild('Entries')
if entries then for _,entry in ipairs(entries:GetChildren())do if entry:GetAttribute('Path')=='StarterPlayer.StarterPlayerScripts.CraxPolariClient'then local installed=entry:FindFirstChild('Installed');if installed and installed.Value==before then installed.Value=after end end end end
safety:SetAttribute('Incomplete',false)
print('Duel Polari : perdant de face, gagnant de profil. Autres duels, sons, titre et cahier conservés. ENREGISTRER puis NOUVEAU Play.')
end

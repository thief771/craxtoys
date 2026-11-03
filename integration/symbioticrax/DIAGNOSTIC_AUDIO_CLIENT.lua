-- Coller côté CLIENT pendant Play, après branchement de l’atlas et un nouveau Play.
do
assert(game:GetService('Players').LocalPlayer,'Exécuter côté CLIENT pendant Play')
local RS=game:GetService('ReplicatedStorage');local C=require(RS:WaitForChild('CraxSymConfig'));local Map=require(RS:WaitForChild('CraxSymAudioMap'))
assert(C.AtlasId~='','Atlas non branché : importer SymbiotiCrax_AUDIO_ATLAS.wav puis BRANCHER_ASSETS_SYMBIOTICRAX.lua en STOP')
task.spawn(function()
 local s=Instance.new('Sound');s.Name='SymAudioDiagnostic';s.SoundId=C.AtlasId;s.Volume=.18;s.Parent=game:GetService('SoundService')
 local started=os.clock();local preloadStatus
 task.spawn(function()pcall(function()game:GetService('ContentProvider'):PreloadAsync({s},function(_,status)preloadStatus=tostring(status)end)end)end)
 while not s.IsLoaded and os.clock()-started<15 do task.wait(.1)end
 if not s.IsLoaded then warn('SYMBIOTICRAX AUDIO : chargement refusé ou expiré. ID='..C.AtlasId..', statut='..tostring(preloadStatus)..'. Vérifier permissions du propriétaire et de l’expérience, modération et vrai ID audio.');s:Destroy();return end
 if math.abs(s.TimeLength-Map.Duration)>.12 then warn('SYMBIOTICRAX AUDIO : mauvais atlas ou durée modifiée : '..s.TimeLength..' s, attendu '..Map.Duration..' s. Ne pas utiliser les plages avec cet asset.');s:Destroy();return end
 local list={};for name,clip in pairs(Map.Segments)do assert(clip.Start>=0 and clip.End>clip.Start and clip.End<=s.TimeLength+.02,'Plage invalide : '..name);list[#list+1]={name=name,clip=clip}end;table.sort(list,function(a,b)return a.clip.Start<b.clip.Start end)
 print('Atlas chargé, durée et '..#list..' plages validées. Écoute directe de chaque passage ; vérifier soi-même le rendu sonore.')
 for _,e in ipairs(list)do
  if not s.Parent then return end
  print('ÉCOUTE '..e.name..' ['..e.clip.Start..' – '..e.clip.End..']')
  s.PlaybackRegionsEnabled=true;s.PlaybackRegion=NumberRange.new(e.clip.Start,e.clip.End);s.TimePosition=e.clip.Start;s:Play();task.wait(e.clip.End-e.clip.Start+.12);s:Stop()
 end
 s:Destroy();print('Diagnostic terminé. Ceci ne valide pas encore les déclenchements en combat, le mixage ou les spectateurs.')
end)
end

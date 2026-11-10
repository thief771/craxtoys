-- Client audio atlas: independent Sound per event, native playback regions bound every clip.
local RS=game:GetService('ReplicatedStorage');local Run=game:GetService('RunService')
local C=require(RS:WaitForChild('CraxVeniConfig'));local Map=require(RS:WaitForChild('CraxVeniAudioMap'))
local M={};local entries={};local root;local connection;local preloaded=false;local missingReported=false
local mix={PoisonTick=.45,BiteStack=.6,CobraLoop=.55,MoltIdle=.4,Cloud=.9,MaxShatter=1,MaxSting=.9}
local function atlasId()
 local user=RS:FindFirstChild('CraxVeniUserAssets');local id=user and user:GetAttribute('AudioAtlas')
 if type(id)=='string'and id:match('^rbxassetid://%d+$')then return id end
 return C.AtlasId
end
local function remove(i)local e=entries[i];e.sound:Stop();e.sound:Destroy();e.anchor:Destroy();table.remove(entries,i)end
function M.Play(name,position,loop,finale,localMix)
 local clip=Map.Segments[name];if not clip then return end
 local id=atlasId()
 if id==''then if not missingReported then missingReported=true;warn('VeniCrax : importer VeniCrax_Audio_Atlas.wav et configurer CraxVeniUserAssets.AudioAtlas pour activer les sons.')end;return end
 if #entries>=28 then remove(1)end
 if not root or not root.Parent then root=Instance.new('Folder');root.Name='VeniAudio';root.Parent=workspace end
 local p=Instance.new('Part');p.Size=Vector3.one*.05;p.Position=position;p.Transparency=1;p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Parent=root
 local s=Instance.new('Sound');s.Name='Veni_'..name;s.SoundId=id;local gain=C.Volume*(mix[name]or 1);s.Volume=finale and gain*.95 or math.min(1,gain*3);s.RollOffMinDistance=8;s.RollOffMaxDistance=135;s.PlaybackRegionsEnabled=true;s.PlaybackRegion=NumberRange.new(clip.Start,clip.End);s.LoopRegion=NumberRange.new(clip.Start,clip.End);s.TimePosition=clip.Start;s.Looped=loop==true and clip.Loop

 -- Seated arena presentation uses a camera mix; spectators keep spatial attenuation.
 s.Parent=localMix and root or p
 if preloaded~=id then preloaded=id;task.spawn(function()pcall(function()game:GetService('ContentProvider'):PreloadAsync({s})end)end)end
 local entry={sound=s,anchor=p,clip=clip,born=os.clock()};entries[#entries+1]=entry
 if not connection then connection=Run.Heartbeat:Connect(function()
  for i=#entries,1,-1 do local e=entries[i]
   if not e.started and e.sound.IsLoaded and not e.paused then
    if math.abs(e.sound.TimeLength-Map.Duration)>.12 then warn('VeniCrax : l’atlas audio configuré n’a pas la bonne durée');e.born=-math.huge
    else e.sound.TimePosition=e.clip.Start;e.sound:Play();e.started=true end
   end
   if not e.anchor.Parent or os.clock()-e.born>15 or(e.sound.IsLoaded and not e.sound.Looped and e.sound.TimePosition>=e.clip.End-.001)or(e.started and e.sound.IsLoaded and os.clock()-e.born>.2 and not e.sound.IsPlaying and not e.sound.IsPaused)then remove(i)end
  end
  if #entries==0 and connection then connection:Disconnect();connection=nil end
 end)end
 return entry
end
function M.Move(entry,position)if entry and entry.anchor.Parent then entry.anchor.Position=position end end
function M.Stop(entry)if not entry then return end;for i=#entries,1,-1 do if entries[i]==entry then remove(i)end end end
function M.Pause(entry,paused)if entry and entry.anchor.Parent then entry.paused=paused;if entry.started then if paused and entry.sound.IsPlaying then entry.sound:Pause()elseif not paused and entry.sound.IsPaused then entry.sound:Resume()end end end end
function M.Clear()for i=#entries,1,-1 do remove(i)end;if connection then connection:Disconnect();connection=nil end;if root then root:Destroy();root=nil end end
return M

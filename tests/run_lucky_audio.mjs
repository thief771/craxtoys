import fs from'node:fs';import{LuauState}from'luau-web';const read=p=>fs.readFileSync(new URL('../'+p,import.meta.url),'utf8');
let base=read('tests/super_installer_fixture.lua').split('local V={}')[0];base=base.replace("  if key=='GetPivot'then",`  if key=='Play'then return function()values.IsPlaying=true;values.IsPaused=false end end
  if key=='Stop'then return function()values.IsPlaying=false;values.TimePosition=0 end end
  if key=='Pause'then return function()values.IsPlaying=false;values.IsPaused=true end end
  if key=='Resume'then return function()values.IsPlaying=true;values.IsPaused=false end end
  if key=='GetPivot'then`);
const lua=`${base}\n${read('tests/client_fixture.lua')}\ntask.spawn=function(f)f()end;create('ContentProvider','ContentProvider')\nlocal config={AtlasId='rbxassetid://123',Volume=.16};local map=(function()${read('src/luckycrax/CraxLuckyAudioMap.lua')}end)()\nconfigObject.Name='CraxLuckyConfig';local mapObject=create('ReplicatedStorage.CraxLuckyAudioMap','ModuleScript');NumberRange={new=function(a,b)return{Min=a,Max=b}end};require=function(o)if o==configObject then return config elseif o==mapObject then return map end end\nlocal Audio=(function()${read('src/luckycrax/CraxLuckyAudio.lua')}end)()\nlocal n=0;local function check(v,msg)n+=1;assert(v,msg)end
local first=Audio.Play('CoinFlip',Vector3.new(0,0,0));check(first and not first.started,'unloaded audio waits before playing')
first.sound.IsLoaded=true;first.sound.TimeLength=map.Duration;heartbeat:Fire(.1);check(first.started and first.sound.TimePosition==map.Segments.CoinFlip.Start,'correct segment starts after load');check(first.sound.PlaybackRegionsEnabled and first.sound.PlaybackRegion.Max==map.Segments.CoinFlip.End,'native playback range configured')
local second=Audio.Play('CoinHit',Vector3.new(0,0,0));second.sound.IsLoaded=true;second.sound.TimeLength=map.Duration;heartbeat:Fire(.1);check(first.sound~=second.sound,'simultaneous events use independent Sounds')
local loop=Audio.Play('ReelsLoop',Vector3.new(0,0,0),true);loop.sound.IsLoaded=true;loop.sound.TimeLength=map.Duration;heartbeat:Fire(.1);check(loop.sound.Looped and loop.sound.LoopRegion.Min==map.Segments.ReelsLoop.Start and loop.sound.LoopRegion.Max==map.Segments.ReelsLoop.End,'loop bounded to segment')
Audio.Pause(loop,true);check(loop.sound.IsPaused,'loop paused with ability clock');Audio.Pause(loop,false);check(loop.sound.IsPlaying,'loop resumed')
first.sound.TimePosition=map.Segments.CoinFlip.End;heartbeat:Fire(.1);check(first.anchor.Parent==nil,'finished segment removed');Audio.Clear();check(not workspace:FindFirstChild('LuckyAudio'),'audio anchors removed');check(heartbeat:Count()==0,'audio heartbeat disconnected')
print('LUCKY AUDIO LIFECYCLE PASS',n,'assertions')`;
const state=await LuauState.createAsync({print:console.log,warn:console.log});await state.loadstring(lua,'sym-real-audio-module',true)();state.destroy();

import fs from 'node:fs';
import {LuauState} from 'luau-web';
const read=p=>fs.readFileSync(new URL('../'+p,import.meta.url),'utf8');
const fixture=read('tests/super_installer_fixture.lua').split('local V={}')[0];
let source=read('src/polaricrax/CraxPolariClient.client.lua');
for(const p of JSON.parse(read('integration/polaricrax/v3/mirror-patches.json')).patches)source=source.replace(p.after,p.before);
const command=read('integration/polaricrax/v3/AJUSTER_DUEL_POLARICRAX.lua');
for(const mode of ['success','preexisting-edit','failure','concurrent','unknown']){
 let lua=fixture+`\nlocal editor=create('ScriptEditorService','ScriptEditorService');local concurrent\nfunction editor:GetEditorSource(o)return o.Source end\nfunction editor:UpdateSourceAsync(o,f)if concurrent==o then concurrent=nil;o.Source=o.Source..'-- concurrent' end;o.Source=f(o.Source)end\nlocal book=create('StarterPlayer.StarterPlayerScripts.CraxPolariClient','LocalScript');book.Source=${JSON.stringify(source)}\nlocal backup=create('ServerStorage.PolariCrax_Backup_V1','Folder');local entry=create('ServerStorage.PolariCrax_Backup_V1.Entries.Book','Folder');entry:SetAttribute('Path','StarterPlayer.StarterPlayerScripts.CraxPolariClient');local installed=new('StringValue');installed.Name='Installed';installed.Value=book.Source;installed.Parent=entry\nlocal function apply()\n${command}\nend\n`;
 if(mode==='preexisting-edit')lua+=`book.Source=book.Source..'\n-- custom title';`;
 if(mode==='failure')lua+=`failure=book;local original=book.Source;check(not pcall(apply),'write failure refused');check(book.Source==original,'original book kept');check(not game.ServerStorage:FindFirstChild('PolariCrax_MirrorPose_Safety_V1'),'clean failure leaves no safety');`;
 else if(mode==='concurrent')lua+=`concurrent=book;check(not pcall(apply),'concurrent edit refused');check(book.Source:find('-- concurrent',1,true),'concurrent edit kept');check(game.ServerStorage.PolariCrax_MirrorPose_Safety_V1:GetAttribute('Incomplete'),'recovery preserved');`;
 else if(mode==='unknown')lua+=`book.Source='-- unknown book';check(not pcall(apply),'unknown structure refused');check(not game.ServerStorage:FindFirstChild('PolariCrax_MirrorPose_Safety_V1'),'preflight writes nothing');`;
 else{
  lua+=`local original=book.Source;local recorded=installed.Value;apply();check(book.Source:find("local mirrorMatch=loser:GetAttribute('CraxId')==C.Id",1,true),'pose change restricted to mirror duel');check(book.Source:find('victimFaceOffset:Inverse()',1,true),'victim uses authored face');check(book.Source:find('s.hero:PivotTo(heroPose:Lerp(faceCamera,closing))',1,true),'other matchups keep front-facing final portrait');local count=#game.ServerStorage:GetChildren();local patched=book.Source;apply();check(book.Source==patched and #game.ServerStorage:GetChildren()==count,'repeat safe');`;
  if(mode==='preexisting-edit')lua+=`check(book.Source:find('custom title',1,true),'custom title preserved');check(installed.Value==recorded,'unrelated edits not blessed into backup');`;
  else lua+=`check(installed.Value==book.Source,'tracked backup stays coherent');`;
  lua+='return book.Source';
 }
 const vm=await LuauState.createAsync({print:console.log,warn:console.log});
 try{const result=await vm.loadstring(lua.replace("..'\n-- custom title'","..'\\n-- custom title'"),'polari-icon-size-'+mode,true)();if(result?.[0])vm.loadstring(result[0],'resized-book',true);}finally{vm.destroy();}
}
console.log('POLARI MIRROR PATCH PASS: scope, authored faces, non-mirror portrait, edits, repeatability and failure recovery');

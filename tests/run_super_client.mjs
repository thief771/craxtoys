import fs from'node:fs';import{LuauState}from'luau-web';
const read=p=>fs.readFileSync(new URL('../'+p,import.meta.url),'utf8');
let instance=read('tests/super_installer_fixture.lua').split('local V={}')[0];
const source=`${instance}\n${read('tests/client_fixture.lua')}\n${read('tests/super_client_extension.lua')}\nlocal Config=(function()${read('src/supercrax/CraxSuperConfig.lua')}end)()\nrequire=function(o)if o==configObject then return Config elseif o==clockObject then return {Time=function()return now end,Paused=function()return false end}end;error('unexpected require')end\ndo\n${read('src/supercrax/CraxSuperClient.client.lua')}\nend\n${read('tests/super_client_assertions.lua')}`;
const state=await LuauState.createAsync({print:console.log});await state.loadstring(source,'super-actual-client',true)();state.destroy();

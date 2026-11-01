import fs from 'node:fs';import path from 'node:path';import {pathToFileURL}from'node:url';
const root=path.resolve(import.meta.dirname,'..');const read=p=>fs.readFileSync(path.join(root,p),'utf8');
const {LuauState}=process.env.LUAU_WEB_PATH?await import(pathToFileURL(process.env.LUAU_WEB_PATH)):await import('luau-web');
const state=await LuauState.createAsync({print:console.log});
const source=`${read('tests/installer_fixture.lua')}\n${read('tests/client_fixture.lua')}\nlocal Config=(function()${read('src/invertedcrax/CraxInvertedConfig.lua')}end)()\nrequire=function(o)if o==configObject then return Config elseif o==clockObject then return {Time=function()return now end}end;error('unexpected require')end\ndo\n${read('src/invertedcrax/CraxInvertedClient.client.lua')}\nend\n${read('tests/client_assertions.lua')}`;
await state.loadstring(source,'actual-client-lifecycle',true)();state.destroy();

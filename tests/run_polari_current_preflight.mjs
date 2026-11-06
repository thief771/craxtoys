import fs from 'node:fs';
import {LuauState} from 'luau-web';
const read=p=>fs.readFileSync(new URL('../'+p,import.meta.url),'utf8');
const installer=read('integration/polaricrax/version-actuelle/INSTALLER_POLARICRAX_VERSION_ACTUELLE.lua');
const ops=JSON.parse(read('integration/polaricrax/version-actuelle/operations.json'));
const quote=s=>JSON.stringify(s);
// Compare every encoded operation with its JSON definition, including leading newlines.
let lua=installer.slice(installer.indexOf('local ops='),installer.indexOf('local modules='));
let checks=0;
ops.forEach((op,i)=>{
 (op.replacements??[]).forEach((r,j)=>{
  for(const key of ['before','after']){lua+=`\nassert(ops[${i+1}].replacements[${j+1}].${key}==${quote(r[key])},'literal roundtrip ${i+1}/${j+1}/${key}')`;checks++;}
 });
});
const source=read('tests/fixtures/polari-bat-current.lua');
lua+=`\nlocal source=${quote(source)}\nlocal bat\nfor _,op in ipairs(ops)do if op.path=='ServerScriptService.CraxBatRuntime'then bat=op end end\nassert(bat)\nfor _,anchor in ipairs(bat.requires)do assert(source:find(anchor,1,true),'missing Bat structure')end\nfor _,r in ipairs(bat.replacements)do\n local a,b=source:find(r.before,1,true);assert(a and not source:find(r.before,b+1,true),'ambiguous Bat anchor')\n source=source:sub(1,a-1)..r.after..source:sub(b+1)\nend\nreturn source`;
const state=await LuauState.createAsync();
try{
 state.loadstring(installer,'current-installer',true);
 const result=await state.loadstring(lua,'serialized-operations-and-uploaded-bat',true)();
 const patched=result[0];state.loadstring(patched,'patched-current-bat',true);
 const old='local function stepLamp(r,dt)';const addition='function M.PolariDelay(dt)\n for _,r in pairs(records)do if r.lamp then r.lamp.Started+=dt end end\nend\n';
 if(patched!==source.replace(old,addition+old))throw Error('Unexpected source modification');
 const method=ops.find(o=>o.path.endsWith('.CraxBatRuntime')).replacements[0].after.split('local function stepLamp')[0];
 await state.loadstring(`local M={};local records={{lamp={Started=20,Age=.4},timer=7},{timer=9}};${method}\nM.PolariDelay(1.2);assert(math.abs(records[1].lamp.Started-21.2)<1e-8);assert(records[1].lamp.Age==.4 and records[1].timer==7 and records[2].timer==9)`, 'bat-lamp-pause-deadline',true)();
 console.log('CURRENT PREFLIGHT PASS:',checks,'literal roundtrips; uploaded Bat patched and compiled; existing code preserved');
}finally{state.destroy();}

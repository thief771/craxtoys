// Run prior behavioural suites against Lucky's actual adapted runtime modules.
import fs from'node:fs';import path from'node:path';import{spawnSync}from'node:child_process';
const root=path.resolve(import.meta.dirname,'..');const cases=JSON.parse(fs.readFileSync(path.join(root,'tests/lucky_family_cancel_assertions.json'),'utf8'));const casePath=JSON.stringify(cases);
for(const name of['sym','super','inverted']){
 let source=fs.readFileSync(path.join(root,'tests/run_'+name+'.mjs'),'utf8');
 const needle="fs.readFileSync(path.join(root,p),'utf8')";
 if(!source.includes(needle))throw Error('Runner read pattern changed');
 source=source.replace(needle,`(()=>{const name=p.split('/').pop();const map={CraxSuperRuntime:true,CraxSymRuntime:true,CraxInvertedRuntime:true};let text=fs.readFileSync(path.join(root,map[name?.replace('.lua','')]?'integration/luckycrax/review/ServerScriptService/'+name:p),'utf8');if(p==='tests/super_runtime_fixture.lua')text+="\\nsss.CraxLuckyRuntime='luckyStub';modules.luckyStub={Dodge=function()return false end}\\n";const cases=${casePath};if(cases[p]){const marker=p==='tests/runtime_assertions.lua'?"print('REAL RUNTIME FIXTURE PASS'":p==='tests/super_runtime_assertions.lua'?"print('SUPER REAL RUNTIME PASS'":"print('SYM REAL RUNTIME + REAL HEALTH PASS'";const at=text.indexOf(marker);if(at<0)throw Error('Assertion anchor missing');text=text.slice(0,at)+cases[p]+text.slice(at);}return text})()`);
 const target=path.join(root,'tests/.lucky-family-'+name+'.mjs');
 try{fs.writeFileSync(target,source);const result=spawnSync(process.execPath,[target],{cwd:root,stdio:'inherit'});if(result.status!==0)throw Error(name+' regressions failed');}finally{fs.unlinkSync(target);}
}
console.log('LUCKY ADAPTED FAMILY REGRESSIONS PASS: actual Super/Sym/Inverted modules; not a BlackSpida validation');

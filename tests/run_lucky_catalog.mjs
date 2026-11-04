import fs from'node:fs';import{LuauState}from'luau-web';const read=p=>fs.readFileSync(new URL('../'+p,import.meta.url),'utf8');const bases=JSON.parse(read('tests/fixtures/lucky-inspected-sources.json'));
let lua=`local modules={};local rs={CraxFleau={FleauRules='FleauRules'}};function rs:WaitForChild(n)return n end;function rs:FindFirstChild()return nil end;game={GetService=function()return rs end};require=function(n)return assert(modules[n],n)end
Color3={fromRGB=function(...)return{...}end,new=function(...)return{...}end};modules.FleauRules={Config={Prices={5000,15000,30000,50000},Gems={30,80,150,250},FinaleDuration=8}};modules.CraxInvertedConfig={FinaleDuration=8};
modules.CraxSuperConfig=(function()${read('src/supercrax/CraxSuperConfig.lua')}end)();modules.CraxSymConfig=(function()${read('src/symbioticrax/CraxSymConfig.lua')}end)();rs.CraxSuperConfig='CraxSuperConfig';rs.CraxSymConfig='CraxSymConfig';modules.CraxLuckyConfig=(function()${read('src/luckycrax/CraxLuckyConfig.lua')}end)();rs.CraxLuckyConfig='CraxLuckyConfig'
local checks=0;local function check(v,msg)checks+=1;assert(v,msg)end
local function same(a,b)if type(a)~=type(b)then return false end;if type(a)~='table'then return a==b end;for k,v in pairs(a)do if not same(v,b[k])then return false end end;for k in pairs(b)do if a[k]==nil then return false end end;return true end
`;
for(const name of['CraxCatalog','CraxSkillCatalog','CraxRouletteConfig','CraxVictoryCatalog']){lua+=`local old${name}=(function()${bases['ReplicatedStorage.'+name]}end)();modules.${name}=old${name};rs.${name}='${name}'\nlocal new${name}=(function()${read('integration/luckycrax/review/ReplicatedStorage/'+name+'.lua')}end)();modules.${name}=new${name}\n`;
if(name!=='CraxRouletteConfig')lua+=`for k,v in pairs(old${name})do check(same(v,new${name}[k]),'preserve existing ${name} '..k)end\n`;
}
lua+=`
local s=newCraxCatalog.Crax_Lucky;check(s.MaxHealth==105 and s.CollisionDamage==8,'confirmed stats');check(s.Speed==newCraxCatalog.Crax_Monster.Speed,'native speed');check(s.Rarity==newCraxCatalog.Crax_Spidey.Rarity,'actual Rare enum')
local skill=newCraxSkillCatalog.Crax_Lucky;check(skill.Enabled,'confirmed Spidey purchase grid enabled');for i,u in ipairs(skill.Upgrades)do local p=newCraxSkillCatalog.Crax_Spidey.Upgrades[i];check(u.Coins==p.Coins and u.Gems==p.Gems,'Spidey prices level '..i)end
local v=newCraxVictoryCatalog.Crax_Lucky;check(skill.Upgrades[4].TrophyId==v.TrophyId and v.DisplayName==skill.Upgrades[4].Name,'one trophy ID/title across book/victory/registry');check(v.MinimumLevel==4 and v.Duration==9,'MAX only, matching timeline')
local before,after={},{};local weights={};for _,e in ipairs(oldCraxRouletteConfig.Pool)do local r=newCraxCatalog[e.Id].Rarity;before[r]=(before[r]or 0)+e.Weight;weights[e.Id]=e.Weight end
for _,e in ipairs(newCraxRouletteConfig.Pool)do local r=newCraxCatalog[e.Id].Rarity;after[r]=(after[r]or 0)+e.Weight;if r~=s.Rarity then check(weights[e.Id]==e.Weight,'non-Rare weight retained '..e.Id)end end
for r,x in pairs(before)do check(math.abs(x-after[r])<1e-7,'rarity mass retained '..r)end;check(same(oldCraxRouletteConfig.DuplicateGems,newCraxRouletteConfig.DuplicateGems),'duplicate rewards retained');print('LUCKY REAL CATALOGS / TROPHY / CASINO PASS',checks,'assertions')
`;
const state=await LuauState.createAsync({print:console.log});await state.loadstring(lua,'sym-real-catalogs',true)();state.destroy();

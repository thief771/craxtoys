import fs from'node:fs';import{LuauState}from'luau-web';
const read=p=>fs.readFileSync(new URL('../'+p,import.meta.url),'utf8');const f=JSON.parse(read('tests/fixtures/super-inspected-sources.json')).canonical;
let lua=`local modules={};local rs={CraxFleau={FleauRules='FleauRules'}};function rs:WaitForChild(n)return n end;function rs:FindFirstChild()return nil end
 game={GetService=function()return rs end};require=function(n)return assert(modules[n],n)end
 local function color(...)return {...}end;Color3={fromRGB=color,new=color};modules.FleauRules={Config={Prices={5000,15000,30000,50000},Gems={30,80,150,250},FinaleDuration=8}}
 modules.CraxSuperConfig=(function()${read('src/supercrax/CraxSuperConfig.lua')}end)();modules.CraxInvertedConfig={FinaleDuration=8};
 local checks=0;local function check(v,msg)checks+=1;assert(v,msg)end
 local function same(a,b)if type(a)~=type(b)then return false end;if type(a)~='table'then return a==b end;for k,v in pairs(a)do if not same(v,b[k])then return false end end;for k in pairs(b)do if a[k]==nil then return false end end;return true end
`;
for(const name of['CraxCatalog','CraxSkillCatalog','CraxRouletteConfig','CraxVictoryCatalog']){
 lua+=`local old${name}=(function()${f['ReplicatedStorage.'+name]}end)();modules.${name}=old${name};rs.${name}='${name}'\n`;
 lua+=`local new${name}=(function()${read('integration/supercrax/review/ReplicatedStorage/'+name+'.lua')}end)();modules.${name}=new${name}\n`;
 if(name!=='CraxRouletteConfig')lua+=`for k,v in pairs(old${name})do check(same(v,new${name}[k]),'preserve existing ${name} '..k)end\n`;
}
lua+=`
local super=newCraxCatalog.Crax_Super;check(super.MaxHealth==100 and super.CollisionDamage==8,'base stats');check(super.Speed==newCraxCatalog.Crax_Monster.Speed,'native speed');check(super.Rarity=='Commun','actual common value')
for i,p in ipairs(newCraxSkillCatalog.Crax_Super.Upgrades)do check(p.Coins==({5000,15000,30000,50000})[i]and p.Gems==({30,80,150,250})[i],'confirmed purchase grid '..i);check(not p.TrophyId,'no invented trophy '..i)end
local before,after={},{};local oldWeights={};for _,e in ipairs(oldCraxRouletteConfig.Pool)do local rarity=newCraxCatalog[e.Id].Rarity;before[rarity]=(before[rarity]or 0)+e.Weight;oldWeights[e.Id]=e.Weight end
local count=0;for _,e in ipairs(newCraxRouletteConfig.Pool)do local rarity=newCraxCatalog[e.Id].Rarity;after[rarity]=(after[rarity]or 0)+e.Weight;if e.Id=='Crax_Super'then count+=1 elseif rarity~='Commun'then check(oldWeights[e.Id]==e.Weight,'preserve non-common weight '..e.Id)end end
for rarity,v in pairs(before)do check(math.abs(v-after[rarity])<1e-7,'preserve total rarity probability '..rarity)end
check(count==1,'single Super pool entry');check(same(oldCraxRouletteConfig.DuplicateGems,newCraxRouletteConfig.DuplicateGems),'duplicate rewards unchanged');check(newCraxVictoryCatalog.Crax_Super.MinimumLevel==4 and newCraxVictoryCatalog.Crax_Super.Duration==8.2,'MAX gate and actual timeline')
print('SUPER REAL CATALOG / CASINO PASS',checks,'assertions')
`;
const state=await LuauState.createAsync({print:console.log});await state.loadstring(lua,'super-real-catalogs',true)();state.destroy();

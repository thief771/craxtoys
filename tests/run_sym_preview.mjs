import fs from'node:fs';import{LuauState}from'luau-web';const read=p=>fs.readFileSync(new URL('../'+p,import.meta.url),'utf8');
let base=read('tests/super_installer_fixture.lua').split('local V={}')[0].replace("return c==class or", "return c==class or(c=='GuiObject'and(class=='ViewportFrame'or class=='Frame'))or");
const source=`${base}\n${read('tests/client_fixture.lua')}\n${read('tests/super_client_extension.lua')}\nlocal ruleObject=create('ReplicatedStorage.CraxSymRules','ModuleScript');local R=(function()${read('src/symbioticrax/CraxSymRules.lua')}end)();require=function(o)assert(o==ruleObject);return R end
CF.RightVector=Vector3.new(1,0,0);function V:Dot(b)return self.X*b.X+self.Y*b.Y+self.Z*b.Z end
CFrame.lookAt=function(p)return setmetatable({Position=p},CF)end
local bboxCalls=0;function a:GetBoundingBox()bboxCalls+=1;return CFrame.identity,Vector3.new(14,10,9)end;a.Destroying=sig()
local view=create('Players.LocalPlayer.PlayerGui.SymView','ViewportFrame');view.AbsoluteSize=Vector2.new(200,400);view.Visible=true;view.CurrentCamera=cam;view.Destroying=sig();cam.FieldOfView=36
local M=(function()${read('src/symbioticrax/CraxSymPreview.lua')}end)();local n=0;local function check(v,msg)n+=1;assert(v,msg)end
M.Bind(view,a);check(render~=nil,'one preview fitting render binding');check(math.abs(cam.CFrame.Position.Z-R.FitDistance(14,10,9,.5,36))<1e-6,'actual module fits full silhouette')
M.Bind(view,a);check(view.Destroying:Count()==1 and a.Destroying:Count()==1,'rebinding does not duplicate connections');local calls=bboxCalls;view.Visible=false;render(.1);check(bboxCalls==calls,'closed preview skips framing work');view.Visible=true;view.AbsoluteSize=Vector2.new(800,400);render(.1);check(math.abs(cam.CFrame.Position.Z-R.FitDistance(14,10,9,2,36))<1e-6,'live resize refits landscape')
view.Destroying:Fire();check(render==nil and a.Destroying:Count()==0,'last preview unbinds and disconnects');print('SYM REAL PREVIEW FRAMING PASS',n,'assertions')`;
const state=await LuauState.createAsync({print:console.log});await state.loadstring(source,'sym-real-preview',true)();state.destroy();

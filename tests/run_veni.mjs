import fs from 'node:fs'; import path from 'node:path'; import { LuauState } from 'luau-web';
const root = path.resolve(import.meta.dirname, '..'); const read = p => fs.readFileSync(path.join(root, p), 'utf8');
const state = await LuauState.createAsync({ print: console.log, warn: console.log });
let count = 0;
const walk = d => { for (const f of fs.readdirSync(path.join(root, d), { withFileTypes: true })) { const p = d + '/' + f.name; if (f.isDirectory()) walk(p); else if (p.endsWith('.lua')) { state.loadstring(read(p), p, true); count++; } } };
for (const base of ['src/venicrax', 'integration/venicrax']) if (fs.existsSync(path.join(root, base))) walk(base);
console.log('VENI COMPILE PASS', count, 'scripts');
const fixture = read('tests/veni_fixture.lua')
  .replace('CONFIG_SOURCE()', () => `(function()${read('src/venicrax/CraxVeniConfig.lua')}end)()`)
  .replace('RULES_SOURCE()', () => `(function()${read('src/venicrax/CraxVeniRules.lua')}end)()`)
  .replace('RUNTIME_SOURCE()', () => `(function()${read('src/venicrax/CraxVeniRuntime.lua')}end)()`);
await state.loadstring(fixture + '\nmodules_config=modules.config\n' + read('tests/veni_assertions.lua'), 'veni-runtime', true)();
state.destroy();

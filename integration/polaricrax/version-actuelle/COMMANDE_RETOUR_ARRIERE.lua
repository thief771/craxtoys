-- Retour arrière : ne lancer que pour retirer PolariCrax, Play arrêté.
do
 assert(not game:GetService("RunService"):IsRunning(), "Arrêtez Play")
 local H = game:GetService("HttpService")
 local enabled = H.HttpEnabled
 if not enabled then H.HttpEnabled = true end
 local ok, source = pcall(function()
  return H:GetAsync("https://raw.githubusercontent.com/thief771/craxtoys/c9d0f8231d8ac0f09374bbb044edd0d0761b55a4/integration/polaricrax/RETOUR_ARRIERE_POLARICRAX.lua", true)
 end)
 if not enabled then H.HttpEnabled = false end
 assert(ok, "Téléchargement impossible : " .. tostring(source))
 local undo, err = loadstring(source)
 assert(undo, err)
 undo()
end

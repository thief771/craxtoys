-- Coller dans la barre de commande de Studio, Play arrêté.
do
 assert(not game:GetService("RunService"):IsRunning(), "Arrêtez Play avant l'installation")
 local H = game:GetService("HttpService")
 local SS = game:GetService("ServerStorage")
 local path = SS:FindFirstChild("PolariCrax_Backup_V1")
  and "integration/polaricrax/v2/METTRE_A_JOUR_POLARICRAX_V2.lua"
  or "integration/polaricrax/version-actuelle/INSTALLER_POLARICRAX_VERSION_ACTUELLE.lua"
 local url = "https://raw.githubusercontent.com/thief771/craxtoys/36e4b5660f45f1143938fa1f37b754143b1e5653/" .. path
 local enabled = H.HttpEnabled
 if not enabled then H.HttpEnabled = true end
 local fetched, source = pcall(function() return H:GetAsync(url, true) end)
 if not enabled then H.HttpEnabled = false end
 assert(fetched, "Téléchargement impossible : " .. tostring(source))
 local install, problem = loadstring(source)
 assert(install, problem)
 local imported = SS:FindFirstChild("PolariCrax_Import")
 local oldParent, oldName
 if not imported and not SS:FindFirstChild("PolariCrax_Backup_V1") then
  imported = workspace:FindFirstChild("PolariCrax_ACCESSOIRES_IMPORT")
  assert(imported, "Modèle Polari absent : conserver les 16 meshes importés sous Workspace.PolariCrax_ACCESSOIRES_IMPORT")
  oldParent, oldName = imported.Parent, imported.Name
  imported.Name = "PolariCrax_Import"
  imported.Parent = SS
 end
 local ok, err = pcall(install)
 if not ok and oldParent and not SS:FindFirstChild("PolariCrax_Backup_V1") then
  imported.Name = oldName
  imported.Parent = oldParent
 end
 assert(ok, tostring(err))
 print("PolariCrax V2 : installation ou mise à jour vérifiée. Enregistrez votre jeu, puis lancez un nouveau Play.")
end

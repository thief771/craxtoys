# Message à ChatGPT Work

Je joins le kit complet de mon projet CraxToys et de la refonte SymbiotiCrax. Je souhaite l’intégrer à ma place Roblox existante. Analyse les fichiers du ZIP et donne-moi les étapes exactes, dans l’ordre, avec les commandes complètes à copier dans Roblox Studio et le contexte d’exécution (STOP, serveur ou CLIENT). Ne te limite pas à des extraits de code avec des points de suspension.

Commence par lire :
- README.md
- docs/symbioticrax/REFONTE.md
- docs/symbioticrax/INSTALLATION.md
- docs/symbioticrax/ETAT.md
- docs/symbioticrax/TESTS.md

Les scripts prêts à exécuter sont :
- integration/symbioticrax/INSTALLER_SYMBIOTICRAX.lua
- integration/symbioticrax/RETOUR_ARRIERE_SYMBIOTICRAX.lua
- integration/symbioticrax/BRANCHER_ASSETS_SYMBIOTICRAX.lua
- integration/symbioticrax/DIAGNOSTIC_AUDIO_CLIENT.lua

Ma place peut déjà contenir la première version de SymbiotiCrax. Vérifie ce point avant de proposer une installation. L’installateur ne met pas à jour une V1 en place : il retourne « déjà installé ». Explique le retour arrière contrôlé, puis la réinstallation. Si une source a été modifiée depuis son installation, préserve-la et aide-moi à comparer les changements ; ne force pas l’écrasement et ne supprime pas les gardes de conflit. SuperCrax doit déjà être installé. Ne remplace pas mes systèmes actuels par les fixtures ou les sources de review du ZIP.

Indique précisément comment importer les 31 accessoires et les 13 repères de assets/symbioticrax/model/SymbiotiCrax_ACCESSOIRES_IMPORT.fbx, puis sélectionner la racine importée avant l’installation. Le kit conserve la vraie tête CraxSourire et n’ajoute pas de corps.

Explique ensuite comment importer assets/symbioticrax/audio/SymbiotiCrax_AUDIO_ATLAS.wav et les quatre illustrations, renseigner leurs vrais IDs, les autoriser pour mon expérience et exécuter le branchement. N’invente aucun ID Roblox. Si une information sur ma place ou une ressource est nécessaire, demande uniquement cette information.

La refonte comprend la contamination animée 1/3, 2/3 puis visage complet temporaire au troisième coup, les petits filaments, la langue avec sillon et enroulement, le modèle plus brillant avec crocs affinés, le MAX et les sons retravaillés. Donne-moi une checklist courte de tests à deux joueurs : stades de contamination, explosion, expiration, mort/nettoyage, traction autour des obstacles, sons, interruption du MAX et restitution caméra.

Les 920 assertions locales passent, mais les services sont simulés : aucun test Roblox Studio réel ni écoute en jeu n’a été réalisé ici. Ne présente pas ces validations comme déjà effectuées dans ma place.

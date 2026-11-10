# Export « copie jeu mardi » — relevé du 10 novembre 2026

SHA-256 : `9bb61b5e6628f51e8d829dbce1ac2c6038dac93f1a886dbe29966b1fa7b22fa0`  
248 996 instances, 1 461 scripts. Analyse statique hors Studio (`tools/rbxl_dump.py`) : rien n'a été exécuté.

## Écarts avec le dossier de reprise (export du 6 novembre)

- `ReplicatedStorage.CraxSonGoFX` (RemoteEvent) est **présent** : le blocage de démarrage signalé dans le dossier ne s'applique plus.
- **PolariCrax est intégré** (`Crax_Polari`, runtime, pause, client, VFX, aperçu). Les dix sources sont identiques à `src/polaricrax`, sauf `CraxPolariConfig` et `CraxPolariClient`, qui portent le titre MAX **ÉCLAT DU TEMPS** et les marqueurs des dernières commandes (`PolariBookImagesAndTitleV1`, `PolariMirrorPortraitV1`, `PolariSkillIconSizeV1`). Sauvegardes V1, V2 et V3 présentes dans `ServerStorage`.
- **Équilibrage du 7 novembre appliqué** : `Workspace.CraxEquilibrage_20261107` (Appliquer, Annuler, Verifier, Plan 001–035). Les 35 scripts ciblés portent le marqueur `CraxEquilibrage20261107V1`. Sauvegarde : `ServerStorage.CraxEquilibrage_Backup_20261107_181635_2781`. Les valeurs chiffrées du dossier (Super, Lucky, Inverted, Sym, BlackSpida, Ghosty…) sont à relire dans ces scripts avant tout nouvel équilibrage.
- Toujours conformes : `ROUNDS_TO_WIN = 3`, DataStores `CraxProfiles_Studio_v1` / `CraxProfiles_v1`.
- VeniCrax : aucun élément dans la place.

## Petits restes à nettoyer (non bloquants)

- `ServerScriptService.Script` : diagnostic VOID qui affiche l'état de la démo puis se détruit.
- `Workspace.Script` : `print("Hello world!")`.
- Le dossier d'installation `CraxEquilibrage_20261107` est dans `Workspace` (ModuleScripts inactifs) ; il serait mieux rangé dans `ServerStorage`.

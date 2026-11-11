# Le gabarit d'une spec

| # | Section | Contenu |
| --- | --- | --- |
| 1 | Besoin, principe et hors périmètre | Pourquoi on le fait, comment ça marche en quelques lignes, ce qui n'est pas fait dans cette itération. |
| 2 | Maquette | À quoi ressemble l'écran et, si l'écran existe déjà, ce qui change. Facultative s'il n'y a pas d'écran. |
| 3 | Règles | Des termes, puis le comportement attendu pour chaque situation possible. |
| 4 | Scénarios | Des situations concrètes avec leur résultat attendu, qui testent chaque règle. |
| 5 | Questions ouvertes | Seulement s'il en reste. Leur présence veut dire que la spec n'est pas terminée. |
| | Annexe : enquête | Facultative. Les chiffres, les options et les combinaisons écartées qui ont orienté les décisions. |

## Où se place chaque altitude

Une idée passe par cinq altitudes. La spec s'arrête à la troisième.

1. **Idée** : quel est le problème ? « Je veux savoir rapidement quand un compteur ne répond plus. »
2. **Cadrage** : quelle solution, dans les grandes lignes ? « Au bout de 60 minutes sans réponse, on envoie un mail. »
3. **Conception** : quel comportement exact, dans tous les cas ? « Quand un compteur est resté monitoré 60 minutes d'affilée sans lecture réussie, un mail part dans les 10 minutes. » ← **la spec**
4. Approche technique : « Un cron toutes les 10 minutes cherche les compteurs dont offlineCountdownStartedAt dépasse 60 minutes. » ← hors spec
5. Code. ← hors spec

## 1. Besoin, principe et hors périmètre

Les trois paragraphes doivent se lire en une minute.

**Besoin** : une user story.

```
**En tant que** <rôle>
**Je veux** <ce que ce rôle doit pouvoir faire>
**Afin de** <bénéfice concret>
```

*En tant que* : le rôle (admin Cockpit, client Deck, conducteur, pôle Opération…). *Je veux* ne présume pas de la solution : le besoin reste vrai quelle qu'elle soit.

**Principe** : quelques puces qui résument la situation nominale.

- Compréhensible par quelqu'un qui n'a pas le contexte, sans jargon technique.
- Ne cherche pas à tout couvrir : les cas particuliers vont dans les règles.

**Hors périmètre** : ce qu'on ne fera pas.

- Seulement ce qu'un lecteur ajouterait de bonne foi, pas la liste de tout ce que la feature ne fait pas.
- Chaque exclusion dit en une ligne pourquoi on l'écarte (après ➡️, en italique). Le plus souvent, c'est l'une de ces raisons toutes prêtes :
  - ➡️ *chaque spec livre le minimum utile : <ce qui suffit pour le besoin>* ;
  - ➡️ *DEV-xxx* (le ticket qui s'en charge) ;
  - ➡️ *plus tard*, quand l'idée est gardée ailleurs (backlog, roadmap).
- Une raison sur mesure n'est écrite que si l'utilisateur l'a donnée ou si une source la dit (voir « D'où vient la raison », `regles-ecriture.md`).

## 2. Maquette

La maquette fait foi pour tout ce qui est statique (contenu, libellés fixes, couleurs, mise en page, version mobile) : la spec ne le redit jamais. Chez Nexteneo, c'est un lien Claude Design.

- **Nouvel écran** : le lien suffit.
- **Écran existant** : le texte liste ce qui est ajouté ou modifié, sans le détailler. Exemple : « Fiche compteur : nouvelle ligne « Monitoring » et nouveau bloc « État ». »
- Les éléments d'autres tickets peuvent y apparaître : une ligne le dit.

Le statique va dans la maquette ; ce qui dépend d'une situation, ou que la maquette ne peut pas montrer (un ordre de tri, une valeur par défaut), va dans les règles. Exemple : la colonne « Statut » et son filtre sont dans la maquette ; quand le statut vaut « Joignable », « Injoignable » ou « N/A » est une règle.

Pas de lien Claude Design encore ? Mettre `Maquette : à venir (lien Claude Design)` et l'ajouter aux questions ouvertes.

## 3. Règles

Deux sous-parties : les **Termes**, puis les règles **R1, R2…**. Voir `regles-ecriture.md`.

## 4. Scénarios

Un tableau `# | Déroulé | Résultat attendu | Règles`. Voir `scenarios.md`.

## 5. Questions ouvertes

Une liste numérotée. Chaque question dit ce qui bloque et, si possible, qui peut trancher. Quand il en reste au moins une, la spec commence par la ligne :

> ⚠️ Spec non terminée : N question(s) ouverte(s), voir la section 5.

## Annexe : enquête

Section facultative : ce qui a orienté les décisions, pour que personne ne refasse l'enquête ni ne rouvre un débat tranché. Elle sert aussi de trace datée pour les dossiers CIR/CII.

**Quand l'écrire** : quand une décision s'appuie sur des chiffres mesurés (dans la base, les logs, un export), quand des options ont été étudiées puis écartées, ou quand la passe « combinaisons » a écarté des constats. Sinon, on ne met pas l'annexe.

**Ce qu'elle contient** :

- **Constat** : la situation qui a lancé le sujet, avec des exemples concrets.
- **Mesures** : chaque chiffre avec sa date et sa source (« base de production, 5 novembre 2026 »), et ce qu'il ne dit pas (un biais, des valeurs écartées).
- **Options étudiées et écartées** : un tableau `Option | Pourquoi elle est écartée`.
- **Combinaisons écartées** : un tableau `Combinaison | Pourquoi elle n'est pas traitée`, la raison étant l'une de : peu probable dans l'usage réel, sans conséquence grave, hors périmètre de cette spec. Une ligne par combinaison, dite en mots produit.
- **Liens** : les tickets et idées liés.

**Ses limites** :

- Elle commence par la ligne : *Annexe informative : en cas d'écart, les règles font foi.* Elle explique les décisions sans en prendre aucune.
- Pas de technique, comme dans le reste de la spec : les mesures sont décrites avec les mots du produit. Les requêtes qui ont produit les chiffres vont dans un commentaire du ticket, si l'utilisateur veut les garder.
- On n'y recopie pas les règles.

## Ce qui n'entre dans aucune section

Les anciens tickets contiennent souvent « Préconditions », « Impacts », « Pour les devs », « Checklist » ou « Acceptance criteria ».

- Acceptance criteria et checklists deviennent des **scénarios**.
- Les dépendances entre tickets (« à livrer avec DEV-1037 ») ne vont pas dans la spec. Un autre ticket n'est cité que dans une règle qui repose sur lui. Ce qui lui appartient ne se décrit pas ici, même par un renvoi (« ce que fait le clic : voir DEV-1037 ») ; s'il manque, il va dans « Trouvé en passant ».
- Les notes techniques (chemins de fichiers, composants, guards, noms de champs) sortent de la spec. Ne les jette pas sans le dire : signale-les à l'utilisateur et demande où il veut les garder, par exemple dans un commentaire du ticket pour l'étape d'approche technique.

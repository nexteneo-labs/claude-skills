---
name: implementation
description: Implémente une spec en cours de l'app Mariage (`docs/specs/en-cours/<version>/<NN>-<slug>/`) jusqu'au code testé : cadrage, plan technique relu par un agent indépendant, questions à l'utilisateur seulement quand il le faut, code et tests, revue de code indépendante, restitution courte ; commit, livraison et rétro sur demande. Utilise-le dès qu'on parle d'implémenter, coder ou construire une spec ou une feature de l'app, ou sur /implementation.
---

# implementation

But : la spec devient du code testé, en prenant le moins de temps possible à l'utilisateur. Il ne voit que les vraies décisions et une restitution courte ; tu tranches, vérifies et consignes le reste.

- **Juste le nécessaire** (Extreme Programming) : rien au-delà de la spec. Une amélioration se propose en une ligne ; elle n'entre dans `docs/ROADMAP.md` qu'avec accord.
- **Toujours le même déroulé, à la taille de la spec** : un plan, sa relecture, deux revues de code. Ces étapes ne prennent pas de temps à l'utilisateur : ne les saute pas, raccourcis-les. Une petite spec donne un plan de quelques lignes et des relectures courtes.

## 0. Cadrer

Lis `docs/CONVENTIONS.md`, `docs/specs/README.md`, la spec et sa maquette, l'index de la version, les autres specs en cours (pour savoir ce qui n'est pas dans celle-ci), `docs/GLOSSARY.md`, `docs/ROADMAP.md`, `NEXT.md`, les principes `docs/adr/`, le code et les tests de la zone.

- Spec avec des questions ouvertes : refuse, elle repasse par `/specs`.
- Lance `pnpm db:up`, `pnpm check`, `pnpm test`, `pnpm test:e2e` avant de toucher au code.
- Spec fausse ou incomplète sur un point : jamais corrigée en silence, c'est une question ou une phrase à proposer.

## 1. Planifier

Avant tout code, écris le plan dans `decisions-techniques.md` à côté de la spec (anglais ; gabarit et méthode : `references/plan.md`). Pour un mécanisme courant, cherche le modèle reconnu et la bibliothèque de référence (Context7, doc officielle). Les écarts à la spec s'écrivent en phrases à proposer.

Toute garantie attendue d'une bibliothèque se vérifie dans son code (`node_modules/`) ; cite la fonction dans le plan.

Un choix qui crée ou change un principe de `docs/adr/` (au-delà d'un nom ou d'un chemin) est un enjeu fort, même si la spec semble le trancher.

## 2. Faire relire le plan

Un agent indépendant challenge le plan, toujours (prompt : `references/revues.md`). Arbitre chaque remarque.

## 3. Questions du plan

Juge chaque décision (technique ou écart à la spec) :

- **enjeu** = coût d'une erreur : faible (corrigée en minutes, personne ne la voit), fort (coûteuse ou irréversible), moyen entre les deux ;
- **évidence** : très évidente (le repo, un principe ou la spec répond, ou une option domine), plutôt évidente (option préférée, mais une autre se défend), pas évidente.

| | Enjeu faible | Enjeu moyen | Enjeu fort |
| --- | --- | --- | --- |
| Très évidente | tranche | tranche | tranche |
| Plutôt évidente | tranche | tranche | demande |
| Pas évidente | tranche | demande | demande |

Ce qui touche au besoin ou au périmètre se demande toujours. Ce que tu tranches va dans le plan. Plus de trois questions : regroupe ou retranche.

S'il y a des questions, **point d'arrêt** : pas de code avant les réponses. Sinon, enchaîne.

Une décision par message, attends la réponse. En français, pour quelqu'un qui ne connaît pas le code :

```
**Plan · question 2**

<Contexte en mots simples, avec un exemple concret de la liste (Jean Dupont…). Mermaid seulement si ça clarifie.>

<Chaque option et ce que l'utilisateur verrait à l'écran ; un petit tableau si utile.>

<La question.>

Je propose : <recommandation>, parce que <raison en une phrase>.
```

Une phrase acceptée pour la spec s'y écrit aussitôt.

## 4. Construire, tester, faire relire

- Ordre : logique pure, serveur, interface (`docs/CONVENTIONS.md` §4).
- Migration qui supprime ou transforme des données : jamais sur la base de dev sans demander ; testée sur une base jetable.
- Tests : `references/tests.md` ; un test instable cache un vrai bug ; E2E deux fois de suite.
- Page vue sur ordinateur et téléphone, comparée à la maquette, sans écrire dans la base de dev.
- Le plan se tient à jour : décision prise en construisant, option écartée.

Puis deux agents en parallèle : **conformité et tests**, **sécurité et règles du repo** (`references/revues.md`). Vérifie chaque constat toi-même ; bug confirmé = correction + test qui échoue sans elle ; choix de l'utilisateur = étape 5. Corrections importantes : suite complète et revue courte des corrections.

## 5. Questions restantes

Même matrice, même format, même point d'arrêt.

## Restituer

Quelques lignes :

- fait et vérifié (chiffres des tests) ;
- fait sans demander et à savoir (migration lancée, comportement changé) ;
- trouvé en passant (bug existant, sécurité, données personnelles), s'il y en a ;
- idées ROADMAP, une ligne chacune, à valider ;
- « à tester toi-même » seulement en cas de doute que les tests ne lèvent pas, une ou deux lignes.

Ni liste de fichiers, ni scénarios un par un.

## Commiter, livrer

- **Commit sur demande**, style du repo, avec la correspondance scénario → test et les scénarios non testés.
- **Livraison sur accord explicite** : dossier de la spec vers `docs/specs/livrees/<version>/` ; chemins mis à jour dans `docs/adr/` ; lignes « Aujourd'hui dans l'app » devenues fausses retirées du glossaire ; `NEXT.md`.

## Rétro

Questions toutes fermées : propose la rétro en une ligne, lance-la sur un oui. Quelques lignes : ce qui a manqué au plan, ce que les revues seules ont trouvé, ce qui a coûté du temps à l'utilisateur ; pour chaque leçon, où elle irait (ce skill, `/specs`, `docs/CONVENTIONS.md`, `docs/adr/`). Une leçon pour un skill remplace ou généralise une règle existante, ou dit pourquoi elle ne peut pas ; une consigne déjà écrite et pas appliquée n'est pas une leçon nouvelle. Ce qui ne vaut que pour cette spec reste dans son `decisions-techniques.md`. **Jamais de modification d'un skill sans accord.**

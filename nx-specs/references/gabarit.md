# Le gabarit d'une spec

Une spec décrit le comportement attendu d'une feature, tel qu'on peut l'observer : ce que voit un utilisateur, ce qui part par mail, ce qui est autorisé ou refusé. Elle ne dit pas comment le construire.

Elle tient en quatre sections, plus une cinquième tant qu'il reste des questions ouvertes.

| # | Section | Contenu |
| --- | --- | --- |
| 1 | Besoin, principe et hors périmètre | Pourquoi on le fait, comment ça marche en quelques lignes, ce qui n'est pas fait dans cette itération. |
| 2 | Maquette | À quoi ressemble l'écran et, si l'écran existe déjà, ce qui change. Facultative s'il n'y a pas d'écran. |
| 3 | Règles | Des termes, puis le comportement attendu pour chaque situation possible. |
| 4 | Scénarios | Des situations concrètes avec leur résultat attendu, qui testent chaque règle. |
| 5 | Questions ouvertes | Seulement s'il en reste. Leur présence veut dire que la spec n'est pas terminée. |

## Où se place chaque altitude

Une idée passe par cinq altitudes. La spec s'arrête à la troisième.

1. **Idée** : quel est le problème ? « Je veux savoir rapidement quand un compteur ne répond plus. »
2. **Cadrage** : quelle solution, dans les grandes lignes ? « Au bout de 60 minutes sans réponse, on envoie un mail. »
3. **Conception** : quel comportement exact, dans tous les cas ? « Quand un compteur est resté monitoré 60 minutes d'affilée sans lecture réussie, un mail part dans les 10 minutes. » ← **la spec**
4. Approche technique : « Un cron toutes les 10 minutes cherche les compteurs dont offlineCountdownStartedAt dépasse 60 minutes. » ← hors spec
5. Code. ← hors spec

La spec est l'endroit où les dernières questions produit sont tranchées. Tout ce qui relève des niveaux 4 et 5 appartient au dev : le fixer trop tôt réduit ses options.

## 1. Besoin, principe et hors périmètre

Les trois paragraphes doivent se lire en une minute. Le lecteur, humain ou IA, comprend la feature avant d'en lire le détail.

**Besoin** : une user story.

```
**En tant que** <rôle>
**Je veux** <ce que ce rôle doit pouvoir faire>
**Afin de** <bénéfice concret>
```

- *En tant que* : le rôle qui utilise la feature (admin Cockpit, client Deck, conducteur, pôle Opération…).
- *Je veux* : ce que le rôle doit pouvoir faire, sans présumer de la solution.
- *Afin de* : le bénéfice concret qui justifie la feature.
- Le besoin reste vrai quelle que soit la solution choisie.

**Principe** : quelques puces qui résument la situation nominale.

- Compréhensible par quelqu'un qui n'a pas le contexte, sans jargon technique.
- Ne cherche pas à tout couvrir : les cas particuliers vont dans les règles.

**Hors périmètre** : ce qu'on ne fera pas.

- Seulement ce qu'un lecteur ajouterait de bonne foi, pas la liste de tout ce que la feature ne fait pas.
- Chaque exclusion dit en une ligne pourquoi on l'écarte (après ➡️, en italique), ou cite le ticket qui s'en charge.

## 2. Maquette

La maquette fait référence : on ne redécrit pas l'écran en texte. Chez Nexteneo, la maquette est un lien Claude Design.

- **Nouvel écran** : le lien suffit. Le texte ajoute seulement ce qu'une image ne peut pas montrer : une valeur par défaut, un ordre de tri…
- **Écran existant** : le texte liste ce qui est ajouté ou modifié, sans le détailler. Exemple : « Fiche compteur : nouvelle ligne « Monitoring » et nouveau bloc « État ». »
- Ce que l'image ne montre pas :
  - toujours vrai ➡️ une ligne sous la maquette suffit ;
  - dépend d'une situation ➡️ c'est une règle, dans la section Règles.

Le statique va dans la maquette, ce qui dépend d'une situation va dans les règles. Exemple : la colonne « Statut » et son filtre sont dans la maquette ; quand le statut vaut « Joignable », « Injoignable » ou « N/A » est une règle.

Pas de lien Claude Design encore ? Mettre `Maquette : à venir (lien Claude Design)` et l'ajouter aux questions ouvertes.

## 3. Règles

Deux sous-parties : les **Termes**, puis les règles **R1, R2…**. Voir `regles-ecriture.md`.

## 4. Scénarios

Un tableau `# | Déroulé | Résultat attendu | Règles`. Voir `scenarios.md`.

## 5. Questions ouvertes

Une liste numérotée. Chaque question dit ce qui bloque et, si possible, qui peut trancher. Quand il en reste au moins une, la spec commence par la ligne :

> ⚠️ Spec non terminée : N question(s) ouverte(s), voir la section 5.

## Ce qui n'entre dans aucune section

Les anciens tickets contiennent souvent « Préconditions », « Impacts », « Pour les devs », « Checklist » ou « Acceptance criteria ».

- Acceptance criteria et checklists deviennent des **scénarios**.
- Les dépendances entre tickets (« à livrer avec DEV-1037 ») ne vont pas dans la spec : elles sont déjà liées dans Jira, et tous les tickets d'un sprint sont livrés ensemble. La spec décrit le comportement attendu une fois le sprint livré. Si ce comportement repose sur ce qu'un autre ticket définit, cite ce ticket là où c'est utile au lecteur, sans parler d'ordre de livraison.
- Les notes techniques (chemins de fichiers, composants, guards, noms de champs) sortent de la spec. Ne les jette pas sans le dire : signale-les à l'utilisateur et demande où il veut les garder, par exemple dans un commentaire du ticket pour l'étape d'approche technique.

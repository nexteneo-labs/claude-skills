# Écrire les scénarios

Les règles décident, les scénarios vérifient. Un scénario est une situation concrète avec son résultat attendu. Le produit s'en sert pour valider la feature, les devs pour écrire des tests automatisés. Un scénario qui contredit une règle veut dire que la spec est fausse.

## Format

| # | Déroulé | Résultat attendu | Règles |
| --- | --- | --- | --- |
| S5 | **De nouveau monitoré après une pause**<br>10:00 : lecture réussie du compteur monitoré, puis toutes ses lectures échouent.<br>11:30 : le smart charging de sa PCA est désactivé.<br>14:00 : il est réactivé. | Mail entre 11:00 et 11:10. Aucun mail à 14:00. Nouveau mail entre 15:00 et 15:10. | R1.2, R1.3, R3 |

- **#** : S1, S2… pour citer le scénario dans un ticket ou un test.
- **Déroulé** : un titre en gras qui dit ce que le scénario teste. Puis des heures et des valeurs concrètes, un événement par ligne.
- **Résultat attendu** : ce qu'on observe, et ce qui ne se passe pas.
- **Règles** : les effets de règle dont dépend le résultat. R1.3 = 3e ligne de la table de R1.

Un scénario se suffit à lui-même : avec le déroulé et les règles citées, on calcule le résultat sans rien deviner.

## Couverture : chaque effet est testé

Chaque effet de chaque règle (chaque ligne de table, chaque branche, chaque exception) est cité par au moins un scénario. Un effet sans scénario ne sera pas testé, c'est un oubli. La colonne Règles rend la vérification mécanique : pour chaque effet, on cherche les scénarios qui le citent.

## Lisibilité : on sait ce qui est testé et pourquoi

Un lecteur qui découvre le scénario doit voir ce qu'il vérifie et pourquoi on l'a écrit.

À éviter :

| Déroulé | Résultat attendu |
| --- | --- |
| Compteur passé en Monitoring Forcé à 14:20 | Pas de mail entre 15:20 et 15:30 |

Le compteur était-il monitoré avant ? En panne depuis quand ? Pourquoi ce scénario existe-t-il ? Le lecteur doit deviner.

À écrire :

| Déroulé | Résultat attendu |
| --- | --- |
| **Réglages changés en pleine panne**<br>14:00 : lecture réussie du compteur, monitoré par le smart charging de sa PCA, puis toutes ses lectures échouent.<br>14:20 : il passe en Monitoring Forcé. | Mail entre 15:00 et 15:10, pas entre 15:20 et 15:30. |

Le titre dit pourquoi le scénario existe. « Pas entre 15:20 et 15:30 » montre le piège sans l'expliquer : l'explication reste dans le ➡️ de la règle.

## Regrouper les effets dans le moins de scénarios possible

Réflexe : avant d'ajouter un scénario, vérifier si un scénario existant peut tester cet effet en plus. Moins de scénarios, c'est moins à lire et à maintenir.

- **Regrouper** quand les effets partent de la même situation (S10 teste à la fois la limite à 30, le mail groupé et le destinataire), ou quand plusieurs variantes donnent le même résultat (S6 teste à la fois le passage en Forcé et le rattachement à une PCA).
- **Séparer** quand le titre ne peut plus dire en quelques mots ce que le scénario teste, ou quand les effets demandent des situations différentes qu'il faudrait mélanger dans une seule frise.

## Pas de mécanisme dans un scénario

Un scénario ne teste que ce que le produit voit. Un scénario « secondes ignorées » ou « le cron passe à :15 » teste un mécanisme : il sort de la spec, comme la règle qui le portait.

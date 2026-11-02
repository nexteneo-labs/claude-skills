# Exemple de référence : F4, alerte de perte de connexion d'un compteur

Spec complète au format attendu. Elle sert de modèle de ton, de niveau de détail et de structure.
Les images de la maquette sont remplacées ici par des liens fictifs : dans un vrai ticket, ce sont des liens Claude Design.

---

## 1. Besoin, principe et hors périmètre

**En tant que** membre du pôle Opération
**Je veux** être alerté quand on n'arrive plus à lire un compteur
**Afin d'**intervenir pour éviter que le smart charging dynamique dépasse la puissance disponible du site ou bride les recharges sans raison

**Principe** :

- On vérifie en continu qu'on arrive à lire chaque compteur monitoré, même hors recharge.
- Au bout de 60 minutes sans avoir réussi à lire le compteur, on envoie un mail d'alerte.
- Cockpit affiche l'état des compteurs.

**Hors périmètre** :

- alerter le client final ➡️ *un diagnostic par l'équipe Opérations doit d'abord confirmer le problème* ;
- détecter les valeurs aberrantes ➡️ *sujet distinct, qui demande sa propre enquête*.

## 2. Maquette

Maquette : [Claude Design — Alerte compteur](https://claude.ai/design/...)

**Création d'un compteur** : nouveau champ « Monitoring ».

**Fiche compteur** : nouvelle ligne « Monitoring » et nouveau bloc « État ».

**Liste des compteurs** :

- Colonne Statut
- Filtre Statut, à sélection multiple, vide par défaut.

**Configuration smart charging** : chip du compteur vert (Joignable), rouge (Injoignable) ou gris (N/A).

## 3. Règles

### Termes

**Compteur monitoré** : un compteur dont on surveille la connexion (voir R1).

**Lecture** : on interroge le compteur. La lecture est **réussie** si on reçoit une valeur numérique, **échouée** sinon : pas de réponse, erreur, ou valeur absente ou non numérique.

**Compteur en alerte** : compteur resté monitoré 60 minutes d'affilée sans lecture réussie.

### R1. Compteur monitoré

Chaque compteur a un champ « Monitoring », qui prend deux valeurs : « Forcé » ou « Selon configuration smart charging » (par défaut). Selon cette valeur et l'activation du smart charging de sa PCA, le compteur est monitoré ou non :

| # | Monitoring | Smart charging de sa PCA | Monitoré ? |
| --- | --- | --- | --- |
| R1.1 | Forcé | indifférent | Oui |
| R1.2 | Selon configuration smart charging | activé | Oui |
| R1.3 | Selon configuration smart charging | désactivé | Non |
| R1.4 | Selon configuration smart charging | pas de PCA | Non |

Un compteur supprimé n'est jamais monitoré.

### R2. Lecture hors recharge

Chaque compteur monitoré est lu au moins toutes les 15 minutes, même sans recharge en cours, et pour la première fois au plus tard 15 minutes après être devenu monitoré.

### R3. Alerte

Quand un compteur passe en alerte, un mail d'alerte part dans les 10 minutes. Un seul mail par période sans lecture réussie. Une nouvelle période commence :

- après une lecture réussie ;
- quand le compteur redevient monitoré.

➡️ *Un seul mail par compteur par panne, pour éviter le flood d'emails.*

➡️ *Changer un réglage ne relance pas les 60 minutes si le compteur reste monitoré : sinon, ce changement retarderait l'alerte d'une panne en cours.*

### R4. Alerte groupée

Quand plus de 30 compteurs sont en alerte, un seul mail groupé part dans les 10 minutes. Il compte comme le mail d'alerte de chacun de ces compteurs. Tant que plus de 30 compteurs sont en alerte, aucun mail d'alerte individuel ne part. Si leur nombre repasse à 30 ou moins, puis de nouveau au-dessus, un nouveau mail groupé part.

➡️ *Au-delà de 30, la panne est générale (réseau, serveur) : une liste de compteurs serait illisible, et déjà fausse au moment où on la lit.*

### R5. Contenu des mails

| # | Mail | Titre | Corps |
| --- | --- | --- | --- |
| R5.1 | Par compteur, déjà lu avec succès | ⚠️ [Alerte Nexteneo] Compteur hors-ligne [nom] | « La lecture du compteur [nom, lien] n'a pas fonctionné depuis le [date de la dernière lecture réussie] (heure de Paris). » |
| R5.2 | Par compteur, jamais lu avec succès | ⚠️ [Alerte Nexteneo] Compteur hors-ligne [nom] | « La lecture du compteur [nom, lien] n'a jamais fonctionné. » |
| R5.3 | Groupé | ⚠️ [Alerte Nexteneo] Plus de 30 compteurs hors-ligne | « La lecture de plus de 30 compteurs monitorés n'a pas fonctionné depuis plus de 60 minutes. » |

Tous les mails partent à alerts@nexteneo.com.

Si l'envoi d'un mail échoue, il part dans les 10 minutes qui suivent le rétablissement de l'envoi, sauf si entre-temps la situation qui l'a déclenché a pris fin.

### R6. Statut affiché dans Cockpit

| # | Monitoré ? | Situation | Statut |
| --- | --- | --- | --- |
| R6.1 | Non | (toutes) | N/A, et le bloc « État » de la fiche est masqué |
| R6.2 | Oui | Aucune tentative de lecture | N/A |
| R6.3 | Oui | Dernière lecture réussie | Joignable |
| R6.4 | Oui | Dernière lecture échouée | Injoignable |

➡️ *R6.1 : joignable et injoignable n'ont de sens que pour un compteur lu régulièrement.*

Dans le bloc « État », une date qui n'existe pas encore s'affiche « — » : « Dernière lecture » jusqu'à la première lecture, « Dernière lecture réussie » jusqu'à la première lecture réussie.

### R7. Compteurs existants

Un compteur qui existait avant l'activation de la fonctionnalité prend la valeur « Selon configuration smart charging » et devient monitoré, ou non, à l'activation.

➡️ *Sinon, tous les compteurs monitorés existants alerteraient dès l'activation.*

## 4. Scénarios

| # | Situation | Résultat attendu | Règles |
| --- | --- | --- | --- |
| S1 | **Jamais lu avec succès**<br>Compteur créé à 14:00, en Monitoring Forcé. Toutes ses lectures échouent. | Statut N/A jusqu'à la 1re lecture, puis Injoignable (pas N/A). Mail « n'a jamais fonctionné » entre 15:00 et 15:10.<br>Bloc « État » : « Dernière lecture » affiche « — » jusqu'à la 1re lecture ; « Dernière lecture réussie » reste « — ». | R1.1, R3, R5.2, R6 (dates), R6.2, R6.4 |
| S2 | **Panne longue, puis nouvelle panne**<br>14:00 : lecture réussie du compteur monitoré, puis toutes ses lectures échouent.<br>16:30 : lecture réussie, puis toutes ses lectures échouent. | Statut Joignable à 14:00 et 16:30, Injoignable au plus tard à 14:15 et 16:45.<br>Un mail entre 15:00 et 15:10, aucun autre avant 16:30. Nouveau mail entre 17:30 et 17:40. | R2, R3, R6.3, R6.4 |
| S3 | **Réglages changés en pleine panne**<br>14:00 : lecture réussie du compteur, monitoré par le smart charging de sa PCA, puis toutes ses lectures échouent.<br>14:20 : il passe en Monitoring Forcé.<br>14:30 : il est rattaché à une autre PCA. | Mail entre 15:00 et 15:10, pas entre 15:20 et 15:30 ni entre 15:30 et 15:40.<br>Titre « ⚠️ [Alerte Nexteneo] Compteur hors-ligne [nom] » ; le corps contient le lien vers le compteur et donne 14:00, heure de Paris, comme date de la dernière lecture réussie. | R1.1, R1.2, R3, R5.1 |
| S4 | **Cesse d'être monitoré en pleine panne**<br>14:00 : lecture réussie du compteur monitoré, puis toutes ses lectures échouent.<br>Envoi de mails en panne de 15:00 à 16:30.<br>16:00 : le smart charging de sa PCA est désactivé. | Aucun mail reçu.<br>Dès 16:00 : statut N/A (pas Injoignable), bloc « État » masqué. | R1.3, R3, R5, R6.1 |
| S5 | **De nouveau monitoré après une pause**<br>10:00 : lecture réussie du compteur monitoré, puis toutes ses lectures échouent.<br>11:30 : le smart charging de sa PCA est désactivé.<br>14:00 : il est réactivé. | Mail entre 11:00 et 11:10. Aucun mail à 14:00. Nouveau mail entre 15:00 et 15:10. | R1.2, R1.3, R3 |
| S6 | **Devient monitoré après sa création**<br>14:00 : deux compteurs créés en Monitoring Selon configuration smart charging, sans PCA.<br>14:20 : le premier passe en Monitoring Forcé, le second est rattaché à une PCA dont le smart charging est activé.<br>Toutes leurs lectures échouent. | Pour chacun, jusqu'à 14:20 : statut N/A, bloc « État » masqué. Puis statut Injoignable au plus tard à 14:35.<br>Pour chacun : mail « n'a jamais fonctionné » entre 15:20 et 15:30, pas entre 15:00 et 15:10. | R1.1, R1.2, R1.4, R2, R3, R5.2, R6.1 |
| S7 | **Compteur supprimé en pleine panne**<br>14:00 : lecture réussie du compteur monitoré, puis toutes ses lectures échouent.<br>14:30 : le compteur est supprimé. | Aucun mail à 15:00. | R1 (supprimé), R3 |
| S8 | **Envoi en échec, puis lecture réussie**<br>14:00 : lecture réussie du compteur monitoré, puis toutes ses lectures échouent.<br>Envoi de mails en panne de 15:00 à 15:45.<br>15:30 : lecture réussie. | Aucun mail reçu au rétablissement de l'envoi, à 15:45. | R3, R5 |
| S9 | **Envoi rétabli**<br>14:00 : lecture réussie du compteur monitoré, puis toutes ses lectures échouent.<br>Envoi de mails en panne de 15:00 à 15:20. | Un seul mail, reçu entre 15:20 et 15:30. | R3, R5 |
| S10 | **30 puis 31 compteurs en alerte**<br>15:00 : 30 compteurs passent en alerte.<br>15:20 : un 31e les rejoint. | Entre 15:00 et 15:10 : 30 mails, un par compteur.<br>Entre 15:20 et 15:30 : un seul mail groupé « ⚠️ [Alerte Nexteneo] Plus de 30 compteurs hors-ligne » ; aucun mail individuel pour le 31e.<br>Tous ces mails partent à alerts@nexteneo.com. | R3, R4, R5, R5.3 |
| S11 | **Compteur existant à l'activation**<br>Compteur monitoré, créé avant l'activation de la fonctionnalité.<br>14:00 : la fonctionnalité est activée.<br>Ensuite, toutes ses lectures échouent. | Aucun mail à 14:00 ; mail entre 15:00 et 15:10. | R3, R7 |

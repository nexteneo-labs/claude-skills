# Écrire les termes et les règles

## Les termes

Chaque feature a ses propres notions. Comme la section « Définitions » d'un contrat, la sous-section **Termes** les définit une fois ; les règles les reprennent ensuite tels quels.

Ce que ça apporte :

- des règles plus courtes : un mot remplace une condition de plusieurs lignes ;
- un sens identique dans toutes les règles ;
- une seule ligne à modifier si la définition change.

Comment l'écrire :

- le mot en gras, puis ce qu'il veut dire en une phrase simple ;
- s'il faut des cas pour dire qui ou quoi est concerné, ils vont dans une règle, et le terme y renvoie (« voir R1 ») ;
- un terme est utile dès qu'un mot au sens peu intuitif revient dans plusieurs règles.

Exemple de ce qu'un terme évite. Avant, la même condition était recopiée dans deux règles :

> « Si le monitoring du compteur est forcé, ou s'il est réglé selon la configuration smart charging et que la config smart charging de sa PCA est active, et qu'il n'a pas été lu depuis 15 minutes, alors il est lu. »
> « Si le monitoring du compteur est forcé, ou s'il est réglé selon la configuration smart charging et que la config smart charging de sa PCA est active, et qu'il n'a fourni aucune lecture réussie depuis 60 minutes, alors un mail d'alerte part. »

Dans la vraie spec, l'une des copies a fini par dire le contraire de l'autre. Après :

> **Compteur monitoré** : un compteur dont on surveille la connexion (voir R1).
> R2. Chaque **compteur monitoré** est lu au moins toutes les 15 minutes, même sans recharge en cours.

## Les règles : 5 exigences

Numérote les règles R1, R2… avec un titre court. Quand une règle est une table, numérote ses lignes (R1.1, R1.2…) : les scénarios les citeront.

### 1. Une seule interprétation possible

Deux lecteurs doivent en tirer le même comportement. Une règle se lit comme un contrat : une clause à deux sens risque d'être mal implémentée.

À éviter : « Chaque modification enregistre l'utilisateur, la date, l'ancienne et la nouvelle valeur. »
Cliquer sur Enregistrer sans rien changer, est-ce une modification ? Deux lectures possibles, deux comportements.

À écrire : « Quand un admin enregistre une valeur différente de la valeur actuelle, on conserve une trace : l'admin, la date et l'heure, l'ancienne et la nouvelle valeur. Enregistrer la même valeur ne laisse pas de trace. »
Le mot piège est remplacé par ce qui se passe vraiment.

### 2. Elle couvre tous les cas, explicitement

Réflexe : lister toutes les valeurs possibles de l'entrée, puis décider pour chacune. Une table oblige à décider pour chaque ligne et fait apparaître les cas qu'on aurait oubliés.

À éviter : « Si la puissance saisie dépasse la puissance maximum, un avertissement s'affiche. Sinon, aucun message. »
Le « sinon » décide pour des cas que personne n'a regardés : vide, négatif, zéro, limite exacte.

À écrire :

| Puissance saisie | Message | Enregistrement |
| --- | --- | --- |
| Négative ou non numérique | Erreur « La puissance doit être un nombre positif ou nul. » | Bloqué |
| 0 kW | Erreur « Aucune borne du groupe ne pourra charger. » | Bloqué |
| Plus de 0, jusqu'à P | Aucun | Autorisé |
| Plus que P | Avertissement « Dépasse la puissance maximum (P kW). » | Autorisé |

C'est ici que le code aide le plus : les valeurs possibles d'un champ, les états existants, les rôles, ce qui se passe déjà aujourd'hui. Cherche-les dans le code, puis décris chaque cas avec des mots du produit.

### 3. Elle laisse l'implémentation au dev

Ce qui s'observe va dans la règle. Champs, tables, endpoints, jobs, crons et composants sont laissés au dev.

À éviter : « SI (electricMeter.monitoring = "forced" OU (…)) ET (now − offlineCountdownStartedAt) ≥ 60 minutes ET (…) ALORS envoi d'un mail. »
Elle choisit à la place du dev les champs et la façon de les comparer, et elle se trompe de nom au passage (« monitoring » ici, « monitoringMode » ailleurs).

À écrire : « Quand un **compteur passe en alerte**, un mail d'alerte part dans les 10 minutes. Un seul mail par période sans lecture réussie. »
La règle se lit sans connaître le code, et la tolérance de 10 minutes laisse au dev le choix du mécanisme.

Pour trier, découpe la règle morceau par morceau et demande-toi : **le produit le voit-il ?**

| Ce que disait la règle | Le produit le voit ? |
| --- | --- |
| Lire même sans recharge | Oui : c'est le cœur de la feature |
| 15 minutes au plus entre deux lectures | Oui : c'est le retard maximal du statut affiché |
| Passages à :00, :15, :30, :45 | Non |
| Ne lire que les compteurs non lus depuis 15 minutes | Non |
| Secondes ignorées | Non |

Une durée qui compte pour le produit reste dans la règle, écrite comme une limite (« au moins toutes les 15 minutes », « dans les 10 minutes »). Comment la tenir, c'est au dev de le décider.

### 4. Chaque chose est dite une fois, au bon endroit

Réflexe : avant d'écrire une phrase, vérifier si elle est déjà dite ailleurs : dans un terme, la maquette ou une autre règle. Une redite finit par contredire l'original.

À éviter : R4 recopie la condition de R3 : « Quand plus de 30 compteurs n'ont pas été lus avec succès depuis 60 minutes… »
La copie a perdu « monitoré d'affilée ». Un compteur redevenu monitoré il y a 10 minutes compterait dans les 30, alors que R3 ne l'alerte pas encore : R3 et R4 se contredisent.

À écrire : R3 et R4 s'appuient toutes les deux sur le terme **Compteur en alerte**.

### 5. Elle dit pourquoi quand elle surprend

Ajoute une ligne introduite par ➡️, en italique, seulement si un lecteur pourrait proposer de faire autrement. Une règle évidente n'en a pas besoin.

> R4. Quand plus de 30 compteurs sont en alerte, un seul mail groupé part. Tant qu'ils sont plus de 30, aucun mail d'alerte individuel ne part.
> ➡️ *Au-delà de 30, la panne est générale (réseau, serveur) : une liste de compteurs serait illisible, et déjà fausse au moment où on la lit.*

Sans cette ligne, le 31e compteur sans mail ressemble à un bug, et un dev ou une IA risque de le « corriger ». Elle garde aussi la trace du pourquoi : si le contexte change, on sait quoi revoir.

La ligne ➡️ tient en une phrase. Si le pourquoi repose sur des chiffres mesurés ou sur des options écartées, leur détail va dans l'annexe facultative « enquête » (voir `gabarit.md`).

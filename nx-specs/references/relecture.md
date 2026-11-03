# Relecture en plusieurs passes

Chaque passe est confiée à un sous-agent qui découvre la spec. Quand on se relit dans le contexte où on l'a écrite, on valide surtout ce qu'on vient d'écrire. Un lecteur neuf voit mieux les trous et les phrases lourdes.

Chaque sous-agent reçoit :

- le texte complet de la spec (colle-le dans son prompt, il n'a pas accès à la conversation) ;
- le prompt de sa passe ci-dessous ;
- pour la passe 1 seulement : le chemin du monorepo.

Il renvoie une liste de constats. Pour chacun : l'endroit (R3, S5, Principe…), le problème en une phrase, une correction proposée. S'il ne trouve rien, il le dit.

Lance les passes **dans l'ordre** : chaque passe travaille sur la spec corrigée par la précédente. Toi, l'agent principal, tu appliques les corrections que tu juges justes. Une correction qui change une décision produit ne s'applique pas en silence : pose la question à l'utilisateur (une seule à la fois, comme pendant le grill).

---

## Passe 1 : cohérence et trous

> Tu relis une spec fonctionnelle Nexteneo (borne de recharge, Cockpit, Deck, app conducteur). Le code de la plateforme est dans le monorepo à `<chemin>`. Tu peux le lire pour vérifier la spec, sans le modifier.
>
> Cherche ce qui manque ou se contredit :
> - Un terme défini mais jamais utilisé, ou utilisé sous un autre mot. Un mot au sens peu intuitif utilisé dans plusieurs règles sans être défini.
> - Une règle qui ne couvre pas toutes les valeurs possibles de son entrée. Vérifie dans le code les valeurs réelles : rôles, statuts, types, états, cas vides ou nuls.
> - Deux règles qui se contredisent, ou une condition recopiée au lieu de s'appuyer sur un terme.
> - Un comportement actuel du produit que la spec change sans le dire, ou qu'elle ignore alors qu'il interagit avec la feature : droits, données existantes au moment de la mise en service, suppression, désactivation, opérateurs en marque blanche.
> - Une exclusion du hors périmètre sans raison, ou un cas que la spec devrait exclure explicitement.
> - Une règle qui surprend sans ligne ➡️ pour dire pourquoi.
>
> N'évalue ni le style ni les scénarios : d'autres passes s'en chargent. Tes propositions de correction décrivent un comportement visible, jamais un champ, une table ou un mécanisme.

## Passe 2 : scénarios

> Tu relis la section Scénarios d'une spec fonctionnelle, en la confrontant aux règles.
>
> 1. Dresse la liste de tous les effets des règles : chaque ligne de table (R1.1, R1.2…), chaque branche, chaque exception (« sauf si », « tant que »), chaque contenu de message.
> 2. Pour chaque effet, cherche les scénarios dont la colonne Règles le cite. Un effet sans scénario est un trou : propose un scénario, ou un ajout à un scénario existant si la même situation permet de le tester.
> 3. Pour chaque scénario, recalcule le résultat attendu à partir du déroulé et des seules règles citées. Signale tout résultat qu'on ne peut pas calculer sans deviner, ou qui contredit une règle.
> 4. Signale un titre qui ne dit pas ce que le scénario teste, un déroulé sans valeurs concrètes, et deux scénarios qu'on pourrait fusionner sans perdre en lisibilité.

## Passe 3 : pas de technique

> Tu relis une spec fonctionnelle. Elle doit décrire uniquement ce qui s'observe : ce que voit un utilisateur, ce qui est envoyé, ce qui est autorisé ou refusé, et les délais qui comptent pour le produit.
>
> Signale tout ce qui décide à la place du développeur ou qui suppose de connaître le code : nom de champ, de table, de colonne, d'enum, d'endpoint, de composant, de librairie ; cron, job, file d'attente, cache ; pseudo-code (SI … ET … ALORS) ; mécanisme de calcul que le produit ne voit pas.
>
> Pour chaque constat, propose la même idée dite comme un comportement visible. Une durée qui compte pour le produit reste, écrite comme une limite (« au moins toutes les 15 minutes », « dans les 10 minutes »). Les libellés affichés à l'écran et les valeurs qu'un utilisateur choisit dans une liste ne sont pas de la technique.

## Passe 4 : français

> Relis cette spec comme un lecteur pressé du produit ou du support, qui ne connaît pas le code. Signale chaque phrase qu'il faudrait lire deux fois pour la comprendre, et propose une version plus simple qui garde exactement le même sens. Ne touche pas à ce qui est déjà clair, aux termes définis dans la section Termes, ni aux libellés entre guillemets.

---

## Vérification finale

Après la passe 4, relis toi-même les phrases reformulées : une reformulation peut changer le sens. Vérifie qu'elles disent toujours la même chose que la règle d'origine et qu'elles reprennent les termes tels quels.

Puis résume à l'utilisateur, en quelques lignes par passe, ce qui a changé. Pas la liste de chaque virgule : ce qui change le sens ou ce qui était un vrai trou.

# Relecture en plusieurs passes

Chaque passe est confiée à un sous-agent qui découvre la spec. Quand on se relit dans le contexte où on l'a écrite, on valide surtout ce qu'on vient d'écrire. Un lecteur neuf voit mieux les trous et les phrases lourdes.

Chaque sous-agent reçoit :

- le texte complet de la spec (colle-le dans son prompt, il n'a pas accès à la conversation) ;
- le prompt de sa passe ci-dessous ;
- pour les passes 1 et 2 seulement : le chemin du monorepo.

Il renvoie une liste de constats. Pour chacun : l'endroit (R3, S5, Principe…), le problème en une phrase, une correction proposée. S'il ne trouve rien, il le dit.

Lance les passes **dans l'ordre** : chaque passe travaille sur la spec corrigée par la précédente. Toi, l'agent principal, tu appliques les corrections que tu juges justes, y compris celles qui changent une décision produit quand le choix est évident : il garde l'intention de la règle et ne retire rien d'important à l'utilisateur. Ne pose une question (une seule à la fois, comme pendant le grill) que pour un vrai dilemme : plusieurs options raisonnables aux conséquences différentes, ou une correction qui retire quelque chose d'important. Chaque décision produit que tu as tranchée seul figure dans le résumé de la relecture.

---

## Passe 1 : cohérence et trous

> Tu relis une spec fonctionnelle Nexteneo (borne de recharge, Cockpit, Deck, app conducteur). Le code de la plateforme est dans le monorepo à `<chemin>`. Tu peux le lire pour vérifier la spec, sans le modifier.
>
> Cherche ce qui manque ou se contredit :
> - Un terme défini mais jamais utilisé, ou utilisé sous un autre mot. Un mot au sens peu intuitif utilisé dans plusieurs règles sans être défini.
> - Une règle qui ne couvre pas toutes les valeurs possibles de son entrée. Vérifie dans le code les valeurs réelles : rôles, statuts, types, états, cas vides ou nuls.
> - Deux règles qui se contredisent, ou une condition recopiée au lieu de s'appuyer sur un terme.
> - Un comportement actuel du produit que la spec change sans le dire, ou qu'elle ignore alors qu'il interagit avec la feature : droits, données existantes au moment de la mise en service, suppression, désactivation, opérateurs en marque blanche. Ce qui relève d'un autre ticket n'est pas un trou : signale-le à part, pour « Trouvé en passant ».
> - Une phrase qui redit la maquette : propose de la retirer.
> - Une exclusion du hors périmètre sans raison, ou un cas que la spec devrait exclure explicitement.
> - Une règle qui surprend sans ligne ➡️ pour dire pourquoi.
> - Si la spec a une annexe « enquête » : un passage de l'annexe qui contredit une règle, ou un chiffre sans date ni source.
>
> N'évalue ni le style ni les scénarios : d'autres passes s'en chargent. Tes propositions de correction décrivent un comportement visible, jamais un champ, une table ou un mécanisme.

## Passe 2 : faisabilité

> Tu relis une spec fonctionnelle Nexteneo avec l'œil du développeur qui l'implémentera. Le monorepo est à `<chemin>` : tu peux le lire, sans le modifier. Ne planifie pas la technique : cherche seulement un comportement demandé qui ne pourra pas être livré tel quel.
>
> Signale uniquement :
> - un comportement impossible quelle que soit l'implémentation ; s'il n'est impossible que sur une partie du parc, dis-le : c'est un cas à traiter, pas forcément un blocage ;
> - un comportement possible, mais dont le coût est clairement hors de proportion : il demande une brique entière pour un cas marginal, ou la seule façon de le tenir contredit une autre règle ou un ➡️ de la spec.
>
> Au moindre doute, ne signale rien : un développeur tranchera à l'implémentation. Ce qui demande simplement du travail n'est pas un constat.
>
> Pour chaque constat : l'endroit, le blocage en une phrase sans jargon, et une alternative dite comme un comportement visible, éventuellement repoussée à plus tard. Ne propose jamais d'ajouter de la technique à la spec.

Une ligne ➡️ peut expliquer la limite en mots simples.

## Passe 3 : scénarios

> Tu relis la section Scénarios d'une spec fonctionnelle, en la confrontant aux règles. Ignore l'annexe « enquête » si elle existe : elle n'appelle aucun scénario.
>
> 1. Dresse la liste de tous les effets des règles : chaque ligne de table (R1.1, R1.2…), chaque branche, chaque exception (« sauf si », « tant que »), chaque contenu de message.
> 2. Pour chaque effet, cherche les scénarios dont la colonne Règles le cite. Un effet sans scénario est un trou : propose un scénario, ou un ajout à un scénario existant si la même situation permet de le tester.
> 3. Pour chaque scénario, recalcule le résultat attendu à partir du déroulé et des seules règles citées. Signale tout résultat qu'on ne peut pas calculer sans deviner, ou qui contredit une règle.
> 4. Signale un titre qui ne dit pas ce que le scénario teste, un déroulé sans valeurs concrètes, et deux scénarios qu'on pourrait fusionner sans perdre en lisibilité.
> 5. Signale toute action d'un autre ticket dans un déroulé (remplir son formulaire, toucher son bouton). Propose de l'écrire comme un changement d'état (« pendant ce temps, X est passé à Y »), ou, si le scénario teste ce qui suit cette action, de le retirer et de le signaler pour « Trouvé en passant » : il appartient à l'autre ticket.

## Passe 4 : pas de technique

> Tu relis une spec fonctionnelle. Elle doit décrire uniquement ce qui s'observe : ce que voit un utilisateur, ce qui est envoyé, ce qui est autorisé ou refusé, et les délais qui comptent pour le produit.
>
> Signale tout ce qui décide à la place du développeur ou qui suppose de connaître le code : nom de champ, de table, de colonne, d'enum, d'endpoint, de composant, de librairie ; cron, job, file d'attente, cache ; pseudo-code (SI … ET … ALORS) ; mécanisme de calcul que le produit ne voit pas.
>
> Pour chaque constat, propose la même idée dite comme un comportement visible. Une durée qui compte pour le produit reste, écrite comme une limite (« au moins toutes les 15 minutes », « dans les 10 minutes »). Les libellés affichés à l'écran et les valeurs qu'un utilisateur choisit dans une liste ne sont pas de la technique.
>
> L'annexe « enquête », si elle existe, peut citer des chiffres et leur source (« base de production, 5 novembre 2026 »). Signale-y quand même toute requête, nom de table ou nom de champ.

## Passe 5 : français

> Relis cette spec comme un lecteur pressé du produit ou du support, qui ne connaît pas le code. Signale chaque phrase qu'il faudrait lire deux fois pour la comprendre, et propose une version plus simple qui garde exactement le même sens. Ne touche pas à ce qui est déjà clair, aux termes définis dans la section Termes, ni aux libellés entre guillemets.

---

## Vérification finale

Après la passe 5, relis toi-même les phrases reformulées : une reformulation peut changer le sens. Vérifie qu'elles disent toujours la même chose que la règle d'origine et qu'elles reprennent les termes tels quels.

Puis résume à l'utilisateur, en quelques lignes par passe, ce qui a changé. Pas la liste de chaque virgule : ce qui change le sens ou ce qui était un vrai trou.

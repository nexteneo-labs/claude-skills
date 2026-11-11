# Relecture en plusieurs passes

Chaque passe est confiée à un sous-agent qui découvre la spec. Un lecteur neuf voit les trous et les phrases lourdes qu'on ne voit plus.

Chaque sous-agent reçoit :

- le texte complet de la spec (colle-le dans son prompt, il n'a pas accès à la conversation) ;
- le prompt de sa passe ci-dessous ;
- pour les passes 1 et 2 seulement : le chemin du monorepo.

Il renvoie une liste de constats. Pour chacun : l'endroit (R3, S5, Principe…), le problème en une phrase, une correction proposée. S'il ne trouve rien, il le dit.

Lance les passes **dans l'ordre** : chaque passe travaille sur la spec corrigée par la précédente. Toi, l'agent principal, tu appliques les corrections que tu juges justes. Une correction qui change une décision produit se tranche avec le critère « Qui tranche » du grill (`SKILL.md`, étape 3) : tu l'appliques seul ou tu poses la question (une seule à la fois, comme pendant le grill). Chaque décision produit que tu as tranchée seul figure dans le résumé de la relecture.

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
> - Une règle qui surprend sans ligne ➡️. Signale-la sans rédiger de raison : seul l'auteur sait si elle a été donnée.
> - Une ligne ➡️ qui ne répond pas à « pourquoi pas autrement ? », qu'on ne comprend pas sans contexte, ou qui emploie un mot que la spec ou le produit n'utilise plus.
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

## Passe 3 : combinaisons

> Tu relis les règles d'une spec fonctionnelle Nexteneo, en cherchant ce qui casse quand deux perturbations arrivent ensemble.
>
> 1. Liste les perturbations que la spec connaît : échec, résultat inconnu (réponse perdue), action répétée, ajout, modification ou suppression par une autre personne ou un autre système, page fermée, retour sur la page.
> 2. Pour chaque règle, vérifie qu'elle donne encore un résultat sensé quand deux de ces perturbations arrivent ensemble.
> 3. Signale toute règle dont la condition repose sur une hypothèse implicite, en particulier une condition écrite sur une suite d'événements (« l'autre a retiré… ») plutôt que sur l'état final (« le groupe n'aurait plus aucune borne »).
>
> Le résultat attendu est surtout une règle reformulée, sans règle ni scénario de plus. Ne propose d'ajouter quelque chose que si la combinaison est plausible dans l'usage réel **et** que son résultat serait grave : donnée perdue ou fausse sans que personne le voie, action sensible mal attribuée. Classe chaque constat : « reformulation », « ajout essentiel » ou « probablement non essentiel ». Ce qui dépend de la façon de construire (requêtes, rechargements, verrous, délais internes) n'entre pas dans la spec : ne propose rien de tel.

Le seuil est volontairement haut : une combinaison peu plausible, ou sans conséquence grave, est écartée, même si elle est juste. Beaucoup de constats peuvent finir écartés ; ce n'est pas un échec de la passe. Applique les reformulations ; un « ajout essentiel » se tranche avec la matrice. Chaque combinaison écartée va dans l'annexe « enquête », tableau « Combinaisons écartées », avec sa raison (`references/gabarit.md`).

## Passe 4 : scénarios

> Tu relis la section Scénarios d'une spec fonctionnelle, en la confrontant aux règles. Ignore l'annexe « enquête » si elle existe : elle n'appelle aucun scénario.
>
> 1. Dresse la liste de tous les effets des règles : chaque ligne de table (R1.1, R1.2…), chaque branche, chaque exception (« sauf si », « tant que »), chaque contenu de message.
> 2. Pour chaque effet, cherche les scénarios dont la colonne Règles le cite. Un effet sans scénario est un trou : propose un scénario, ou un ajout à un scénario existant si la même situation permet de le tester.
> 3. Pour chaque scénario, recalcule le résultat attendu à partir du déroulé et des seules règles citées. Signale tout résultat qu'on ne peut pas calculer sans deviner, ou qui contredit une règle.
> 4. Signale un titre qui ne dit pas ce que le scénario teste, un déroulé sans valeurs concrètes, et deux scénarios qu'on pourrait fusionner sans perdre en lisibilité.
> 5. Signale un scénario qui concerne un autre ticket : sa place est dans cet autre ticket. Signale aussi un changement venu d'ailleurs écrit comme une action (« il ouvre le formulaire de la PCA et choisit… ») : propose de l'écrire comme un changement d'état (« 14:30 : il est rattaché à une autre PCA »).

## Passe 5 : pas de technique

> Tu relis une spec fonctionnelle. Elle doit décrire uniquement ce qui s'observe : ce que voit un utilisateur, ce qui est envoyé, ce qui est autorisé ou refusé, et les délais qui comptent pour le produit.
>
> Signale tout ce qui décide à la place du développeur ou qui suppose de connaître le code : nom de champ, de table, de colonne, d'enum, d'endpoint, de composant, de librairie ; cron, job, file d'attente, cache ; pseudo-code (SI … ET … ALORS) ; mécanisme de calcul que le produit ne voit pas.
>
> Pour chaque constat, propose la même idée dite comme un comportement visible. Une durée qui compte pour le produit reste, écrite comme une limite (« au moins toutes les 15 minutes », « dans les 10 minutes »). Les libellés affichés à l'écran et les valeurs qu'un utilisateur choisit dans une liste ne sont pas de la technique.
>
> L'annexe « enquête », si elle existe, peut citer des chiffres et leur source (« base de production, 5 novembre 2026 »). Signale-y quand même toute requête, nom de table ou nom de champ.

## Passe 6 : français

> Relis cette spec comme un lecteur pressé du produit ou du support, qui ne connaît pas le code. Signale chaque phrase qu'il faudrait lire deux fois pour la comprendre, et propose une version plus simple qui garde exactement le même sens. Ne touche pas à ce qui est déjà clair, aux termes définis dans la section Termes, ni aux libellés entre guillemets.

---

## Vérification finale

Après la passe 6, relis toi-même les phrases reformulées : une reformulation peut changer le sens. Vérifie qu'elles disent toujours la même chose que la règle d'origine et qu'elles reprennent les termes tels quels.

Puis résume à l'utilisateur, en quelques lignes par passe, ce qui a changé. Pas la liste de chaque virgule : ce qui change le sens ou ce qui était un vrai trou.

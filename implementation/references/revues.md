# Revues indépendantes

L'agent reçoit des fichiers, jamais tes messages ni tes conclusions. Il ne modifie rien, ne lance ni E2E ni base (`pnpm test`, `pnpm check` permis). Chaque prompt se termine par :

> Constats seulement, du plus grave au moins grave. Pour chacun : fichier:ligne, le problème, un scénario concret (actions → résultat visible faux), ta confiance, vérifié de bout en bout ou soupçonné. Au plus 800 mots, moins pour un petit plan ou un petit diff.

## Plan (étape 2)

> Relis le plan technique d'une feature de l'app Mariage (`<repo>`) : spec `<chemin>` et maquette, `docs/CONVENTIONS.md`, `docs/adr/`, puis `<dossier>/decisions-techniques.md`. Challenge-le :
> 1. Suit-il les pratiques établies ? Une option plus simple répondrait-elle à la spec ?
> 2. Chaque garantie attendue d'une bibliothèque : vérifie-la dans son code (`node_modules/`, version installée), cite la fonction.
> 3. Table des états : état manquant (requêtes dans le désordre, rechargement annulé ou échoué…) ou combinaison qui contredirait une règle ?
> 4. Construit-il plus que la spec ne demande ?

## Code (étape 4), deux agents en parallèle

Les deux reçoivent la spec, la maquette, `docs/CONVENTIONS.md`, `docs/GLOSSARY.md` et le diff (`git status`, `git diff`, fichiers non suivis).

**Conformité et tests**

> 1. Chaque règle et scénario est-il vraiment fait ? Croise les perturbations de la spec (échec, pas de réponse, action répétée, autre appareil, fermeture, retour, formulaire ouvert) avec les états ajoutés (requête en vol, réponse perdue, rechargement, requêtes croisées ou dans le désordre). Cherche un résultat visible qui contredit une règle. Lis le code des bibliothèques plutôt que de supposer.
> 2. Pour chaque scénario, le test qui le prouve. Signale : scénario non prouvé, assertion qui ne peut pas échouer, test dépendant du temps, test qui passerait sans la protection.

**Sécurité et règles du repo**

> - Requêtes forgées (autre type de Personne, champs inconnus, formes mélangées, gros corps, autre type de contenu) : que peuvent-elles faire ? Chaque protection a-t-elle un test d'API qui échouerait sans elle ?
> - Migrations : justes sur les données existantes, ordre, cohérence avec le schéma, réversibilité.
> - Logs : aucune donnée personnelle (une erreur de requête peut contenir ses paramètres).
> - Règles du repo : glossaire ; aucune citation de spec, règle ou scénario dans le code ; commentaires exacts, densité du code autour ; placement et noms ; `docs/adr/` et `decisions-techniques.md` fidèles au code ; docs qui décrivent l'ancien comportement comme actuel.

# Tests

En plus de `docs/CONVENTIONS.md` §8.

## Ajouts aux niveaux

- API (helper `send` de `e2e/api.ts`) : aussi un corps JSON valide en `text/plain`, qui doit être refusé.
- Migration de données : base jetable, migrations précédentes, données d'avant, nouvelle migration (`e2e/migrations.api.spec.ts`).

## Simuler sans délai fixe

- Autre appareil : écrire directement en base (`e2e/db.ts`).
- Connexion lente ou perdue : retenir la requête dans `page.route`, la libérer ou `route.abort` quand le test le décide.
- Délai de 15 s : `page.clock.install()`, `page.clock.runFor(…)`.
- Requêtes vraiment simultanées : `crossingInserts`.
- Retour sur la page : simuler `visibilitychange`.
- Requêtes retenues : reçues dans l'ordre d'arrivée, pas des clics.

## Pièges

- Le texte d'une alerte inclut son « ✕ » : `getByText(…, { exact: true })` dedans.
- `getByRole("banner")` ne voit pas un `<header>` dans une `<section>` : l'assertion « absent » ne peut pas échouer.
- Téléphone : éléments masqués exclus par défaut ; `includeHidden: true` pour prouver l'absence.

## Prouver

- Protection : la retirer (copie du fichier, jamais `git checkout` sur du travail non commité), lancer le seul test, constater l'échec, la remettre.

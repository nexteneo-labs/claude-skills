# Le plan : `decisions-techniques.md`

Figé avec la spec livrée. Ce qui restera vrai et peut surprendre devient aussi un principe court dans `docs/adr/` (`docs/adr/template.md`) : le plan garde le débat, le principe la règle.

## Gabarit

```markdown
# Spec NN: technical decisions

How spec NN (<title>) was built, and why (<date>). Frozen with the spec once delivered. Principles: `docs/adr/NNNN-….md`.

## Context        what the spec asks that drives the technique; principles that apply
## Options considered   per decision, one line per option; the established practice, followed or not
## Decision       the choice, with function names
## States and disturbances   the table, expected behaviour per case kept (only if something is asynchronous)
## Tests          scenario → level; server protection → API test
## Consequences   accepted limits; roadmap; sentences proposed for the spec
```

## Pratiques établies (repères du projet)

- Affichage avant la réponse du serveur : état du serveur + changements en attente rejoués dans l'ordre (Replicache) ; file par donnée (« scope » de TanStack Query) ; indicateur « en cours » (horloge de WhatsApp) ; réservé aux actions fréquentes, sans gravité, réversibles.
- Reprise sans doublon : identifiants choisis par le navigateur, ou clé d'idempotence.
- Deux appareils : écrire champ par champ ce qui a changé ; sur un même champ, le dernier écrit gagne.

On suit le modèle et on le nomme ; on n'ajoute la bibliothèque que si c'est nécessaire.

## Table des états

États ajoutés par la technique (à adapter) : requête en vol ; réponse perdue (peut-être enregistré) ; délai dépassé, serveur encore au travail ; rechargement après une action en cours, annulé ou échoué ; nouvel essai ; deux requêtes qui se croisent **ou arrivent dans le désordre** ; liste chargée avant une action et reçue après sa réponse ; formulaire ouvert pendant qu'une action attend ; onglet fermé pendant qu'une action attend.

Croisés avec les perturbations de la spec : échec, pas de réponse, action répétée, ajout / modification / suppression ailleurs, fermeture, retour sur la page.

Chaque case : un comportement déduit des règles, ou « sans intérêt ». Case indéductible = trou de la spec → question ou phrase, selon la matrice. Les cases à risque donnent un test.

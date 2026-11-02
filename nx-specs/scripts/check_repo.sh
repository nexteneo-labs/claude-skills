#!/usr/bin/env bash
# Vérifie que le monorepo Nexteneo est disponible et à jour avec origin/main.
# Usage : check_repo.sh [chemin]   (par défaut : le dossier courant)
# Sortie 0 = OK. Sinon, affiche ce qui bloque et ce que l'utilisateur doit faire.
set -u

dir="${1:-.}"

if ! git -C "$dir" rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "BLOQUANT : $dir n'est pas un dépôt git."
  echo "Ouvre la session dans le monorepo (github.com/nexteneo/monorepo) ou donne son chemin."
  exit 1
fi

root=$(git -C "$dir" rev-parse --show-toplevel)
remote=$(git -C "$root" remote get-url origin 2>/dev/null || true)
case "$remote" in
  *nexteneo/monorepo*) ;;
  *)
    echo "BLOQUANT : $root n'est pas le monorepo Nexteneo (origin = ${remote:-aucun})."
    exit 1
    ;;
esac

if ! git -C "$root" fetch --quiet origin main 2>/dev/null; then
  echo "BLOQUANT : impossible de joindre origin pour vérifier que le code est à jour."
  exit 1
fi

branch=$(git -C "$root" branch --show-current)
behind=$(git -C "$root" rev-list --count HEAD..origin/main)
dirty=$(git -C "$root" status --porcelain | head -1)

if [ "$branch" != "main" ]; then
  echo "BLOQUANT : le monorepo est sur la branche '$branch', pas sur main."
  echo "À faire : git -C $root switch main && git -C $root pull"
  exit 1
fi

if [ "$behind" -gt 0 ]; then
  echo "BLOQUANT : main a $behind commit(s) de retard sur origin/main."
  echo "À faire : git -C $root pull"
  exit 1
fi

echo "OK : $root, main à jour ($(git -C "$root" log -1 --format='%h du %cd' --date=short))."
if [ -n "$dirty" ]; then
  echo "Note : modifications locales non commitées dans le monorepo."
fi

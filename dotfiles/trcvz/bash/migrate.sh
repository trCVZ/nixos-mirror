#!/usr/bin/env bash
# xdg-migrate.sh — migration ponctuelle des anciens dotfiles vers les
# emplacements XDG définis dans xdg-apps.sh.
#
# Usage :
#   ./xdg-migrate.sh                              # dry-run (rien n'est modifié)
#   ./xdg-migrate.sh --apply                       # applique les déplacements sûrs
#   ./xdg-migrate.sh --apply --include-docker      # + ~/.docker (Docker doit être arrêté)
#   ./xdg-migrate.sh --apply --include-npm         # + réinitialise le cache ~/.npm
#
# À exécuter UNE FOIS, après avoir sourcé xdg-apps.sh dans le shell courant
# (pour que $XDG_* soient définies), et avec les logiciels concernés fermés.

set -euo pipefail

APPLY=0
INCLUDE_DOCKER=0
INCLUDE_NPM=0
for arg in "$@"; do
    case "$arg" in
        --apply) APPLY=1 ;;
        --include-docker) INCLUDE_DOCKER=1 ;;
        --include-npm) INCLUDE_NPM=1 ;;
        *) echo "Option inconnue : $arg" >&2; exit 1 ;;
    esac
done

: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"

move() {
    local src="$1" dst="$2" label="$3"
    [[ -e "$src" ]] || return 0
    if [[ -e "$dst" ]]; then
        echo "IGNORÉ   $label : la cible existe déjà ($dst)"
        return 0
    fi
    if [[ "$APPLY" -eq 1 ]]; then
        mkdir -p "$(dirname "$dst")"
        mv -v "$src" "$dst"
        echo "DÉPLACÉ  $label -> $dst"
    else
        echo "SIMULÉ   $label : $src -> $dst"
    fi
}

echo "== Déplacements sûrs =="
move "$HOME/.cargo"              "$XDG_DATA_HOME/cargo"                     "Cargo (Rust)"
move "$HOME/.rustup"             "$XDG_DATA_HOME/rustup"                    "rustup"
move "$HOME/.copilot"            "$XDG_CONFIG_HOME/copilot"                 "GitHub Copilot CLI"
move "$HOME/.java"               "$XDG_CONFIG_HOME/java"                    "Préférences Java"
move "$HOME/.m2/repository"      "$XDG_DATA_HOME/maven/repository"          "Dépôt local Maven"
move "$HOME/.m2/settings.xml"    "$XDG_CONFIG_HOME/maven/settings.xml"      "Config Maven (settings.xml)"
move "$HOME/.jupyter"            "$XDG_CONFIG_HOME/jupyter"                 "Jupyter"
move "$HOME/.ipython"            "$XDG_CONFIG_HOME/ipython"                 "IPython"
move "$HOME/.node_repl_history"  "$XDG_DATA_HOME/node_repl_history"         "Historique Node REPL"
move "$HOME/.python_history"     "$XDG_STATE_HOME/python_history"           "Historique Python REPL"
move "$HOME/.rediscli_history"   "$XDG_DATA_HOME/redis/rediscli_history"    "Historique redis-cli"
move "$HOME/.texlive2024/texmf-var"    "$XDG_CACHE_HOME/texlive/texmf-var"      "TeX Live (texmf-var)"
move "$HOME/.texlive2024/texmf-config" "$XDG_CONFIG_HOME/texlive/texmf-config"  "TeX Live (texmf-config)"
move "$HOME/.compose-cache"      "$XDG_CACHE_HOME/X11/xcompose"             "Cache X11 Compose"

echo
echo "== Optionnel (nécessite d'arrêter le logiciel avant) =="
if [[ "$INCLUDE_DOCKER" -eq 1 ]]; then
    move "$HOME/.docker" "$XDG_CONFIG_HOME/docker" "Config Docker CLI"
else
    echo "IGNORÉ   Docker (~/.docker) : relancez avec --include-docker après avoir arrêté Docker"
fi

if [[ "$INCLUDE_NPM" -eq 1 && "$APPLY" -eq 1 ]]; then
    mkdir -p "$XDG_CONFIG_HOME/npm"
    cat > "$XDG_CONFIG_HOME/npm/npmrc" <<-EOF
	prefix=${XDG_DATA_HOME}/npm
	cache=${XDG_CACHE_HOME}/npm
	init-module=${XDG_CONFIG_HOME}/npm/config/npm-init.js
	logs-dir=${XDG_STATE_HOME}/npm/logs
	EOF
    echo "ÉCRIT    $XDG_CONFIG_HOME/npm/npmrc"
    if [[ -d "$HOME/.npm" ]]; then
        rm -rf "$HOME/.npm"
        echo "SUPPRIMÉ ~/.npm (cache jetable, sera régénéré dans \$XDG_CACHE_HOME/npm)"
    fi
else
    echo "IGNORÉ   config npm : relancez avec --apply --include-npm pour écrire le npmrc XDG et vider l'ancien cache ~/.npm"
fi

echo
echo "== Laissés tels quels (hardcodé en amont, risqué, ou non pertinent) =="
cat <<'EOF'
  ~/.mozilla, ~/.librewolf     Profils de navigateur actifs : migration manuelle
                               requise (fermer le navigateur, déplacer le profil,
                               PUIS supprimer/renommer l'ancien dossier, sinon
                               l'appli continuera à préférer le chemin legacy).
  ~/.steam*, ~/.ssh            Attendus à un chemin fixe par de nombreux outils ;
                               non corrigé en amont, à ne pas toucher.
  ~/.var (Flatpak)             Les applis sandboxées gèrent leur propre layout ;
                               non corrigé en amont.
  ~/.dotnet, ~/.dbshell,
  ~/.mongorc.js                Aucune relocalisation supportée en amont.
  ~/.vscode, ~/.vscode-oss,
  ~/.vscode-R, ~/.vscode-shared  Support partiel seulement (--extensions-dir ou
                               VSCODE_PORTABLE, non documenté officiellement) ;
                               à faire à la main si voulu.
  ~/.pulse-cookie               Vérifiez si $XDG_CONFIG_HOME/pulse/cookie existe
                               déjà : si oui, ce fichier est un résidu supprimable.
  ~/.winboat                    Vérifiez si $XDG_DATA_HOME/winboat-app existe déjà
                               (versions récentes) : si oui, résidu supprimable.
  ~/.vim, ~/.viminfo             Si vous n'utilisez plus que nvim (EDITOR=nvim),
                               ce sont des résidus de l'ancien Vim ; sinon voir
                               :h xdg-base-dir dans Vim pour la migration.
  ~/.swp                        Fichier isolé à la racine du home, probablement
                               un swap Vim orphelin. Inspectez avec
                               'vim -r ~/.swp' avant de le supprimer.
  ~/.nix-profile, ~/.nix-defexpr  Relocalisables via l'option Nix
                               use-xdg-base-directories = true (voir la réponse
                               ci-dessus) — changement système, pas un simple mv.
EOF

echo
if [[ "$APPLY" -eq 0 ]]; then
    echo "Dry-run uniquement — relancez avec --apply pour exécuter les déplacements."
fi

#!/bin/bash
# Télécharge le Système de design de l'État (DSFR) depuis le paquet npm
# officiel « @gouvfr/dsfr » et place dans static/dsfr/ les fichiers dont ce
# thème a besoin. Rien du DSFR n'est stocké dans ce dépôt : chaque
# installation le télécharge elle-même et reste soumise à ses conditions
# d'utilisation (voir NOTICE).
#
# Il faut : bash, curl, tar, sha512sum (paquets Debian de base).
# Le paquet téléchargé est vérifié avec l'empreinte SHA-512 ci-dessous (celle
# du registre npm) : un fichier modifié est refusé.
set -euo pipefail

VERSION=1.15.3
SHA512=47d0002d97352df663b72b5664c39a50838759392594167fb1996c2fc4e9299560177a94297b7fb8d621f8bd43d45878a7dd99a96c5bb4d71e6ec8a00597b9a5
URL="https://registry.npmjs.org/@gouvfr/dsfr/-/dsfr-$VERSION.tgz"
FONTS="Marianne-Light Marianne-Regular Marianne-Medium Marianne-Bold"

cd "$(dirname "$0")"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Téléchargement du DSFR $VERSION..."
curl -fsSL "$URL" -o "$tmp/dsfr.tgz"
got=$(sha512sum "$tmp/dsfr.tgz" | cut -d' ' -f1)
if [ "$got" != "$SHA512" ]; then
  echo "ERREUR : empreinte différente, fichier refusé." >&2
  echo "  attendue : $SHA512" >&2
  echo "  reçue    : $got" >&2
  exit 1
fi

files="package/dist/dsfr.min.css package/LICENSE.md"
for f in $FONTS; do files="$files package/dist/fonts/$f.woff2"; done
# shellcheck disable=SC2086
tar -xzf "$tmp/dsfr.tgz" -C "$tmp" $files

rm -rf static/dsfr
mkdir -p static/dsfr/fonts
cp "$tmp/package/dist/dsfr.min.css" "$tmp/package/LICENSE.md" static/dsfr/
for f in $FONTS; do cp "$tmp/package/dist/fonts/$f.woff2" static/dsfr/fonts/; done
echo "DSFR $VERSION installé dans static/dsfr/ (vérifié)."

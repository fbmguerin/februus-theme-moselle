# Thème « Préfet de la Moselle » pour Februus

Thème d'apparence (système de design de l'État, DSFR) pour les écrans des
stations [Februus](https://github.com/fbmguerin/februus) de la préfecture de
la Moselle : en-tête avec le bloc-marque, police Marianne, alertes, couleurs
du verdict (vert / orange / rouge = couleurs « succès / avertissement /
erreur » du DSFR) et texte agrandi pour la borne.

> Ce dépôt est en français : il s'adresse à la préfecture de la Moselle.
> **Lisez le fichier [NOTICE](NOTICE)** : le DSFR, la police Marianne et le
> bloc-marque ne sont **pas** sous licence MIT, ne sont **pas** dans ce dépôt,
> et ne peuvent être utilisés que par les services de l'État.

## Contenu

| Fichier | Rôle |
|---|---|
| `templates/base.html` | en-tête DSFR avec le bloc-marque, pied de page ; garde la structure qu'attend Februus (`<body data-key>`, un seul `<main>`, le son, `live.js`) |
| `templates/_notice.html` | messages « deux clés » et « appareil bloqué » en alertes DSFR |
| `static/theme.css` | taille du texte pour la borne, couleurs du verdict |
| `fetch-dsfr.sh` | télécharge le DSFR 1.15.3 (paquet npm officiel, empreinte SHA-512 vérifiée) dans `static/dsfr/` |

## Installer sur une station

Sur la station, avec Februus déjà installé (voir son `docs/INSTALL.fr.md`),
en `root` :

```
apt-get install -y git curl
git clone https://github.com/fbmguerin/februus-theme-moselle.git /usr/local/src/februus-theme-moselle
cd /usr/local/src/februus-theme-moselle
./fetch-dsfr.sh
cd /usr/local/src/februus
./deploy/install.sh --theme /usr/local/src/februus-theme-moselle
```

`fetch-dsfr.sh` doit être lancé **avant** : sans lui, les écrans s'affichent
sans le style du DSFR. L'installation copie seulement `templates/` et
`static/` dans `/etc/februus/theme` (propriété de `root`, en lecture seule
pour le service) et redémarre le service.

Retour à l'écran neutre : `rm -r /etc/februus/theme && systemctl restart februus`.

## Mettre à jour le DSFR

1. Choisir la nouvelle version sur <https://www.npmjs.com/package/@gouvfr/dsfr>.
2. Dans `fetch-dsfr.sh`, changer `VERSION` et `SHA512` (l'empreinte du paquet :
   `npm view @gouvfr/dsfr@<version> dist.integrity`, à convertir en
   hexadécimal, ou celle de `sha512sum` du fichier téléchargé après l'avoir
   comparée à celle du registre).
3. Relancer `./fetch-dsfr.sh`, regarder les écrans (aperçu :
   `februus web -c config/februus.dev.toml`, adresse `/preview/<écran>`),
   puis réinstaller.

## Notes

- Les textes des écrans (en français simple) viennent de Februus, pas de ce
  thème.
- Le DSFR interdit de modifier ses fondamentaux : ici seuls la taille du texte
  et la mise en page plein écran (borne) sont adaptées. À valider avec le
  service de communication de la préfecture.
- Licence : [MIT](LICENSE) pour les fichiers de ce dépôt (voir [NOTICE](NOTICE)).

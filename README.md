# ath9k-htc-lab

Pilote `ath9k` de Linux 6.8 (clé USB AR9271, `ath9k_htc`), compilé hors arbre, avec un ajout pour le
labo radio : la lecture et l'écriture directes des registres de la puce.

Il sert à la recherche d'I/Q sur l'AR9271, avec le firmware modifié
([open-ath9k-htc-firmware](https://github.com/Alixpat/open-ath9k-htc-firmware), branche `iq`) et l'outil
`ar9271.py` de [my-rf-lab](https://github.com/Alixpat/my-rf-lab).

## Ce qui est ajouté

Deux fichiers dans sysfs, réservés à root :

```
/sys/class/ieee80211/phyN/regidx    adresse du registre
/sys/class/ieee80211/phyN/regval    valeur (lecture ou écriture)
```

```bash
echo 0x9800 | sudo tee /sys/class/ieee80211/phy0/regidx
sudo cat /sys/class/ieee80211/phy0/regval
```

Pourquoi sysfs et non debugfs : avec Secure Boot, le noyau interdit d'ouvrir en écriture les fichiers
debugfs, même en root.

## Installation (DKMS)

```bash
sudo apt install dkms linux-headers-$(uname -r)
sudo make dkms_install
sudo modprobe -r ath9k_htc ath9k_common ath9k_hw && sudo modprobe ath9k_htc
```

DKMS recompile et signe les modules à chaque mise à jour du noyau (clé MOK de la machine si Secure Boot
est actif). Retrait : `sudo make dkms_remove`.

## Limites

- Les sources viennent de Linux **v6.8** : le paquet ne se compile que pour un noyau 6.8. Pour un autre
  noyau, reprendre `drivers/net/wireless/ath/ath9k` de la version voulue et y reporter le dernier commit.
- Les quatre modules `ath9k_hw`, `ath9k_common`, `ath9k_htc` et `ath9k` remplacent ceux du noyau.
- Écrire dans les registres peut bloquer la clé. Si elle ne répond plus, la débrancher et la rebrancher ;
  ne pas tenter de la réinitialiser par logiciel.

## Licence

Celle du pilote d'origine (ISC, voir l'en-tête de chaque fichier).

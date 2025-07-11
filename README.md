# NMapReportGen

NMapReportGen est un script Bash qui automatise le scan de ports avec Nmap et génère un rapport HTML simple des résultats.

## Fonctionnalités

- Interface CLI interactive pour saisir la cible (IP ou domaine)
- Nettoie et normalise la saisie de la cible
- Lance un scan TCP basique avec Nmap
- Génère un rapport HTML léger listant les ports ouverts et services détectés
- Stocke les rapports dans un dossier `./reports` horodaté

## Utilisation

1. **Installer Nmap**  
    Assurez-vous que [Nmap](https://nmap.org/) est installé sur votre système.

2. **Lancer le script en root**  
    ```bash
    sudo ./nmapreportgen.sh
    ```

3. **Suivre les instructions**  
    - Entrez l’IP ou le domaine cible lorsque demandé.
    - Le script scannera et générera un rapport HTML.

4. **Retrouver votre rapport**  
    - Les rapports sont enregistrés dans le dossier `reports` avec un nom de fichier horodaté.

## Exemple

```bash
sudo ./nmapreportgen.sh
# Suivez les instructions...
# Sortie : [OK] Rapport généré ici : ./reports/scan_example.com_2024-06-01_12-00-00.html
```

## Avertissement

> **ATTENTION !**  
> Le scan avec Nmap peut être illégal sur des réseaux que vous ne possédez pas ou sans autorisation.  
> Utilisez ce script de façon responsable.

## Licence

Licence MIT

---

*Script par melvi*
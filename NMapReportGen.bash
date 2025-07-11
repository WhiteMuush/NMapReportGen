#!/bin/bash
clear   

DARK_ORANGE='\033[38;5;208m'
RESET='\033[0m'
ROUGE='\033[0;31m'
GREEN='\033[0;32m'

echo -e "${DARK_ORANGE}"
echo " ▐ ▄ • ▌ ▄ ·.  ▄▄▄·  ▄▄▄·▄▄▄  ▄▄▄ . ▄▄▄·      ▄▄▄  ▄▄▄▄▄ ▄▄ • ▄▄▄ . ▐ ▄ "
echo "•█▌▐█·██ ▐███▪▐█ ▀█ ▐█ ▄█▀▄ █·▀▄.▀·▐█ ▄█▪     ▀▄ █·•██  ▐█ ▀ ▪▀▄.▀·•█▌▐█"
echo "▐█▐▐▌▐█ ▌▐▌▐█·▄█▀▀█  ██▀·▐▀▀▄ ▐▀▀▪▄ ██▀· ▄█▀▄ ▐▀▀▄  ▐█.▪▄█ ▀█▄▐▀▀▪▄▐█▐▐▌"
echo "██▐█▌██ ██▌▐█▌▐█ ▪▐▌▐█▪·•▐█•█▌▐█▄▄▌▐█▪·•▐█▌.▐▌▐█•█▌ ▐█▌·▐█▄▪▐█▐█▄▄▌██▐█▌"
echo "▀▀ █▪▀▀  █▪▀▀▀ ▀  ▀ .▀   .▀  ▀ ▀▀▀ .▀    ▀█▄▀▪.▀  ▀ ▀▀▀ ·▀▀▀▀  ▀▀▀ ▀▀ █▪"
echo ""
echo ""
echo -e "${RESET}${ROUGE}ATTENTION ! Le nmap peut être illégal ne le faite pas sur un réseau qui ne vous appartient pas !${RESET}" 
echo -e "${DARK_ORANGE}"
echo " Script de scan de ports avec Nmap + génération de rapport HTML"
echo " Il est recommandé de l'exécuter avec les droits root."
echo " Il faut avoir installé Nmap !"
echo -e "${RESET}" 
read -p "Appuyez sur Entrée pour executer le script ..."
sleep 1
echo ""
echo -e "${DARK_ORANGE}Lancement du script...${RESET}"

read -p "Adresse IP ou domaine : " TARGET

TARGET="${TARGET,,}"  # Convertir en minuscules
TARGET="${TARGET#http://}"  # Supprimer le préfixe http:// s'il existe
TARGET="${TARGET#https://}"  # Supprimer le préfixe https:// s'il existe
TARGET="${TARGET%%/*}"  # Supprimer tout ce qui suit le premier slash

OUTPUT_DIR="./reports"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
HTML_FILE="$OUTPUT_DIR/scan_$TARGET_$DATE.html"

# Vérification des prérequis
function check_requirements {
    if ! command -v nmap &>/dev/null; then
        echo "[ERREUR] nmap n'est pas installé."
        exit 1
    fi

    if [ -z "$TARGET" ]; then
        echo "Utilisation : $0 <IP ou domaine>"
        exit 1
    fi

    mkdir -p "$OUTPUT_DIR"
}

function scan_ports {
    echo "[INFO] Scan léger de $TARGET en cours (TCP connect, pas de version)..."
    nmap -T2 "$TARGET" -oG - | tee "scan_raw.txt"
}

function generate_html {
    echo "[INFO] Génération du rapport HTML..."

    {
        echo "<!DOCTYPE html><html lang='fr'><head><meta charset='UTF-8'><title>Scan - $TARGET</title>"
        echo "<style>body{font-family:sans-serif;}table{border-collapse:collapse;}td,th{border:1px solid #ccc;padding:5px;}</style></head><body>"
        echo "<h1>Rapport de scan allégé - $TARGET</h1><p>Date : $DATE</p>"
        echo "<table><tr><th>Port</th><th>État</th><th>Service (si détecté)</th></tr>"

        grep -E "^Host:|Ports:" scan_raw.txt | grep "/open" | while read -r line; do
            echo "$line" | grep -oP '\d+/open.*?(?=,|\s)' | while read -r port; do
                port_num=$(echo "$port" | cut -d '/' -f 1)
                state="open"
                service=$(echo "$port" | cut -d '/' -f 2 | awk '{print $1}')
                echo "<tr><td>$port_num</td><td>$state</td><td>$service</td></tr>"
            done
        done

        echo "</table></body></html>"
    } > "$HTML_FILE"

    rm -f scan_raw.txt
    echo "[OK] Rapport généré ici : $HTML_FILE"
}

check_requirements
scan_ports
generate_html
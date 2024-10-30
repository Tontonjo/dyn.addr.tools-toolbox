#!/bin/bash

# Tonton Jo - 2024
# Join me on Youtube: https://www.youtube.com/c/tontonjo

# apt-get install dnsutils curl dig

# Settings:
version=1.0

# Main script
usage() {
	echo "
    Usage: $0 -s SECRET [-i IP] [-r] [-n] [-d] [-4 | -6]
    Options
      -s SECRET    : Mot de passe secret utilisé pour l'authentification
      -i IP        : Adresse IP à mettre à jour (ou 'self' - par défaut pour votre IP publique automatique)
	  -r           : Lire la valeure actuelle
	  -n IP        : Serveur DNS à utiliser pour les contrôles
	  -d           : Supprimer tous les enregistrements DNS pour le domaine associé
      -4           : Forcer l'utilisation d'IPv4
      -6           : Forcer l'utilisation d'IPv6
      -h           : Afficher cette aide
    
     Exemples d'utilisation:
      Mettre à jour l'IP avec votre adresse publique IPv4 :
          $0 -s '1SuperSecretPassphrase' -i self -4
		  
	  Interroger le serveur DNS recommandé sur les entrées actuelles :
          $0 -s '1SuperSecretPassphrase' -r
		  
      Interroger un serveur DNS spécifique sur les entrées actuelles :
          $0 -s '1SuperSecretPassphrase' -n 1.1.1.1 -r

      Supprimer l'enregistrement DNS :
          $0 -s '1SuperSecretPassphrase' -d
		  
"
    exit 1
}

# Variables pour stocker les options
secret=""
ip=""
delete=false
read_value=false
get_domain=false
use_ipv4=false
use_ipv6=false
nameserver=116.203.95.251 #116.203.95.251 defaults to the nameserver responsible for addr.tools for accurate and faster results

# Parse les options
while getopts ":s:n:i:dg46r" opt; do
    case ${opt} in
        s ) secret="$OPTARG" ;;
        i ) ip="$OPTARG" ;;
		n ) nameserver="$OPTARG" ;;
        d ) delete=true ;;
		r ) read_value=true ;;
        4 ) use_ipv4=true ;;
        6 ) use_ipv6=true ;;
        h ) usage ;;
        \? ) echo "Option invalide : -$OPTARG" >&2; usage ;;
        : ) echo "L'option -$OPTARG nécessite un argument." >&2; usage ;;
    esac
done

# Vérifie que le secret est fourni
if [[ -z "$secret" ]]; then
    echo "Erreur : le paramètre -s SECRET est requis."
    usage
fi

# Calcule le sous-domaine en SHA-224
sha224=$(echo -n "$secret" | shasum -a 224 | awk '{print $1}')


echo "
===================== dyn.addr.tools toolbox ===================
==================== Tonton Jo - 2024 - V $version ==================
nom du dynDNS : $sha224.dyn.addr.tools
"



if $get_domain; then
    echo "Nom du dynDNS : $sha224.dyn.addr.tools"
    exit 0
fi


    if $read_value; then
		digresultv4=$(dig @$nameserver $sha224.dyn.addr.tools A +short)
		digresultv6=$(dig @$nameserver $sha224.dyn.addr.tools AAAA +short)
		echo "
		Nameserver: $nameserver 
		IPv4: 		$digresultv4
		IPv6: 		$digresultv6
		"
	
		exit 0
    fi

# Détermine l'URL à utiliser en fonction des options IPv4 ou IPv6
base_url="https://dyn.addr.tools"
if $use_ipv4; then
    base_url="https://ipv4.dyn.addr.tools"
elif $use_ipv6; then
    base_url="https://ipv6.dyn.addr.tools"
fi

# Mettre à jour l'adresse IP
if [[ -n "$ip" ]]; then
	curl -s -d "secret=$secret" -d "ip=$ip" $base_url
    response=$(curl -s -d "secret=$secret" -d "ip=$ip" $base_url)
    if [[ "$response" == "OK" ]]; then
        echo "Mise à jour de l'adresse IP $ip réussie."
    else
        echo "Erreur lors de la mise à jour de l'adresse IP : $response"
		exit 1
    fi
    exit 0
fi

# Supprimer les enregistrements DNS
if $delete; then
    curl -s -X DELETE -d "secret=$secret" $base_url
    if [[ -z "$response" ]]; then
        echo "Suppression réussie des enregistrements DNS."
    else
        echo "Erreur lors de la suppression des enregistrements DNS : $response"
		exit 1
    fi
    exit 0
fi

# Si aucune option n'a été spécifiée
echo "Erreur : une option -r, -i, -d, est requise."
usage
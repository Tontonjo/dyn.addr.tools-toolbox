# dyn.addr.tools-toolbox

## Tonton Jo  
### Rejoint la trame - Join the community & Support my work   
[Click Here!](https://linktr.ee/tontonjo)  

## Informations:

This little tool aims to make the use of dyn.addr.tools easier.
I'm not affiliated or related to them in any way

### Demonstration:  
You can watch a demonstration of the tool [in this video](https://youtu.be/zVV0a79rGz0) 

### Prerequisits:
- Terminal with bash
- Dependencies installed: shasum, dig, curl, dnsutils

## Features are:
- Create a dyndns using dyn.addr.tools services
  - Use your public IP or a defined IP
  - Support IPv4 or / and IPv6
- Query the DNS entry using Dig
  - Specify an alternate DNS server to query
- Delete all DNS entries

## Usage and arguments:
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


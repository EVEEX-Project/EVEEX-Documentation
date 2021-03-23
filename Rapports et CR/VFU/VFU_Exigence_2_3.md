# Validation Fonctionnelle

## Type de test 

Fonctionnel 

## fonctionnalité testée

langage : C / PYTHON / GOLANG

matériel : PC 

étape de code testé : L'algorithme doit pouvoir formater les données compressées afin qu'elles puissent être envoyées en réseau. L'algorithme doit pouvoir recevoir les données par le réseau et les comprendre.

## Manipulation Effectuée

#### Python 

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Python_logo_and_wordmark.svg/1280px-Python_logo_and_wordmark.svg.png" alt="Logo python" style="zoom:30%;" />

Dans le main, Le bitstream est créé et est envoyé par paquet via un socket. Il est ensuite réceptionné et chaque paquet est décodé pour reconstruire l'image.

## Résultats 

**Entrée:**

![](/home/hugoq/EVEEX/EVEEX-Documentation/Rapports et CR/VFU/assets/Ferrari.jpg)



**Envoi du bitstream par réseau:**

```
[12:06:29][DEB] Serveur> Serveur prêt, en attente de requêtes ...

[12:06:29][DEB] Client> Connexion établie avec le serveur.
[12:06:29][DEB] Serveur> Client connecté, adresse IP 127.0.0.1, port 39470.


[12:06:35][DEB] Les messages entre le client et le serveur n'ont ici pas été affichés pour plus de lisibilité.


[12:06:35][DEB] Thread d'écriture dans le buffer du bitstream supprimé.

[12:06:35][DEB] Serveur> Client déconnecté.
[12:06:35][DEB] Thread d'écoute du serveur supprimé.
[12:06:35][DEB] Serveur supprimé.

[12:06:36][DEB] Transmission réseau réussie : TRUE
```

**Sortie après décodage du bitstream:**

![](assets/ferraritest.jpg)



L'image est donc bien décodée. 
# Validation Fonctionnelle

## Type de test 

Fonctionnel 

## fonctionnalité testée

langage : C / PYTHON / GOLANG

matériel : PC 

étape de code testé : L'algorithme doit pouvoir formater les données compresser afin qu'elle puissent être envoyé en réseau. L'algorithme doit pouvoir recevoir les données par le réseau et les comprendre.

## Manipulation Effectuée

#### Python 

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Python_logo_and_wordmark.svg/1280px-Python_logo_and_wordmark.svg.png" alt="Logo python" style="zoom:30%;" />

Dans le main, Le bitstream est créé et est envoyé par paquet via un socket. Il est ensuite réceptionné et chaque paquet est décodé pour reconstruire l'image.

## Résultats 

**Entrée:**

![](/home/hugoq/EVEEX/EVEEX-Documentation/Rapports et CR/VFU/assets/Ferrari.jpg)

**Sortie après décodage du bitstream:**

![](assets/ferraritest.jpg)



L'image est donc bien décodée. 
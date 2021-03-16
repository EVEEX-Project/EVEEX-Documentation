# Validation Fonctionnelle

## Type de test 

Fonctionnel 

## fonctionnalité testée

langage : C / PYTHON / GOLANG

matériel : PC 

étape de code testé : compression et décompression d'un format image vers un bitstream de taille inférieure, d'une manière différente au MJPEG 

## manip 

Python : test de la fonction `encode` grâce au CLI qui ressort un fichier texte contenant le bitstream. Ce bitstream est ensuite lu par le CLI grâce à la fonction `decode` et l'image de base est reconstituée.

## Résultats 

taille de macro-bloc variable => changement manuelle dans le code possible, mais pas d'automatique. 

**Entrée:**

![](assets/Ferrari.jpg)

**Sortie après décodage du bitstream:**

![](assets/ferraritest.jpg)
# Validation Fonctionnelle

## Type de test 

Fonctionnel 

## fonctionnalité testée

langage : C / PYTHON / GOLANG

matériel : PC 

étape de code testé : compression et décompression d'un format image vers un bitstream de taille inférieure, d'une manière différente au MJPEG 

## Manipulation Effectuée

#### Python 

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Python_logo_and_wordmark.svg/1280px-Python_logo_and_wordmark.svg.png" alt="Logo python" style="zoom:30%;" /> 

Test de la fonction `encode` grâce au CLI qui ressort un fichier texte contenant le bitstream. Ce bitstream est ensuite lu par le CLI grâce à la fonction `decode` et l'image de base est reconstituée.

## Résultats 



**Entrée:**

![](assets/Ferrari.jpg)



Création du bitstream.

```python
[DEB] Bitstream total : 19.31% --> taux de compression "5.18 : 1"
```

Le Bitstream est bien de taille inférieure à l'image originale. 

**Sortie après décodage du bitstream:**

![](assets/ferraritest.jpg)

La décompression est donc effectuée. Les pertes sont invisibles à l'oeil. 
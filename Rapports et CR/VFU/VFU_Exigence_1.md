# Validation Fonctionnelle N°1

## Type de test 

Exigence non fonctionnelle

## Fonctionnalité Testée

langage : **C / PYTHON / GOLANG**

matériel : **PC / RASPBERRYPI / MAIXDUINO / FPGA** 

étape de code testé : intégralité du code 

## Manipulation

Revue des bibliothèques utilisées, en indiquant pour chacune d'elle où trouver la source, et ce dans chaque langage 

## Résultats 

Python : 

* Colorama : sert juste à colorier la console sur Linux ET Windows. Code source ouvert et disponible https://github.com/tartley/colorama
* Numpy : Bibliothèque de fonctions mathématiques (sin, cos, produit matriciel) et de type (Numpy array). Code source ouvert et disponible https://github.com/numpy/numpy
* Matplotlib : Bibliothèque d'affichage. Code source ouvert et disponible https://github.com/matplotlib/matplotlib
* sockets : fonctions de connexion réseau TCP. Code source ouvert et disponible https://github.com/python/cpython/blob/master/Lib/socket.py

C : 

* tout les includes sont issues directement du système Linux (sys, os, time, etc...) et sont donc open-source et disponibles via un `git clone` https://www.gnu.org/software/libc/libc.html

golang : 

* `requirements` externes : 

  ```go
  github.com/gen2brain/shm v0.0.0-20200228170931-49f9650110c5 // indirect
  github.com/gorilla/mux v1.8.0 // indirect
  github.com/kbinani/screenshot v0.0.0-20191211154542-3a185f1ce18f // indirect
  github.com/lxn/win v0.0.0-20210218163916-a377121e959e // indirect
  github.com/nfnt/resize v0.0.0-20180221191011-83c6a9932646 // indirect
  github.com/pion/webrtc/v2 v2.2.26 // indirect
  github.com/poi5305/go-yuv2webRTC v2.1.18+incompatible
  github.com/rs/zerolog v1.20.0
  github.com/spf13/cobra v1.1.1
  ```

  La liste des paquets nécessaires et externes au golang est trouvable dans `go.mod` à la racine du code. 

  Tout les paquets extérieurs sont bien disponibles sur github et ouvert. 

**Validation de l'exigence non fonctionnelle => 100 %** 

#  


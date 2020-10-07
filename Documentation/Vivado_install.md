# Installer Vivado : le guide détaillé 

## Linux (Debian 20.04)

Téléchargement : 

https://www.xilinx.com/support/download.html prendre l'archive complète (ne marche pas avec l’installateur web)

Dependencies: 

```
sudo apt-get install libncurses5
```

tuto: 

```
Steps:

1) Download Xilinx_Unified_2020.1_0602_1208.tar.gz from the Xilinx Download page and extract the content

2) generate the Authentication Token using your Xilinx Account

./xsetup -b AuthTokenGen

Running in batch mode...
Copyright (c) 1986-2020 Xilinx, Inc.  All rights reserved.

INFO : Log file location - /home/user_name/.Xilinx/xinstall/xinstall_1592209834385.log
INFO : Log file location - /home/user_name/.Xilinx/xinstall/xinstall_1592209834385.log
INFO : Internet connection validated, can connect to internet.
INFO : In order to generate the authentication token please provide your Xilinx account User Email Address and password.
User E-mail address: 
Password:

INFO : Generating authentication token...
INFO : Saved authentication token file successfully, valid until 06/22/2020 10:32 AM

3) generate the installation config

./xsetup -b ConfigGen

Running in batch mode...
Copyright (c) 1986-2020 Xilinx, Inc.  All rights reserved.

INFO : Log file location - /home/user_name/.Xilinx/xinstall/xinstall_1592209963861.log
Select a Product from the list:
1. Vitis
2. Vivado
3. On-Premises Install for Cloud Deployments
4. BootGen
5. Lab Edition
6. Hardware Server
7. Documentation Navigator (Standalone)

Please choose from options above:  e.g. 2 


Select an Edition from the list:
1. Vivado HL WebPACK
2. Vivado HL Design Edition
3. Vivado HL System Edition

Please choose: e.g. 3

INFO : Config file available at /home/user_name/.Xilinx/install_config.txt. Please use -c <filename> to point to this install configuration.

4) The Installation (replace config path and maybe target directory)

sudo ./xsetup --batch Install --agree XilinxEULA,3rdPartyEULA,WebTalkTerms --location /opt/Xilinx/ --config "/home/user_name/.Xilinx/install_config.txt"

Running in batch mode...
Copyright (c) 1986-2020 Xilinx, Inc.  All rights reserved.

INFO : Log file location - /root/.Xilinx/xinstall/xinstall_1592210290697.log
INFO : Installing Edition: Vitis Unified Software Platform
INFO : Installation directory is /opt/Xilinx/

Installing files, 99% completed. (Done)                         
It took 12 minutes to install files.

INFO : Log file is copied to : /opt/Xilinx/.xinstall/Vitis_2020.1/xinstall.log
INFO : Installation completed successfully.For the platforms: please visit xilinx.com and review the "Getting Started Guide" UG1301

5) Launch Vivado

user_name@machine_name:/tmp$ source /opt/Xilinx/Vivado/2020.1/settings64.sh
user_name@machine_name:/tmp$ vivado

****** Vivado v2020.1 (64-bit)
  **** SW Build 2902540 on Wed May 27 19:54:35 MDT 2020
  **** IP Build 2902112 on Wed May 27 22:43:36 MDT 2020
    ** Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.

start_gui
```

Pour la gestion de la carte : 

installer les paquets ```runtime``` et ```utilities``` 



Ajout des fichiers boards : 

https://github.com/Digilent/vivado-boards

télécharger l'archive, décompresser et ajouter les fichier contenu dans  ``new/boards_parts/``dans le dossier ``data/boards/boards`` du repertoire d'installation de Vivado

ajout des fichiers XDC : 

https://github.com/Digilent/digilent-xdc

il vous faudra un fichier "xdc" représentant les entrées sorties de la carte. il faudra l'ajouter en temps que "constraint file"

Pour notre cas, on aura besoin du fichier Nexys4-master.xdc, que vous pouvez copier n'importe où (idéalement dans le dossier du projet). le fichier sera demandé lors de la création d'un projet 

ATTENTION : cocher "do not specify source at this time" dans les options pour un projet en RTL. 

## Windows

https://www.xilinx.com/support/download.html

A priori tout marche du premier coup 

Ajout des fichiers boards : 

https://github.com/Digilent/vivado-boards

télécharger l'archive, décompresser et ajouter les fichier contenu dans  ``new/boards_parts/``dans le dossier ``data/boards/boards`` du repertoire d'installation de Vivado

ajout des fichiers XDC : 

https://github.com/Digilent/digilent-xdc



il vous faudra un fichier "xdc" représentant les entrées sorties de la carte. il faudra l'ajouter en temps que "constraint file"

Pour notre cas, on aura besoin du fichier Nexys4-master.xdc, que vous pouvez copier n'importe où (idéalement dans le dossier du projet). le fichier sera demandé lors de la création d'un projet 

ATTENTION : cocher "do not specify source at this time" dans les options pour un projet en RTL. 


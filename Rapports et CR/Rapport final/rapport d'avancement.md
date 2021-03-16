---
title: "Rapport final : EVEEX"
subtitle: "Encodage Vidéo ENSTA Bretagne Expérimental"
author: [A. Froehlich, G. Leinen, J.N. Clink, H. Saad, H. Questroy]
date: "05-01-2021"
keywords: [encodage, python, C, FPGA, video, codec, x264]
lang: fr
book: false
titlepage: false
toc-own-page: true
header-left: "\\rightmark"
header-right: "\\thetitle"
#Config : https://github.com/Wandmalfarbe/pandoc-latex-template
---

# Informations

Membres du groupe : Guillaume Leinen, Jean-Noël Clink, Hussein Saad, Alexandre Froehlich, Hugo Questroy

Encadrants : Pascal Cotret, Jean-Christophe Le Lann, Joël Champeau

Code disponible sur GitHub ==> [https://github.com/EVEEX-Project](https://github.com/EVEEX-Project)

Eportfolio Mahara disponible => [https://mahara.ensta-bretagne.fr/view/groupviews.php?group=348](https://mahara.ensta-bretagne.fr/view/groupviews.php?group=348)

# Abstract



# Résumé

\pagebreak

# Remerciements

-   Nos encadrants **Pascal Cotret**, **Jean-Christophe Le Lann** et **Joël Champeau**, qui nous aident à définir les objectifs à atteindre, nous prêtent le matériel nécessaire en particulier les cartes FPGA, ainsi qu'a résoudre des problèmes théoriques.
-   **Enjoy Digital**, société créée par un Alumni Ensta-Bretagne, et son produit Litex qui nous sera très utile sur l'implémentation hardware.
-   Le site **FPGA4students** pour ses tutoriels VHDL/Verilog.
-   **Jean-Christophe Leinen** pour ses conseils sur les méthodes Agiles.

\pagebreak

# Introduction

Dans son rapport annuel sur l'usage d'internet, Cisco met en exergue l'importance du trafic vidéo dans l'internet mondial [1] : la part du streaming dans le débit mondial ne fait qu'augmenter, les définitions de lecture augmentent elles aussi, ainsi que la part de "live" très gourmands en bande passante. 

Dans cette perspective, il est clair que l'algorithme de compression utilisée pour compresser un flux vidéo brut à toute son importance, le moindre % de bande passante économisée permettant de libérer plusieurs TB/s de bande passante. Ces codecs sont relativement peu connu du grand public, en voici quelques uns: 

* MPEG-4 (H.264) : il s'agit d'un des codecs les plus connu, car il génère des fichiers d'extension .mp4 et est embarqué dans un grand nombre d'appareils. Il est important de savoir que, comme le H.265, ce codec est **protégé** par un brevet, et les services et constructeurs souhaitant utilisé cet algorithme ou un connecteur basé sur l'algorithme doivent reverser des royalties à MPEG-LA [2] (*La fabrication d'un connecteur display-port coutant 0.20$ de license au constructeur*), coalitions de plusieurs entreprises du numériques comme sony, panasonic ou encore l'université de Columbia. 
* VPx : appartenant à l'origine à One-technologie, l'entreprise fut racheté par Google à la suite. Les codecs VP (dernière version VP9) sont ouvert et sans royalties. Ce codec est plutôt performant en terme de compression mais son encodage est lent [3], avec sur un core i7 d'intel en 720p une vitesse de compression proche de 2 images/s, occasionnant des coûts non négligeable en puissance informatique pour les entreprises productrices de contenu (comme Netflix). 
* H.265 : l'un des codecs les plus récents, il permet une réduction significative de la bande passante nécessaire, notamment pour le streaming, mais est aussi lent à l'encodage, et demande des royalties. 

Vous l'aurez constaté, les codecs les plus actuels sont souvent détenus par des entreprises du secteur. Pour limiter les coûts annexes pour les entreprises, un consortium s'est créé en 2015, a but non lucratif, afin de développer un codec libre de droit aussi efficace que les autres : l'**Aliance for Open-Media** [4]. On compte la plupart des acteurs du secteur dans ce consortium, notamment l'arrivée des acteurs du streaming comme Hulu ou Netflix. Leur création, le codec AV1, basé sur VP9, est donc libre de droit, et est notamment très employé dans le streaming vidéo. Il a l'avantage de proposer une compression 30% plus forte que le H265 [5], mais occasionne par les différentes bibliothèques utilisées une utilisation des ressources informatiques (puissance CPU) bien plus importante, aussi bien du coté encodeur que décodeur. La transition vers l'AV1 sur les grandes plateformes vidéos (Netflix, Youtube) n'est pas encore réalisé mais bien en cours de planification. 

Ce besoin en ressources CPU devient donc critique et un point économiquement important pour les entreprises du secteur vidéo. A l'heure actuelle, l'architecture PC (jeu d'instruction x64, x86) reste la plus utilisé dans l'informatique moderne, mais cela pourrait changer d'ici quelques années. En effet, les architectures a but embarqué on fait de gros progrès ces dernières années, au point que même un géant du secteur comme Apple décide de basculer tout ces ordinateurs vers une architecture ARM. 

Ces architectures embarqués, plus récentes, possèdent en effet des caractéristiques de consommation et de performances qui les rendent très intéressantes pour le traitement vidéo. Voyons ensemble quelques architectures et technologies actuelles : 

### Architecture ARM

Ce jeu d'instruction est très utilisé dans les appareils mobiles comme les smartphones ou tablettes. Il a l'avantage de proposer un jeu d'instruction beaucoup plus simple, ce qui permet notamment des **performances** en matières de **consommation d’énergie** très intéressantes en mobilité. En revanche, **l'architecture est**, tout comme les jeux d'instructions pc plus anciens, **sous licence** également (x64 pour AMD, x86 pour Intel). Les *SOC* ARM **embarquent** tout les composants nécessaires au fonctionnement du système (CPU, GPU, DSP, gestions des I/O) sur une seule puce ce qui rend les systèmes compacts. Le jeu d'instructions réduit rend en revanche l**’inter compatibilité** entre x64/86 et architectures de type RISC (Reduced Instruction Set Computer) comme l'ARM ou le riscV. 

### Architecture RISCV

Le jeu d'instruction RISCV est très proche de l'ARM, qui est aussi un RISC. La différence profonde se situe dans l'adoption de la technologie ARM dans l'écrasante majorité des applications, ce qui implique une faible quantité de code existant pour RISCV. En Revanche, RISCV possède un avantage notable : elle est complètement Open-source et libre de droits. 

### Processeurs Field Programmable Gate Array (FPGA) 

L'architecture FPGA est complément différente des autres cités précédemment. Un processeur ARM ou x86 est gravé et inaltérable dans son fonctionnement, il n'est pas possible de modifier le "hardware" c'est à dire les branchements des registres au sein même de la puce. Avec les FPGA, on gagne cette possibilité et c'est tout l’intérêt. La quasi-totalité du processeur est ainsi "reprogrammable" au niveau matériel. Cela implique beaucoup de choses dont voici une partie : 

* Comme on peut reprogrammer les portes logiques qui le constitue, il est possible d'intégrer un **très fort parallélisme** au sein des calculs : les portes logiques peuvent être repartis en **autant d'unités de traitement qu'on le souhaite** pourvu qu'on a assez de silicium. Si un design consomme 500 portes et qu'on en disposent de 5000, on peut tout a fait séparer le calcul en 10 cœurs alors qu'un processeur conventionnel à 4 cœurs sera limité à 4 unités de traitement, et ce peut importe le niveau de charge de ces cœurs. 
* Un code implémenté sur FPGA est par définition **optimisé pour le matériel** puisque l'on définit les branchements processeurs en fonction du code exécuté. A contrario il y aura un processus de routage important dans une architecture "gravé dans le marbre". En fait, avec un FPGA, il est possible de développer des Application Specific Integrated Circuit (ASIC), massivement employés dans la réalisation de taches simples et répétitives comme le minage de cryptomonnaies. 
* En revanche, l'appréhension d'une tel technologie est loin d’être aisé, le **développement** avec des Hardware Description Langage (HDL) tel que le Verilog ou le VHDL est **loin d’être facile** et la formation est longue. 
* Aussi, la **synthèse FPGA** pour passer du code au branchement de portes logiques est **longue** et nécessite des ***Toolchains*** de développement **lourde** (Vivado de Xilinx pèse 50 go sur un disque dur)

Vous l'aurez compris, 

\pagebreak

# Présentation de la problématique 





## Réalisation 

## Difficultés rencontrées 



\pagebreak

# Annexes

\pagebreak

# Bibliographie

**[1]** https://www.cisco.com/c/en/us/solutions/collateral/executive-perspectives/annual-internet-report/white-paper-c11-741490.html

**[2]** mpeg-la royalties https://www.businesswire.com/news/home/20150305006071/en/MPEG-LA-Introduces-License-DisplayPort

**[3]** encodage lent VP9 https://groups.google.com/a/webmproject.org/g/codec-devel/c/P5je-wvcs60?pli=1 

**[4]** http://aomedia.org/about/

**[5]** https://www.lesnumeriques.com/tv-televiseur/av1-nouveau-standard-video-adopte-a-unanimite-n73213.html

**[6]** 2014. _Vivado Design Suite Tutorial : High-Level Synthesis_. [ebook] Available at: [https://www.xilinx.com/support/documentation/sw_manuals/xilinx2014_2/ug871-vivado-high-level-synthesis-tutorial.pdf](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2014_2/ug871-vivado-high-level-synthesis-tutorial.pdf) [Accessed 15 October 2020].

**[7]** LiteX-hub - Collaborative FPGA projects around LiteX. Available at: [https://github.com/litex-hub](https://github.com/litex-hub) [Accessed 1 December 2020].

**[8]** Zenhub.com - project Management in Github. Available at: [https://www.zenhub.com/](https://www.zenhub.com/) [Accessed 15 october 2020]

**[9]** Pilai, L., 2003. _Huffman Coding_. [pdf] Available at: [https://www.xilinx.com/support/documentation/application_notes/xapp616.pdf](https://www.xilinx.com/support/documentation/application_notes/xapp616.pdf) [Accessed 1 December 2020].

\pagebreak

# Glossaire

**Flux-Vidéo:** Processus d'envoi, réception et lecture en continu de la vidéo.

**Open-Source:** Tout logiciel dont les codes sont ouverts gratuitement pour l'utilisation ou la duplication, et qui permet de favoriser le libre échange des savoirs informatiques.

**RGB:** Rouge, Vert, Bleu. C'est un système de codage informatique des couleurs. Chaque pixel possède une valeur de rouge, une de vert et une de bleu.

**FPGA:** Une puce FPGA est un circuit imprimé reconfigurable fonctionnant à base de portes logiques.

**Macrobloc **(ou Macroblock) : Une partie de l'image de taille 16x16 pixels.

**Bitstream:** Flux de données en binaire.

**VHDL:** Langage de description de matériel destiné à représenter le comportement ainsi que l'architecture d'un système électronique numérique.

**IDE:** Environnement de Développement.

**Frames:** Images qui composent une vidéo. On parle de FPS (Frames Per Second) pour mesurer la fréquence d'affichage.

**HLS**: High Level Synthesis. Outil logiciel permettant de synthétiser du code haut niveau en un code de plus bas niveau.

**SoC**: System on Chip. Puce de sillicium intégrant plusieurs composants, comme de la mémoire, un processeur, et un composant de gestion d'entrées/sorties.

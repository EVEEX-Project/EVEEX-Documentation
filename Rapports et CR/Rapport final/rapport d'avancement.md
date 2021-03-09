---
title: "Rapport d'avancement : EVEEX"
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

-   **Aliexpress** pour les caméras pas chères.

\pagebreak

# Introduction



\pagebreak

# Présentation de la problématique 





## Réalisation 

## Difficultés rencontrées 



\pagebreak

# Annexes

\pagebreak

# Bibliographie

**[1]** Ines, S., 2020. _Youtube En Chiffres 2020_. [online] Agence des medias sociaux. Available at: [https://www.agencedesmediassociaux.com/youtube-chiffres-2020/](https://www.agencedesmediassociaux.com/youtube-chiffres-2020/) [Accessed 15 December 2020].

**[2]** Gaudiaut, T., 23 mars 2020. Le streaming vidéo représente 61 % du trafic Internet. [online] Statista. Available at: [https://fr.statista.com/infographie/21207/repartition-du-trafic-internet-mondial-par-usage/](https://fr.statista.com/infographie/21207/repartition-du-trafic-internet-mondial-par-usage/) [Accessed 15 octobre 2020].

**[3]** Bouvet, R., 12 octobre 2020. AMD envisage d'acquerir xilinx, inventeur du FPGA, pour 30 milliards de dollars. [online] Tom's Hardware. Available at: [https://www.tomshardware.fr/amd-envisage-dacquerir-xilinx-inventeur-du-fpga-pour-30-milliards-de-dollars/](https://www.tomshardware.fr/amd-envisage-dacquerir-xilinx-inventeur-du-fpga-pour-30-milliards-de-dollars/) [Accessed 15 octobre 2020].

**[4]** Moore, A., 2017. _Fpgas For Dummies_. 2nd ed. [eBook] Intel Altera. Available at: [https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/misc/fpgas-for-dummies-ebook.pdf](https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/misc/fpgas-for-dummies-ebook.pdf) [Accessed 31 September 2020].

**[5]** Chireux, N., 1999. Compression d'images fixes. p.5/24 [cours] Available at:  
[https://www.chireux.fr/mp/cours/Compression%20JPEG.pdf](https://www.chireux.fr/mp/cours/Compression%20JPEG.pdf) [Accessed 31 September 2020]

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

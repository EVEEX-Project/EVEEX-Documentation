# Rapport réunion 16 mars 2021

>   Projet EVEEX
>
>   Membres présents :
>
>   *   Pascal COTERET
>   *   Jean Christophe LELANN
>   *   Joël CHAMPEAU
>   *   Alexandre FROEHLICH
>   *   Guillaume LEINEN
>   *   Hussein SAAD
>   *   Hugo QUESTROY
>   *   Jean noël CLINK

## Regard sur la grille d'évaluation

On se rend compte du barème d'évaluation. Le barème sur la valeur technique est à notre surprise, tourné vers les tests plus que sur le contenu.

De plus dans le cadre d'un développement logiciel, les tests d'intégration ne semblent pas différer de la validation fonctionnelle. Pour nous un test d'intégration c'est "*mon algo fait quelque chose, je rend compte de si ça marche*" alors qu'une validation fonctionnelle est  "*une fonction doit être réalisée par un système, mon système réalise ou non cette fonction*".

Joel Champeau nous indique que la différence dans notre cas réside en le matériel sur lequel l'algorithme tourne (algo vs embarqué). Dans ce cas le test d'intégration peut réaliser une fonction mais pas en intégration dans un matériel spécifique.

**=> On doit donc montrer ce qui fonctionne et sur quel support l'algorithme fonctionne**

**=> On doit pouvoir être capable de dire surtout comment est-ce qu'on l'a fait, comment est-ce qu'on l'a réalisé**

## Difficultés rencontrées

Durant le projet on a du faire face à de nombreuses difficultés en raison de la nature très technique du projet. L'équipe s'est éparpillé sur différents points à explorer et on a pas su déceler assez rapidement les "branches mortes" que l'on a du abandonner.

La complexité du projet ainsi que le grand nombre de plateformes différentes (x86, ARM, RISC-V, FPGA) ont fait qu'il était difficile de concentrer une action sur un domaine particulier.

On a eu les cours nécessaire pour comprendre le projet qu'à la fin de l'année, ça serait bien de mettre les liens aux cours dispensés à l'ENSTA et établir une liste des prérequis.

**=> Il faut valoriser le chemin qu'on a pris, les expériences qu'on a mené et expliquer nos choix**

## Sprints

On a décidé de regrouper nos sprints par 3. Chacun de ces groupes retraçant au travers des user stories ce qui a fonctionné ou non ainsi qu'une release à la fin de chacun de ces groupes de sprints.

**=> Dire à la fin de chaque sprint ce qui a marché, ce qui n'a pas marché et comment on s'est adapté.**

## Conclusion du projet

Il faudrait qu'on propose un flow (enchaînement d'outils et d'activités) de travail pour le futur.

Imaginons qu'on est une entreprise qui modélise (étape de prototypage) sur Golang son projet et que dans l'avenir on souhaite déployer sur FPGA. Comment est-ce qu'on envisagerait ce portage sur FPGA ? Quelles seraient les étapes à venir ?

Si on avait plus de temps qu'est-ce qu'on aurait pu faire ?

**=> Dessiner ce que pourrait être l'avenir du projet dans le cas ou ce projet est travaillé une année supplémentaire**

## Tests

Les encadrants craignent qu'on ait testé l'algorithme sur 4 images et qu'on dise "ah tiens ça marche".

**=> Faire un programme permettant d'exécuter l'algorithme sur une centaine d'images et récupérer les statistiques**

Par exemple prendre un film open source et compresser chacune de ses images manuellement et en faire les statistiques.

**=> Il faut des preuves que ça bien été pensé, bien structuré, bien codé et pour cela il va falloir présenter les résultats dans un grand tableau en mode papier académique**

**=> Comparer les performances des briques atomiques entre les différents langages (C ou python)**

## Rendu final

Il faudra rendre quelque chose, une base qui pourra être la suite de ce qu'on a fait. Donc donner une documentation et un code qui soit réutilisable et surtout améliorable (avec les pistes de réflexion). Il faut penser aux encadrants et aux suivants.

**=> Archive propre, code propre et documentation / rapport digne d'un logiciel professionnel**

Il faudra qu'on fasse un paragraphe sur le retour d'expérience.



**PENSER À FAIRE DES GRAPHIQUES !!!**
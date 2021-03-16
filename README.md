# am2sp
Assigning Meaning to SPARK Programs

Ce projet contient des exemples de code en SPARK qui sont tous des variations
de l'algorithme de sommation des éléments d'un tableau présenté dans l'article
de Robert W. Floyd de 1967 « Assigning Meaning to Programs ».

Tous les exemples sont prouvés avec la version courante de l'outil de preuve
GNATprove, en dehors de la version `Floyd.Sum_Floyd` pour laquelle l'absence de
bornes sur les indexes et les valeurs du tableau rend improuvables les
vérifications de respect des bornes de valeurs dans le corps de la fonction.

Des adaptations sont nécessaires pour utiliser la version Community 2020
(téléchargeable [ici](https://www.adacore.com/download)) qui ne reconnaît pas
l'aspect `Subprogram_Variant` utilisé ici pour prouver la terminaison des
fonctions récursives, et qui utilise une version précédente d'annotations pour
spécifier les emprunts (*pledge*) de pointeurs, telle que présentée dans ce
[billet de
blog](https://blog.adacore.com/pointer-based-data-structures-in-spark).

Ces adaptations sont disponibles dans la branche `community_2020`.

La branche `big_integer_list` contient une version du code avec pointeurs (dans
`list_arith.ads` et `list_arith.adb`) où les fonctions `Length` et `Sum`
retournent un entier non borné. Les invariants de boucle sont plus lisibles
dans cette version car ils n'ont pas besoin de gardes pour garantir que `Sum`
peut être appelé, `Sum` n'ayant pas besoin de précondition dans cette version.
Par contre, cette version ne prouve pas la terminaison des fonctions récursives
et des boucles `while`, car GNATprove n'accepte pas les valeurs de type non
scalaire `Big_Integer` comme argument de variant.

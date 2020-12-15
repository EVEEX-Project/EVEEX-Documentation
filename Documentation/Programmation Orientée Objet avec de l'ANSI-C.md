# Programmation Orientée Objet avec de l'ANSI-C

> Prise de notes réalisée par 
> Lecture du livre [Object-Oriented Programming With ANSI-C - RIT CS](http://www.cs.rit.edu/~ats/books/ooc.pdf)
> Le 24 novembre 2020

Même si l'ANSI-C est un langage de programmation fonctionnel, il est possible d'imiter le fonctionnement de langages de programmation orienté objet en implémentant ce qui donne leur particularité à ces langages.

## Types de données abstraites et dissimulation de l'information

### Types de données abstraites

Appeler un type de donnée "abstrait" veut dire que l'on ne révèle pas sa représentation à l'utilisateur. Il y a donc des étapes que l'on va lui cacher (des opérations, des tests, etc...). Avec un type de donnée abstraite on sépare l'implémentation de son utilisation ce qui rend le code final beaucoup plus accessible. On peut alors décomposer un large système en plein de petits modules.

Exemple avec le type `Set`. Ce type de donnée est abstraite, on déclare ce que l'on peut faire avec un set : 

```c
#ifndef SET_H
#define SET_H

extern const void *Set;

void *add (void *set, const void *element);
void *find (const void *set, const void *element);
void *drop (void *set, const void *element);
int contains (const void *set, const void *element);

#endif
```

Le header est complet mais est-ce qu'il est utile ? On peut travailler maintenant avec des set grâce à `add()`, `find()` ou `drop()`. On a l'exemple d'une fonction d'aide qui convertit le résultat de `find` dans une valeur de vérité.

On a utilisé ici un pointeur `void *` pour deux raisons : il est impossible de découvrir ce à quoi un set ressemble, et parce que cela nous permet de passer ce que l'on veut aux fonctions.

### Gestion de la mémoire

Comment est-ce que l'on peut créer un `Set` ? Il s'agit d'un pointeur, pas un type définit avec `typedef`. On va utiliser des pointeurs pour référer au `Set` et à ses éléments : 

```c
void *new(const void *type, ...);
void delete(void *item);
```

La fonction `new()` accepte un descripteur comme `Set` et possiblement plus d'argument pour l'initialisation de la commande. `delete()` accepte un pointeur produit par `new()` et le recycle. Concrètement ce sont juste des "wrappers" de `calloc()` et `free()`.

De même si l'on veut stocker quelque chose d'intéressant dans le `Set` il va falloir un autre type abstrait de données. Ici `Objet` : 

```c
extern const void *Objet;
int differ(const void *a, const void *b);
```

La fonction `differ()` peut comparer des objets en retournant vrai si ils sont égaux et faux sinon. Il s'agit d'un "wrapper" de la fonctionnalité `strcmp()` pour certaines paires d'objets on retournera un nombre négatifs et d'autres un positif pour donner le concept d'ordre.

Ainsi le code suivant prend du sens : 

```c
void *s = new(Set);
void *a = add(s, new(Object));
void *b = add(s, new(Object));
void *c = new(Object);

contains(s, a) && contains(s, b); // vrai pour les deux
contains(s, c); // sera faux
contains(s, drop(s, a)); // retournera faux

differ(a, add(s, a)); // retournera faux les deux objets étant identiques

delete(drop(s, b)); // on supprime les références aux objets
delete(drop(s, c));
```

### Implémentation - Set

La fonction `new()` est simple à comprendre. Il s'agit de la même pour les `Set` et les `Object`. On utilise un tableau `heap[]` pour contenir les valeurs :

```c
#if !defined MANY || MANY < 1
#define MANY 10
#endif

static int head[MANY];

void *new(const void *type, ...) {
    int *p; 	/* &heap[1..] */
    for (p = heap + 1; p < heap + MANY; ++p)
        if (!*p) // si p est non null -> on est à la fin du tab initialisé
            break;
    
    assert(p < heap + MANY); // on vérifie qu'on a le bon nombre d'éléments
    						 // peut se déclencher si on est à court de mémoire
    *p = MANY;
    return p;
}
```

Avant qu'un objet soit ajouté à un `Set`, on le laisse contenir une valeur d'index impossible pour que `new()` ne puisse pas le retrouver et qu'on ne le confonde pas comme la valeur d'un membre d'un `Set`.

La fonction `delete()` doit faire attention aux pointeurs null. Un élément de `heap[]` est recyclé en le mettant à zéro :

```c
void delete(void *_item) {
    int *item = _item;
    if (item) {
        // on s'assure que l'objet appartienne bien au set
        assert(item > heap && item < heap + MANY);
        *item = 0; // on le recycle
    }
}
```

Ici on utilise une nomenclature pour gérer les pointeurs génériques : un underscore en préfixe et utilisation uniquement dans les arguments de la fonction.

Un `Set` est représenté par ses objets : chaque élément pointe vers le `Set`. Si un élément contient `MANY` alors il peut être ajouté au `Set` sinon il est déjà dedans car on ne permet pas aux `Object` d'être dans deux `Set` différents :

```c
void *add(void *_set, const void *_element) {
    int *set = _set;
    const int *element = _element;
    
    // on ne veut traiter qu'avec des pointeurs dans heap[]
    assert(set > heap && set < heap + MANY);
    // on veut que set n'appartienne pas à un autre set (logique)
    assert(*set == MANY);
    assert(element > heap && element < heap + MANY);
    
    // si l'élément n'appartient à aucun set on l'ajoute
    if (*element == MANY)
        *(int *) element = set - heap;
    else
        assert(*element == set - heap);
    
    return (void *) element;
}
```

Les autres fonctions sont transparentes. `find()` cherche uniquement si ses éléments contiennent le bon index du `Set` :

```c
void *find(const void *_set, const void *_element) {
    const int *set = _set;
    const int *element = _element;
    
    assert(set > heap && set < heap + MANY);
    assert(*set ==MANY);
    assert(element > heap && element < heap + MANY);
    assert(*element);
    
    return *element == set - heap ? (void *) element : 0;
}
```

Et `contains()` convertit le résultat de `find()` dans une valeur de vérité :

```c
int contains(const void *_set, const void *_element) {
    return find(_set, _element) != 0;
}
```

La fonction `drop()` peut s'appuyer sur `find()` pour vérifier que l'élément à retirer appartient bien au `Set`. Dans ce cas on marque l'objet avec `MANY` :

```c
void *drop(void *_set, const void *_element) {
    int *element = find(_set, _element);
    
    // si l'élément appartenait bien au Set
    if (element)
        *element = MANY;
    return element;
}
```

Cette implémentation permet de se passer de la fonction `differ()` cependant notre application en dépend, il faut donc l'implémenter (une simple comparaison de pointeurs ici est suffisante) :

```c
int differ(const void *a, const void *b) {
    return a != b;
}
```

Il ne reste plus qu'à rendre le compilateur heureux en définissant les descripteurs `Set` et `Object` :

```c
const void *Set;
const void *Object;
```

### Autre implémentation - Sac

On conserve l'interface de `Set` mais cette fois-ci on utilise l'allocation dynamique et les objets deviennent des structures :

```c
struct Set { unsigned count; };
struct Object { unsigned count; struct Set *in; };
```

La variable `count` garde la trace du nombre d'éléments dans un `Set`. Pour un élément `count` enregistre le nombre de fois que cet élément à été ajouté au `Set`. Si on décrémente cette variable à chaque appel de `drop()` et que l'on ne le retire que lorsque cette valeur vaut 0 alors on a un Sac.

On doit initialiser les objets dans `new()`, on doit donc pouvoir connaitre leur taille :

```c
static const size_t _Set = sizeof(structSet);
static const size_t _Object = sizeof(struct Object);
const void *Set = &_Set;
const void *Object = &_Object;
```

Ce qui rend la fonction `new()` nettement plus simple : 

```C
void *new(const void *type, ...) {
    const size_t size = *(const size_t *) type;
    void *p = calloc(1, size);
    asser(p); // on s'assure que le pointeur existe bien
    return p;
}
```

De même `delete()` transmet directement son argument à la fonction `free()`. La fonction `add()` doit croire ses arguments et incrémente le nombre de ses enregistrements :

```c
void *add(void* _set, const void*_element) {   
    struct Set *set = _set;
    struct Object *element = (void *) _element;
    
    assert(set); // on vérifie que le set existe
    assert(element);// on vérifie que l'élément existe
    
    if (!element—>in) // si l'élément n'appartenait à aucun set
        element—>in = set;
    else
        assert(element—> in == set);
    
    ++element—>count, ++set—>count;
    return element;
}
```

La fonction `find()` vérifie toujours si l'élément pointe vers le bon set (`contains()` ne change pas ) :

```c
void *find(const void *_set, const void *_element) {   
    const struct Object *element = _element;
    
    assert(_set);
    assert(element);
    
    return element—>in == _set ? (void *) element : 0;
}
```

Si `drop()` trouve l'élément dans le `Set` il décrémente sa référence et le nombre d'éléments dans le `Set`. Si sa référence tombe à zéro il est retiré du `Set` :

```c
void *drop(void *_set, const void *_element) {   
    struct Set * set = _set;
    struct Object * element = find(set, _element);
    
    // si l'élément appartient toujours au set
    if (element) {
        if(——element—>count == 0)
            element—>in = 0; // on retirer la référence au Set
        ——set—>count;
    }
    return element;
}
```

On peut maintenant fournir une fonction `count()` qui retourne le nombre d'éléments dans un set : 

```c
unsigned count(const void *_set) {
    const struct Set *set = _set;
    assert(set); // on s'assure que le Set existe
    return set->count;
}
```

Bien sur ça serait plus simple que l'application ait accès au composant `.count` directement mais on insiste sur le fait de ne pas révéler la représentation de la donnée. Ce n'est rien par rapport au danger d'avoir une application écrivant sur une donnée critique.

## Liaison dynamique et fonctions génériques

### Constructeurs et destructeurs

On va implémenter un type "chaîne de caractères" que l'on va ensuite mettre dans un `Set`. La fonction `new()` sait quel type d'objet elle doit créer mais la fonction `delete()` devient une autre histoire. La façon évidente de l'implémenter est de donner le lien vers la façon de détruire l'objet, dans son type pour conserver la structure de donnée abstraite.

```c
struct type {
    size_t size;				/* Taille de l'objet */
    void (* dtor) (void *);		/* destructeur */
}

struct String {
    char *text;					/* Chaine de caractères dynamique */
    const void *destroy;		/* Localisation du destructeur */
}

struct Set {
	... information ...
    const void *destroy;		/* Localisation du destructeur */
}
```

L'initialisation fait partie du boulot de `new()` et les différents types exigent différentes fonctions d'initialisation avec probablement des arguments supplémentaires : 

```c
new(Set);						/* init un Set */
new(String, "text");			/* init une string */
```

Il nous faut donc une nouvelle fonction de la même manière que le destructeur : c'est ce qu'on va appeler le constructeur. Comme le constructeur et le destructeur ne sont pas spécifiques au type et ne changent pas, on les passent tous les deux à `new()`.

> Bien noter que ce n'est pas le rôle du constructeur et du destructeur de gérer directement la mémoire. Pour cela il faudra bien faire appel aux fonctions `delete()` et `new()`.

### Méthodes, messages, classes et objets

La fonction `delete()` doit dans tous les cas pouvoir être capable de trouver le destructeur qu'importe le type d'objet. On peut ainsi créer une structure `Class` avec le pointeur vers le destructeur toujours en haut. De la même manière on va ainsi définir des pointeurs vers d'autres fonctions que l'on va considérer indispensable comme le constructeur, le clonage (`clone()`) et la comparaison (`differ()`).

```c
struct Class {
    size_t size;
    void * (* ctor) (void *self, va_list *app); 		/* Constructeur */
    void * (* dtor) (void *self); 						/* Destructeur */
    void * (* clone) (const void *self); 				/* Clonage */
    int (* differ) (const void *self, const void *b); 	/* Comparaison */
};
```

 On peut se rendre compte qu'il suffit de faire passer cette structure à tous nos nouveaux types pour régler ces problèmes.

```c
struct String {
    const void *class;	/* Doit être en premier */
    char *text;
};

struct Set {
    const void *class;	/* Doit être en premier */
    ... information ...
};
```

En regardant la liste des fonctions que l'on vient de créer, on se rend compte qu'elles vont fonctionner pour n'importe quel type d'objet. Il n'y a que le constructeur qui sera un peu délicat. On appelle ces fonctions les **méthodes** des objets. Appeler une méthode c'est mettre un terme sur un message et nous avons marqué l'*objet receveur* avec le paramètre `self`.

Beaucoup d'objets vont partager le même descripteur de type, ils auront besoin de la même quantité de mémoire et les mêmes méthodes pourront s'appliquer à eux. On appelle ce descripteur de type une **classe**. Un seul objet deviendra alors une **instance** de la classe.

### Sélecteurs, liaison dynamique et polymorphismes

Qui s'occupe de faire la messagerie ? Le constructeur est appelé par `new()` pour une nouvelle zone mémoire qui est quasiment non-initialisée :

```c
void *new(const void *_class, ...) {
    const struct Class *class = _class;
    void *p = calloc(1, class->size);
    
    assert(p); // on vérifie que la mémoire à bien été allouée
    *(const struct Class **)p = class; // quelque soit l'objet on lui donne sa classe
    
    // si la classe possède un constructeur
    if (class->ctor) {
        va_list ap; // liste variable d'arguments
        va_start(ap, _class); // init de la liste variable d'arguments
        p = class->ctor(p, &ap); // on appelle le constructeur de la classe
        va_end(ap); // on termine son utilisation
    }
    return p; // on retourne l'instance de classe ainsi crée
}
```

L'existence du pointeur vers `struct Class` au début d'un objet est du coup extrêmement important. C'est pour cela qu'on initialise le pointeur correspondant dans `new()`. 

La fonction `delete()` suppose que chaque objet (i.e. chaque pointeur non null) pointe vers un descripteur de type pour appeler le destructeur. Ici `self` joue le rôle de `p` précédemment.

```c
void delete(void *self) {
    const struct Class **cp = self;
    
   	// si l'objet existe et qu'il possède un destructeur
    if (self && *cp && (*cp)->dtor)
        self = (*cp)->dtor(self); // on appelle le destructeur
    free(self); // on libère enfin l'objet
}
```

Le destructeur répare ici les bêtises qui peuvent être fait par le constructeur. Si un objet ne veut pas être supprimé, le destructeur peut alors simplement retourner un pointeur null.

Les autres méthodes stockées dans le descripteur de type fonctionnent d'une manière similaire en acceptant un paramètre `self`, il suffit de router la méthode vers son descripteur :

```c
int differ(const void *self, const void *_b) {
    const struct Class *const *cp = self;
    
    // on s'assure que l'objet existe bien et qu'il possède une fct de comparaison
    assert(self && *cp && (*cp)->differ);
    return (*cp)->differ(self, b); // on appelle la méthode de la classe
}
```

On appelle alors `differ()` une **fonction sélecteur**. C'est un exemple de fonction polymorphique, i.e. une fonction qui accepte des arguments de différents types et agit différemment selon leur type. Quand `differ()` est implémentée dans toutes les classes elle devient une **fonction générique** et s'applique partout.

Des méthodes peuvent être polymorphiques sans pour autant avoir une liaison dynamique. Exemple avec la fonction `sizeOf()` qui retourne la taille de n'importe quel objet :

```c
size_t sizeOf(const void *self) {
    const struct Class *const *cp = self;
    assert(self && *cp); // on s'assure que l'objet existe ainsi que son contenu
    return (*cp)->size; // on retourne la taille de l'objet
}
```

Tous les objets portant leur descripteur peuvent utiliser cette fonction. Attention cependant : 

```c
void *s = new(String, "text");
assert(sizeof s != sizeOf(s)); // différence de résultat
```

`sizeof` est un opérateur en C qui est évalué au moment de la compilation et qui retourne le nombre de bytes requis par ses variables. `sizeOf()` est une fonction polymorphique qui retourne au moment de l’exécution le nombre de bytes de l'objet.

### Une application

Même si on a pas encore implémenté les strings, on va écrire un programme de test.

```c
/* String.h */
extern const void *String;
```

Nos méthodes sont communes à tous les objets. On ajoute alors leurs déclarations dans le fichier de gestion de mémoire :

```c
/* new.h */
void *clone(const void *self);						/* Fct sélecteur dérivée de struct Class */
int differ(const void *self, const void *b);		/* Fct sélecteur dérivée de struct Class */
size_t sizeOf(const void *self);
```

On a alors l'application suivante :

```c
#include "String.h"
#include "new.h"

int main() {
    void *a = new(String, "a"), *aa = clone(a);
    void *b = new(String, "b"); // création de 2 strings + 1 clone
    
    printf("sizeOf(a) == %u\n"; sizeOf(a));
    if (differ(a, b)) // 2 textes différents donnent 2 strings différentes
        puts("ok");
    if (differ(a, aa)) // on vérifie qu'une copie est égale mais pas identique
        puts("differ?");
    if (a == aa)
        puts("clone?");
    
    // résultat : sizeOf(a) == 8 \n ok
    
    delete(a), delete(aa), delete(b);
    return 0;
}
```

### Une implémentation - String

On implémente les `String` en écrivant les méthodes qui vont entrer dans le descripteur. Le constructeur récupère le texte passé dans `new()` et garde une copie dynamique dans la structure. La variable `class` étant déjà initialisée dans `new()`.

```c
struct String {
    const void *class;	/* Doit être en premier */
    char *text;
};

static void *String_ctor(void *_self, va_list *app) {
    struct String *self = _self; // on récupère les arguments
    const char *text = va_arg(*app, const char *);
    
    self->text = malloc(strlen(text) + 1); // allocation de mémoire pour la string
    assert(self->text); // on vérifie qu'il n'y a pas eu d'erreur
    strcpy(self->text, text); // copie de la chaine dans la variable
    return self; // on retourne l'instant de variable ainsi crée
}
```

Le destructeur libère la mémoire contrôlée par la `String`. Comme `delete()` est appelée si et seulement si `self` est non null on a pas besoin de vérifier : 

```c
static void *String_dtor(void *_self) {
	struct String *self = _self;
    free(self->text), self->text = 0; // on libère l'espace alloué
    return self; // on retourne le pointeur sur l'objet pour le libérer dans delete()
}
```

La fonction `String_clone()` va créer une copie de `String`. Plus tard l'original et la copie seront passé à `delete()` donc on doit faire une copie dynamique. C'est plus facile en appelant `new()` :

```c
static void *String_clone(const void *_self) {
    const struct String *self = _self;
    return new(String, self->text); // crée une nouvelle instance dynamiquement
}
```

`String_differ()` est fausse si les deux objets ne sont pas du même type ou que leur contenu est différent :gitddkfk

```c
static int String_differ(const void *_self, const void *b) {
    const struct String *self = _self;
    const struct String *b = _b;
    
    if (self == b) // si il s'agit du même objet c'est forcément vrai
        return 0;
    if (!b || b->class != String) // types différents donc f
        return 1;
    return strcmp(self->text, b->text); // on compare leur contenu
}
```

Toutes ces méthodes sont statiques parce qu'elles ne doivent être appelée que par `new()`, `delete()` ou bien par les sélecteurs. Alors on peut définir la classe `String` :

```c
#include "new.r" // header privé contenant la struct Class

static const struct Class _String = {
    sizeof(struct String),
    String_ctor, String_dtor,
    String_clone, String_differ
};
const void *String = &_String;
```

## Implémentation avec une superclasse `Object`

Pour réussir à faire une abstraction sur toutes les classes que l'on va utiliser, on peut simplement créer une superclasse `Object` comme en python ou en Java, et qui sera la classe mère de toutes celles que l'on va créer.

L'auteur du livre sépare le code en 3 types de fichiers :

* `.r` : fichier de représentation (de classe)
* `.h` : description plus "lisible" des fonctions de classe
* `.c` : code des fonctions

Ainsi on peut représenter la classe `Object` par le fichier `Object.r` :

```c
struct Object {
	const struct Class * class;					/* Description d'objet */
};

struct Class {
	const struct Object _;						/* Description de la classe */
	const char * name;							/* Nom de la classe */
	const struct Class * super;					/* Super classe de la classe */
	size_t size;								/* Taille d'objet de la classe */
	void * (* ctor) (void * self, va_list * app);
	void * (* dtor) (void * self);
	int (* differ) (const void * self, const void * b);
	int (* puto) (const void * self, FILE * fp);
};

void * super_ctor (const void * class, void * self, va_list * app);
void * super_dtor (const void * class, void * self);
int super_differ (const void * class, const void * self, const void * b);
int super_puto (const void * class, const void * self, FILE * fp);
```

De même on développe les fonctions de base dans `Object.h` :

```c
#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>

extern const void * Object;						/* new(Object); */

void *new (const void *class, ...);
void delete (void * self);

const void *classOf (const void *self);
size_t sizeOf (const void *self);

void *ctor (void *self, va_list * app);
void *dtor (void *self);
int differ (const void *self, const void *b);
int puto (const void *self, FILE *fp);

extern const void * Class;						/* new(Class, "name", super, size
															sel, meth, ... 0); */

const void * super (const void * self);			/* Superclasse de la classe */
```

Finalement dans le fichier `Object.c` on va pouvoir écrire le code en plusieurs parties, sans oublier d'inclure les fichiers `Object.h` et `Object.r`. On commence par les fonctions de `Object` : 

```c
static void * Object_ctor (void * _self, va_list * app) {			/* Constructeur */
	return _self;
}

static void * Object_dtor (void * _self) {							/* Destructeur */
	return _self;
}

static int Object_differ (const void * _self, const void * b) {		/* Comparateur */
	return _self != b;
}

static int Object_puto (const void * _self, FILE * fp) {			/* Afficheur ? */
    const struct Class * class = classOf(_self);
	return fprintf(fp, "%s at %p\n", class->name, _self);
}

const void * classOf (const void * _self) {							/* Retourne la classe de l'objet */
    const struct Object * self = _self;
	assert(self && self->class);
	return self->class;
}

size_t sizeOf (const void * _self) {								/* Retourne la taille de l'objet */
    const struct Class * class = classOf(_self);
	return class->size;
}
```

Ensuite les fonctions de la `Class` :

```c
static void *Class_ctor (void *_self, va_list *app) {			/* Constructeur */ 	
    struct Class *self = _self;
	const size_t offset = offsetof(struct Class, ctor);

	self->name = va_arg(*app, char *);							/* on récupère les arguments de la liste */
	self->super = va_arg(*app, struct Class *);
	self->size = va_arg(*app, size_t);

	assert(self->super);

	memcpy((char *) self + offset, (char *) self->super
					+ offset, sizeOf(self->super) - offset);
{
	typedef void (* voidf) ();	/* generic function pointer */
	voidf selector;
#ifdef va_copy
	va_list ap; va_copy(ap, * app);
#else
	va_list ap = * app;
#endif
    
	while ((selector = va_arg(ap, voidf)))
	{	voidf method = va_arg(ap, voidf);

		if (selector == (voidf) ctor)
			* (voidf *) & self -> ctor = method;
		else if (selector == (voidf) dtor)
			* (voidf *) & self -> dtor = method;
		else if (selector == (voidf) differ)
			* (voidf *) & self -> differ = method;
		else if (selector == (voidf) puto)
			* (voidf *) & self -> puto = method;
	}
#ifdef va_copy
    va_end(ap);
#endif

	return self;
}}

static void *Class_dtor (void *_self)								/* Destructeur */
{	struct Class * self = _self;

	fprintf(stderr, "%s: cannot destroy class\n", self->name);
	return 0;
}

const void *super (const void *_self)								/* Récupérer la super classe */
{	const struct Class *self = _self;

	assert(self && self->super);
	return self->super;
}
```

Ensuite la partie initialisation :

```c
static const struct Class object[] = {
	{ { object + 1 },
	  "Object", object, sizeof(struct Object),
	  Object_ctor, Object_dtor, Object_differ, Object_puto
	},
	{ { object + 1 },
	  "Class", object, sizeof(struct Class),
	  Class_ctor, Class_dtor, Object_differ, Object_puto
	}
};

const void *Object = object;
const void *Class = object + 1;
```

Enfin on termine par les sélecteurs et le management des objets : 

```c
void *new (const void *_class, ...)	{							/* Nouvelle instance de classe */
	const struct Class *class = _class;
	struct Object *object;
	va_list ap;

	assert(class && class->size);
	object = calloc(1, class->size);	// allocation de l'espace mémoire nécessaire
	assert(object);
	object->class = class; // on attribue la classe
	va_start(ap, _class);
	object = ctor(object, &ap); // on appelle le constructeur de l'objet
	va_end(ap);
	return object; // on retourne l'instance
}

void delete (void * _self) {
	if (_self)
		free(dtor(_self));	// on appelle le destructeur puis on libère la référence
}

void *ctor (void *_self, va_list * app) {	
    const struct Class *class = classOf(_self); // on récupère la classe de l'objet

	assert(class->ctor);	// on vérifie que l'objet possède un constructeur
	return class->ctor(_self, app); // on appelle son constructeur
}

void *super_ctor (const void *_class,
				void *_self, va_list *app) {	
    const struct Class * superclass = super(_class);	// on récupère la super classe

	assert(_self && superclass->ctor);
	return superclass->ctor(_self, app); // on appelle le constructeur de la super classe
}

void *dtor (void *_self) {	
    const struct Class * class = classOf(_self); // on récupère la classe de l'objet

	assert(class->dtor);
	return class->dtor(_self); // on appelle son destructeur
}

void *super_dtor (const void *_class, void *_self) {	
    const struct Class * superclass = super(_class); // on récupère la superclasse

	assert(_self && superclass->dtor);
	return superclass->dtor(_self); // on appelle le destructeur de la superclasse
}

int differ (const void * _self, const void * b) {	/* Comparaison */
    const struct Class * class = classOf(_self);

	assert(class->differ);
	return class->differ(_self, b); // on les compare
}

int super_differ (const void *_class, const void *_self, const void *b)
{	const struct Class *superclass = super(_class);

	assert(_self && superclass->differ);
	return superclass->differ(_self, b); // on appelle le comparateur de la super classe
}

int puto (const void *_self, FILE *fp) {	
    const struct Class *class = classOf(_self); // on récupère la classe de l'objet

	assert(class->puto);
	return class->puto(_self, fp); // on affiche le contenu dans fp
}

int super_puto (const void * _class, const void * _self, FILE * fp) {	
    const struct Class * superclass = super(_class); // on récupère la superclasse de l'objet

	assert(_self && superclass->puto);
	return superclass->puto(_self, fp); // on affiche le contenu a l'aide de la superclasse
}
```

Maintenant on peut créer beaucoup plus simplement des classes complexes qui peuvent hériter les unes des autres. Exemple de la classe `Point` avec `Point.r` :

```c
#include "Object.r"

struct Point { const struct Object _;	/* Point : Object */
	int x, y;				/* coordonnées */
};

void super_draw (const void *class, const void *self);

struct PointClass {
	const struct Class _;			/* PointClass : Class */
	void (*draw) (const void *self);
};
```

Puis ensuite `Point.h` :

```c
#include "Object.h"

extern const void *Point;			/* new(Point, x, y); */

void draw (const void *self);
void move (void *point, int dx, int dy);

extern const void *PointClass;		/* adds draw */

void initPoint (void);
```

Et enfin `Point.c` :

```c
/* Point */
static void *Point_ctor (void *_self, va_list *app) {	
    struct Point *self = super_ctor(Point, _self, app);

	self->x = va_arg(*app, int); // On récupère les arguments dynamiques
	self->y = va_arg(*app, int);
	return self;
}

static void Point_draw (const void *_self) {	
    const struct Point *self = _self;
	printf("\".\" at %d,%d\n", self->x, self->y);
}

void draw (const void *_self) {	
    const struct PointClass *class = classOf(_self);

	assert(class->draw);
	class->draw(_self);
}

void super_draw (const void *_class, const void *_self) {	
    const struct PointClass *superclass = super(_class);

	assert(_self && superclass->draw);
	superclass->draw(_self);
}

void move (void *_self, int dx, int dy)
{	struct Point *self = _self;

	self->x += dx, self->y += dy;
}

/* PointClass */
static void * PointClass_ctor (void * _self, va_list * app) {	
    struct PointClass * self
					= super_ctor(PointClass, _self, app);
	typedef void (*voidf) ();
	voidf selector;
#ifdef va_copy
	va_list ap; va_copy(ap, *app);
#else
	va_list ap = *app;
#endif

	while ((selector = va_arg(ap, voidf)))
	{	voidf method = va_arg(ap, voidf);

		if (selector == (voidf) draw)
			*(voidf *) &self->draw = method;
	}
#ifdef va_copy
    va_end(ap);
#endif

	return self;
}

/* Initialisation */
const void * PointClass, * Point;

void initPoint(void)
{
	if (!PointClass)
		PointClass = new(Class, "PointClass",
				Class, sizeof(struct PointClass),
				ctor, PointClass_ctor,
				0);
	if (!Point)
		Point = new(PointClass, "Point",
				Object, sizeof(struct Point),
				ctor, Point_ctor,
				draw, Point_draw,
				0);
}
```


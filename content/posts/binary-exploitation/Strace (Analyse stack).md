### **1. Vue d'ensemble des mécanismes d'allocation et de libération de mémoire**

L' OS gère la mémoire via différents mécanismes, principalement à travers des appels système comme `brk` et `mmap`. Les appels `brk` sont utilisés pour ajuster la taille de la heap , tandis que `mmap` permet une gestion plus fine de la mémoire, souvent utilisée pour allouer des segments mémoire pour des bibliothèques partagées ou pour réserver de la mémoire de manière anonyme.

Dans le cadre des deux scripts, l'observation des traces révèle des comportements similaires en matière d'allocation.

---

### **2. Analyse détaillée des appels `brk` et `mmap` dans `fact.py`**

#### **a. Appels `brk`**

Les appels à `brk` montrent la gestion de la heap, et sont utilisée par le programme pour stocker des données dynamiques.

`brk(NULL)                               = 0x14fbb000 brk(0x14fdc000)                         = 0x14fdc000`

- **Interprétation** : Le processus commence avec une allocation de mémoire dans la heap à partir de l'adresse `0x14fbb000`. Par la suite, un appel `brk` pour étendre la heap à `0x14fdc000` est effectué. Cette extension de la heap représente un changement de la mémoire dynamique disponible pour le processus. L'intervalle entre ces deux valeurs (environ 128 Ko) indique une première allocation mémoire pour le programme. 
#### **b. Appels `mmap`**

L'utilisation de `mmap` alloue de la mémoire de manière plus fine. Permet de réserver des zones spécifiques de mémoire, comme des segments de code, de données, ou des espaces de mémoire partagée.

`mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f6ab42c9000 mmap(NULL, 96182, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f6ab42b1000 mmap(NULL, 938008, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f6ab41cb000 mmap(0x7f6ab41db000, 499712, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7f6ab41db000`

- **Interprétation** : La trace révèle plusieurs appels à `mmap`, chacun avec des objectifs et des tailles différentes :
    - Le premier appel alloue 8 Ko de mémoire anonyme en lecture et écriture, ce qui pourrait correspondre à des variables temporaires ou des buffers de petite taille.
    - Les appels suivants, avec des tailles variant de 96 Ko à 938 Ko, sont probablement utilisés pour des segments de données ou de bibliothèques partagées.
    - Le dernier appel, allouant un segment de mémoire plus grand de 499 Ko pour du code exécutable (`PROT_EXEC`), montre que la mémoire réservée est utilisée pour des bibliothèques partagées ou même des pages de code.

#### **c. Libération de mémoire (`munmap`)**

Les appels `munmap` sont essentiels pour comprendre comment le processus libère la mémoire allouée de manière explicite, optimisant ainsi l'utilisation de la mémoire.
  

`munmap(0x7f6ab42b1000, 96182)           = 0`

- **Interprétation** : La libération de mémoire est réalisée après que les données ou ressources ne sont plus nécessaires. Dans ce cas, environ 96 Ko de mémoire sont libérés. Cela indique probablement la fin de l’utilisation d'un segment de données ou la fin de l'exécution d'une fonction qui nécessitait cette mémoire.

---

### **3. Analyse détaillée des appels `brk` et `mmap` dans `factbis.py`**

#### **a. Appels `brk`**

Les appels `brk` dans `factbis.py` suivent un modèle similaire à celui de `fact.py`, mais avec des tailles d’allocation légèrement différentes.
  

`brk(NULL)                               = 0x155c4000 brk(0x155c6000)                         = 0x155c6000`

- **Interprétation** : De manière similaire, la heap est étendue à partir de l’adresse `0x155c4000` jusqu’à `0x155c6000`. L’extension est légèrement plus petite que dans le cas de `fact.py`, ce qui peut suggérer que `factbis.py` nécessite moins de mémoire dynamique au départ.

#### **b. Appels `mmap`**

L'analyse des appels `mmap` dans `factbis.py` montre une dynamique très proche de celle observée dans `fact.py`, mais avec des différences subtiles dans les tailles des allocations :

`mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7effe7616000 mmap(NULL, 96182, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7effe75fe000 mmap(NULL, 938008, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7effe7518000 mmap(0x7effe7528000, 499712, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x10000) = 0x7effe7528000`

- **Interprétation** : Bien que les types et tailles des segments mémoire alloués soient similaires à `fact.py`, une différence clé réside dans l'utilisation plus fréquente de segments mémoire de 8 Ko à 16 Ko, ce qui pourrait correspondre à un mécanisme d'allocation plus granulaire. Ce type de gestion pourrait indiquer une approche plus conservatrice ou plus optimisée vis-à-vis de la fragmentation de la mémoire.

#### **c. Libération de mémoire (`munmap`)**

La libération de mémoire suit le même principe qu’avec `fact.py` :
  
`munmap(0x7effe75fe000, 96182)           = 0`

- **Interprétation** : Tout comme dans `fact.py`, après l'utilisation des ressources mémoires allouées via `mmap`, la mémoire est rendue disponible, ce qui permet au système de gérer efficacement les ressources.

---

### **4. Comparaison des deux traces :**

Une analyse plus fine des deux traces montre plusieurs distinctions intéressantes qui influent directement sur les performances et la gestion des ressources :

1. **Granularité de l'allocation mémoire** :
    
    - **`factbis.py`** utilise une granularité d'allocation plus fine, avec davantage d'allocation de petits blocs (notamment 8 Ko à 16 Ko), ce qui pourrait être plus efficace en termes de gestion de la mémoire dans des environnements à haute densité de processus. Cela permet de mieux contrôler la fragmentation de la mémoire.
    - **`fact.py`**, bien que similaire, utilise des blocs plus grands dans l'ensemble.
2. **Extensions de la heap (`brk`)** :
    
    - Les deux scripts montrent un usage similaire de `brk` pour étendre la heap, bien que la taille de l'extension dans `factbis.py` semble plus modeste.
3. **Libération de la mémoire** :
    
    - Les deux scripts libèrent la mémoire de manière explicite, mais `factbis.py` semble faire un usage plus intense de petites allocations et libérations, suggérant un besoin accru de gestion fine de la mémoire pendant l'exécution.


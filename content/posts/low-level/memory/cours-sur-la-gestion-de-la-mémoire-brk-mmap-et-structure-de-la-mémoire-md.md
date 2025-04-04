---
title: "Linux Memory Management Internals"
date: 2025-04-04T15:24:19+02:00
draft: false
categories:
  - Low Level
tags:
  - Memory
  - Kernel
  - brk
  - mmap
  - Heap
toc: true
---

## 1️⃣ **Structure Générale de la Mémoire d'un Processus**

Lorsqu'un programme est exécuté, le système d'exploitation alloue un espace mémoire spécifique au processus. Cet espace est divisé en plusieurs segments :
```lua
+---------------------------+ High memory addresses
|        Kernel Space       | <-- Espace réservé au noyau du système
+---------------------------+
|        Stack              | <-- Utilisé pour les appels de fonction et variables locales
|                           |     Croît vers les adresses plus basses
|---------------------------|
|        Heap               | <-- Utilisé pour l'allocation dynamique de mémoire (malloc, calloc)
|                           |     Croît vers les adresses plus hautes
|---------------------------|
|        BSS               | <-- Variables globales et statiques non initialisées
|                           |     Initialisées à zéro par défaut par le système
|---------------------------|
|        Data              | <-- Variables globales et statiques initialisées
|                           |     Exemples : int x = 5;
|---------------------------|
|        Text (Code)       | <-- Contient le code exécutable du programme
|                           |     Généralement en lecture seule
+---------------------------+ Low memory addresses


```



- **Text Segment** : Contient le code exécutable du programme (instructions machine).
- **Data Segment** : Contient les variables globales initialisées.
- **BSS Segment** : Contient les variables globales non initialisées.
- **Heap** : Espace mémoire dynamique alloué par des appels comme `malloc`. Utilise `brk` et `sbrk`.
- **Stack** : Utilisé pour les variables locales, appels de fonction, etc.

---

## 2️⃣ **Appel système `brk`**

### 🔑 **Définition**

- L'appel système **`brk`** est utilisé pour ajuster la taille du segment **Heap**.
- Il change l'adresse limite supérieure du **Heap**.

### ⚙️ **Fonctionnement**

- Lorsqu'un programme demande plus de mémoire via `malloc`, il peut utiliser `brk` pour étendre le Heap.
- **Heap** croît vers des adresses mémoire plus élevées.

### 📊 **Schéma avec `brk`**

```lua
Avant appel brk :          Après appel brk :
+------------------+       +------------------+
|      Heap       |       |      Heap        |
|  (adresse A)    | ----> |  (adresse B)     |
+------------------+       +------------------+

```
### 🛠️ **Exemple en C**

```c
#include <unistd.h>
#include <stdio.h>

int main() {
    void *initial = sbrk(0); // Obtenir l'adresse actuelle du Heap
    printf("Heap initial : %p\n", initial);

    brk(initial + 0x1000); 
    void *after = sbrk(0);
    printf("Heap après brk : %p\n", after);

    return 0;
}

```

---

## 3️⃣ **Appel système `mmap`**

### 🔑 **Définition**

- **`mmap`** permet de mapper des fichiers ou de la mémoire anonyme dans l'espace mémoire du processus.
- Il est souvent utilisé pour des allocations de mémoire de grande taille ou pour le partage de mémoire entre processus.

### ⚙️ **Fonctionnement**

- Avec `mmap`, le noyau alloue un espace mémoire directement dans le segment des **"mappings mémoire"**.
- Contrairement à `brk`, les adresses allouées avec `mmap` ne sont pas nécessairement contiguës avec le Heap.

### 📊 **Schéma avec `mmap`**

```lua
Avant mmap :              Après mmap :
+------------------+      +------------------+
|   Heap          |      |   Heap           |
|   ...           |      |   ...            |
|------------------|      |------------------|
|   Libre         | -->  | mmap allocation  |
+------------------+      +------------------+

```

### 🛠️ **Exemple en C**

```c
#include <sys/mman.h>
#include <stdio.h>

int main() {
    void *ptr = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (ptr == MAP_FAILED) {
        perror("mmap failed");
        return 1;
    }
    printf("Mémoire allouée avec mmap à : %p\n", ptr);

    munmap(ptr, 4096); 
    return 0;
}

```
---

## 4️⃣ **Comparaison entre `brk` et `mmap`**

|**Caractéristique**|**brk**|**mmap**|
|---|---|---|
|**Croissance**|Linéaire (contiguë)|Fragmentée (non contiguë)|
|**Taille allouée**|Petites allocations|Grandes allocations|
|**Espace mémoire**|Segment Heap|Segment Mapping mémoire|
|**Libération**|Automatique (avec Heap)|Doit être explicitement libérée (munmap)|

---

## 5️⃣ **Quand utiliser `brk` ou `mmap` ?**

- **`brk`** : Pour de petites allocations fréquentes.
- **`mmap`** : Pour des allocations de grande taille ou lorsque le contrôle précis de l'adresse est nécessaire.

---

## 6️⃣ **Résumé**

- **`brk`** ajuste la taille du **Heap**.
- **`mmap`** mappe directement la mémoire dans l'espace des mappages mémoire.
- La mémoire d'un programme est organisée en **Text**, **Data**, **BSS**, **Heap**, **Stack**, et **Mappages mémoire**.

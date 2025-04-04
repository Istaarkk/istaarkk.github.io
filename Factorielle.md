### Résultats expérimentaux

|Méthode|Temps de calcul (s)|Nombre d'appels récursifs|
|---|---|---|
|**`fact`**|0.00346|5000|
|**`fact_bis`**|0.00156|11999|

---

### Analyse des performances

#### **Temps de calcul**

- **`fact_bis`** est environ **2 fois plus rapide** que `fact`.
-  **diviser pour régner** utilisée par `fact_bis`, qui réduit efficacement la taille du problème à chaque étape (moins d'instruction en assembly).

#### **Nombre d'appels récursifs**

- `fact` effectue exactement **n appels récursifs** pour un input de taille `n`, soit 5000 appels dans cet exemple.
- `fact_bis` effectue **plus d'appels en raison de la division en deux sous-plages a chaque niveau, mais avec un calcul plus équilibré entre les branches soit 11999.

#### **`fact_bis` plus rapide  **

- **Facteurs d'optimisation dans `fact_bis` :**
    
    - Chaque appel de `fact_bis` traite une plage réduite, minimisant le coût total des multiplications.
    - Le traitement des sous-plages est réalisé en parallèle au sein de la stack.
- **Facteurs limitants dans `fact` :**
    
    - Les multiplications sont strictement séquentielles, chaque étape devant attendre la complétion de l'étape précédente.
    - La structure linéaire des appels génère une profondeur de stack directement proportionnelle à la taille de `n`.

- ### Analyse du désassemblage

#### Différences observées

1. **Structure de `fact` :**
    
    - La fonction repose sur une récursion simple.
    - L'opération principale dans `fact` est une **multiplication séquentielle**, où chaque appel calcule directement `n * fact(n-1)` ce qui fait plus d'appels en assembly .
    
désassemblage :
```Nasm
34 LOAD_GLOBAL (fact)
46 LOAD_CONST (n-1)
52 CALL (1)
60 BINARY_OP (*)
64 RETURN_VALUE
```
**Structure de `fact_bis` :**

- La fonction utilise une **récursion dichotomique**.
- Chaque appel divise la plage `[deb, fin]` en deux sous-plages :
    - Première moitié : `[deb, (deb + fin) // 2]`
    - Deuxième moitié : `[(deb + fin) // 2 + 1, fin]`
- Les résultats des deux sous-plages sont ensuite multipliés.

désassemblage :
```nasm
34 LOAD_GLOBAL (fact_bis)
46 LOAD_FAST (deb)
50 BINARY_OP (+)
54 LOAD_CONST (2)
56 BINARY_OP (//)
60 CALL (2)
108 BINARY_OP (*)
112 RETURN_VALUE

```

`NB`: puisque le code est du python le reverse à été fait avec la commande:
```python
python -m dis prog.py
```

### 1. **Scan basique pour voir les ports ouverts**

C'est un scan léger, idéal pour commencer.

```bash
nmap -sS -T3 <cible>
```

- **-sS** : Scan SYN (rapide et discret, sans établir complètement la connexion TCP).
- **-T3** : Vitesse "modérée", pour ne pas surcharger la cible.

---

### 2. **Scan pour détecter les services et versions**

Après avoir trouvé les ports ouverts, identifier ce qui tourne dessus :

```bash
nmap -sV -T3 <cible>
```

- **-sV** : Détection de versions des services.

---

### 3. **Scan spécifique pour identifier l'OS**

Si tu as besoin de deviner le système d'exploitation de la cible :

```bash
nmap -O -T3 <cible>
```

- **-O** : Détection du système d'exploitation.

---

### 4. **Scan pour chercher des vulnérabilités légères avec des scripts Nmap**

Utilise les scripts Nmap NSE, en te limitant à ceux sans impact fort :

```bash
nmap --script vuln -T3 <cible>
```

- **--script vuln** : Lance les scripts de détection de vulnérabilités légères.

---

### 5. **Scan d'une plage d'adresses IP avec un mode furtif**

Pour cartographier rapidement une plage sans bruit excessif :

```bash
nmap -Pn -sS -T2 <plage d'adresses>
```

- **-Pn** : Pas de ping, au cas où l'ICMP serait bloqué.
- **-T2** : Mode lent, moins détectable.

---

### 6. **Recherche de sous-domaines vivants avec DNS**

Pour détecter des sous-domaines via un scan DNS doux :

```bash
nmap -p 53 --script dns-brute <cible>
```

- **-p 53** : Interroge le service DNS.
- **--script dns-brute** : Test des sous-domaines communs.

---

### 7. **Lister les ports sans effectuer un scan intrusif**

Utilise le mode "list-only" pour voir ce qui serait scanné sans toucher la cible :

```bash
nmap -sS -T3 --top-ports 100 --reason --open --list-only <cible>
```

- **--list-only** : Ne fait que lister, ne scanne pas activement.
- **--top-ports 100** : Liste les 100 ports les plus courants.
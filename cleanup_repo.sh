#!/bin/bash

# Créer les répertoires nécessaires s'ils n'existent pas
mkdir -p content/posts/web-security
mkdir -p content/posts/low-level
mkdir -p content/posts/binary-exploitation
mkdir -p content/posts/network
mkdir -p content/posts/reverse-engineering
mkdir -p content/posts/misc

# Supprimer les fichiers de script temporaires
rm -f translate_*.sh organize_*.sh direct_copy.sh move_markdown_files.sh cleanup_content.sh refine_content.sh *.py

# Déplacer tous les fichiers markdown de la racine vers le bon répertoire en fonction du contenu
for file in *.md; do
    # Ignorer README.md
    if [ "$file" != "README.md" ]; then
        # Déterminer la catégorie en fonction du contenu
        if grep -qi "web\|fuzzing\|lfi\|http" "$file"; then
            mv "$file" content/posts/web-security/
        elif grep -qi "memory\|kernel\|assembleur\|assembly\|x86\|bas niveau\|low level" "$file"; then
            mv "$file" content/posts/low-level/
        elif grep -qi "buffer\|overflow\|format string\|exploitation\|pwn" "$file"; then
            mv "$file" content/posts/binary-exploitation/
        elif grep -qi "network\|scan\|nmap" "$file"; then
            mv "$file" content/posts/network/
        elif grep -qi "reverse\|reversing" "$file"; then
            mv "$file" content/posts/reverse-engineering/
        else
            mv "$file" content/posts/misc/
        fi
    fi
done

# Supprimer les images à la racine et les déplacer dans static/images
mkdir -p static/images
mv *.png static/images/ 2>/dev/null || true

# Mettre à jour le thème en tant que sous-module
git submodule init
git submodule update

# Supprimer les fichiers Hugo temporaires
rm -f .hugo_build.lock
rm -rf public

echo "Nettoyage terminé. Le dépôt est maintenant prêt pour GitHub Pages." 
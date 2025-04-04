#!/bin/bash

# Créer le répertoire de destination s'il n'existe pas
mkdir -p content/posts/cybersecurity

# Liste des fichiers les plus intéressants à traiter
files=(
  "📚 Cours sur la Gestion de la Mémoire brk, mmap et Structure de la Mémoire.md"
  "Web Fuzzing - HTB Course Notes.md"
  "Basic Format String.md"
  "LFI HTB Academy.md"
  "x86-64 NASM Assembly Language Registers, Calling Conventions and Examples.md"
  "Architecture Informatique de Bas Niveau et Sécurité Le Kernel et le Développement de Logiciels Malveillants.md"
)

# Le reste du script reste inchangé
for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    # Nettoyer le nom de fichier pour le slug
    clean_name=$(echo "$file" | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]' | sed 's/-\+/-/g' | sed 's/^-//' | sed 's/-$//')
    
    # Extraire le titre du fichier
    title=$(basename "$file" .md)
    
    # Créer un nouveau fichier avec frontmatter
    cat > "content/posts/cybersecurity/$clean_name.md" << EOF
---
title: "$title"
date: $(date +"%Y-%m-%dT%H:%M:%S%:z")
draft: false
categories:
  - Cybersecurity
tags:
  - Notes
  - Security
---

$(cat "$file")
EOF
    
    echo "Moved and formatted: $file -> content/posts/cybersecurity/$clean_name.md"
  else
    echo "File not found: $file"
  fi
done

echo "Articles organization completed." 
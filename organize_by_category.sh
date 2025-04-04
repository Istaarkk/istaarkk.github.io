#!/bin/bash

# Créer les répertoires de destination par catégorie
mkdir -p content/posts/web-security
mkdir -p content/posts/low-level
mkdir -p content/posts/exploits

# Organiser les articles par catégorie
# Catégorie: Web Security
web_files=(
  "Web Fuzzing - HTB Course Notes.md"
  "LFI HTB Academy.md"
)

# Catégorie: Low Level
low_level_files=(
  "x86-64 NASM Assembly Language Registers, Calling Conventions and Examples.md"
  "📚 Cours sur la Gestion de la Mémoire brk, mmap et Structure de la Mémoire.md"
  "Architecture Informatique de Bas Niveau et Sécurité Le Kernel et le Développement de Logiciels Malveillants.md"
)

# Catégorie: Exploits
exploit_files=(
  "Basic Format String.md"
)

# Fonction pour traiter les fichiers avec la catégorie appropriée
process_files() {
  local files=("$@")
  local category=$1
  local category_dir=$2
  shift 2

  for file in "${@}"; do
    if [ -f "$file" ]; then
      # Nettoyer le nom de fichier pour le slug
      clean_name=$(echo "$file" | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]' | sed 's/-\+/-/g' | sed 's/^-//' | sed 's/-$//')
      
      # Extraire le titre du fichier
      title=$(basename "$file" .md)
      
      # Créer un nouveau fichier avec frontmatter
      cat > "content/posts/$category_dir/$clean_name.md" << EOF
---
title: "$title"
date: $(date +"%Y-%m-%dT%H:%M:%S%:z")
draft: false
categories:
  - $category
tags:
  - Notes
  - Security
---

$(cat "$file")
EOF
      
      echo "Moved and formatted: $file -> content/posts/$category_dir/$clean_name.md"
    else
      echo "File not found: $file"
    fi
  done
}

# Traiter chaque catégorie
process_files "Web Security" "web-security" "${web_files[@]}"
process_files "Low Level" "low-level" "${low_level_files[@]}"
process_files "Exploits" "exploits" "${exploit_files[@]}"

echo "Articles organization completed by categories." 
#!/bin/bash

# Fonction pour ajouter un frontmatter en fonction de la catégorie
add_frontmatter() {
  local file="$1"
  local title=$(basename "$file" | sed 's/\.md$//')
  local category=$(echo "$file" | cut -d'/' -f2)
  local date="2024-06-01"
  local tags=""
  
  case "$category" in
    "web-security")
      tags="web, security, pentest, fuzzing, lfi"
      ;;
    "low-level")
      tags="assembly, memory, kernel, system, linux"
      ;;
    "binary-exploitation")
      tags="pwn, exploitation, buffer-overflow, format-string, security"
      ;;
    "network")
      tags="network, scanning, discovery, nmap, security"
      ;;
    "misc"|"reverse-engineering")
      tags="reverse-engineering, security, binary, analysis"
      ;;
  esac
  
  # Créer le frontmatter
  local frontmatter="---\ntitle: \"$title\"\ndate: $date\ndescription: \"Notes de cybersécurité\"\ncategories: [\"$category\"]\ntags: [$tags]\ntoc: true\n---\n\n"
  
  # Ajout du frontmatter au début du fichier
  temp_file=$(mktemp)
  echo -e "$frontmatter" > "$temp_file"
  cat "$file" >> "$temp_file"
  mv "$temp_file" "$file"
  
  echo "Frontmatter ajouté à $file"
}

# Traiter individuellement chaque fichier sans frontmatter
find content/posts -name "*.md" | while read -r file; do 
  if ! grep -q "^---" "$file"; then
    add_frontmatter "$file"
  fi
done

echo "Tous les fichiers ont été corrigés." 
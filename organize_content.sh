#!/bin/bash

# Arrêter Hugo avant les modifications
pkill hugo || true

# Supprimer tous les articles existants
rm -rf content/posts/*

# Créer des répertoires avec une structure plus précise
mkdir -p content/posts/web-security/lfi
mkdir -p content/posts/web-security/fuzzing
mkdir -p content/posts/low-level/memory
mkdir -p content/posts/low-level/assembly
mkdir -p content/posts/low-level/kernel
mkdir -p content/posts/binary-exploitation/format-string
mkdir -p content/posts/binary-exploitation/buffer-overflow
mkdir -p content/posts/network/scanning
mkdir -p content/posts/reverse-engineering

# Liste des articles à conserver avec structure et tags améliorés
# Format: source_file|destination_dir|title|category|tags (séparés par des virgules)

declare -A articles
articles=(
  # Web Security - plus avancé et pertinent
  ["Web Fuzzing - HTB Course Notes.md"]="web-security/fuzzing|Advanced Web Fuzzing Techniques|Web Security|HTB,Pentesting,Reconnaissance,Wordlists,Discovery"
  ["LFI HTB Academy.md"]="web-security/lfi|LFI Exploitation Methods|Web Security|PHP,Vulnerabilities,File Inclusion,Pentesting"
  
  # Low Level - aspects techniques importants
  ["x86-64 NASM Assembly Language Registers, Calling Conventions and Examples.md"]="low-level/assembly|x86-64 Assembly: Registers and Calling Conventions|Low Level|Assembly,Registers,x86-64,Function Calls"
  ["📚 Cours sur la Gestion de la Mémoire brk, mmap et Structure de la Mémoire.md"]="low-level/memory|Linux Memory Management Internals|Low Level|Memory,Kernel,brk,mmap,Heap"
  ["Architecture Informatique de Bas Niveau et Sécurité Le Kernel et le Développement de Logiciels Malveillants.md"]="low-level/kernel|Kernel Architecture and Security Implications|Low Level|Kernel,Malware,System Security,Ring0"
  
  # Binary Exploitation - techniques avancées
  ["Basic Format String.md"]="binary-exploitation/format-string|Format String Exploitation Techniques|Binary Exploitation|Format String,Memory Corruption,printf,RCE"
  ["Buffer Overflow PIE.md"]="binary-exploitation/buffer-overflow|Bypassing PIE in Buffer Overflow Attacks|Binary Exploitation|Buffer Overflow,PIE,ASLR,Memory Protection"
  ["Note on Binary exploitation from LiveOverflow.md"]="binary-exploitation|Advanced Binary Exploitation Notes|Binary Exploitation|LiveOverflow,Techniques,Memory Corruption"
  
  # Network - les plus techniques
  ["Nmap Scan passif.md"]="network/scanning|Passive Reconnaissance with Nmap|Network|Scanning,Nmap,Stealth,Reconnaissance"
  
  # Reverse Engineering - contenu technique pertinent
  ["Strace (Analyse stack).md"]="reverse-engineering|Stack Analysis using Strace|Reverse Engineering|Strace,Dynamic Analysis,Stack,Debugging"
)

# Fonction pour traiter un fichier
process_file() {
  local source_file="$1"
  local dest_info="$2"
  
  # Extraire les informations
  IFS='|' read -r dest_dir title category tags <<< "$dest_info"
  
  # Créer un nom de fichier propre
  clean_name=$(echo "$source_file" | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]' | sed 's/-\+/-/g' | sed 's/^-//' | sed 's/-$//')
  
  # Créer le chemin complet
  dest_path="content/posts/$dest_dir"
  
  # S'assurer que le répertoire existe
  mkdir -p "$dest_path"
  
  # Ajouter frontmatter au début du fichier et conserver le contenu original
  cat > "$dest_path/$clean_name.md" << EOF
---
title: "$title"
date: $(date +"%Y-%m-%dT%H:%M:%S%:z")
draft: false
categories:
  - $category
tags:
$(echo "$tags" | tr ',' '\n' | sed 's/^/  - /')
toc: true
---

$(cat "$source_file")
EOF
  
  echo "Processed: $source_file -> $dest_path/$clean_name.md"
}

# Traiter chaque fichier
for file in "${!articles[@]}"; do
  if [ -f "$file" ]; then
    process_file "$file" "${articles[$file]}"
  else
    echo "Warning: File not found - $file"
  fi
done

# Créer des fichiers _index.md pour les sections principales
cat > "content/posts/web-security/_index.md" << EOF
---
title: "Web Security"
description: "Web application security techniques, vulnerabilities and exploitations"
---
EOF

cat > "content/posts/low-level/_index.md" << EOF
---
title: "Low Level"
description: "Low level programming, memory management, assembly and kernel internals"
---
EOF

cat > "content/posts/binary-exploitation/_index.md" << EOF
---
title: "Binary Exploitation"
description: "Techniques for exploiting vulnerabilities in binary applications"
---
EOF

cat > "content/posts/network/_index.md" << EOF
---
title: "Network"
description: "Network security, scanning and reconnaissance techniques"
---
EOF

cat > "content/posts/reverse-engineering/_index.md" << EOF
---
title: "Reverse Engineering"
description: "Analysis and understanding of compiled programs and binaries"
---
EOF

echo "Content organization completed. Only relevant articles preserved with improved categorization and tagging." 
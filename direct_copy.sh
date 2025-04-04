#!/bin/bash

# Créer les répertoires nécessaires
mkdir -p content/posts/low-level
mkdir -p content/posts/web-security
mkdir -p content/posts/exploits
mkdir -p content/posts/network
mkdir -p content/posts/reverse-engineering
mkdir -p content/posts/misc

# Supprimer les articles existants pour éviter les doublons
rm -f content/posts/low-level/*.md
rm -f content/posts/web-security/*.md
rm -f content/posts/exploits/*.md
rm -f content/posts/network/*.md
rm -f content/posts/reverse-engineering/*.md
rm -f content/posts/misc/*.md

# Fonction pour traiter un fichier markdown
process_file() {
  local file="$1"
  local dest_dir="$2"
  local title="$3"
  local category="$4"
  
  # Créer un nom de fichier propre
  clean_name=$(echo "$file" | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]' | sed 's/-\+/-/g' | sed 's/^-//' | sed 's/-$//')
  
  # Ajouter frontmatter au début du fichier et conserver le contenu original
  cat > "content/posts/$dest_dir/$clean_name.md" << EOF
---
title: "$title"
date: $(date +"%Y-%m-%dT%H:%M:%S%:z")
draft: false
categories:
  - $category
tags:
  - Cybersecurity
  - Notes
---

$(cat "$file")
EOF
  
  echo "Copied: $file -> content/posts/$dest_dir/$clean_name.md"
}

# Traiter chaque fichier par catégorie

# Web Security
process_file "Web Fuzzing - HTB Course Notes.md" "web-security" "Web Fuzzing Techniques" "Web Security"
process_file "LFI HTB Academy.md" "web-security" "LFI (Local File Inclusion) Exploitation" "Web Security"

# Low Level
process_file "Architecture Informatique de Bas Niveau et Sécurité Le Kernel et le Développement de Logiciels Malveillants.md" "low-level" "Low-Level Computer Architecture and Security" "Low Level"
process_file "📚 Cours sur la Gestion de la Mémoire brk, mmap et Structure de la Mémoire.md" "low-level" "Memory Management: brk, mmap and Memory Structure" "Low Level"
process_file "x86-64 NASM Assembly Language Registers, Calling Conventions and Examples.md" "low-level" "x86-64 Assembly: Registers, Calling Conventions and Examples" "Low Level"

# Exploits
process_file "Basic Format String.md" "exploits" "Format String Vulnerabilities" "Exploits"
process_file "Buffer Overflow PIE.md" "exploits" "Buffer Overflow with PIE" "Exploits"
process_file "Note on Binary exploitation from LiveOverflow.md" "exploits" "Binary Exploitation Techniques" "Exploits"

# Network
process_file "Network.md" "network" "Network Security" "Network"
process_file "Nmap Scan passif.md" "network" "Passive Nmap Scanning Techniques" "Network"

# Reverse Engineering
process_file "Strace (Analyse stack).md" "reverse-engineering" "Stack Analysis with Strace" "Reverse Engineering"
process_file "Htb Challenge Reverse.md" "reverse-engineering" "HTB Reverse Engineering Challenges" "Reverse Engineering"

# Misc Security
process_file "SCADA & ICS.md" "misc" "SCADA and ICS Security" "Misc"
process_file "Satellite.md" "misc" "Satellite Communications Security" "Misc"
process_file "SDR.md" "misc" "Software Defined Radio in Security" "Misc"

echo "All files have been copied with their original content preserved." 
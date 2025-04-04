#!/bin/bash

# Créer les répertoires de destination par catégorie
mkdir -p content/posts/web-security
mkdir -p content/posts/low-level
mkdir -p content/posts/exploits

# Supprimer les fichiers existants dans ces répertoires
rm -f content/posts/web-security/*.md
rm -f content/posts/low-level/*.md
rm -f content/posts/exploits/*.md

# Organiser les articles par catégorie avec traduction en anglais
# Catégorie: Web Security
process_web_files() {
  # Web Fuzzing
  if [ -f "Web Fuzzing - HTB Course Notes.md" ]; then
    cat > "content/posts/web-security/web-fuzzing-htb-course-notes-md.md" << EOF
---
title: "Web Fuzzing - HTB Course Notes"
date: $(date +"%Y-%m-%dT%H:%M:%S%:z")
draft: false
categories:
  - Web Security
tags:
  - Cybersecurity
  - Notes
---

$(cat "Web Fuzzing - HTB Course Notes.md")
EOF
    echo "Translated and moved: Web Fuzzing - HTB Course Notes.md -> content/posts/web-security/web-fuzzing-htb-course-notes-md.md"
  fi

  # LFI Exploitation
  if [ -f "LFI HTB Academy.md" ]; then
    cat > "content/posts/web-security/lfi-htb-academy-md.md" << EOF
---
title: "LFI Exploitation - HTB Academy Notes"
date: $(date +"%Y-%m-%dT%H:%M:%S%:z")
draft: false
categories:
  - Web Security
tags:
  - Cybersecurity
  - Notes
---

$(cat "LFI HTB Academy.md")
EOF
    echo "Translated and moved: LFI HTB Academy.md -> content/posts/web-security/lfi-htb-academy-md.md"
  fi
}

# Catégorie: Low Level
process_low_level_files() {
  # x86-64 Assembly
  if [ -f "x86-64 NASM Assembly Language Registers, Calling Conventions and Examples.md" ]; then
    cat > "content/posts/low-level/x86-64-nasm-assembly-language-registers-calling-conventions-and-examples-md.md" << EOF
---
title: "x86-64 Assembly Language: Registers, Calling Conventions and Examples"
date: $(date +"%Y-%m-%dT%H:%M:%S%:z")
draft: false
categories:
  - Low Level
tags:
  - Cybersecurity
  - Assembly
  - Notes
---

$(cat "x86-64 NASM Assembly Language Registers, Calling Conventions and Examples.md")
EOF
    echo "Translated and moved: x86-64 NASM Assembly Language Registers, Calling Conventions and Examples.md -> content/posts/low-level/x86-64-nasm-assembly-language-registers-calling-conventions-and-examples-md.md"
  fi

  # Memory Management
  if [ -f "📚 Cours sur la Gestion de la Mémoire brk, mmap et Structure de la Mémoire.md" ]; then
    cat > "content/posts/low-level/cours-sur-la-gestion-de-la-memoire-brk-mmap-et-structure-de-la-memoire-md.md" << EOF
---
title: "Memory Management: brk, mmap and Memory Structure"
date: $(date +"%Y-%m-%dT%H:%M:%S%:z")
draft: false
categories:
  - Low Level
tags:
  - Cybersecurity
  - Memory
  - Notes
---

$(cat "📚 Cours sur la Gestion de la Mémoire brk, mmap et Structure de la Mémoire.md")
EOF
    echo "Translated and moved: 📚 Cours sur la Gestion de la Mémoire brk, mmap et Structure de la Mémoire.md -> content/posts/low-level/cours-sur-la-gestion-de-la-memoire-brk-mmap-et-structure-de-la-memoire-md.md"
  fi

  # Low-Level Architecture
  if [ -f "Architecture Informatique de Bas Niveau et Sécurité Le Kernel et le Développement de Logiciels Malveillants.md" ]; then
    cat > "content/posts/low-level/architecture-informatique-de-bas-niveau-et-securite-le-kernel-et-le-developpement-de-logiciels-malveillants-md.md" << EOF
---
title: "Low-Level Computer Architecture and Security: Kernel and Malware Development"
date: $(date +"%Y-%m-%dT%H:%M:%S%:z")
draft: false
categories:
  - Low Level
tags:
  - Cybersecurity
  - Kernel
  - Malware
  - Notes
---

$(cat "Architecture Informatique de Bas Niveau et Sécurité Le Kernel et le Développement de Logiciels Malveillants.md")
EOF
    echo "Translated and moved: Architecture Informatique de Bas Niveau et Sécurité Le Kernel et le Développement de Logiciels Malveillants.md -> content/posts/low-level/architecture-informatique-de-bas-niveau-et-securite-le-kernel-et-le-developpement-de-logiciels-malveillants-md.md"
  fi
}

# Catégorie: Exploits
process_exploit_files() {
  # Format String
  if [ -f "Basic Format String.md" ]; then
    cat > "content/posts/exploits/basic-format-string-md.md" << EOF
---
title: "Format String Vulnerabilities: Basic Exploitation Techniques"
date: $(date +"%Y-%m-%dT%H:%M:%S%:z")
draft: false
categories:
  - Exploits
tags:
  - Cybersecurity
  - Binary Exploitation
  - Notes
---

$(cat "Basic Format String.md")
EOF
    echo "Translated and moved: Basic Format String.md -> content/posts/exploits/basic-format-string-md.md"
  fi
}

# Exécuter les fonctions de traitement
process_web_files
process_low_level_files
process_exploit_files

echo "Articles have been translated and organized by categories." 
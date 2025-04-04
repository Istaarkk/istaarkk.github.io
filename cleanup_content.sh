#!/bin/bash

# Arrêter Hugo avant de faire des modifications
pkill hugo || true

# Articles à conserver (les plus techniques et pertinents)
KEEP_ARTICLES=(
  # Web Security
  "content/posts/web-security/fuzzing/web-fuzzing-htb-course-notes-md.md"
  "content/posts/web-security/lfi/lfi-htb-academy-md.md"
  
  # Low Level
  "content/posts/low-level/assembly/x86-64-nasm-assembly-language-registers-calling-conventions-and-examples-md.md"
  "content/posts/low-level/memory/cours-sur-la-gestion-de-la-mémoire-brk-mmap-et-structure-de-la-mémoire-md.md"
  "content/posts/low-level/kernel/architecture-informatique-de-bas-niveau-et-sécurité-le-kernel-et-le-développement-de-logiciels-malveillants-md.md"
  
  # Binary Exploitation
  "content/posts/binary-exploitation/format-string/basic-format-string-md.md"
  "content/posts/binary-exploitation/buffer-overflow/buffer-overflow-pie-md.md"
  
  # Reverse Engineering
  "content/posts/reverse-engineering/strace-analyse-stack-md.md"
)

# Créer un répertoire temporaire pour sauvegarder les articles à conserver
mkdir -p /tmp/hugo_articles_backup

# Sauvegarder les articles à conserver
for article in "${KEEP_ARTICLES[@]}"; do
  if [ -f "$article" ]; then
    # Créer les répertoires nécessaires dans le backup
    dest_dir="/tmp/hugo_articles_backup/$(dirname "$article")"
    mkdir -p "$dest_dir"
    
    # Copier l'article
    cp "$article" "$dest_dir/"
    echo "Sauvegardé: $article"
  else
    echo "Article non trouvé: $article"
  fi
done

# Sauvegarder les fichiers _index.md
find content/posts -name "_index.md" -exec cp --parents {} /tmp/hugo_articles_backup \;

# Supprimer tous les articles
rm -rf content/posts/*

# Recréer la structure des répertoires
mkdir -p content/posts/web-security/fuzzing
mkdir -p content/posts/web-security/lfi
mkdir -p content/posts/low-level/memory
mkdir -p content/posts/low-level/assembly
mkdir -p content/posts/low-level/kernel
mkdir -p content/posts/binary-exploitation/format-string
mkdir -p content/posts/binary-exploitation/buffer-overflow
mkdir -p content/posts/reverse-engineering

# Restaurer les articles sauvegardés
cp -r /tmp/hugo_articles_backup/content/posts/* content/posts/

# Créer/mettre à jour les fichiers _index.md pour les sections principales
cat > "content/posts/web-security/_index.md" << EOF
---
title: "Web Security"
description: "Advanced web application security techniques and exploitations"
---
EOF

cat > "content/posts/low-level/_index.md" << EOF
---
title: "Low Level"
description: "System internals, memory management, assembly and kernel security"
---
EOF

cat > "content/posts/binary-exploitation/_index.md" << EOF
---
title: "Binary Exploitation"
description: "Advanced techniques for exploiting binary vulnerabilities"
---
EOF

cat > "content/posts/reverse-engineering/_index.md" << EOF
---
title: "Reverse Engineering"
description: "Techniques for analyzing and understanding binary code"
---
EOF

echo "Le contenu a été nettoyé. Seuls les articles les plus pertinents ont été conservés." 
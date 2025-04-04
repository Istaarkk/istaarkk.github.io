#!/usr/bin/env python3

import os
import re
import sys
import glob
import frontmatter

try:
    from googletrans import Translator
    translator = Translator()
except ImportError:
    print("La bibliothèque googletrans n'est pas installée.")
    print("Installez-la avec: pip install googletrans==4.0.0-rc1")
    sys.exit(1)

def translate_text(text, dest='en'):
    """Traduit le texte du français vers l'anglais."""
    try:
        # Traduire le texte
        result = translator.translate(text, dest=dest)
        return result.text
    except Exception as e:
        print(f"Erreur lors de la traduction: {e}")
        return text

def translate_markdown_file(file_path):
    """Traduit le contenu d'un fichier markdown."""
    print(f"Traduction du fichier: {file_path}")
    
    try:
        # Charger le fichier avec frontmatter
        post = frontmatter.load(file_path)
        
        # Extraire le contenu
        content = post.content
        
        # Trouver tous les blocs de code
        code_blocks = re.findall(r'```[\s\S]*?```', content)
        
        # Remplacer temporairement les blocs de code par des marqueurs
        for i, block in enumerate(code_blocks):
            content = content.replace(block, f"CODE_BLOCK_{i}")
        
        # Traduire le contenu
        translated_content = translate_text(content)
        
        # Remettre les blocs de code
        for i, block in enumerate(code_blocks):
            translated_content = translated_content.replace(f"CODE_BLOCK_{i}", block)
        
        # Mettre à jour le contenu
        post.content = translated_content
        
        # Sauvegarder le fichier
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(frontmatter.dumps(post))
        
        print(f"Traduction terminée pour: {file_path}")
    except Exception as e:
        print(f"Erreur lors de la traduction du fichier {file_path}: {e}")

def main():
    # Tous les articles dans les catégories
    markdown_files = glob.glob('content/posts/**/*.md', recursive=True)
    
    for file_path in markdown_files:
        translate_markdown_file(file_path)
    
    print("Traduction de tous les articles terminée!")

if __name__ == "__main__":
    main() 
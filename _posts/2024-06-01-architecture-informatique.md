---
layout: post
title: "Architecture Informatique de Bas Niveau et Sécurité"
date: 2024-06-01
categories: low-level
tags: kernel security malware architecture
---

# Architecture Informatique de Bas Niveau et Sécurité

## Introduction Générale

L'architecture informatique de bas niveau est une discipline fondamentale pour tout ingénieur en informatique. Elle permet de comprendre les interactions entre les composants matériels et logiciels d'un système et leur fonctionnement à un niveau élémentaire. Ce livre aborde les concepts essentiels pour comprendre l'architecture informatique moderne, avec un accent particulier sur le **kernel** du système d'exploitation et la manière dont les logiciels malveillants (maldev) exploitent cette architecture pour pénétrer les systèmes.

Le livre est structuré en sept chapitres :

1. **L'architecture matérielle et logicielle d'un système**
2. **Le jeu d'instructions et l'exécution des programmes**
3. **Le rôle et l'architecture du système d'exploitation**
4. **Le kernel : structure et fonctionnement**
5. **La gestion des ressources par le kernel**
6. **Le développement de logiciels malveillants : introduction et techniques**
7. **Exploitation avancée et contre-mesures en sécurité**

## Chapitre 1 : Introduction à l'Architecture Informatique

### 1.1. L'Architecture Informatique : Définition et Histoire

L'architecture informatique désigne l'organisation et la structure des composants d'un ordinateur. Elle comprend à la fois les éléments matériels et logiciels qui interagissent pour exécuter des programmes.

Historiquement, l'architecture de Von Neumann a servi de base à la conception des ordinateurs modernes. Proposée par John von Neumann en 1945, cette architecture repose sur une mémoire partagée pour les instructions et les données. Si cette conception a permis d'obtenir une flexibilité sans précédent, elle entraîne également un **goulot d'étranglement** : les instructions et les données doivent emprunter le même chemin pour accéder à la mémoire, ce qui peut ralentir le processus.

En revanche, l'architecture **Harvard** permet de séparer les mémoires d'instructions et de données, offrant ainsi des performances améliorées. Cependant, elle est plus complexe à implémenter.

## Chapitre 2 : Le Jeu d'Instructions et l'Interaction Matériel/Logiciel

### 2.1. Le Jeu d'Instructions (ISA)

Le **jeu d'instructions** (Instruction Set Architecture, ISA) est l'ensemble des instructions que le processeur peut comprendre et exécuter. Les principaux types d'ISA sont :

- **CISC (Complex Instruction Set Computing)** : Chaque instruction peut effectuer plusieurs opérations.
- **RISC (Reduced Instruction Set Computing)** : Les instructions sont simples et rapides, mais nécessitent plus d'instructions pour effectuer des tâches complexes.

## Chapitre 3 : Exploitation et Sécurité

Les logiciels malveillants exploitent souvent des failles dans le kernel, les drivers ou des vulnérabilités dans les applications. Parmi les techniques utilisées :

- **Exploitation de buffers overflow** : Permet à un attaquant d'écrire du code malveillant dans des zones mémoires non protégées.
- **Injection de code** : Injecte du code malveillant dans des processus légitimes.
- **Exploitation des vulnérabilités d'un OS** : Par exemple, des failles dans la gestion de la mémoire.

## Conclusion

La compréhension de l'architecture informatique de bas niveau est essentielle pour développer des solutions de sécurité efficaces et pour comprendre les mécanismes d'attaque modernes. 
Infrastructure DevOps - Terraform + Ansible + Jenkins

Ce projet est une démonstration complète d'une infrastructure DevOps automatisée. Il permet de créer des machines virtuelles sur Google Cloud Platform (GCP) avec Terraform, de les configurer avec Ansible, et de piloter l'ensemble via un pipeline Jenkins.

Objectifs

Création de VMs front, back et db sur GCP

Automatisation du provisionnement avec Terraform

Configuration des VMs avec Ansible

Intégration CI/CD avec Jenkins (multi-branches)

Arborescence principale

.
├── .gitignore
├── Jenkinsfile
├── ansible.cfg
├── hosts.ini
├── main.tf
├── roles
│   ├── front/
│   ├── back/
│   └── db/
├── site.yml
└── terraform.tfstate (ignoré)

Prérequis

Un projet GCP configuré (avec API Compute Engine activée)

Un fichier JSON de clé de compte de service (non versionné)

Jenkins installé avec les plugins Git, Terraform, Ansible

Une machine Jenkins avec la clé SSH correspondante aux métadonnées GCP

Déploiement avec Jenkins

Jenkins déclenche le pipeline depuis GitHub

Le stage Terraform initialise et applique l'infrastructure sur GCP

Le stage Ansible exécute un playbook sur les VMs provisionnées

Fichiers importants

main.tf

Crée dynamiquement 3 VMs avec des noms, tags et labels (front, back, db).

site.yml

Playbook Ansible lié à des rôles pour configurer chaque VM.

Jenkinsfile

Pipeline déclaratif divisé en trois stages : checkout, terraform, ansible.

Sécurité

Les fichiers sensibles (.json, .tfstate, etc.) sont ignorés via .gitignore

Le fichier JSON GCP ne doit jamais être versionné

Possibilité d'utiliser Vault ou Google Secret Manager à l'avenir

TODO futur

Ajouter des tests de déploiement (Ansible lint, Terraform validate)

Stocker les tfstate sur un bucket distant (backend)

Intégrer Vault pour gérer les secrets

Ajouter des tags GitHub Actions ou badges Jenkins

Ce projet est un excellent point de départ pour comprendre l'enchaînement infrastructure-as-code + configuration + automatisation DevOps.

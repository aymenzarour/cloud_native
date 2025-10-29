# 🚀 Ma Plateforme Cloud Native

Ce projet documente la construction et le déploiement d'une plateforme cloud native complète sur Kubernetes. L'objectif est d'automatiser l'infrastructure (IaC) et les déploiements (GitOps) à l'aide d'outils modernes.

## 🗺️ Vision du Projet

Ce dépôt n'est pas seulement un ensemble de scripts Ansible. Il sert de base pour une plateforme complète qui inclura :
* **Phase 1 : Bootstrap (terminée)** - Installation automatisée des services de base (Stockage, GitOps).
* **Phase 2 : Déploiement d'Applications** - Utilisation d'ArgoCD pour gérer les applications de la plateforme.
* **Phase 3 : Observabilité** - Ajout d'une stack de monitoring (ex: Prometheus, Grafana).
* ...et plus encore.

---

## Phase 1 : Bootstrap (Ansible)

La première phase de ce projet utilise **Ansible** pour initialiser le cluster Kubernetes avec les services essentiels.

### 📦 Composants Installés

* 🐃 **Longhorn** : Solution de stockage bloc persistant distribué.
* ⛵ **ArgoCD** : Outil de déploiement continu (GitOps).

### 📋 Prérequis

Avant de lancer le bootstrap, assurez-vous que votre machine de contrôle dispose de :

1.  Un cluster Kubernetes fonctionnel (ex: k3s, Kind, etc.).
2.  `kubectl` configuré pour accéder à ce cluster.
3.  `ansible` (ex: `sudo apt install ansible`).
4.  Le binaire `helm` (voir [helm.sh](https://helm.sh/docs/intro/install/)).
5.  Les dépendances Ansible pour Kubernetes :
    ```bash
    ansible-galaxy collection install kubernetes.core
    sudo apt install python3-kubernetes python3-openshift
    ```
6.  Les dépendances Longhorn (à installer sur **tous les nœuds** du cluster) :
    ```bash
    sudo apt install open-iscsi nfs-common
    ```

### ⚙️ Lancer le Bootstrap

1.  Naviguez vers le dossier `ansible` :
    ```bash
    cd ansible
    ```
2.  Exécutez le playbook principal :
    ```bash
    ansible-playbook -i inventory.ini install.yaml
    ```
    Le script va :
    * Tester la connexion à K8s.
    * Installer Longhorn (depuis `playbooks/longhorn.yaml`).
    * Installer ArgoCD (depuis `playbooks/argocd.yaml`).

---

## 🔌 Accès aux Services

Pour accéder aux interfaces web de Longhorn et ArgoCD, un script est fourni pour configurer les services en `NodePort`.

1.  Assurez-vous d'être à la racine du projet (`cloud_native/`).
2.  Rendez le script exécutable :
    ```bash
    chmod +x scripts/expose-services.sh
    ```
3.  Exécutez le script :
    ```bash
    ./scripts/expose-services.sh
    ```
    Le script affichera les URL d'accès direct, les ports, ainsi que les identifiants de connexion pour ArgoCD.


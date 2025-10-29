#!/bin/bash

# Quitte immédiatement si une commande échoue
set -e

echo "--- 1. Configuration des services ---"

echo "Mise à jour du service ArgoCD en NodePort..."
kubectl patch service argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

echo "Mise à jour du service Longhorn UI en NodePort..."
kubectl patch service longhorn-frontend -n longhorn-system -p '{"spec": {"type": "NodePort"}}'

echo "Patientez 5 secondes pendant l'assignation des ports..."
sleep 5

echo "--- 2. Récupération des accès ---"

# Récupérer les ports
ARGO_PORT=$(kubectl get service -n argocd argocd-server -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
LH_PORT=$(kubectl get service -n longhorn-system longhorn-frontend -o jsonpath='{.spec.ports[0].nodePort}')

# Récupérer l'IP de la VM
VM_IP=$(hostname -I | awk '{print $1}')

# Récupérer le mot de passe ArgoCD
echo "Récupération du mot de passe ArgoCD..."
# Nous stockons d'abord la donnée en base64
ARGO_PASS_B64=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 2>/dev/null)

if [[ -n "$ARGO_PASS_B64" ]]; then
    # Si la donnée existe, on la décode
    ARGO_PASS=$(echo "$ARGO_PASS_B64" | base64 -d)
else
    # Sinon, le secret a probablement été supprimé (ce qui est normal après un changement de mdp)
    ARGO_PASS="<Secret 'argocd-initial-admin-secret' non trouvé. Le mot de passe a-t-il déjà été changé/supprimé?>"
fi


# --- 3. Affichage des résultats ---

echo ""
echo "-------------------------------------------------------------------"
echo "✅ Configuration terminée !"
echo ""
echo "ArgoCD :"
echo "  URL :          https://$VM_IP:$ARGO_PORT"
echo "  Utilisateur :  admin"
echo "  Mot de passe : $ARGO_PASS"
echo ""
echo "Longhorn UI :"
echo "  URL :          http://$VM_IP:$LH_PORT"
echo "  Identifiants : (Aucun par défaut - L'interface est ouverte)"
echo "-------------------------------------------------------------------"
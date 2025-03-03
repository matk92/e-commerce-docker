#!/bin/bash

REGISTRY="ghcr.io"
USERNAME="deathfal"
STACK_NAME="ecommerce"
DEPLOY_PATH="/home/adam/e-commerce"

echo "Démarrage du déploiement..."

echo "Pull des nouvelles images..."
docker pull $REGISTRY/$USERNAME/e-commerce-frontend:latest
docker pull $REGISTRY/$USERNAME/e-commerce-auth-service:latest
docker pull $REGISTRY/$USERNAME/e-commerce-product-service:latest
docker pull $REGISTRY/$USERNAME/e-commerce-order-service:latest

if ! docker info | grep -q "Swarm: active"; then
    echo "Initialisation du Swarm..."
    docker swarm init
fi

mkdir -p $DEPLOY_PATH

echo "Déploiement de la stack..."
docker stack deploy -c docker-compose.swarm.yml $STACK_NAME --with-registry-auth

echo "Vérification des services..."
docker service ls | grep $STACK_NAME

echo " Déploiement terminé"

check_service() {
    local service=$1
    if [ "$(docker service ls -f name=$STACK_NAME_$service -q)" ]; then
        if [ "$(docker service ps $STACK_NAME_$service --format '{{.Error}}')" ]; then
            echo "⚠️ Erreur détectée dans $service. Logs:"
            docker service logs $STACK_NAME_$service
        fi
    fi
}

check_service "frontend"
check_service "auth-service"
check_service "product-service"
check_service "order-service"

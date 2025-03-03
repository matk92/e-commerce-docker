#!/bin/bash

# Pull latest changes from git
git pull origin main

REGISTRY="ghcr.io"
USERNAME="deathfal"
STACK_NAME="ecommerce"
DEPLOY_PATH="/home/adam/e-commerce"

echo "Démarrage du déploiement..."

# Check if Docker swarm is initialized
if ! docker info | grep -q "Swarm: active"; then
    echo "Initialisation du Swarm..."
    docker swarm init
fi

mkdir -p $DEPLOY_PATH

# Pull the latest images
echo "Pull des nouvelles images..."
docker compose -f docker-compose.swarm.yml pull

echo "Déploiement de la stack..."
docker stack deploy -c docker-compose.swarm.yml $STACK_NAME --with-registry-auth

# Wait for services to be updated
echo "Waiting for services to be updated..."
for service in $(docker service ls --filter name=$STACK_NAME --format "{{.Name}}"); do
    echo "Waiting for $service..."
    docker service update --quiet --detach=false $service > /dev/null
    if [ $? -eq 0 ]; then
        echo "$service successfully updated"
    else
        echo "Error updating $service"
        exit 1
    fi
done

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

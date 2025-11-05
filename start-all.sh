#!/bin/bash

echo "🚀 Starting all services..."

# Start Traefik
echo "▶️  Starting Traefik..."
cd traefik && docker compose up -d && cd ..

# Start PostgreSQL
echo "▶️  Starting PostgreSQL..."
cd postgresql && docker compose up -d && cd ..

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 5

# Start Evolution API
echo "▶️  Starting Evolution API..."
cd evolution-api && docker compose up -d && cd ..

echo "✅ All services started successfully!"
docker ps

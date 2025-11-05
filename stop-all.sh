#!/bin/bash

echo "🛑 Stopping all services..."

# Stop Evolution API
echo "⏹️  Stopping Evolution API..."
cd evolution-api && docker compose down && cd ..

# Stop PostgreSQL
echo "⏹️  Stopping PostgreSQL..."
cd postgresql && docker compose down && cd ..

# Stop Traefik
echo "⏹️  Stopping Traefik..."
cd traefik && docker compose down && cd ..

echo "✅ All services stopped successfully!"

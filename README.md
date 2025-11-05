# Docker Traefik + Evolution API + PostgreSQL

Complete development stack with Traefik as reverse proxy, automatic SSL certificates with Let's Encrypt, PostgreSQL 17, and Evolution API v2.

## 📋 Project Structure

```
evolution-docker/
├── traefik/              # Reverse proxy with automatic SSL
├── postgresql/           # PostgreSQL 17 database
├── evolution-api/        # Evolution API v2 with custom configuration
├── build-all.sh          # Script to build all services
├── start-all.sh          # Script to start all services
├── stop-all.sh           # Script to stop all services
└── install-docker.sh     # Script to install Docker (optional)
```

## 🚀 Quick Start

### 0. Install Docker (Optional)

If you don't have Docker installed, run the installation script with sudo:

```bash
sudo ./install-docker.sh
```

After installation, log out and log back in for the changes to take effect, or run:

```bash
newgrp docker
```

Then you can use Docker without sudo.

### 1. Configure Docker Networks

```bash
docker network create traefik-network
docker network create postgres-network
```

### 2. Configure Let's Encrypt Permissions

```bash
mkdir -p traefik/letsencrypt
touch traefik/letsencrypt/acme.json
chmod 600 traefik/letsencrypt/acme.json
```

### 3. Configure Domains

Edit the `.env` files in each folder:

#### traefik/.env

```env
LETS_ENCRYPT_CONTACT_EMAIL=your-email@example.com
DOMAIN_NAME=traefik.yourdomain.com
```

#### postgresql/.env

```env
POSTGRES_DB=evolution
POSTGRES_PASSWORD=evolution_password
POSTGRES_USER=evolution
```

#### evolution-api/.env

**Important:** Update the following variables:

```env
# Domain configuration
DOMAIN=evolution.yourdomain.com

# API Authentication - CHANGE THIS!
AUTHENTICATION_API_KEY=change-me-to-a-secure-key

# Database Configuration
DATABASE_ENABLED=true
DATABASE_PROVIDER=postgresql
DATABASE_CONNECTION_URI=postgresql://evolution:evolution_password@postgresql:5432/evolution

# Server Configuration
SERVER_URL=https://evolution.yourdomain.com
```

> **Note:** Make sure to change `AUTHENTICATION_API_KEY` to a secure random string. You can generate one using: `openssl rand -hex 32`

### 4. Build and Start Services

```bash
# Build all services
./build-all.sh

# Start all services
./start-all.sh

# Check status
docker ps
```

## 🌐 Service Access

After starting all services, you can access:

- **Evolution API**: https://evolution.yourdomain.com
- **Traefik Dashboard**: https://traefik.yourdomain.com
- **API Documentation**: https://evolution.yourdomain.com/manager

## ⚙️ Domain Configuration

### Change Evolution API Domain

Edit `evolution-api/.env`:

```env
DOMAIN=your-new-domain.com
SERVER_URL=https://your-new-domain.com
```

### Change Traefik Domain

Edit `traefik/.env`:

```env
DOMAIN_NAME=traefik.your-new-domain.com
```

## 🛠️ Management Scripts

### build-all.sh

Builds all Docker images for the services.

```bash
./build-all.sh
```

### start-all.sh

Starts all services in the correct order (Traefik → PostgreSQL → Evolution API).

```bash
./start-all.sh
```

### stop-all.sh

Stops all services in reverse order.

```bash
./stop-all.sh
```

## 📦 Included Services

### Traefik (Reverse Proxy)

- Automatic SSL certificate generation with Let's Encrypt
- HTTP to HTTPS redirection
- Dashboard on port 8080
- Custom size limits for file uploads

### PostgreSQL

- Version 17
- Persistent data storage
- Isolated network for database connections

### Evolution API v2

- WhatsApp integration API
- Supports Baileys and WhatsApp Business API
- PostgreSQL database integration
- Automatic SSL via Traefik
- Instance data persistence

## 🔧 Useful Commands

### View service logs

```bash
# Evolution API logs
cd evolution-api && docker compose logs -f

# PostgreSQL logs
cd postgresql && docker compose logs -f

# Traefik logs
cd traefik && docker compose logs -f
```

### Restart a specific service

```bash
cd evolution-api && docker compose restart
```

### Rebuild a service

```bash
cd evolution-api && docker compose up -d --build
```

### Check network status

```bash
docker network ls
docker network inspect traefik-network
docker network inspect postgres-network
```

## 🔒 Security

- Always change the default `AUTHENTICATION_API_KEY` in `evolution-api/.env`
- Use strong passwords for PostgreSQL
- Keep your email updated in Traefik for Let's Encrypt notifications
- The `acme.json` file must have 600 permissions for Let's Encrypt to work

## 📝 Important Notes

- Make sure ports 80, 443, and 8080 are available on your server
- DNS records must point to your server before starting services
- Let's Encrypt certificates are automatically renewed by Traefik
- All data is persisted in Docker volumes

## 🐛 Troubleshooting

### Error: "network not found"

Make sure you created the networks:

```bash
docker network create traefik-network
docker network create postgres-network
```

### Error: "acme.json permission denied"

Fix the permissions:

```bash
chmod 600 traefik/letsencrypt/acme.json
```

### Evolution API doesn't connect to PostgreSQL

1. Check if PostgreSQL is running: `cd postgresql && docker compose ps`
2. Verify the connection string in `evolution-api/.env`
3. Check PostgreSQL logs: `cd postgresql && docker compose logs`

### SSL certificate not generated

1. Verify your domain points to the server IP
2. Check Traefik logs: `cd traefik && docker compose logs`
3. Ensure ports 80 and 443 are open in your firewall
4. Verify the email in `traefik/.env` is correct

### Evolution API returns 401 Unauthorized

Make sure you're sending the `apikey` header with the value from `AUTHENTICATION_API_KEY` in your requests:

```bash
curl -X GET https://evolution.yourdomain.com/instance/fetchInstances \
  -H "apikey: your-api-key-here"
```

## 📚 Additional Resources

- [Evolution API Documentation](https://doc.evolution-api.com/)
- [Evolution API GitHub](https://github.com/EvolutionAPI/evolution-api)
- [Traefik Documentation](https://doc.traefik.io/traefik/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 📄 License

This project is open source and available under the MIT License.

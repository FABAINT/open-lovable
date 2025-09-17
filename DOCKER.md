# Docker Deployment Guide

This guide explains how to run the Open Lovable application using Docker.

## Prerequisites

- Docker and Docker Compose installed
- Environment variables configured

## Environment Variables Setup

### 1. Copy the environment template
```bash
cp .env.example .env.local
```

### 2. Configure Required Variables

Edit `.env.local` with your actual API keys and settings:

#### Required
- `FIRECRAWL_API_KEY` - Get from [Firecrawl](https://firecrawl.dev)

#### Sandbox Provider (Choose ONE)

**Option A: Vercel Sandbox (Recommended)**
```bash
SANDBOX_PROVIDER=vercel

# Method 1: OIDC Token (Development)
VERCEL_OIDC_TOKEN=your_token_here

# Method 2: Personal Access Token (Production)
VERCEL_TEAM_ID=team_xxxxxxxxx
VERCEL_PROJECT_ID=prj_xxxxxxxxx  
VERCEL_TOKEN=vercel_xxxxxxxxxxxx
```

**Option B: E2B Sandbox**
```bash
SANDBOX_PROVIDER=e2b
E2B_API_KEY=your_e2b_api_key
```

#### AI Providers (Need at least one)

**Recommended: AI Gateway**
```bash
AI_GATEWAY_API_KEY=your_ai_gateway_key
```

**Individual Provider Keys**
```bash
ANTHROPIC_API_KEY=your_anthropic_key
OPENAI_API_KEY=your_openai_key
GEMINI_API_KEY=your_gemini_key
GROQ_API_KEY=your_groq_key
```

## Deployment Options

### Option 1: Docker Compose (Recommended)

**Production:**
```bash
docker-compose up --build
```

**Development (with hot reload):**
```bash
docker-compose --profile dev up --build dev
```

### Option 2: Docker Commands

**Build the image:**
```bash
docker build -t open-lovable .
```

**Run production container:**
```bash
docker run -p 3000:3000 --env-file .env.local open-lovable
```

**Run development container:**
```bash
docker build -f Dockerfile.dev -t open-lovable-dev .
docker run -p 3000:3000 -v $(pwd):/app --env-file .env.local open-lovable-dev
```

## Container Access

The application will be available at:
- **http://localhost:3000**

## Environment Variable Handling

The Docker setup handles environment variables in multiple ways:

1. **`.env.local` file** - Automatically loaded by docker-compose
2. **Environment variables** - Passed through docker-compose.yml
3. **Default values** - Some variables have defaults (e.g., `SANDBOX_PROVIDER=vercel`)

## Security Notes

- Never commit `.env.local` to version control
- Use `.env.example` as a template
- In production, consider using Docker secrets or external secret management
- The `.dockerignore` excludes sensitive files from the build context

## Troubleshooting

### Common Issues

1. **Missing environment variables**
   - Check that `.env.local` exists and contains required keys
   - Verify docker-compose is loading the env file

2. **Port conflicts**
   - Change the port mapping in docker-compose.yml if 3000 is occupied
   - Example: `"3001:3000"` to use port 3001

3. **Build failures**
   - Clear Docker cache: `docker system prune`
   - Rebuild without cache: `docker-compose build --no-cache`

4. **Permission issues**
   - The container runs as non-root user `nextjs` for security
   - Check file permissions if mounting volumes

### Logs

**View application logs:**
```bash
docker-compose logs -f app
```

**View development logs:**
```bash
docker-compose logs -f dev
```

## Production Considerations

- Use specific image tags instead of `latest`
- Implement health checks
- Use multi-container setups with reverse proxy (nginx)
- Consider using orchestration platforms (Kubernetes, Docker Swarm)
- Set up proper monitoring and logging
- Use external databases and Redis for scalability
# devops-blog

## Overview

A personal blog built with Hugo, deployed to a local k3s cluster. Multi-stage container build — no local Hugo binary required.

## Architecture

```
hugo-site/          # Hugo source + content
├── content/        # Blog posts (Markdown)
├── static/         # Images, assets
├── themes/         # Hugo themes (Ananke)
├── nginx/          # Nginx config for serving
└── config.toml     # Hugo site config

container/
└── Containerfile    # Multi-stage: Hugo build → Nginx serve

manifests/
├── deployment.yaml  # k3s Deployment + Service
└── ingress.yaml     # Traefik Ingress

scripts/
├── build.sh         # Build container image
└── deploy.sh        # Deploy to k3s
```

## Prerequisites

- [Podman](https://podman.io) (or Docker)
- [Kubectl](https://kubernetes.io/docs/reference/kubectl/) (for deployment)
- Optional: `figlet` + `lolcat` for styled output

## Build

```bash
# Build the container image (includes Hugo build + Nginx)
./scripts/build.sh

# Result: localhost/devopsblog:latest
```

## Run Locally

```bash
# Run container locally
podman run -d -p 8080:80 --name devopsblog localhost/devopsblog:latest

# Access: http://localhost:8080
```

## Deploy to k3s

```bash
# Load image into k3s (if building locally)
sudo k3s ctr images import <(podman save localhost/devopsblog:latest --format oci-archive)

# Or push to registry and use that image in manifests

# Deploy
./scripts/deploy.sh

# Access: http://blog.odesa.local (via Ingress)
```

## Writing Posts

1. Create Markdown file in `hugo-site/content/posts/`
2. Include Hugo frontmatter:
   ```yaml
   ---
   title: "Post Title"
   date: 2024-01-15T10:00:00-05:00
   draft: false
   ---
   ```
3. Rebuild and redeploy

## Theme

- **Ananke** — Default Hugo theme
- Configured in `hugo-site/config.toml`

## TODO

- [ ] Add actual blog posts
- [ ] Configure TLS/HTTPS for Ingress
- [ ] Add CI/CD pipeline (GitHub Actions)
- [ ] Add Ansible playbook for bare-metal deployment
- [ ] Migrate from k3s Traefik to custom ingress controller

## License

Personal use. Content © Jorge Villavicencio.

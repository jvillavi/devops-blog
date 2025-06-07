# devops-blog

## Overview

devops-blog is a personal blog project documenting Jorge's journey, experiments, and learnings in the world of DevOps. The blog is built using [Hugo](https://gohugo.io) for static site generation and is designed to be deployed in modern cloud-native environments. It covers topics such as containerization, Kubernetes deployments, CI/CD pipelines, infrastructure as code, and GitOps practices.

The project aims to serve as both a technical reference and a record of real-world DevOps challenges and solutions, with a focus on practical implementation and automation.

**Key Features:**
- Static site generation with Hugo
- Themed with custom and community Hugo themes
- Containerized build and deployment using Podman
- Kubernetes manifests for k3s deployment
- Infrastructure automation goals (AWS, Terraform, GitOps)

**Main Goals**

| Priority | Task | Completion |
|----------|------|------------|
| 1 | Functional blog generation - by hand | ✅ |
| 2 | Functional container image including static assets | ✅ |
| 3 | Deployment to k3s | |
| 4 | Multi-stage containers | |
| 5 | Full build and deploy pipelines | |
| 6 | AWS Infrastructure - S3 + CloudFront + Shield | |
| 7 | Terraform Integration | |
| 8 | GitOps - Maybe Tekton | |

**Dependencies**

- [Hugo](https://gohugo.io)
- [Lolcat](https://github.com/busyloop/lolcat)
- [Figlet](http://www.figlet.org)
- [Podman](https://podman.io)
- [Kubectl](https://kubernetes.io/docs/reference/kubectl/)

**Build Instructions**

1. Clone the project (with dependencies):

```
git clone $REPO --recurse-submodules
```

2. Build the static site and container image:

```
cd build
sh build.sh
```

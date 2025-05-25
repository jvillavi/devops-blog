# devops-blog

## My Devops misadventures blog
- by: @jvillavi

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

1. Cloning the project (with dependencies)

```
git clone $REPO --recurse-submodules
```

2. Execute Hugo and make container image

```
cd build
sh build.sh
```

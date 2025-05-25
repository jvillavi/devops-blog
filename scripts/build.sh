#!/bin/bash

WELCOME_MSG="jvillavi DevOps Blog"
HUGO_SITE_PATH="../hugo-site"
CONTAINERFILE_LOC="../container/Containerfile"

# Pre-requisites checks
is_figlet_available() {
    figlet -v "$1" >/dev/null 2>&1
}

is_lolcat_available() {
    lolcat -v "$1" >/dev/null 2>&1
}

is_podman_available() {
    podman -v "$1" >/dev/null 2>&1
}

if ! is_podman_available; then
    echo "😵 Podman is not installed. Please install Podman to continue"
    exit 1
fi

if is_figlet_available && is_lolcat_available; then
    figlet $WELCOME_MSG | lolcat
else
    echo $WELCOME_MSG
fi

echo "--------------------------------------------------"
echo "WORKING DIRECTORY: $(pwd)"
echo "HUGO SITE PATH: $HUGO_SITE_PATH"
echo "CONTAINERFILE LOC: $CONTAINERFILE_LOC"
echo "--------------------------------------------------"


echo "Building the Hugo site..."
hugo -D -s $HUGO_SITE_PATH
if [ $? -ne 0 ]; then
    echo "😵 Hugo build failed. Please check the output for errors."
    exit 1
fi

echo "Building the container image..."
podman build -t devopsblog -f $CONTAINERFILE_LOC $HUGO_SITE_PATH
if [ $? -ne 0 ]; then
    echo "🔥 Podman build failed. Please check the output for errors."
    exit 1
fi

# podman run -d -p 8080:80 --name devopsblog localhost/devopsblog
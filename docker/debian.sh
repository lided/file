#!/bin/bash

set -e

URL="https://mirrors.aliyun.com/docker-ce/linux/debian"

sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL "$URL/gpg" -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc


echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://mirrors.aliyun.com/docker-ce/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
&& sudo systemctl enable docker && sudo systemctl restart docker

if ! systemctl is-active --quiet docker; then
    echo "Error: Docker service failed to start!" >&2
    exit 1
fi

read -p "run hello-world to test ? [Y/n]": yn
case "${yn,,}" in  # 转换为小写
    y|yes|"") 
        sudo docker run --rm hello-world
        ;;
    *)
        echo "Skipping test."
        ;;
esac

#!/bin/ash
set -e

echo ">> Cloning Alpine aports repo"
git clone --depth=1 https://gitlab.alpinelinux.org/alpine/aports.git /builder/aports

echo ">> Copiando perfil personalizado..."
cp /builder/mkimg.k3shelm.sh /builder/aports/scripts/
cp /builder/genapkovl-k3shelm.sh /builder/aports/scripts/

echo ">> Downloading k3s..."
curl -L https://github.com/k3s-io/k3s/releases/download/v1.29.4%2Bk3s1/k3s -o /builder/k3s
chmod +x /builder/k3s

echo ">> Downloading helm..."
curl -L https://get.helm.sh/helm-v3.14.4-linux-amd64.tar.gz -o /builder/helm.tar.gz
tar -xzf /builder/helm.tar.gz -C /builder
mv /builder/linux-amd64/helm /builder/helm
chmod +x /builder/helm
rm -rf /builder/linux-amd64 /builder/helm.tar.gz

echo ">> Generating ISO..."
set -x
#export _abuild_pubkey=/etc/apk/keys/alpine-devel@lists.alpinelinux.org-4a6a0840.rsa.pub
sed -i 's|_abuild_pubkey=|_abuild_pubkey=/usr/share/apk/keys/alpine-devel@lists.alpinelinux.org-6165ee59.rsa.pub|' /builder/aports/scripts/mkimage.sh
sh /builder/aports/scripts/mkimage.sh --tag edge --outdir /builder/output --arch x86_64 --repository https://dl-cdn.alpinelinux.org/alpine/edge/main --profile k3shelm > /builder/output/mkimage.log 2>&1


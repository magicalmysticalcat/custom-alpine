FROM alpine:edge

RUN apk add --no-cache \
    alpine-sdk \
    grub-efi \
    grub \
    xorriso \
    dosfstools \
    mtools \
    ca-certificates \
    openssl \
    abuild \
    bash \
    curl \
    alpine-conf

WORKDIR /builder

COPY ./builder/mkimage.sh /builder/
COPY ./builder/mkimg.k3shelm.sh /builder/
COPY ./builder/genapkovl-k3shelm.sh /builder/
COPY ./run.sh /builder/

RUN chmod +x /builder/*.sh

ENV _abuild_pubkey=/usr/share/apk/keys/alpine-devel@lists.alpinelinux.org-6165ee59.rsa.pub

ENTRYPOINT ["/bin/ash", "/builder/run.sh"]

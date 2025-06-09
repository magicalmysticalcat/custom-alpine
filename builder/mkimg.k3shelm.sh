profile_k3shelm() {
    profile_standard
    kernel_flavors="lts"
    initfs_features="ata base bootchart cdrom ext4 mmc nvme raid scsi squashfs usb virtio"
    apks="alpine-base bash openrc ca-certificates"
    apkovl="./genapkovl-k3shelm.sh"
    kernel_cmdline="console=tty0"
    modloop_sign="no" 
}

section_modloop() {
    echo "Skipping modloop"
}

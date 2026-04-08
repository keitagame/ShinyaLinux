#!/bin/bash
echo "Shinya Linux Build Script"
# 作業ディレクトリ作成
mkdir -p build/chroot
# 最小構成のDebian (Bookworm等) をダウンロード
debootstrap --arch=amd64 bookworm build/chroot http://debian.org
cat <<EOF | sudo chroot build/chroot /bin/bash
apt update

# カーネルとライブ起動用ツールは必須
apt install -y linux-image-amd64 live-boot network-manager
# 好きなデスクトップ環境など
apt install -y xterm
apt clean
EOF
mkdir -p build/iso/live
# システムを圧縮（これがOSの実体になる）
sudo mksquashfs build/chroot build/iso/live/filesystem.squashfs -e boot
# chroot内から起動用カーネルをISOディレクトリへコピー
cp build/chroot/boot/vmlinuz-* build/iso/live/vmlinuz
cp build/chroot/boot/initrd.img-* build/iso/live/initrd


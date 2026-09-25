#!/data/data/com.termux/files/usr/bin/bash
DIR="$HOME/dragonfly-lunc"
ISO="$DIR/dfly.iso"
DISK="$DIR/dfly.img"
URL="https://mirror-master.dragonflybsd.org/iso-images/dfly-x86_64-6.4.0_REL.iso"
mkdir -p "$DIR"
if [ "$1" = "install" ]; then
  pkg update -y && pkg install -y wget qemu-system-x86-64 qemu-utils
  [ -f "$ISO" ] || wget -c -O "$ISO" "$URL"
  [ -f "$DISK" ] || qemu-img create -f qcow2 "$DISK" 20G
  qemu-system-x86_64 -cdrom "$ISO" -hda "$DISK" -boot d -m 1024 -smp 2 -accel tcg,thread=multi -nographic
elif [ "$1" = "run" ]; then
  qemu-system-x86_64 -hda "$DISK" -m 1024 -smp 2 -accel tcg,thread=multi -nographic -nic user,hostfwd=tcp::2222-:22
elif [ "$1" = "stop" ]; then
  pkill -f "qemu.*dfly.img"; echo "stopped"
elif [ "$1" = "status" ]; then
  pgrep -af "qemu.*dfly.img" || echo "off"
elif [ "$1" = "uninstall" ]; then
  pkill -f "qemu.*dfly.img"; rm -rf "$DIR"; echo "removed"
else
  echo "use: ./dragonFly install|run|stop|status|uninstall"
fi

#!/bin/ash

tmp="$1"

echo ">> Ejecutando genapkovl para k3shelm"

# 1. Crear estructura básica
mkdir -p "$tmp"/etc/apk
cat << EOW > "$tmp"/etc/apk/world
alpine-base
bash
openrc
ca-certificates
EOW

# 2. Instalar binarios
mkdir -p "$tmp"/usr/local/bin
cp /builder/k3s "$tmp"/usr/local/bin/
cp /builder/helm "$tmp"/usr/local/bin/
chmod +x "$tmp"/usr/local/bin/k3s
chmod +x "$tmp"/usr/local/bin/helm

# 3. Crear el servicio
mkdir -p "$tmp"/etc/init.d
cat << 'EOT' > "$tmp"/etc/init.d/k3s
#!/sbin/openrc-run
command="/usr/local/bin/k3s"
command_args="server"
pidfile="/var/run/k3s.pid"
depend() {
    need net
}
EOT
chmod +x "$tmp"/etc/init.d/k3s

# 4. Crear el symlink — después de que /etc/init.d/k3s exista
mkdir -p "$tmp"/etc/runlevels/default
ln -s ../../init.d/k3s "$tmp"/etc/runlevels/default/k3s

echo ">> Archivos en $tmp:"
find "$tmp"

echo ">> Generando manualmente $PWD/k3s.apkovl.tar.gz"
tar -czf /builder/output/k3s.apkovl.tar.gz -C "$tmp" .

if [ ! -f "$tmp/etc/init.d/k3s" ]; then
    echo "❌ ERROR: /etc/init.d/k3s no existe, no se puede crear el symlink"
    ls -l "$tmp/etc/init.d"
    exit 1
fi

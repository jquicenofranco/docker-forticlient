#!/bin/sh

if [ -z "$VPNADDR" -o -z "$VPNUSER" -o -z "$VPNPASS" ]; then
  echo "Variables VPNADDR, VPNUSER and VPNPASS must be set."; exit;
fi

export VPNTIMEOUT=${VPNTIMEOUT:-5}

# Configuración de red más robusta
iptables -F
iptables -t nat -F
iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
iptables -A FORWARD -i eth0 -j ACCEPT

# Permitir tráfico entre contenedores
for iface in $(ip a | grep eth | grep inet | awk '{print $2}'); do
  iptables -t nat -A POSTROUTING -s "$iface" -j MASQUERADE
  iptables -A FORWARD -i "$iface" -j ACCEPT
  iptables -A FORWARD -o "$iface" -j ACCEPT
done

while [ true ]; do
  echo "------------ VPN Starts ------------"
  /usr/bin/forticlient
  echo "------------ VPN exited ------------"
  sleep 10
done
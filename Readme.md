# Docker Forticlient + FileZilla

Este proyecto es un fork de [docker-forticlient](https://github.com/HybirdCorp/docker-forticlient) con algunas modificaciones para incluir FileZilla y facilitar la conexión a servidores FTP a través de VPN.

## Descripción

Este proyecto nació de la necesidad de resolver problemas de compatibilidad con FortiClient en Windows. Usando Docker, podemos encapsular toda la configuración y dependencias necesarias en contenedores, eliminando problemas de instalación y compatibilidad del sistema operativo.

## Estructura del Proyecto

El archivo `docker-compose.yml` define dos servicios principales:

### 1. FortiClient VPN
```yaml
forticlient:
    build:
      context: .
      dockerfile: Dockerfile
    image: hybirdcorp/docker-forticlient
    restart: unless-stopped
    # ... otras configuraciones
```
Este servicio maneja la conexión VPN con las siguientes características:
- Reinicio automático en caso de fallo
- Configuración de red privilegiada para gestionar conexiones VPN
- Configuración de DNS usando Google DNS (8.8.8.8 y 8.8.4.4)
- Forwarding de puertos 3000 y 3001

### 2. FileZilla
```yaml
filezilla:
    image: lscr.io/linuxserver/filezilla:latest
    container_name: filezilla
    # ... otras configuraciones
```
Este servicio proporciona una interfaz gráfica de FileZilla que:
- Utiliza la red del contenedor FortiClient
- Mantiene la configuración persistente a través de volúmenes
- Se ejecuta con los permisos adecuados (PUID/PGID)

## Configuración

### Archivo .env

Es necesario crear un archivo `.env` en la raíz del proyecto con las siguientes variables:

```env
VPNADDR=vpn.tudominio.com
VPNUSER=usuario
VPNPASS=contraseña
VPNTIMEOUT=10
```

Donde:
- `VPNADDR`: Dirección del servidor VPN
- `VPNUSER`: Usuario de la VPN
- `VPNPASS`: Contraseña de la VPN
- `VPNTIMEOUT`: Tiempo de espera para la conexión (en segundos)

## Agradecimientos

Este proyecto no sería posible sin:

- El proyecto original [docker-forticlient](https://github.com/HybirdCorp/docker-forticlient) y sus contribuidores
- La comunidad de Linux por proporcionar un sistema operativo robusto y libre
- Docker por revolucionar la forma en que desarrollamos y desplegamos software
- La comunidad de código abierto en general

## Licencia

Este proyecto mantiene la licencia del proyecto original del cual se hizo fork.

# Freifunk Hennef Firmware Downloader Docker Image

Docker Image für den Freifunk Hennef Firmware Downloader (https://github.com/Freifunk-Hennef/ffhef-fw-dl)

## Benutzung

Zur Konfiguration (siehe https://github.com/Freifunk-Hennef/ffhef-fw-dl#installation) die Datei community-config.inc.php überschreiben/in den Container mounten.

Beispiel

```
docker run -v /firmware:/var/www/html/firmware -v /config/community-config.inc.php:/var/www/html/community-config.inc.php ffhef/ffhef-fw-dl
```
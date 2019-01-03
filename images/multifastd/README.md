# fastd

Docker Image für einen Freifunk fastd Server.

## Funktionen

* Startet auf Port 10000 einen fastd Server

## Variablen

| Variable            | Beschreibung                                 | Format                                       | Standardwert | Benötigt           |
| ------------------- | -------------------------------------------- | -------------------------------------------- | ------------ | ------------------ |
| FASTD_SECRET        | Secret                                       | `abcdef...`                                  | -            | :white_check_mark: |
| FASTD_PORT          | Port                                         | Portnummer                                   | `10000`      | :x:                |
| FASTD_BIND_ADDRESS  | IP-Adresse                                   | IPv4- oder IPv6-Adresse                      | `0.0.0.0`    | :x:                |
| FASTD_LOGLEVEL      | Loglevel                                     | `fatal,error,warn,info,verbose,debug,debug2` | `info`       | :x:                |
| FASTD_MODE          | Modus                                        | `tap,multitap,tun`                           | `tap`        | :x:                |
| FASTD_PEER_LIMIT    | Maximale Anzahl an Verbindungen              | Zahl                                         | `128`        | :x:                |
| FASTD_MTU           | MTU (innerhalb des Tunnels)                  | Zahl                                         | `1406`       | :x:                |
| FASTD_INTERFACE_MAC | MAC-Adresse, die das Interface erhalten soll | MAC-Adresse                                  | ``           | :x:                |

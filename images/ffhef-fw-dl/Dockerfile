FROM php:7.0-apache

MAINTAINER Nico - Freifunk Hennef <nico@freifunk-hennef.de>

RUN apt-get update && apt-get install -y git && \
    apt-get remove -y $REMOVE_PACKAGES && apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists

RUN rm -rf /var/www/html && cd /tmp && git clone https://github.com/Freifunk-Hennef/ffhef-fw-dl.git /var/www/html

ADD community-config.inc.php /var/www/html/community-config.inc.php

VOLUME /var/www/html/firmware

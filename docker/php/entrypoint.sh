#!/bin/bash

/usr/local/bin/supervisord -c /etc/supervisor.conf -d && php-fpm -F

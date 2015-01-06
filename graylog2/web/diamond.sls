{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{% set version = '0.20.6' %}

include:
  - diamond
  - mongodb.diamond
  - nginx.diamond
  - rsyslog.diamond

graylog2_web_diamond_resource:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[graylog2-web]]
        cmdline = java.+\-Duser\.dir=/usr/local/graylog2\-web\-interface

{#-
Copyright (c) 2013, Bruno Clermont
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Bruno Clermont <patate@fastmail.cn>
Maintainer: Bruno Clermont <patate@fastmail.cn>
-#}
include:
  - reprepro
  - nginx
  - web
{% if pillar['salt_ppa_mirror']['ssl']|default(False) %}
  - ssl
{% endif %}

/var/lib/reprepro/salt:
  file:
    - directory
    - user: root
    - group: www-data
    - mode: 750
    - require:
      - file: /var/lib/reprepro
      - user: web

/var/lib/reprepro/salt/ubuntu:
  file:
    - directory
    - user: root
    - group: www-data
    - mode: 750
    - require:
      - file: /var/lib/reprepro/salt
      - user: web

{% set filenames = ('distributions', 'updates') %}
{% for version in pillar['salt_ppa_mirror']['versions'] %}
{% set root="/var/lib/reprepro/salt/ubuntu/" + version %}
{{ root }}:
  file:
    - directory
    - user: root
    - group: www-data
    - mode: 750
    - require:
      - file: /var/lib/reprepro/salt/ubuntu
      - user: web

{{ root }}/conf:
  file:
    - directory
    - user: root
    - group: www-data
    - mode: 750
    - require:
      - file: {{ root }}
      - user: web

{% for filename in filenames %}
{{ root }}/conf/{{ filename }}:
  file:
    - managed
    - template: jinja
    - source: salt://salt/mirror/{{ filename }}.jinja2
    - user: root
    - group: www-data
    - mode: 640
    - require:
      - file: {{ root }}/conf
{% endfor %}

{% for distribution in pillar['salt_ppa_mirror']['distributions'] %}
reprepro-update-{{ version }}-{{ distribution }}:
  cmd:
    - wait
    - name: reprepro update {{ distribution }}
    - cwd: {{ root }}
    - watch:
      - file: {{ root }}
    - require:
      - pkg: reprepro
{% for filename in filenames %}
      - file: {{ root }}/conf/{{ filename }}
{% endfor %}
{% endfor %}{# distributions #}
{% endfor %}{# versions #}

/etc/nginx/conf.d/salt_mirror_ppa.conf:
  file:
    - managed
    - template: jinja
    - source: salt://salt/mirror/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/salt_mirror_ppa.conf
{% if pillar['salt_ppa_mirror']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['salt_ppa_mirror']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['salt_ppa_mirror']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['salt_ppa_mirror']['ssl'] }}/ca.crt
{% endif %}

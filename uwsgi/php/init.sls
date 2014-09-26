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
  - apt
  - php.dev
  - uwsgi

{%- if grains['osrelease']|float == 12.04 %}
symlink-libphp5.so:
  file:
    - symlink
    {%- if grains['cpuarch'] == 'i686' %}
    - name: /usr/lib/i386-linux-gnu/libphp5.so
    {%- else %}
    - name: /usr/lib/x86_64-linux-gnu/libphp5.so
    {%- endif %}
    - target: /usr/lib/php5/libphp5.so
    - require:
      - pkg: php-dev
  cmd:
    - wait
    - name: /sbin/ldconfig
    - watch:
      - file: symlink-libphp5.so
    - watch_in:
      - cmd: uwsgi_emperor
{%- endif %}

extend:
  uwsgi:
    service:
      - watch:
        - file: php-dev
  uwsgi_build:
    file:
      - require:
        - pkg: php-dev

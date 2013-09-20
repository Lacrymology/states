{#-
Copyright (c) 2013, Lam Dang Tung
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

Author: Lam Dang Tung lamdt@familug.org
Maintainer: Lam Dang Tung lamdt@familug.org

Nagios NRPE check for OpenERP
-#}

include:
  - nrpe
  - apt.nrpe
  - build.nrpe
  - nginx.nrpe
  - pip.nrpe
  - postgresql.server.nrpe
  - python.dev.nrpe
{%- if salt['pillar.get']('openerp:ssl', False) %}
  - ssl.nrpe
{%- endif %}
  - underscore.nrpe
  - uwsgi.nrpe
  - virtualenv.nrpe
  - xml.nrpe

/etc/nagios/nrpe.d/openerp.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://uwsgi/nrpe/instance.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - watch_in:
      - service: nagios-nrpe-server
    - context:
      deployment: openerp
      workers: {{ salt['pillar.get']('openerp:workers', '2') }}
      {%- if 'cheaper' in salt['pillar.get']('openerp') %}
      cheaper: {{ salt['pillar.get']('openerp:cheaper')  }}
      {%- endif %}

/etc/nagios/nrpe.d/openerp-nginx.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://nginx/nrpe/instance.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: openerp
      domain_name: {{ salt['pillar.get']('openerp:hostnames')[0] }}
      http_uri: /
{%- if salt['pillar.get']('openerp:ssl', False) %}
      https: True
      http_result: 301 Moved Permanently
{%- endif %}

{#-
/etc/nagios/nrpe.d/postgresql-openerp.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://postgresql/nrpe.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: openerp
      password: {{ salt['password.pillar']('openerp:database:password', 10) }}
    - watch_in:
      - service: nagios-nrpe-server
#}

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
  - shinken.broker
  - shinken.broker.diamond
  - shinken.broker.nrpe

{%- set check_set = (('shinken_broker_http_port', 'Connection refused'),
                    ('shinken_broker_http', 'Connection refused'),
                    ('shinken.broker_nginx_http', 'Invalid HTTP response')) %}

{%- set ssl = salt['pillar.get']('shinken:ssl', False) %}
{%- if ssl %}
{%- set check_set = check_set + [('shinken.broker_nginx_https', 'Invalid HTTP response')] %}
{%- endif %}

{% for name, failure in check_set %}
{{ name }}:
  monitoring:
    - run_check
    - accepted_failure: {{ failure }}
    - require:
      - sls: shinken.broker.nrpe
{%- endfor %}

test:
  monitoring:
    - run_all_checks
    - order: last
    - exclude:
{%- for name, _ in check_set %}
      - {{ name }}
{%- endfor %}
    - require:
{%- for name, _ in check_set %}
      - monitoring: {{ name }}
{%- endfor %}

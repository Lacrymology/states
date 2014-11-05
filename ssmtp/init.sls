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

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - apt
  - hostname
  - rsyslog

ssmtp:
  pkg:
    - installed
    - require:
      - service: rsyslog
      - cmd: apt_sources
      - debconf: ssmtp
      - cmd: hostname
      - host: hostname
  debconf:
    - set
    - data:
        'ssmtp/mailhub': {'type': 'string', 'value': '{{ pillar['smtp']['server'] }}'}
        'ssmtp/hostname': {'type': 'string', 'value': '{{ pillar['mail']['mailname'] }}'}
        'ssmtp/root': {'type': 'string', 'value': '{{ pillar['smtp']['root'] }}'}
        'ssmtp/rewritedomain': {'type': 'string', 'value': ''}
        {# unused by the package itself, why? #}
        'ssmtp/overwriteconfig': {'type': 'boolean', 'value': False}
        'ssmtp/mailname': {'type': 'string', 'value': '{{ pillar['mail']['mailname'] }}'}
        'ssmtp/port': {'type': 'string', 'value': '{{ pillar['smtp']['port'] }}'}
        'ssmtp/fromoverride': {'type': 'boolean', 'value': False}
    - require:
      - pkg: apt_sources

bsd-mailx:
  pkg:
    - installed
    - require:
      - pkg: ssmtp
      - cmd: apt_sources

{% for template, config in (('config', 'ssmtp.conf'), ('revaliases', 'revaliases')) %}
/etc/ssmtp/{{ config }}:
  file:
    - managed
    - template: jinja
    - source: salt://ssmtp/{{ template }}.jinja2
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: bsd-mailx
      - pkg: ssmtp
{% endfor %}

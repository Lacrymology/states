{#
 Nagios NRPE check for tightvncserver
#}
{%- set wm = salt['pillar.get']('tightvncserver:wm', 'fluxbox') %}

include:
  - apt.nrpe
  - logrotate.nrpe
  - {{ wm }}.nrpe

/etc/nagios/nrpe.d/tightvncserver.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://tightvncserver/nrpe/config.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - watch_in:
      - service: nagios-nrpe-server

{#-
Amavis: A Email Virus Scanner
=============================

Mandatory Pillar
----------------

mail:
  mailname: somehost.fqdn.com

Optional Pillar
---------------

mail:
  maxproc: 2

-#}
include:
  - apt
  - spamassassin
  - mail

amavis:
  pkg:
    - latest
    - name: amavisd-new
    - require:
      - cmd: apt_sources
      - file: /etc/mailname
  service:
    - running
    - watch:
      - pkg: amavis
    - require:
      - pkg: spamassassin

{% for cfg in ('05-node_id', '15-content_filter_mode', '22-max_servers') %}
/etc/amavis/conf.d/{{ cfg }}:
  file:
    - managed
    - source: salt://amavis/{{ cfg }}.jinja2
    - template: jinja
    - watch_in:
      - service: amavis
{% endfor %}

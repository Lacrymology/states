{#-
Amavis: A Email Virus Scanner
=============================

Mandatory Pillar
----------------

mail:
  mailname: somehost.fqdn.com

mail:mailname: fully qualified domain (if possible) of the mail server hostname.

Optional Pillar
---------------

mail:
  maxproc: 2

mail:maxproc: maximum number of process.
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
    - order: 50
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

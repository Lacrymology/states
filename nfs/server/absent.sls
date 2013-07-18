/etc/exports:
  file:
    - absent
    - require:
      - pkg: nfs-kernel-server

{#
/etc/hosts.allow:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://nfs/allow.jinja2
    - require:
      - pkg: nfs-kernel-server

/etc/hosts.deny:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - template: jinja
    - source: salt://nfs/deny.jinja2
    - require:
      - pkg: nfs-kernel-server
      #}

/etc/default/nfs-common:
  file:
    - absent

/etc/default/nfs-kernel-server:
  file:
    - absent
    - require:
      - pkg: nfs-kernel-server

nfs-kernel-server:
  pkg:
    - purged
    - require:
      - service: nfs-kernel-server
  service:
    - dead
    - enable: False

{% for pkg in 'libnfsidmap2', 'libgssglue1', 'libtirpc1', 'rpcbind' %}
{{ pkg }}:
  pkg:
    - purged
    - require:
      - pkg: nfs-kernel-server
{% endfor %}

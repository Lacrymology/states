include:
  - apt
  - nrpe

salt-repository:
  file:
    - managed
    - template: jinja
    - name: /etc/apt/sources.list.d/saltstack-salt-{{ grains['lsb_codename'] }}.list
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/apt.jinja2

{#
 this is until 0.16 is out
 #}
{% for patched_file, source in (('states/git', 'git'), ('modules/djangomod', 'djangomod')) %}
salt-patch-{{ source }}:
  file:
    - managed
    - name: /usr/share/pyshared/salt/{{ patched_file }}.py
    - source: salt://salt/{{ source }}.py
    - user: root
    - group: root
    - mode: 444
{% endfor %}

salt-minion:
  file:
    - managed
    - template: jinja
    - name: /etc/salt/minion
    - user: root
    - group: root
    - mode: 440
    - source: salt://salt/config.jinja2
  pkg:
    - latest
    - require:
      - module: apt_sources
  service:
    - running
    - watch:
      - file: salt-patch-git
      - file: salt-patch-djangomod
      - pkg: salt-minion
      - file: salt-minion

/etc/nagios/nrpe.d/salt-minion.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://salt/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/salt-minion.cfg
  apt_sources:
    module:
      - watch:
        - file: salt-repository

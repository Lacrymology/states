{#
 # common stuff between carbon and graphite
 #}

include:
  - virtualenv

graphite:
  user:
    - present
    - shell: /bin/false
    - home: /usr/local/graphite
    - gid_from_name: True
  virtualenv:
    - managed
    - name: /usr/local/graphite
    - require:
      - pkg: python-virtualenv

{% for subdir in ('/var/lib', '/etc') %}
{{ subdir }}/graphite:
  file:
    - directory
    - user: graphite
    - group: graphite
    - mode: 770
    - require:
      - user: graphite
{% endfor %}

/var/log/graphite:
  file:
    - directory
    - user: root
    - group: root
    - mode: 555
    - makedirs: True

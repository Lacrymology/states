{#
 Common stuff for all shinken components
 #}
include:
  - virtualenv
  - pip
  - python.dev
  - apt

{# common to all shinken daemons #}

/usr/local/bin/shinken-ctl.sh:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://shinken/shinken-ctl.jinja2

{% for dirname in ('log', 'lib') %}
/var/{{ dirname }}/shinken:
  file:
    - directory
    - user: shinken
    - group: shinken
    - mode: 770
    - require:
      - user: shinken
{% endfor %}

/etc/shinken:
  file:
    - directory
    - user: shinken
    - group: shinken
    - mode: 550
    - require:
      - user: shinken

shinken:
  virtualenv:
    - manage
    - name: /usr/local/shinken
    - no_site_packages: True
    - require:
      - module: virtualenv
  file:
    - managed
    - name: /usr/local/shinken/salt-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/requirements.jinja2
    - require:
      - virtualenv: shinken
  module:
    - wait
    - name: pip.install
    - pkgs: ''
    - upgrade: True
    - bin_env: /usr/local/shinken/bin/pip
    - requirements: /usr/local/shinken/salt-requirements.txt
    - require:
      - virtualenv: shinken
    - watch:
      - file: shinken
      - pkg: python-dev
      - user: shinken
  user:
    - present
    - shell: /bin/false
    - home: /var/lib/shinken
    - gid_from_name: True

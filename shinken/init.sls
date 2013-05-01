{#
 Install all or some of the components required to have a complete Shinken
 Monitoring cluster.
 #}
{# TODO: add support for GELF logging #}
include:
  - virtualenv
  - pip
  - apt
{% if pillar['shinken']['ssl']|default(False) %}
  - ssl
{% endif %}
{% if grains['id'] in pillar['shinken']['architecture']['broker']|default([]) %}
  - nginx
{% endif %}

{#{% if 'arbiter' in pillar['shinken']['roles'] %}#}
{#    {% if pillar['shinken']['arbiter']['use_mongodb'] %}#}
{#  - mongodb#}
{#    {% endif %}#}
{#{% endif %}#}

{# common to all shinken daemons #}

/usr/local/bin/shinken-ctl.sh:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://shinken/shinken-ctl.jinja2

{% set configs = ('architecture', 'infra') %}
{% set var_directories = ('log', 'lib') %}

{% for dirname in var_directories %}
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
      - user: shinken
      - file: /var/log/shinken
      - file: /var/lib/shinken
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
  user:
    - present
    - shell: /bin/false
    - home: /var/lib/shinken
    - gid_from_name: True

{% for role in pillar['shinken']['architecture'] %}
{% if grains['id'] in pillar['shinken']['architecture'][role] %}

{% if role == 'poller' %}
nagios-nrpe-plugin:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
{% endif %}

{% if role == 'broker' %}
/etc/nginx/conf.d/shinken-web.conf:
  file:
    - managed
    - template: jinja
    - source: salt://shinken/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
{% endif %}

shinken-{{ role }}:
  file:
    - managed
    - name: /etc/shinken/{{ role }}.conf
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/{% if role != 'arbiter' %}non_{% endif %}arbiter.jinja2
    - context:
      shinken_component: {{ role }}
{% if role == 'arbiter' %}
      configs:
  {% for config in configs %}
        - {{ config }}
  {% endfor %}
{% endif %}
    - require:
      - virtualenv: shinken
  service:
    - running
    - enable: True
    - require:
{% for dirname in var_directories %}
      - file: /var/{{ dirname }}/shinken
{% endfor %}
    - watch:
      - module: shinken
      - file: /etc/init/shinken-{{ role }}.conf
      - file: shinken-{{ role }}
{% if pillar['shinken']['ssl']|default(False) %}
      - cmd: /etc/ssl/{{ pillar['shinken']['ssl'] }}/chained_ca.crt
      - module: /etc/ssl/{{ pillar['shinken']['ssl'] }}/server.pem
      - file: /etc/ssl/{{ pillar['shinken']['ssl'] }}/ca.crt
{% endif %}
{% if role == 'arbiter' %}
    {% for config in configs %}
      - file: /etc/shinken/{{ config }}.conf
    {% endfor %}

/etc/shinken/objects:
  file:
    - directory
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 550
    - require:
      - file: /etc/shinken

    {% for config in configs %}
/etc/shinken/{{ config }}.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 440
    - source: salt://shinken/{{ config }}.jinja2
    - require:
      - file: /etc/shinken
    {% endfor %}

{% endif %}

/etc/init/shinken-{{ role }}.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://shinken/upstart.jinja2
    - context:
      shinken_component: {{ role }}
{% endif %}
{% endfor %}

{% if grains['id'] in salt['pillar.get']('shinken:architecture:broker', []) %}
extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/shinken-web.conf
{% if pillar['shinken']['ssl']|default(False) %}
        - cmd: /etc/ssl/{{ pillar['shinken']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['shinken']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['shinken']['ssl'] }}/ca.crt
{% endif %}
{% endif %}

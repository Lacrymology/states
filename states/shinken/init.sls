include:
  - virtualenv
  - nrpe
{#{% if 'arbiter' in pillar['shinken']['roles'] %}#}
{#    {% if pillar['shinken']['arbiter']['use_mongodb'] %}#}
{#  - mongodb#}
{#    {% endif %}#}
{#{% endif %}#}

{# common to all shinken daemons #}

{% set configs = ('architecture',) %}

/var/log/shinken:
  file:
    - directory
    - user: shinken
    - group: shinken
    - mode: 700
    - require:
      - user: shinken

/var/lib/shinken:
  file:
    - directory
    - user: shinken
    - group: shinken
    - mode: 700
    - require:
      - user: shinken

shinken:
  virtualenv:
    - manage
    - name: /usr/local/shinken
    - no_site_packages: True
    - require:
      - pkg: python-virtualenv
      - user: shinken
      - file: /var/log/shinken
      - file: /var/lib/shinken
  pip:
    - installed
    - name: -e git+git://github.com/naparuba/shinken.git@{{ pillar['shinken']['revision'] }}#egg=shinken
    - bin_env: /usr/local/shinken
    - require:
      - virtualenv: shinken
  user:
    - present
    - shell: /bin/false
    - home: /var/lib/shinken
    - gid_from_name: True

{#
 Each shinken daemons, valids are:
 - arbiter
 - broker
#}

{% for role in pillar['shinken']['roles'] %}
shinken-{{ role }}:
  file:
    - managed
    - name: /etc/shinken/{{ role }}.conf
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 600
    - source: salt://shinken/{% if role != 'arbiter' %}non_{% endif %}arbiter.jinja2
    - context:
      shinken_component: {{ role }}
    - require:
      - virtualenv: shinken
  service:
    - running
    - watch:
      - pip: shinken
      - file: /etc/init/shinken-{{ role }}.conf
      - file: shinken-{{ role }}
{% if role == 'arbiter' %}
{#    {% if pillar['shinken']['arbiter']['use_mongodb'] %}#}
{#      - service: mongodb#}
{#    {% endif %}#}
    {% for config in configs %}
      - file: /etc/shinken/{{ config }}.conf
    {% endfor %}

    {% for config in configs %}
/etc/shinken/{{ config }}.conf:
  file:
    - managed
    - template: jinja
    - user: shinken
    - group: shinken
    - mode: 600
    - source: salt://shinken/{{ config }}.jinja2
    {% endfor %}

{% endif %}

/etc/init/shinken-{{ role }}.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://shinken/upstart.jinja2
    - context:
      shinken_component: {{ role }}

/etc/nagios/nrpe.d/shinken-{{ role }}.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 600
    - source: salt://shinken/nrpe.jinja2
    - context:
      shinken_component: {{ role }}

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/shinken-{{ role }}.cfg
{% endfor %}

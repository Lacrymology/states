{#
 Nagios NRPE check for Shinken
#}
include:
  - nrpe
  - virtualenv.nrpe
  - pip.nrpe
  - python.dev.nrpe
  - apt.nrpe
{% if pillar['shinken']['ssl']|default(False) %}
  - ssl.nrpe
{% endif %}
{% if grains['id'] in pillar['shinken']['architecture']['broker']|default([]) %}
  - nginx.nrpe
{% endif %}

{% for role in pillar['shinken']['architecture'] %}
{% if grains['id'] in pillar['shinken']['architecture'][role] %}
/etc/nagios/nrpe.d/shinken-{{ role }}.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://shinken/nrpe/config.jinja2
    - context:
      shinken_component: {{ role }}
    - require:
      - pkg: nagios-nrpe-server
{% endif %}
{% endfor %}

{% if grains['id'] in salt['pillar.get']('shinken:architecture:broker', []) %}
/etc/nagios/nrpe.d/shinken-nginx.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://nginx/nrpe/instance.jinja2
    - require:
      - pkg: nagios-nrpe-server
    - context:
      deployment: shinken_broker
      http_uri: /user/login
      domain_name: {{ pillar['shinken']['web']['hostnames'][0] }}
      http_port: 7767
      https: {{ pillar['shinken']['ssl']|default(False) }}
{% endif %}

extend:
  nagios-nrpe-server:
    service:
      - watch:
{% for role in pillar['shinken']['architecture'] %}
{% if grains['id'] in pillar['shinken']['architecture'][role] %}
        - file: /etc/nagios/nrpe.d/shinken-{{ role }}.cfg
{% endif %}
{% endfor %}
{% if grains['id'] in salt['pillar.get']('shinken:architecture:broker', []) %}
        - file: /etc/nagios/nrpe.d/shinken-nginx.cfg
{% endif %}

{# TODO: send logs to GELF #}
include:
  - virtualenv
  - nrpe

carbon_logrotate:
  file:
    - managed
    - name: /etc/logrotate.d/carbon
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://carbon/logrotate.jinja2

carbon_logdir:
  file:
    - directory
    - name: /var/log/graphite/carbon
    - user: graphite
    - group: graphite
    - mode: 770
    - makedirs: True
    - require:
      - user: carbon

carbon_storage-schemas:
  file:
    - managed
    - name: /etc/graphite/storage-schemas.conf
    - template: jinja
    - user: graphite
    - group: graphite
    - mode: 440
    - source: salt://carbon/storage.jinja2
    - require:
      - user: carbon

carbon_storage:
  file:
    - directory
    - name: /var/lib/graphite
    - user: graphite
    - group: graphite
    - mode: 770
    - require:
      - user: carbon

carbon:
  virtualenv:
    - managed
    - name: /usr/local/graphite
    - require:
      - pkg: python-virtualenv
  pip:
    - installed
    - name: ''
    - bin_env: /usr/local/graphite/bin/pip
    - requirements: salt://carbon/requirements.txt
    - install_options:
      - "--prefix=/usr/local/graphite"
      - "--install-lib=/usr/local/graphite/lib/python2.7/site-packages"
    - require:
      - virtualenv: carbon
      - pkg: python-virtualenv
  user:
    - present
    - name: graphite
    - shell: /bin/false
    - home: /usr/local/graphite
    - gid_from_name: True
  file:
    - managed
    - name: /etc/graphite/carbon.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://carbon/config.jinja2

{#
 # until https://github.com/graphite-project/carbon/commit/2a6dbe680c973c54c5426eb4248f90ca798595c1
 # is merged in a stable release
 #}
carbon-patch:
  file:
    - managed
    - name: /usr/local/graphite/lib/python2.7/site-packages/carbon/writer.py
    - user: root
    - group: root
    - mode: 644
    - source: salt://carbon/writer.py

{% for instance in ('a',) %}
carbon-{{ instance }}:
  file:
    - managed
    - name: /etc/init.d/carbon-{{ instance }}
    - template: jinja
    - user: root
    - group: root
    - mode: 550
    - source: salt://carbon/init.jinja2
    - context:
      instance: a
  service:
    - running
    - name: carbon-{{ instance }}
    - require:
      - user: carbon
      - file: carbon_logdir
      - file: carbon_storage
      - file: carbon-{{ instance }}
      - file: carbon-patch
    - watch:
      - pip: carbon
      - file: carbon
      - file: carbon_storage-schemas
      - virtualenv: carbon
      - file: carbon-{{ instance }}
{% endfor %}

/etc/nagios/nrpe.d/carbon.cfg:
  file.managed:
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://carbon/nrpe.jinja2

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/carbon.cfg

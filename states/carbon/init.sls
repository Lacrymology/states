{# TODO: send logs to GELF #}
include:
  - virtualenv
  - nrpe

carbon_upstart:
  file:
    - managed
    - name: /etc/init/carbon.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://carbon/upstart.jinja2

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
    - requirements: salt://carbon/requirements.txt
    - require:
      - pkg: python-virtualenv
  git:
    - latest
    - name: git://github.com/graphite-project/carbon.git
    - rev: ee5cc3fd3b7db271444d480476468461cda2d34b
    - target: /usr/local/graphite/src/carbon
  pip:
    - installed
    - name: /usr/local/graphite/src/carbon
    - bin_env: /usr/local/graphite/bin/pip
    - install_options:
      - "--prefix=/usr/local/graphite"
      - "--install-lib=/usr/local/graphite/lib/python2.7/site-packages"
    - require:
      - virtualenv: carbon
      - pkg: python-virtualenv
      - git: carbon
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
  service:
    - running
    - require:
      - user: carbon
      - file: carbon_logdir
      - file: carbon_storage
      - file: carbon_upstart
    - watch:
      - pip: carbon
      - file: carbon
      - file: carbon_storage-schemas
      - virtualenv: carbon

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

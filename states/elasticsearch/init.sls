include:
  - diamond
  - nrpe

/etc/default/elasticsearch:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - source: salt://elasticsearch/default.jinja2

/etc/elasticsearch/elasticsearch.yml:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - source: salt://elasticsearch/config.jinja2

/etc/elasticsearch/logging.yml:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - source: salt://elasticsearch/logging.jinja2

elasticsearch-debianfile:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/elasticsearch-{{ pillar['elasticsearch']['version'] }}.deb
    - source: https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-{{ pillar['elasticsearch']['version'] }}.deb
    - user: root
    - group: root
    - mode: 600
    - replace: False
    - source_hash: md5={{ pillar['elasticsearch']['md5'] }}

elasticsearch-package:
  pkg:
    - installed
    - name: openjdk-7-jre-headless
  file:
    - absent
    - names:
      - /etc/default/elasticsearch
      - /etc/elasticsearch/elasticsearch.yml
      - /etc/elasticsearch/logging.yml
  cmd:
    - run
    - name: dpkg -i {{ opts['cachedir'] }}/elasticsearch-{{ pillar['elasticsearch']['version'] }}.deb
    - unless: dpkg-query --showformat='${Status} ${Package} ${Version}\n' -W elasticsearch | grep -q "install ok installed elasticsearch {{ pillar['elasticsearch']['version'] }} "
    - require:
      - pkg: elasticsearch-package
      - file: elasticsearch-package
    - watch:
      - file: elasticsearch-debianfile

elasticsearch:
  service:
    - running
    - watch:
      - file: /etc/default/elasticsearch
      - file: /etc/elasticsearch/elasticsearch.yml
      - file: /etc/elasticsearch/logging.yml
      - cmd: elasticsearch-package
{#      - cmd: elasticsearch-cloud-aws#}

{#elasticsearch-cloud-aws:#}
{#  cmd:#}
{#    - run#}
{#    - name: /usr/share/elasticsearch/bin/plugin install cloud-aws#}
{#    - watch:#}
{#      - cmd: elasticsearch#}

/etc/nagios/nrpe.d/elasticsearch.cfg:
  file.managed:
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 600
    - source: salt://elasticsearch/nrpe.jinja2

elasticsearch_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/ElasticSearchCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - source: salt://elasticsearch/diamond.jinja2

extend:
  diamond:
    service:
      - watch:
        - file: elasticsearch_diamond_collector
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/elasticsearch.cfg

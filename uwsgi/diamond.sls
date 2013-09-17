{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Diamond statistics for uWSGI
-#}
include:
  - diamond
  - nginx.diamond
  - rsyslog.diamond

uwsgi_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[uwsgi]]
        cmdline = ^\/usr\/local\/uwsgi\/uwsgi

{% if grains['virtual'] == 'kvm' and salt['file.file_exists']('/sys/kernel/mm/ksm/run') %}
diamond_ksm:
  file:
    - managed
    - name: /etc/diamond/collectors/KSMCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://diamond/basic_collector.jinja2
    - require:
      - file: /etc/diamond/collectors

extend:
  diamond:
    service:
      - watch:
        - file: diamond_ksm
{% endif %}

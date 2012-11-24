etc_hostname:
  cmd.run:
    - name: hostname `cat /etc/hostname`
    - unless: hostname | grep -q {{ pillar['hostname'] }}
    - require:
      - file: etc_hostname
  file:
    - managed
    - template: jinja
    - name: /etc/hostname
    - user: root
    - group: root
    - mode: 644
    - source: salt://hostname/hostname.jinja2
  host:
    - present
    - name: {{ pillar['hostname'] }}
    - ip: 127.0.0.1

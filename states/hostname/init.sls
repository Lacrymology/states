etc_hostname:
  file:
    - managed
    - template: jinja
    - name: /etc/hostname
    - user: root
    - group: root
    - mode: 444
    - source: salt://hostname/hostname.jinja2
  host:
    - present
    - name: {{ pillar['hostname'] }}
    - ip: 127.0.0.1
  cmd:
    - wait
    - stateful: False
    - name: hostname `cat /etc/hostname`
    - watch:
      - file: etc_hostname

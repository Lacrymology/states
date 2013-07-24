{#-
Denyhosts
=========

Install Denyhosts used to block SSH brute-force attack.

Mandatory Pillar
----------------

message_do_not_modify: Warning message to not modify file.

Optional Pillar
---------------

denyhosts:
  purge: 1d
  deny_threshold_invalid_user: 5
  deny_threshold_valid_user: 10
  deny_threshold_root: 1
  reset_valid: 5d
  reset_root: 5d
  reset_restricted: 25d
  reset_invalid: 10d
  reset_on_success: no
  sync:
    server: 192.168.1.1
    interval: 1h
    upload: yes
    download: yes
    download_threshold: 3
    download_resiliency: 5h
  whitelist:
    - 127.0.0.1
shinken_pollers:
  - 192.168.1.1

shinken_pollers: IP address of monitoring poller that check this server.
denyhosts:purge: each of these pillar are documented in
    salt://denyhosts/config.jinja2.
-#}
include:
  - apt
  - gsyslog

denyhosts-allowed:
  file:
    - managed
    - name: /var/lib/denyhosts/allowed-hosts
    - source: salt://denyhosts/allowed.jinja2
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - require:
      - pkg: denyhosts

denyhosts:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  file:
    - managed
    - source: salt://denyhosts/config.jinja2
    - name: /etc/denyhosts.conf
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - require:
      - pkg: denyhosts
  service:
    - running
    - enable: True
    - watch:
      - file: denyhosts
      - pkg: denyhosts
      - file: denyhosts-allowed
    - require:
      - service: gsyslog

{% for file in ('/etc/logrotate.d/denyhosts', '/var/log/denyhosts') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: denyhosts
{% endfor %}

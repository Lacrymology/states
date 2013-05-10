amavis: # make sure that /etc/mailname exists
  pkg:
    - installed
    - name: amavisd-new
  service:
    - running
    - watch:
      - user: amavis
      - file: /etc/amavis/conf.d/22-max_servers
      - file: amavis
  file:
    - managed
    - name: /etc/amavis/conf.d/15-content_filter_mode
    - source: salt://amavis/15-content_filter_mode
  user:
    - present
    - groups:
      - amavis
      - clamav
    - require:
      - pkg: amavis
      - pkg: clamav-daemon

/etc/amavis/conf.d/22-max_servers:
  file:
    - managed
    - source: salt://amavis/22-max_servers
    - template: jinja
    - makedirs: True

spamassassin:
  pkg:
    - installed

clamav-daemon:
  pkg:
    - installed
  service:
    - running
    - names:
      - clamav-daemon
      - clamav-freshclam
    - watch:
      - user: clamav-daemon
      - file: clamav-daemon
    - require:
      - pkg: amavis
  file:
    - managed
    - name: /etc/clamav/freshclam.conf
    - source: salt://amavis/freshclam.conf
  user:
    - present
    - name: clamav
    - groups:
      - clamav
      - amavis
    - require:
      - pkg: clamav-daemon
      - pkg: amavis

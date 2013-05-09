amavis: # make sure that /etc/mailname exists
  pkg:
    - installed
    - name: amavisd-new
  service:
    - running
    - watch:
      - user: amavis
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
    - require:
      - pkg: amavis
  user:
    - present
    - name: clamav
    - groups:
      - clamav
      - amavis
    - require:
      - pkg: clamav-daemon
      - pkg: amavis

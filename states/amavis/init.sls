amavis: # make sure that /etc/mailname exists
  pkg:
    - installed
    - name: amavisd-new
  service:
    - running
  file:
    - managed
    - name: /etc/amavis/conf.d/15-content_filter_mode
    - source: salt://amavis/15-content_filter_mode
    
spamassassin:
  pkg:
    - installed

clamav-daemon:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: clamav-daemon
    - require:
      - pkg: amavis
  file:
    - managed
    - name: /etc/clamav/clamd.conf
    - source: salt://amavis/clamd.conf

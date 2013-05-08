amavis: # make sure that /etc/mailname exists
  pkg:
    - installed
    - name: amavisd-new
  service:
    - running
    
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




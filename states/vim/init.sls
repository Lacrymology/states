vim:
  pkg:
    - installed
  file:
    - managed
    - name: /etc/vim/vimrc
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://vim/vimrc.jinja2
    - require:
      - pkg: cron

vim-tiny:
  pkg:
    - purged

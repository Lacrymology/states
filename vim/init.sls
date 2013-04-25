{#
 Install VIM a vi compatible editor.
 #}
include:
  - apt

vim:
  pkg:
    - latest
  file:
    - managed
    - name: /etc/vim/vimrc
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://vim/vimrc.jinja2
    - require:
      - pkg: cron
      - cmd: apt_sources

vim-tiny:
  pkg:
    - purged

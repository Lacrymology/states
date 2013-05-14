{#
 Install VIM a vi compatible editor.
 #}
include:
  - apt

vim:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  file:
    - managed
    - name: /etc/vim/vimrc
    - template: jinja
    - user: root
    - group: root
    - mode: 444
    - source: salt://vim/vimrc.jinja2
    - require:
      - pkg: vim

vim-tiny:
  pkg:
    - purged

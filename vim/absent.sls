{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Uninstall VIM a vi compatible editor.
 -#}
vim:
  pkg:
    - purged

/etc/vim/vimrc:
  file:
    - absent
    - require:
      - pkg: vim

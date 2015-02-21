{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

vim:
  pkg:
    - purged

/etc/vim/vimrc:
  file:
    - absent
    - require:
      - pkg: vim

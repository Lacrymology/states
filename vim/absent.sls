{#
 Uninstall VIM a vi compatible editor.
 #}
vim:
  pkg:
    - purged

/etc/vim/vimrc:
  file:
    - absent
    - require:
      - pkg: vim

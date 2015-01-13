{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.


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

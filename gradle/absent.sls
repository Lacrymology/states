{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

gradle_archive:
  file:
    - absent
    - name: /usr/local/gradle-2.4

/usr/local/bin/gradle:
  file:
    - absent

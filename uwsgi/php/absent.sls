{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

symlink-libphp5.so:
  file:
    - absent
{%- if grains['cpuarch'] == 'i686' %}
    - name: /usr/lib/i386-linux-gnu/libphp5.so
{%- else %}
    - name: /usr/lib/x86_64-linux-gnu/libphp5.so
{%- endif %}
  cmd:
    - wait
    - name: /sbin/ldconfig
    - watch:
      - file: symlink-libphp5.so

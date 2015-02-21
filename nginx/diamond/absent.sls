{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

nginx_diamond_collector:
  file:
    - absent
    - name: /etc/diamond/collectors/NginxCollector.conf

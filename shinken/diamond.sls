{#
 Diamond statistics for Shinken
#}
include:
  - diamond
{% if grains['id'] in pillar['shinken']['architecture']['broker']|default([]) %}
  - nginx.diamond
  - gsyslog.diamond
{% endif %}

{% for role in pillar['shinken']['architecture'] %}
{% if grains['id'] in pillar['shinken']['architecture'][role] %}
shinken_{{ role }}_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[shinken.{{ role }}]]
        cmdline = ^\/usr\/local\/shinken\/bin\/python \/usr\/local\/shinken\/bin\/shinken-{{ role }}
{% endif %}
{% endfor %}

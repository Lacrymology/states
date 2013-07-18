{% for pkg in 'libnfsidmap2', 'libgssglue1', 'libtirpc1', 'rpcbind' %}
{{ pkg }}:
  pkg:
    - purged
{% endfor %}

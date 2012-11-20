{% if 'availabilityZone' in grains %}
 {% if grains['region'] == 'us-east-1' %}
crontab_hour: 12
 {% elif grains['region'] == 'eu-west-1' %}
crontab_hour: 2
 {% else %}
crontab_hour: 3
 {% endif %}
{% else %}
crontab_hour: 6
{% endif %}

{%- for pkg in 'php5_gd', 'php5_mysql', 'php5_mcrypt', 'php5_curl', 'php5_cli' %}
{{ pkg }}:
  pkg:
    - purged
{%- endfor %}

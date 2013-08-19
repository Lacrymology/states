php_bundle:
  pkg:
    - purged
    - name: php5-cli

{%- for pkg in 'php5_gd', 'php5_mysql', 'php5_mcrypt', 'php5_curl'%}
{{ pkg }}:
  pkg:
    - purged
{%- endfor %}

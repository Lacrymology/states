spamassassin:
  pkg:
    - purged

{# as long as https://github.com/saltstack/salt/issues/5572 isn't fixed
   the following is required: #}
{% for pkg in ('pyzor', 'razor') %}
{{ pkg }}:
  pkg:
    - purged
    - require:
      - pkg: spamassassin
{% endfor %}

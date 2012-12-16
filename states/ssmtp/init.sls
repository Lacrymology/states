ssmtp:
  pkg:
    - installed
    - names:
      - ssmtp
      - bsd-mailx

{% for template, config in (('config', 'ssmtp.conf'), ('revaliases', 'revaliases')) %}
/etc/ssmtp/{{ config }}:
  file:
    - managed
    - template: jinja
    - source: salt://smtp/{{ template }}.jinja2
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: ssmtp
{% endfor %}

include:
  - apt
  - nginx
{% if salt['pillar.get']('apt_cache:ssl', False) %}
  - ssl
{% endif %}

apt_cache:
  pkg:
    - installed
    - name: apt-cacher-ng
    - require:
      - cmd: apt_sources
  service:
    - running
    - name: apt-cacher-ng
    - require:
      - pkg: apt_cache

/etc/nginx/conf.d/apt_cache.conf:
  file:
    - managed
    - template: jinja
    - source: salt://apt_cache/nginx.jinja2
    - user: www-data
    - group: www-data
    - mode: 440
    - require:
      - pkg: nginx
      - service: apt_cache

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/apt_cache.conf
{%- if salt['pillar.get']('apt_cache:ssl', False) %}
        - cmd: ssl_cert_and_key_for_{{ pillar['apt_cache']['ssl'] }}
{%- endif %}

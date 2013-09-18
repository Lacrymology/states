{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
include:
  - salt
  - apt

{%- for type in ('profiles', 'providers') %}
/etc/salt/cloud.{{ type }}:
  file:
    - managed
    - template: jinja
    - source: salt://salt/cloud/{{ type }}.jinja2
    - require:
      - pkg: salt-cloud
{%- endfor %}

/etc/salt/cloud:
  file:
    - managed
    - template: jinja
    - source: salt://salt/cloud/config.jinja2
    - require:
      - pkg: salt-cloud

salt-cloud:
  pkg:
    - installed
    - skip_verify: True
    - require:
      - pkg: salt
      - apt_repository: salt

salt-cloud-boostrap-script:
  file:
    - managed
    - name: /etc/salt/cloud.deploy.d/bootstrap_salt.sh
    - source: salt://salt/cloud/bootstrap.jinja2
    - mode: 500
    - user: root
    - group: root
    - mkdirs: True
    - template: jinja
    - require:
      - pkg: salt-cloud

include:
  - salt
  - apt

/etc/salt/cloud.profiles:
  file:
    - managed
    - template: jinja
    - source: salt://salt/cloud/profiles.jinja2
    - require:
      - pkg: salt-cloud

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
      - cmd: apt_sources

deploy_script:
  file:
    - managed
    - name: /etc/salt/cloud.deploy.d/bootstrap_salt.sh
    - source: salt://salt/minion/bootstrap.sh
    - mode: 500
    - user: root
    - group: root
    - mkdirs: True
    - require:
      - pkg: salt-cloud

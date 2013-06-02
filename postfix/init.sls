{% set ssl = salt['pillar.get']('postfix:ssl', False) %}
include:
  - dovecot.agent
  - apt
{% if ssl %}
  - ssl
{% endif %}

postfix:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  service:
    - running
    - require:
      - file: /var/mail/vhosts
    - watch:
      - pkg: postfix
      - file: /etc/postfix

/var/mail/vhosts:
  file:
    - directory
    - user: dovecot-agent

/etc/postfix:
  file:
    - recurse
    - source: salt://postfix/configs
    - template: jinja
    - user: postfix
    - group: postfix
    - file_mode: 400
    - require:
      - pkg: postfix

/etc/mailname:
  file:
    - managed
    - source: salt://postfix/mailname.jinja2
    - template: jinja
    - require:
      - pkg: postfix

postfix-ldap:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkg: postfix

/etc/postfix/vmailbox:
  file:
    - managed
    - source: salt://postfix/vmailbox
    - template: jinja
    - mode: 400
    - user: postfix
    - group: postfix
    - require:
      - pkg: postfix

postmap /etc/postfix/vmailbox:
  cmd:
    - require:
      - pkg: postfix
      - file: /etc/postfix
    {% if salt['file.file_exists']('/etc/postfix/vmailbox.db') %}
    - wait
    - watch:
      - file: /etc/postfix/vmailbox
    {% else %}
      - file: /etc/postfix/vmailbox
    - run
    {% endif %}

{% if ssl %}
extend:
  postfix:
    service:
      - watch:
        - cmd: /etc/ssl/{{ pillar['postfix']['ssl'] }}/chained_ca.crt
        - module: /etc/ssl/{{ pillar['postfix']['ssl'] }}/server.pem
        - file: /etc/ssl/{{ pillar['postfix']['ssl'] }}/ca.crt
{% endif %}

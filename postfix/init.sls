{#-
Postfix: An Email Server (SMTP Server)
=============================

Mandatory Pillar
----------------

mail:
  mailname: somehost.fqdn.com

mail:mailname: fully qualified domain (if possible) of the mail server hostname.

Optional Pillar
---------------

mail:
  maxproc: 2

ldap:
  data:
    mailname:
      user1:
        cn: CN user1
        sn: SN user1
        passwd: password of user1 (plaintext or created by ldappasswd)
        desc: description for user1
        email: other email of user1
      user2:
        cn: CN user2
        sn: SN user2
        passwd: password of user2
        desc:
        email:


mail:maxproc: number of processes for passing email to amavis.  This value is used for amavis, too.
ldap:data: nested dict contain user infomation, that will be used for create LDAP users and mapping emails (user@mailname) to mailboxes
-#}
{% set ssl = salt['pillar.get']('postfix:ssl', False) %}
include:
  - dovecot.agent
  - apt
  - mail
{% if ssl %}
  - ssl
{% endif %}

apt-utils:
  pkg:
    - installed
    - require:
      - cmd: apt_sources

postfix:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - file: /etc/mailname
      - pkg: apt-utils
  service:
    - running
    - require:
      - file: /var/mail/vhosts
    - watch:
      - pkg: postfix
      - file: /etc/postfix
{% if ssl %}
      - cmd: /etc/ssl/{{ ssl }}/chained_ca.crt
      - module: /etc/ssl/{{ ssl }}/server.pem
      - file: /etc/ssl/{{ ssl }}/ca.crt
{% endif %}

/var/mail/vhosts:
  file:
    - directory
    - user: dovecot-agent
    - require:
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
      - user: dovecot-agent

postfix-ldap:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
      - pkg: postfix

/etc/postfix/vmailbox:
  file:
    - managed
    - source: salt://postfix/vmailbox.jinja2
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

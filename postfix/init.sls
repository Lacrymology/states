{#-
Postfix: An Email Server (SMTP Server)
=============================

All pillar default data is configurate for postfix work with  virtual mailbox, dovecot and spam filter amavis. Other ways to use postfix should disable these configurations.

Mandatory Pillar
----------------

mail:
  mailname: somehost.fqdn.com

mail:mailname: fully qualified domain (if possible) of the mail server hostname.

Optional Pillar
---------------

mail:
  maxproc: 2

postfix:
  spam_filter: False
  sasl: False
  virtual_mailbox: False
  mynetworks: 127.0.0.0/8 192.168.122.0/24

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
postfix:spam_filter: set configuration for amavis spam filter. Default: True
postfix:sasl: set configuration for authentication by dovecot sasl. Default: True
postfix:virtual_mailbox: enable using virtual mailbox. Default: True
postfix:mynetworks: trusted networks that postfix will relay mail from. Default: values for localhost
postfix:mydestination: host that this mail server will be final destination. Default: values for localhost, its domain
postfix:relayhost: the next-hop destination of non-local mail; overrides non-local domains in recipient addresses. Default: ''
postfix:relay_domains: domains that this mail server will relay mail to. Default: all values defined in mydestination
postfix:inet_interfaces: intefaces that this mail server listen to. Default: all
-#}
{% set ssl = salt['pillar.get']('postfix:ssl', False) %}
include:
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
  file:
    - managed
    - name: /etc/postfix/main.cf
    - source: salt://postfix/main.jinja2
    - template: jinja
    - user: postfix
    - group: postfix
    - file_mode: 400
    - require:
      - pkg: postfix
  service:
    - running
    - order: 50
    - watch:
      - pkg: postfix
      - file: /etc/postfix/master.cf
      - file: postfix
{% if ssl %}
      - cmd: /etc/ssl/{{ ssl }}/chained_ca.crt
      - module: /etc/ssl/{{ ssl }}/server.pem
      - file: /etc/ssl/{{ ssl }}/ca.crt
{% endif %}

/etc/postfix/master.cf:
  file:
    - managed
    - source: salt://postfix/master.jinja2
    - template: jinja
    - user: postfix
    - group: postfix
    - file_mode: 400
    - require:
      - pkg: postfix

{%- if salt['pillar.get']('postfix:virtual_mailbox', True) %}
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
    {% if salt['file.file_exists']('/etc/postfix/vmailbox.db') %}
    - wait
    - watch:
      - file: /etc/postfix/vmailbox
    {% else %}
      - file: /etc/postfix/vmailbox
    - run
    {% endif %}
{%- endif %}

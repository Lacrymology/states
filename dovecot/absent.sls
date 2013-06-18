/var/mail/vhosts/indexes:
  file:
    - absent

{% set dovecot_non_core = ('imapd', 'pop3d', 'ldap') %}
{% for pkg in dovecot_non_core %}
dovecot-{{ pkg }}:
  pkg:
    - purged
{% endfor %}

dovecot-core:
  pkg:
    - purged
    - require:
{% for pkg in dovecot_non_core %}
      - pkg: dovecot-{{ pkg }}
{% endfor %}

/etc/dovecot/:
  file:
    - absent
    - require:
      - pkg: dovecot

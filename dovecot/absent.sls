{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}
{{ upstart_absent('dovecot') }}

/var/mail/vhosts/indexes:
  file:
    - absent

extend:
  dovecot:
    pkg:
      - purged
      - pkgs:
        - dovecot-imapd
        - dovecot-pop3d
        - dovecot-ldap
        - dovecot-core
        - dovecot-managesieved
      - require:
        - service: dovecot
{#- ``upstart_absent`` absent of ``{{ formula }}.file`` if for upstart
    ``/etc/init`` file, but dovecot handle that already remove that file.
    then, recycle that statement to remove something else. #}
    file:
      - absent
      - name: /etc/dovecot
  dovecot-log:
    file:
      - require:
        - pkg: dovecot

/var/lib/dovecot:
  file:
    - absent
    - require:
      - pkg: dovecot

postfix:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: postfix
    - require:
      - pkg: postfix
  file:
    - managed
    - name: /etc/postfix/main.cf
    - source: salt://postfix/main.cf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix

postfix-ldap:
  pkg:
    - installed


#sasl2-bin:
#  pkg:
#    - installed

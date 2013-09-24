Pillar
======

Mandatory 
---------

mail:
  mailname: somehost.fqdn.com

mail:mailname
~~~~~~~~~~~~~

fully qualified domain (if possible) of the mail server hostname.

Optional 
--------

mail:
  maxproc: 2

postfix:
  spam_filter: True
  sasl: True
  virtual_mailbox: True
  mydestination:
    - saltlab.com
    - localhost.localdomain
    - localhost
  mynetworks:
    - 127.0.0.0/8
    - 192.168.122.0/24

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


mail:maxproc
~~~~~~~~~~~~

number of processes for passing email to amavis.  This value is used for amavis, too.

ldap:data
~~~~~~~~~

nested dict contain user infomation, that will be used for create LDAP users and mapping emails (user@mailname) to mailboxes

postfix:spam_filter
~~~~~~~~~~~~~~~~~~~

set configuration for amavis spam filter. Default: False

postfix:sasl
~~~~~~~~~~~~

set configuration for authentication by dovecot sasl. Default:False

postfix:virtual_mailbox
~~~~~~~~~~~~~~~~~~~~~~~

enable using virtual mailbox. Default: False

postfix:mynetworks
~~~~~~~~~~~~~~~~~~

list of trusted networks that postfix will relay mail from. Default: ["127.0.0.0/8"]

postfix:mydestination
~~~~~~~~~~~~~~~~~~~~~

host that this mail server will be final destination. Default: []

postfix:relayhost
~~~~~~~~~~~~~~~~~

the next-hop destination of non-local mail; overrides non-local domains in recipient addresses. Default: ''

postfix:relay_domains
~~~~~~~~~~~~~~~~~~~~~

domains that this mail server will relay mail to. Default: all values defined in mydestination

postfix:inet_interfaces
~~~~~~~~~~~~~~~~~~~~~~~

intefaces that this mail server listen to. Default: all

{#- Usage of this is governed by a license that can be found in doc/license.rst
 -*- ci-automatic-discovery: off -*-

 Dovecot is only used on a complete mail server integrated with:

 - clamav
 - postfix
 - dovecot
 - openldap

 There is no reason to perform standalone tests. Skip and only let
 mail.server.test perform all integration tests.
-#}

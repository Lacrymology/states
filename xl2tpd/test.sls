{#- Usage of this is governed by a license that can be found in doc/license.rst
 -*- ci-automatic-discovery: off -*-

xl2tpd is only used in a complete IPsec L2TP VPN integrated with:

  - openswan
  - ppp

There is no reason to perform standalone tests. Skip and only let
openswan.test perform all integration tests.
-#}

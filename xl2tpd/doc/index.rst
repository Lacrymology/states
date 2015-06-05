..
   Author: Quan Tong Anh <quanta@robotinfra.com>
   Maintainer: Quan Tong Anh <quanta@robotinfra.com>

L2TP
====

L2TP is a tunneling protocol used to support virtual private networks (VPNs) or
as part of the delivery of services by ISPs. It does not provide any encryption
or confidentiality by itself. Rather, it relies on an encryption protocol that
it passes within the tunnel to provide privacy.

.. Copied from http://en.wikipedia.org/wiki/Layer_2_Tunneling_Protocol
   on 2015-04-06

xl2tpd
------

:doc:`index` contains many patches that have not yet been integrated into
the mainstream release. These patches are needed to run on modern distributions
with DEVFS, or to support L2TP over IPsec, when used in conjunction with
Openswan.

.. Copied from https://www.xelerance.com/services/software/xl2tpd/
   on 2015-04-06

Links
-----

* `xl2tpd <https://www.xelerance.com/services/software/xl2tpd/>`_
* `Wikipedia <http://en.wikipedia.org/wiki/Layer_2_Tunneling_Protocol>`_

Related Formulas
----------------

* :doc:`/apt/doc/index`
* :doc:`/openswan/doc/index`

Content
-------

.. toctree::
    :glob:

    *

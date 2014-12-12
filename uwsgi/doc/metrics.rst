Metrics
=======
                          
:doc:`/diamond/doc/process`:

* ``uwsgi`` - :doc:`/uwsgi/doc/index`

KSM
---

This collector collects `Kernel Samepage Merging (KSM)
<http://www.linux-kvm.org/page/KSM>`_ statistics.

KSM is a memory de-duplication feature of the Linux Kernel (2.6.32+).
It can be enabled, if compiled into your kernel, by echoing 1 to
``/sys/kernel/mm/ksm/run``.

full_scans
~~~~~~~~~~

Number of times that KSM has scanned for duplicated content.

pages_shared
~~~~~~~~~~~~

Number of pages that have been merged.

pages_sharing
~~~~~~~~~~~~~

Number of virtual pages that are sharing a single page.

pages_to_scan
~~~~~~~~~~~~~

Number of pages to scan at a time.

pages_unshared
~~~~~~~~~~~~~~

Number of pages that are candidate to be shared but are not currently
shared.

pages_volatile
~~~~~~~~~~~~~~

Number of pages that are candidate to be shared but are changed
frequently. These pages are not merged.

run
~~~

* 1: `KSM <http://www.linux-kvm.org/page/KSM>`_ is enabled.
* 0: `KSM <http://www.linux-kvm.org/page/KSM>`_ is disabled.

sleep_milisecs
~~~~~~~~~~~~~~

Time in miliseconds between scans.

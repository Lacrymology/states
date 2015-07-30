..
   Author: Bruno Clermont <bruno@robotinfra.com>
   Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

ProFTPD
=======

Introduction
------------

ProFTPD_ (short for Pro FTP daemon) is a :ref:`glossary-ftp` server. ProFTPD_
is Free and open-source software, compatible with Unix-like systems and
Microsoft Windows (via Cygwin).  Along with vsftpd and Pure-FTPd, ProFTPD_ is
among the most popular :ref:`glossary-ftp` servers in Unix-like environments
today.  Compared to those, which focus e.g. on simplicity, speed or security,
ProFTPD_'s primary design goal is to be a highly feature rich
:ref:`glossary-ftp` server, exposing a large amount of configuration options to
the user

.. http://en.wikipedia.org/wiki/ProFTPD

.. warning::

  `FTP <https://en.wikipedia.org/wiki/Ftp>`_ is an insecure protocol,
  You should never use that. Please do not use this state.

But a client wanted to upload files from a special software used
during sports competitions.
They wanted to have the results available on their website.
And it only support :ref:`glossary-ftp`.

For security reason this state had been designed to be as less intrusive as
possible in the rest of the system.
It to depends on already existing :doc:`/postgresql/doc/index`
server to not not mess with Unix users/passwords.

Links
-----

* `ProFPTD Homepage <http://www.proftpd.org/>`_
* `Wikipedia <http://en.wikipedia.org/wiki/ProFTPD>`_

Related Formulas
----------------

* :doc:`/apt/doc/index`
* :doc:`/postgresql/doc/index`
* :doc:`/rsyslog/doc/index`

Content
-------

.. toctree::
    :glob:

    *

.. _ProFTPD: http://www.proftpd.org

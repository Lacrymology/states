.. Copyright (c) 2013, Hung Nguyen Viet
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Hung Nguyen Viet nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

Pillar
======

Optional
--------

Example::

  rsync:
    limit_per_ip: 1
    attribute: value
      'other attrib': other value
    module_name:
      'mod attrib 2': value
      attrib: value
    module_name2:
      ...

rsync:limit_per_ip
~~~~~~~~~~~~~~~~~~

Takes an integer or "UNLIMITED" as an argument.
This specifies the maximum instances of this ser- vice per source IP
address.

Default: ``"UNLIMITED"``.

other
~~~~~

Attributes and values is mapped to rsync daemon's attributes and values. If
attribute contains space, wrap quotes about it. All attributes and values
are `available here <http://rsync.samba.org/documentation.html>`__.

Example::

  rsync:
    'max connections': 4
    documents:
      path: /home/foo/docs
      comment: many serious documents...
      'read only': true

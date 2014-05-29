.. Copyright (c) 2009, Luan Vo Ngoc
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     * Redistributions of source code must retain the above copyright notice,
..       this list of conditions and the following disclaimer.
..     * Redistributions in binary form must reproduce the above copyright
..       notice, this list of conditions and the following disclaimer in the
..       documentation and/or other materials provided with the distribution.
..
.. Neither the name of Luan Vo Ngoc nor the names of its contributors may be used
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

Usage
=====

.. TODO: FIX

Web UI
------

After installing, you can login to the :doc:`index` UI by using the account that
is defined in :doc:`pillar` key ``shinken:users``.

Click ``All`` section to see all notifications on :doc:`index` that include:

- ``CRITICAL``
- ``WARNING``
- ``UNKNOWN``
- ``UP``
- ``OK``

Click ``IT problems`` to see notifications that only include something ralated
to errors.

With these error notifications that can be considered are ignored. Let
acknowledge by click ``Acknowledge`` at ``Actions`` section.

Refresh Service
^^^^^^^^^^^^^^^

Login to the Web UI in the URL specified in :doc:`/shinken/doc/pillar`, you will have an
overview of business impact.

then on the Web UI:

* click on the service
* choose ``Commands`` tab
* and ``Recheck now``

From the :doc:`/shinken/doc/index` Web UI, you can also go to :doc:`/graphite/doc/index` by clicking on the
``Shinken`` menu on the top-left.

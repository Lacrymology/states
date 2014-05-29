.. Copyright (c) 2009, Bruno Clermont
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
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
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

Troubleshooting
===============

Clustering
----------

Start the first instance, you should see something along the lines of::

  [2013-12-11 02:23:34,245][INFO ][cluster.service          ]
  [my-node-1] new_master
  [my-node-1][feumL84zT26zxpLi-PBWNQ][inet[/10.134.133.157:9300]]{master=true},
  reason: zen-disco-join (elected_as_master)

and on the second node::

  [2013-12-11 02:23:40,498][INFO ][cluster.service          ]
  [my-node-2] detected_master
  [my-node-1][feumL84zT26zxpLi-PBWNQ][inet[/10.134.133.1
  57:9300]]{master=true}, added
  {[my-node-1][feumL84zT26zxpLi-PBWNQ][inet[/10.134.133.157:9300]]{master=true},},
  reason: zen-disco-receive(from master [
  [my-node-1][feumL84zT26zxpLi-PBWNQ][inet[/10.134.133.157:9300]]{master=true}])

switch back to the first node::

  [2013-12-11 02:23:42,522][INFO ][cluster.service          ]
  [my-node-1] added
  {[my-node-2][URdBoFeFRKim3N-UYGxgCQ][inet[/10.128.213.252:9300]]
  {master=true},}, reason: zen-disco-receive(join from
  node[[my-node-2][URdBoFeFRKim3N-UYGxgCQ][inet[/10.128.213.252:9300]]{master=true}])

.. TODO: NO REAL USAGE OF IT.
.. TODO: PLEASE LINK TO ES OFFICIAL DOC.

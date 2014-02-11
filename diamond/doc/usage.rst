:Copyrights: Copyright (c) 2013, Quan Tong Anh

             All rights reserved.

             Redistribution and use in source and binary forms, with or without
             modification, are permitted provided that the following conditions
             are met:

             1. Redistributions of source code must retain the above copyright
             notice, this list of conditions and the following disclaimer.

             2. Redistributions in binary form must reproduce the above
             copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
             POSSIBILITY OF SUCH DAMAGE.
:Authors: - Quan Tong Anh
          
Diamond
=======

Diamond is a python daemon that collects system metrics and publishes them to
Graphite (and others). It is capable of collecting cpu, memory, network, i/o,
load and disk metrics. Additionally, it features an API for implementing custom
collectors for gathering metrics from almost any source.

Installation
------------

Here we will show you the way to use `Diamond` to gather metrics of the server
that is running ElasticSearch and send to Graphite.

Install Diamond on the ElasticSearch server by running::

  salt myminion state.sls diamond -v

Make sure that Diamond connected to the Graphite::

  tcp        0      0 10.134.133.157:51832    10.128.41.11:2004
  ESTABLISHED 29756/python

Usage
-----

After installing, refresh the Graphite web, you will see a new node appear
under Graphite with name is the hostname of ElasticSearch machine. You can
override it by changing the `path_prefix` setting in the configuration file.

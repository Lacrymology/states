Graylog2 web interface user guide
=================================

:copyrights: Copyright (c) 2013, Bruno Clermont

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
:authors: - Quan Tong Anh

Elasticsearch
-------------

Follow the instruction in the minion_installation.rst to install the minions.
Then from the Salt master, you can install Elasticsearch cluster by running::

  salt -L myminion1,myminion2 state.sls elasticsearch

Start the first instance, you should see something along the lines of::

  [2013-12-11 02:23:34,245][INFO ][cluster.service          ]
  [q-elasticsearch-1] new_master
  [q-elasticsearch-1][feumL84zT26zxpLi-PBWNQ][inet[/10.134.133.157:9300]]{master=true},
  reason: zen-disco-join (elected_as_master)

and on the second node::

  [2013-12-11 02:23:40,498][INFO ][cluster.service          ]
  [q-elasticsearch-2] detected_master
  [q-elasticsearch-1][feumL84zT26zxpLi-PBWNQ][inet[/10.134.133.1
  57:9300]]{master=true}, added
  {[q-elasticsearch-1][feumL84zT26zxpLi-PBWNQ][inet[/10.134.133.157:9300]]{master=true},},
  reason: zen-disco-receive(from master [
  [q-elasticsearch-1][feumL84zT26zxpLi-PBWNQ][inet[/10.134.133.157:9300]]{master=true}])

switch back to the first node::

  [2013-12-11 02:23:42,522][INFO ][cluster.service          ]
  [q-elasticsearch-1] added
  {[q-elasticsearch-2][URdBoFeFRKim3N-UYGxgCQ][inet[/10.128.213.252:9300]]
  {master=true},}, reason: zen-disco-receive(join from
  node[[q-elasticsearch-2][URdBoFeFRKim3N-UYGxgCQ][inet[/10.128.213.252:9300]]{master=true}])

Graylog2 server
---------------

Run the following command on the Salt master to install Graylog2 server::

  salt myminion state.sls graylog2.server

Check the log on the Elasticsearch nodes to make sure that the graylog2-server
was discovered::

  [2013-12-11 02:27:20,308][INFO ][cluster.service          ]
  [q-elasticsearch-1] added
  {[q-graylog2][MZXCVbnLT4Wiq0dgxiWVvA][inet[/10.138.50.176:9300]]{client=
  true, data=false, master=false},}, reason: zen-disco-receive(join from
  node[[q-graylog2][MZXCVbnLT4Wiq0dgxiWVvA][inet[/10.138.50.176:9300]]{client=true,
  data=
  false, master=false}])

Verify your cluster is operational::

  curl -XGET 'http://localhost:9200/_cluster/nodes?pretty=true'

You can also check the health of a cluster by running::

  curl -XGET 'http://localhost:9200/_cluster/health?pretty=true'

Graylog2 web interface
----------------------

Install Graylog2 web interface by running::

  salt myminion state.sls graylog2.web

If everything is OK, now you can access to the web interface via the URL that
is configured in the web server (for e.g: q-logs.robotinfra.com). 

After registering an admin user and login, take a look at over all tabs.

Since Graylog2 is already configured to transport email, belows are all the
steps that you need to do to get the notifications:

* Go to `streams` tab to create a stream (for e.g: shinken)
* Define filter rules for stream in `Rules` tab:

  * Level (or higher): Warn
  * Short Message (regex): :code:`[Ff]ailed|[Mm]issing|connection lost|down`

* `Settings` tab: uncheck **Stream disabled**
* `Alarms` tab: check on **Active** and **I want to receive alarms of this
  stream**

  * **Maximum number of messages**: 1
  * **Minutes**: 1
  * **Grace period (minutes)**: 1

  Don't forget to click on **Save** button.
  
Go to `users` tab and add the email address for each user that you want to
send him email notifications.

About the OOM error, you can use this regex: :code:`[Oo]ut of
[Mm]emory: [Kk]illed process|oom-killer`.

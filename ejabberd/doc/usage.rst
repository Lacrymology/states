XMPP server
===========

:Copyrights: Copyright (c) 2013, Dang Tung Lam

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
:Authors: - Dang Tung Lam

`eJabberd` is a Jabber/XMPP instant messaging server, licensed under GPLv2 
(Free and Open Source), written in Erlang/OTP. Among other features, 
ejabberd is cross-platform, fault-tolerant, clusterable and modular.

Pillar
------

Follow the instruction in the `ejabberd/doc/pillar.rst` to create the pillar
data for git server, for e.g::
  
  ejabberd:
    hostnames:
      - im.example.com
    admins:
      user1: pass1
      user2: pass2
    blocked:
      - user3
      - user4

Don't forget to update the `top.sls` file to deliver this pillar data to
minion::

  base:
    xmpp-server:
      - ejabberd

Installation
------------

From the Salt master, run the following command::

  salt xmpp-server state.sls ejabberd

After the installation is finished, you can login and modify all the settings in
eJabberd web administrator interface at `http(s)://im.example.com/admin`

Usage
-----

You can use an XMPP client on your OS (such as Pidgin, Empathy...) to communicate 
with server with below infomations::

  Username: user1
  Domain: im.example.com
  Server: im.example.com
  Port: 5222 (or 5223 if old-style ssl enabled)

Then, add your friend and start chatting.

Set up Pidgin for XMPP
----------------------

This is XMPP setup intruction for Pigin:

1. Open Pidgin.
2. Click the Accounts menu and click Manage Accounts.
3. Click Add.
4. In the Protocol field, select XMPP.
5. In the Username field, enter your username. For example, ``user1``.
6. In the Domain field, enter your domain, such as ``im.example.com``.
7. In the Password field, enter the password used to log in to SmarterMail.
8. Select the Remember password checkbox if you need.
9. Click the Advanced tab.
10. In the Connection Security field, select Use encryption if available.
11. In the Connect Server field, enter XMPP server address,
    such as ``im.example.com``.
12. Click Add.

And wait for connection.

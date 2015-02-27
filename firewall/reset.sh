#!/bin/bash
# Usage of this is governed by a license that can be found in doc/license.rst

# set policy for 3 built-in chains of filter table to ACCEPT - which is default.
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
# flush all the chains in filter table.
iptables -F
# attempt to delete every non-built-in chains in filter table.
iptables -X
# flush all chains and delete non-built-in chains in all other tables.
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X
iptables -t security -F
iptables -t security -X

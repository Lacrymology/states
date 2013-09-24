Pillar
======
Mandatory 
---------

None

Optional
--------

postgresql:
  listen_addresses: '*' # Default: localhost
  diamond: password for diamond # Default: auto-generate by salt
  replication: # only used for cluster setup
    username: usr name used for replication # Default replication_agent
    hot_standby: True # Default: True
    # bellow is manadatory if you are setup a cluster
    master: 10.0.0.5 # address of master server
    standby:
      - 10.0.0.7 
      - other_standby_address

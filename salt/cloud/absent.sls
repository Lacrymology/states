/etc/salt/cloud.profiles:
  file:
    - absent

/etc/salt/cloud:
  file:
    - absent

salt-cloud:
  pkg:
    - purged

/etc/salt/cloud.deploy.d:
  file:
    - absent

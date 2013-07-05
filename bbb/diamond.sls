{#
 Diamond statistics for BigBlueButton
#}
include:
  - diamond
  - ffmpeg.diamond
  - nginx.diamond
  - redis.diamond
  - tomcat.diamond

bbb_server_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[god]]
        cmdline = ^\/usr\/bin\/ruby1\.9\.2 \/usr\/bin\/god
        [[openoffice]]
        exec = ^\/usr\/lib\/libreoffice\/program\/oosplash
        [[red5]]
        cmdline = .+java.+ \/usr\/share\/red5\/red5-server-bootstrap\.jar
        [[freeswitch]]
        exec = ^\/opt\/freeswitch\/bin\/freeswitch

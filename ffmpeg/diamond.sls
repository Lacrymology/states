{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Diamond statistics for ffmpeg
-#}

include:
  - diamond

ffmpeg_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[ffmpeg]]
        exe = ^\/usr\/local\/bin\/ffmpeg$

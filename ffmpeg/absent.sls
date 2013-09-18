{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
ffmpeg:
  file:
    - absent
    - name: /usr/local/bin/ffmpeg

/usr/local/bin/ffprobe:
  file:
    - absent
